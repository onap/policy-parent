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

SCRIPT_NAME=$(basename "$0")
repo_location="./"

usage()
{
    echo ""
    echo "$SCRIPT_NAME - generates a new commit or a patch on an existing commit for PF releases"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h                - this help message"
    echo "         -l location       - the location of the policy framework repos on the file system,"
    echo "                             defaults to '$repo_location'"
    echo "         -r repo           - the policy repo to which to commit"
    echo "         -i issue-id       - issue ID in the format POLICY-nnnn"
    echo "         -e commit-header  - the header for the commit"
    echo "         -m commit-message - the message body for the commit"
    echo ""
    echo " example:"
    echo "  $SCRIPT_NAME -l /home/git/onap -r policy/pap -i POLICY-1234 -e commit-header -m commit-message"
    echo "    create a new commit or update an existing commit on policy/pap with the given details"
    exit 255;
}

while getopts "hl:r:i:e:m:" opt
do
    case $opt in
    h)
        usage
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
    e)
        commit_header=$OPTARG
        ;;
    m)
        commit_message=$OPTARG
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

if [ -z "$commit_header" ]
then
    echo "commit_header not specified on -e flag"
    exit 1
fi

if [ -z "$commit_message" ]
then
    echo "commit_message not specified on -m flag"
    exit 1
fi

git -C "$repo_location/$specified_repo" status | grep '^Your branch is up to date' > /dev/null 2>&1
return_code=$?

if [ $return_code -eq 0 ]
then
    echo "generating commit '$commit_header' . . ."

    commit_msg_temp_file=$(mktemp)
    {
        echo "$commit_header"
        echo ""
        echo "$commit_message"
        echo ""
        echo "*** This commit is generated by a PF release script ***"
        echo ""
        echo "Issue-ID: $issue_id"
    } > "$commit_msg_temp_file"

    git -C "$repo_location/$specified_repo" add .
    git -C "$repo_location/$specified_repo" commit -s -F "$commit_msg_temp_file"
    rm "$commit_msg_temp_file"

    echo "commit '$commit_header' generated"
else
    echo "updating commit '$commit_header' . . ."

    git -C "$repo_location/$specified_repo" add .
    git -C "$repo_location/$specified_repo" commit -as --amend --no-edit

    echo "commit '$commit_header' updated"
fi

echo "sending commit '$commit_header' to gerrit . . ."
git -C "$repo_location/$specified_repo" review
echo "commit '$commit_header' sent to gerrit . . ."


