#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2021 AT&T Intellectual Property. All rights reserved.
# Modifications Copyright (C) 2022 Nordix Foundation.
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
# This creates the x.y.z.yaml file for releasing (java) artifacts.
# It should be executed from somewhere within the "git" repo to be
# released.  Assumes the following:
#   - the branch to be released is currently checked out
#   - the latest maven-stage jenkins job is the one to be released
#   - the defaultbranch within the .gitreview file is set to the
#     branch to be released
#
# This uses xmllint, which is part of the libxml2-utils package.
#
# If behind a firewall, then http_proxy must be set so that curl
# can get through the firewall.
#

if [[ "$OSTYPE" == "darwin"* ]]
then
    SED="gsed"
else
    SED="sed"
fi

set -e

has_docker_images=false

if [ "$1" == "-d" ]
then
    has_docker_images=true
    shift
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
            $SED 's/.git$//')
if [ -z "${PROJECT}" ]; then
    echo "cannot extract project from ${TOPDIR}/.gitreview" >&2
    exit 1
fi
echo Project: ${PROJECT}
TPROJ=$(echo ${PROJECT} | $SED 's!/!%2F!')
DPROJ=$(echo ${PROJECT} | $SED 's!/!-!')

VERSION=$(
    xmllint --xpath \
        '/*[local-name()="project"]/*[local-name()="version"]/text()' \
        "${TOPDIR}/pom.xml" |
    $SED 's!-SNAPSHOT!!'
    )
if [ -z "${VERSION}" ]; then
    echo "cannot extract version from ${TOPDIR}/pom.xml" >&2
    exit 1
fi
echo Version: ${VERSION}

prefix='https://jenkins.onap.org/view/policy/job/'
STAGE_ID=$(
    curl --silent ${prefix}${DPROJ}-maven-stage-${BRANCH}/ |
    grep "Last completed build" |
    $SED -e 's!.*Last completed build .#!!' -e 's!).*!!' |
    head -1
    )
if [ -z "${STAGE_ID}" ]; then
    echo "cannot extract last maven stage ID from jenkins" >&2
    exit 1
fi
STAGE_ID=${DPROJ}-maven-stage-${BRANCH}/${STAGE_ID}/
echo Stage ID: ${STAGE_ID}

prefix='https://jenkins.onap.org/view/policy/job/'
JOB_OUT=$(curl --silent ${prefix}${STAGE_ID}/console)
echo "${JOB_OUT}" | grep -q "Finished: SUCCESS"
if [ $? -ne 0 ]; then
    echo "last jenkins build has not completed successfully" >&2
    exit 1
fi

echo Creating ${TOPDIR}/releases/${VERSION}.yaml

echo "distribution_type: 'maven'"  > "${TOPDIR}/releases/${VERSION}.yaml"
echo "version: '${VERSION}'"      >> "${TOPDIR}/releases/${VERSION}.yaml"
echo "project: '${DPROJ}'"        >> "${TOPDIR}/releases/${VERSION}.yaml"

if [ $has_docker_images = true ]
then
    echo "tag_release: false" >> "${TOPDIR}/releases/${VERSION}.yaml"
fi

echo "log_dir: '${STAGE_ID}'" >> "${TOPDIR}/releases/${VERSION}.yaml"
