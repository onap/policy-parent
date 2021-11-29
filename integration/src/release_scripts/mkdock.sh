#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2020 AT&T Intellectual Property. All rights reserved.
# =========================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END==================================================
#

#
# This creates the x.y.z-container.yaml file for releasing a docker image.
# It should be executed from somewhere within the "git" repo to be
# released.  Assumes the following:
#   - the latest commit is at the top of the "git log"
#   - the branch to be released is currently checked out
#   - the latest maven-docker-stage jenkins job is the one to be released
#   - the defaultbranch within the .gitreview file is set to the
#     branch to be released
#
# This uses xmllint, which is part of the libxml2-utils package.
#
# If behind a firewall, then http_proxy must be set so that curl
# can get through the firewall.
#

if [ $# -lt 1 -o "$1" = "-?" ]
then
	echo "arg(s): docker-container-name1 docker-container-name2 ..." >&2
	exit 1
fi

TOPDIR=$(git rev-parse --show-toplevel)
if [ -z "${TOPDIR}" ]; then
	echo "cannot determine top of 'git' repo" >&2
	exit 1
fi

BRANCH=$(awk -F= '$1 == "defaultbranch" { print $2 }' "${TOPDIR}/.gitreview")
if [ -z "${BRANCH}" ]; then
	echo "cannot extract default branch from ${TOPDIR}/.gitreview" >&2
	exit 1
fi
echo Branch: ${BRANCH}

PROJECT=$(awk -F= '$1 == "project" { print $2 }' "${TOPDIR}/.gitreview" |
			sed 's/.git$//')
if [ -z "${PROJECT}" ]; then
	echo "cannot extract project from ${TOPDIR}/.gitreview" >&2
	exit 1
fi
echo Project: ${PROJECT}
TPROJ=$(echo ${PROJECT} | sed 's!/!%2F!')
DPROJ=$(echo ${PROJECT} | sed 's!/!-!')

RELEASE=$(
	xmllint --xpath \
		'/*[local-name()="project"]/*[local-name()="version"]/text()' \
		"${TOPDIR}/pom.xml" |
	sed 's!-SNAPSHOT!!'
	)
if [ -z "${RELEASE}" ]; then
	echo "cannot extract release from ${TOPDIR}/pom.xml" >&2
	exit 1
fi
echo Release: ${RELEASE}

REF_ID=$(git log | grep commit | head -1 | awk '{ print $2 }')
if [ -z "${REF_ID}" ]; then
	echo "cannot extract ref from 'git log'" >&2
	exit 1
fi
echo Ref: ${REF_ID}

prefix='https://jenkins.onap.org/view/policy/job/'
STAGE_ID=$(
	curl --silent ${prefix}${DPROJ}-maven-docker-stage-${BRANCH}/ |
	grep "Last completed build" |
	sed -e 's!.*Last completed build .#!!' -e 's!).*!!' |
	head -1
	)
if [ -z "${STAGE_ID}" ]; then
	echo "cannot extract last docker stage ID from jenkins" >&2
	exit 1
fi
STAGE_ID=${DPROJ}-maven-docker-stage-${BRANCH}/${STAGE_ID}
echo Stage ID: ${STAGE_ID}

prefix='https://jenkins.onap.org/view/policy/job/'
JOB_OUT=$(curl --silent ${prefix}${STAGE_ID}/console)
echo "${JOB_OUT}" | grep -q "Finished: SUCCESS"
if [ $? -ne 0 ]; then
	echo "last docker build has not completed successfully" >&2
	exit 1
fi

echo Creating ${TOPDIR}/releases/${RELEASE}-container.yaml
cat >"${TOPDIR}/releases/${RELEASE}-container.yaml" <<EOT
distribution_type: 'container'
container_release_tag: '${RELEASE}'
project: '${DPROJ}'
log_dir: '${STAGE_ID}'
ref: ${REF_ID}
containers:
EOT

for CONT_NAME in "$@"
do
	VERSION=$(
		echo "${JOB_OUT}" |
		awk "
			/Successfully tagged onap/ { found = 0 }
			/Successfully tagged onap\/${CONT_NAME}:/ { found = 1 }
			found == 1 && /Tag with/ { print }
		" |
		head -1 |
		sed 's!.*Tag with!!' |
		cut -d, -f2
		)
	if [ -z "${VERSION}" ]; then
		echo "cannot extract ${CONT_NAME} version from jenkins build output" >&2
		exit 1
	fi
	echo ${CONT_NAME} version: ${VERSION}

	cat >>"${TOPDIR}/releases/${RELEASE}-container.yaml" <<EOT_LOOP
    - name: '${CONT_NAME}'
      version: '${VERSION}'
EOT_LOOP
done
