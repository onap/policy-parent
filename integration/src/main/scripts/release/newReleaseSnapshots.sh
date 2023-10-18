#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2022-2023 Nordix Foundation.
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
        "policy/gui"
        "policy/clamp"
        "policy/drools-applications"
)

usage()
{
    echo ""
    echo "$SCRIPT_NAME - on release changes, generate commits to set the snapshot version and update"
    echo "               references on any repos that reference other repos"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -m           - update snapshots for a major release, default is to update for a minor release"
    echo "         -i issue-id  - issue ID in the format POLICY-nnnn"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234"
    echo "    set snapshots on the repos at location '/home/user/onap' using the release data"
    echo "    in the file '/home/user/data/pf_release_data.csv'"
    exit 255;
}

major_release=false

while getopts "hmd:l:i:" opt
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
    m)
        major_release=true
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
    echo "policy repo location not specified on -l flag"
    exit 1
fi

if ! [ -d "$repo_location" ]
then
    echo "policy repo location '$repo_location' not found"
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
            changed_files \
            docker_images \
        <<< $(grep "$specified_repo" "$release_data_file" | tr ',' ' ' )

    if [ ! "$repo" = "$specified_repo" ]
    then
        echo "repo '$specified_repo' not found in file 'pf_release_data.csv'"
        continue
    fi

    next_release_version=${latest_snapshot_tag%-*}

    major_version=$(echo "$latest_released_tag" | $SED -E 's/^([0-9]*)\.[0-9]*\.[0-9]*$/\1/')
    minor_version=$(echo "$latest_released_tag" | $SED -E 's/^[0-9]*\.([0-9]*)\.[0-9]*$/\1/')
    patch_version=$(echo "$next_release_version" | $SED -E 's/^[0-9]*\.[0-9]*\.([0-9]*)$/\1/')
    # shellcheck disable=SC2004

    if $major_release
    then
        new_major_version=$(($major_version+1))
        new_minor_version=0
    else
        new_major_version=$major_version
        new_minor_version=$(($minor_version+1))
    fi

    new_snapshot_tag="$new_major_version"."$new_minor_version".0-SNAPSHOT

    echo "updating snapshot version and references of repo $repo to $new_snapshot_tag . . ."
    mvn -f "$repo_location/$repo" \
        "-DnewVersion=$new_snapshot_tag" versions:set \
        versions:update-child-modules versions:commit

    temp_file=$(mktemp)

    echo "set snapshot version of repo $repo in $repo_location/$repo/version.properties"
    $SED \
        -e "s/major=$major_version/major=$new_major_version/" \
        -e "s/minor=$minor_version/minor=$new_minor_version/" \
        -e "s/patch=$patch_version/patch=0/" \
        "$repo_location/$repo/version.properties" \
        > "$temp_file"
    mv "$temp_file" "$repo_location/$repo/version.properties"

    updateRefs.sh -pcmoxs -d "$release_data_file" -l "$repo_location" -r "$repo"

    generateCommit.sh \
       -l "$repo_location" \
        -r "$repo" \
        -i "$issue_id" \
        -e "Set snapshot and/or references of $repo for new release" \
        -m "$repo updated to its latest own and reference snapshots"

    echo "commit to set snapshot version and/or references of repo $repo generated"
done

