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
    echo "$SCRIPT_NAME - release the specified repository by generating the release yaml file and the release commit"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -r repo      - the policy repo to release"
    echo "         -i issue-id  - issue ID in the format POLICY-nnnn"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -r policy/common -i POLICY-1234"
    echo "    release the 'policy/common' repo at location '/home/user/onap' using the release data"
    echo "    in the file '/home/user/data/pf_release_data.csv'"
    exit 255;
}

while getopts "hd:l:r:i:" opt
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
    r)
        specified_repo=$OPTARG
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

if [ -z "$specified_repo" ]
then
    echo "repo not specified on -r flag"
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

read repo \
    latest_released_tag \
    latest_snapshot_tag \
    changed_files docker_images \
    <<< $( grep $specified_repo $release_data_file | tr ',' ' ' )

if [ ! "$repo" = "$specified_repo" ]
then
    echo "repo '$specified_repo' not found in file 'pf_release_data.csv'"
    exit 1
fi

next_release_version=${latest_snapshot_tag%-*}

while true
do
   read -p "have you run 'stage_release' on the '$repo' repo? " yes_no
   case $yes_no in
       [Yy]* ) break
        ;;

       [Nn]* ) exit
        ;;

       * ) echo "Please answer 'yes' or 'no'"
    ;;
   esac
done

saved_current_dir=`pwd`
cd $repo_location/$repo
if [ "$docker_images" != "" ]
then
    mkart.sh -d
else
    mkart.sh
fi
cd $saved_current_dir

echo "generating commit for $repo release: $latest_released_tag-->$next_release_version . . ."

generateCommit.sh \
    -l $repo_location \
    -r $repo \
    -i $issue_id \
    -e "Release $repo: $next_release_version" \
    -m "This commit releases repo $repo."

echo "commit for $repo release: $latest_released_tag-->$next_release_version generated"
