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

SCRIPT_NAME=`basename $0`
repo_location="./"
release_data_file="./pf_release_data.csv"

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
    "policy/gui"
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
    echo "         -d data_file - the policy release data file to create, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    exit 255;
}

while getopts "hd:l:" opt
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

update_repos() {
    echo "updating the policy framework data from '$repo_location' to data file '$release_data_file' . . ."

    for repo in "${pf_repos[@]}"
    do
        echo "updating data from repo $repo to data file '$release_data_file' . . ."

        if [ -d $repo_location/$repo ]
        then
            echo "updating repository '$repo' . . ."
            git -C $repo_location/$repo checkout master
            git -C $repo_location/$repo pull
            git -C $repo_location/$repo rebase
            git -C $repo_location/$repo fetch --tags
        else
            echo "repo $repo does not exist"
            exit 1
        fi
        echo "data from repo $repo updated to data file '$release_data_file' . . ."
    done

    echo "policy framework data from '$repo_location' updated to data file '$release_data_file' . . ."
}


get_tags() {
    echo "Repo, Last Tag Version,Master Snapshot Version,Changed Files,Docker Images"
    echo "repo, Last Tag Version,Master Snapshot Version,Changed Files,Docker Images" > $release_data_file
    for repo in "${pf_repos[@]}"
    do
        latest_released_tag=`git -C $repo_location/$repo tag | \
            grep '^[0-9]*\.[0-9]*\.[0-9]*$' | \
            sort -V | \
            tail -1`

        latest_snapshot_tag=`mvn -f $repo_location/$repo clean | \
            grep "SNAPSHOT" | \
            tail -1 | \
            sed -r 's/^.* ([0-9]*\.[0-9]*\.[0-9]*-SNAPSHOT).*$/\1/'`

        changed_files=`git -C $repo_location/$repo diff --name-only $latest_released_tag origin/master | \
            grep -v 'pom.xml$' | \
            grep -v '^version.properties$' | \
            grep -v "^releases/$latest_released_tag.yaml$" | \
            grep -v "^releases/$latest_released_tag-container.yaml$" | \
            wc -l | \
            sed 's/^[[:space:]]*//g'`

        if [ -f $repo_location/$repo/releases/$latest_released_tag-container.yaml ]
        then
            docker_images=`grep '\- name:' $repo_location/$repo/releases/$latest_released_tag-container.yaml | \
            sed -e 's/\- //g' -e 's/\://g' -e "s/\'//g" -e 's/^[[:space:]]*//g' -e 's/^name //' | \
            tr '\n' ':' | \
            sed 's/:$//'`
        else
            docker_images=""
        fi

        echo "$repo,$latest_released_tag,$latest_snapshot_tag,$changed_files,$docker_images"
        echo "$repo,$latest_released_tag,$latest_snapshot_tag,$changed_files,$docker_images" >> $release_data_file
    done
}

update_repos
get_tags

