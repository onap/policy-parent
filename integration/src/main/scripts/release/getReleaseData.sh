#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2021-2022 Nordix Foundation.
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
branch="master"

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
    "policy/apex-pdp"
    "policy/drools-pdp"
    "policy/xacml-pdp"
    "policy/distribution"
    "policy/clamp"
    "policy/drools-applications"
)

usage()
{
    echo ""
    echo "$SCRIPT_NAME - gets information from the checked out Policy Framework repos for the release process"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -b branch    - the branch to release on, defaults to '$branch'"
    echo "         -d data_file - the policy release data file to create, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    exit 255;
}

while getopts "hb:d:l:" opt
do
    case $opt in
    h)
        usage
        ;;
    b)
        branch=$OPTARG
        ;;
    d)
        release_data_file=$OPTARG
        ;;
    l)
        repo_location=$OPTARG
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

if [[ -z "$repo_location" ]]
then
    echo "policy repo location not specified on -l flag"
    exit 1
fi

if [[ -z "$branch" ]]
then
    echo "policy branch not specified on -b flag"
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

update_repos() {
    echo "updating the policy framework data from '$repo_location' to data file '$release_data_file' . . ."

    for repo in "${pf_repos[@]}"
    do
        echo ""
        echo "updating data from repo $repo branch $branch to data file '$release_data_file' . . ."

        if [ -d "$repo_location/$repo" ]
        then
            echo "updating repository '$repo' . . ."
            git -C "$repo_location/$repo" checkout -- .
            git -C "$repo_location/$repo" checkout "$branch"
            git -C "$repo_location/$repo" pull
            git -C "$repo_location/$repo" rebase
            git -C "$repo_location/$repo" fetch --tags
        else
            echo "repo $repo does not exist"
            exit 1
        fi
        echo "data from repo $repo updated to data file '$release_data_file' . . ."
    done

    echo "policy framework data from '$repo_location' updated to data file '$release_data_file' . . ."
}

get_tags() {
    echo "Repo, Last Tag Version,Snapshot Version,Changed Files,Docker Images"
    echo "Repo, Last Tag Version,Snapshot Version,Changed Files,Docker Images" > "$release_data_file"
    for repo in "${pf_repos[@]}"
    do
        latest_snapshot_tag=$(mvn -f "$repo_location/$repo" clean | \
            grep "SNAPSHOT" | \
            tail -1 | \
            $SED -r 's/^.* ([0-9]*\.[0-9]*\.[0-9]*-SNAPSHOT).*$/\1/')

        if [[ $branch == *master ]]
        then
            latest_released_tag=$(git -C "$repo_location/$repo" tag | \
                grep '^[0-9]*\.[0-9]*\.[0-9]*$' | \
                sort -V | \
                tail -1)
        else
            # shellcheck disable=SC2001
            latest_snapshot_major_minor=$(echo "$latest_snapshot_tag" | sed 's/\.[0-9]*-SNAPSHOT$//')
            latest_released_tag=$(git -C "$repo_location/$repo" tag | \
                grep '^[0-9]*\.[0-9]*\.[0-9]*$' | \
                grep "$latest_snapshot_major_minor" | \
                sort -V | \
                tail -1)
        fi

        changed_files=$(git -C "$repo_location/$repo" diff --name-only "$latest_released_tag" "$branch" | \
            grep -v 'pom.xml$' | \
            grep -v '^version.properties$' | \
            grep -v "^releases/$latest_released_tag.yaml$" | \
            grep -cv "^releases/$latest_released_tag-container.yaml$" | \
            $SED 's/^[[:space:]]*//g')

        latest_container_yaml=$(find "$repo_location/$repo/releases" -name "*container.yaml" | sort | tail -1)
        if [ "$latest_container_yaml" != "" ]
        then
            docker_images=$(grep '\- name:' "$latest_container_yaml" | \
            $SED -e 's/\- //g' -e 's/\://g' -e "s/\'//g" -e 's/^[[:space:]]*//g' -e 's/^name //' | \
            tr '\n' ':' | \
            $SED 's/:$//')
        else
            docker_images=""
        fi

        echo "$repo,$latest_released_tag,$latest_snapshot_tag,$changed_files,$docker_images"
        echo "$repo,$latest_released_tag,$latest_snapshot_tag,$changed_files,$docker_images" >> "$release_data_file"
    done
}

update_repos
get_tags
