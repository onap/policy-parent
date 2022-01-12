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

usage()
{
    echo ""
    echo "$SCRIPT_NAME - execute a certain policy framework release phase"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -i issue-id  - issue ID in the format POLICY-nnnn"
    echo "         -p phase     - the release phase, a positive integer"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234 -p 3"
    echo "    perform release phase 3 on the repos at location '/home/user/onap' using the release data"
    echo "    in the file '/home/user/data/pf_release_data.csv'"
    exit 255;
}

while getopts "hd:l:i:p:" opt
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
    p)
        release_phase=$OPTARG
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

if [ -z "$release_phase" ]
then
    echo "release_phase not specified on -p flag"
    exit 1
fi

if ! [[ "$release_phase" =~ ^[0-9]+$ ]]
then
  echo "release_phase is invalid, it should be a positive integer"
  exit 1
fi

release_phase_1() {
    echo "Updating parent references in the parent pom and generating commit . . ."
    updateRefs.sh -d $release_data_file -l $repo_location -r policy/parent -p
    generateCommit.sh \
        -l $repo_location \
        -r policy/parent \
        -i $issue_id \
        -e "update parent references in parent pom" \
        -m "updated the parent references in the parent pom"
    echo "Updated parent references in the parent pom and generated commit"
}

release_phase_2() {
    echo "Generating artifact release yaml fine and commit for policy/parent . . ."
    releaseRepo.sh -d $release_data_file -l $repo_location -r policy/parent -i $issue_id
    echo "Generated artifact release yaml fine and commit for policy/parent . . ."
}

case "$release_phase" in

1)  release_phase_1
    ;;

2)  release_phase_2
    ;;

*) echo "specified release phase '$release_phase' is invalid"
   ;;
esac

