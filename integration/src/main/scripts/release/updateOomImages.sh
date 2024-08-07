#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2021-2022,2024 Nordix Foundation.
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

set -e

SCRIPT_NAME=$(basename "$0")
repo_location="./"
release_data_file="./pf_release_data.csv"

# Use the bash internal OSTYPE variable to check for MacOS
if [[ "$OSTYPE" == "darwin"* ]]
then
    SED="gsed"
else
    SED="sed"
fi

declare -a pf_repos=(
        "policy/parent"
        "policy/docker"
        "policy/common"
        "policy/models"
        "policy/api"
        "policy/pap"
        "policy/drools-pdp"
        "policy/apex-pdp"
        "policy/xacml-pdp"
        "policy/distribution"
        "policy/clamp"
        "policy/drools-applications"
)

usage()
{
    echo ""
    echo "$SCRIPT_NAME - generate an OOM commit to update the versions of Policy Framework images in values.yaml files"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, defaults to '$release_data_file'"
    echo "         -l location  - the location of the OOM repo on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -i issue-id  - issue ID in the format POLICY-nnnn"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234"
    echo "    update the version of policy framework images at location '/home/user/onap/oom' using the release data"
    echo "    in the file '/home/user/data/pf_release_data.csv'"
    exit 255;
}

while getopts "hd:l:i:" opt
do
    case $opt in
    h)
        usage
        ;;
    d)
        release_data_file=$OPTARG
        ;;
    l)
        repo_location=$OPTARG
        ;;
    i)
        issue_id=$OPTARG
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

if [ $OPTIND -eq 1 ]
then
    echo "no arguments were specified"
    usage
fi

if [[ -z "$repo_location" ]]
then
    echo "OOM repo location not specified on -l flag"
    exit 1
fi

if ! [ -d "$repo_location" ]
then
    echo "OOM repo location '$repo_location' not found"
    exit 1
fi

if [[ -z "$release_data_file" ]]
then
    echo "policy release data file not specified on -d flag"
    exit 1
fi

if ! [ -f "$release_data_file" ]
then
    echo "policy release data file '$release_data_file' not found"
    exit 1
fi

if [ -z "$issue_id" ]
then
    echo "issue_id not specified on -i flag"
    exit 1
fi

if ! echo "$issue_id" | grep -Eq '^POLICY-[0-9]*$'
then
  echo "issue ID is invalid, it should be of form 'POLICY-nnnn'"
  exit 1
fi

for specified_repo in "${pf_repos[@]}"
do
    # shellcheck disable=SC2034
    # shellcheck disable=SC2046
    read -r repo \
            latest_released_tag \
            latest_snapshot_tag \
            changed_files docker_images \
        <<< $(grep "$specified_repo" "$release_data_file" | tr ',' ' ' )

    if [ ! "$repo" = "$specified_repo" ]
    then
        echo "repo '$specified_repo' not found in file 'pf_release_data.csv'"
        continue
    fi

    if [ "$docker_images" = "" ]
    then
        continue
    fi

    for docker_image in $(echo "$docker_images" | sed -e "s/'//g" -e "s/:/ /g")
    do
        new_image="$docker_image:$latest_released_tag"

        echo "updating OOM image $new_image . . ."
        find "$repo_location/oom/kubernetes/policy" \
            -name values.yaml \
            -exec \
                $SED -i \
                "s/image:[ |\t]*onap\/$docker_image:[0-9]*\.[0-9]*\.[0-9]*$/image: onap\/$new_image/" {} \;
        echo "OOM image $docker_image:$latest_released_tag updated"
    done
done

echo "generating OOM commit to update policy framework docker image versions . . ."

generateCommit.sh \
    -l "$repo_location" \
    -r oom \
    -i "$issue_id" \
    -e "[POLICY] Update docker images to latest versions" \
    -m "The image versions in policy values.yaml files have been updated"

echo "OOM commit to update policy framework docker image versions generated"

