#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2022,2024 Nordix Foundation.
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
release_data_file="pf_release_data.csv"
release_data_file_tag=""

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
    echo "         -t tag       - tag the release data file with the given tag"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234 -p 3"
    echo "    perform release phase 3 on the repos at location '/home/user/onap' using the release data"
    echo "    in the file '/home/user/data/pf_release_data.csv'"
    exit 255;
}

while getopts "hd:l:i:p:t:" opt
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
    t)
        release_data_file_tag="$OPTARG"
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
    updateRefs.sh -d "$release_data_file" -l "$repo_location" -r policy/parent -p
    generateCommit.sh \
        -l "$repo_location" \
        -r policy/parent \
        -i "$issue_id" \
        -e "update parent references in policy/parent pom" \
        -m "updated the parent references in the policy/parent pom"
    echo "Updated parent references in the parent pom and generated commit"
}

release_phase_2() {
    echo "Generating artifact release yaml file and commit for policy/parent . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/parent -i "$issue_id"
    echo "Generated artifact release yaml file and commit for policy/parent"
}

release_phase_3() {
    echo "Updating snapshots for policy/parent, updating references on policy/docker and policy/common . . ."
    bumpSnapshots.sh \
        -d "$release_data_file" \
        -l "$repo_location" \
        -i "$issue_id"
    updateRefs.sh \
        -pk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/docker"
    updateRefs.sh \
        -p \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/common"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/docker" \
        -i "$issue_id" \
        -e "update parent references in policy/docker pom" \
        -m "updated the parent references in the policy/docker pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/common" \
        -i "$issue_id" \
        -e "update parent references in policy/common pom" \
        -m "updated the parent references in the policy/common pom"
    echo "Updated snapshots for policy/parent, updating references on policy/docker and policy/common"
}

release_phase_4() {
    echo "Generating artifact release yaml file and commit for policy/common . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/common -i "$issue_id"
    echo "Generated artifact release yaml file and commit for policy/common"

    echo "Generating docker release yaml file and commit for policy/docker . . ."
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/docker -i "$issue_id"
    echo "Generated docker release yaml file and commit for policy/docker"
}

release_phase_5() {
    echo "Updating snapshots for policy/common and policy/docker, updating references on policy/models . . ."
    bumpSnapshots.sh \
        -d "$release_data_file" \
        -l "$repo_location" \
        -i "$issue_id"
    updateRefs.sh \
        -pck \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/models"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/models" \
        -i "$issue_id" \
        -e "update parent,common references in policy/models pom" \
        -m "updated the parent and common references in the policy/models pom"
    echo "Updated snapshots for policy/common and policy/docker, updated references on policy/models"
}

release_phase_6() {
    echo "Generating artifact release yaml file and commit for policy/models . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/models -i "$issue_id"
    echo "Generated artifact release yaml file and commit for policy/models"
}

release_phase_7() {
    echo "Generating docker release yaml file and commit for policy/models . . ."
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/models -i "$issue_id"
    echo "Generated docker release yaml file and commit for policy/models"
}

release_phase_8() {
    echo "Updating snapshots for policy/models, updating references on other repos . . ."
    bumpSnapshots.sh \
        -d "$release_data_file" \
        -l "$repo_location" \
        -i "$issue_id"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/apex-pdp"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/api"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/clamp"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/distribution"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/drools-pdp"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/pap"
    updateRefs.sh \
        -pcmk \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/xacml-pdp"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/apex-pdp" \
        -i "$issue_id" \
        -e "update references in policy/apex-pdp pom" \
        -m "updated references in the policy/apex-pdp pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/api" \
        -i "$issue_id" \
        -e "update references in policy/api pom" \
        -m "updated references in the policy/api pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/clamp" \
        -i "$issue_id" \
        -e "update references in policy/clamp pom" \
        -m "updated references in the policy/clamp pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/distribution" \
        -i "$issue_id" \
        -e "update references in policy/distribution pom" \
        -m "updated references in the policy/distribution pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/drools-pdp" \
        -i "$issue_id" \
        -e "update references in policy/drools-pdp pom" \
        -m "updated references in the policy/drools-pdp pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/pap" \
        -i "$issue_id" \
        -e "update references in policy/pap pom" \
        -m "updated references in the policy/pap pom"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/xacml-pdp" \
        -i "$issue_id" \
        -e "update references in policy/xacml-pdp pom" \
        -m "updated references in the policy/xacml-pdp pom"
    echo "Updated snapshots for policy/models, updated references on other repos"
}

release_phase_9() {
    echo "Generating artifact release yaml file and commit for repos . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/apex-pdp -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/api -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/clamp -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/distribution -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/drools-pdp -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/pap -i "$issue_id"
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/xacml-pdp -i "$issue_id"
    echo "Generated artifact release yaml file and commit for repos"
}

release_phase_10() {
    echo "Generating docker release yaml file and commit for repos . . ."
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/apex-pdp -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/api -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/clamp -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/distribution -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/drools-pdp -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/pap -i "$issue_id"
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/xacml-pdp -i "$issue_id"
    echo "Generated docker release yaml file and commit for repos"
}

release_phase_11() {
    echo "Updating snapshots for repos, updating references on policy/drools-applications . . ."
    bumpSnapshots.sh \
        -d "$release_data_file" \
        -l "$repo_location" \
        -i "$issue_id"
    updateRefs.sh \
        -pcmok \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/drools-applications"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/drools-applications" \
        -i "$issue_id" \
        -e "update references in policy/drools-applications pom" \
        -m "updated references in the policy/drools-applications pom"
    echo "Updated snapshots for repos, updated references on policy/drools-applications"
}

release_phase_12() {
    echo "Generating artifact release yaml file and commit for policy/drools-applications . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/drools-applications -i "$issue_id"
    echo "Generated artifact release yaml file and commit for policy/drools-applications"
}

release_phase_13() {
    echo "Generating docker release yaml file and commit for policy/drools-applications . . ."
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/drools-applications -i "$issue_id"
    echo "Generated docker release yaml file and commit for policy/drools-applications"
}

release_phase_14() {
    echo "Updating snapshots on policy/drools-applications . . ."
    bumpSnapshots.sh \
        -d "$release_data_file" \
        -l "$repo_location" \
        -i "$issue_id"
    echo "Updated snapshots on policy/drools-applications"
}

release_phase_15() {
    echo "Updating release data file . . ."
    updateRefs.sh \
        -t "$release_data_file_tag" \
        -d "$release_data_file" \
        -l "$repo_location" \
        -r "policy/parent"
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/parent" \
        -i "$issue_id" \
        -e "update release data in policy/parent" \
        -m "updated release data in policy/parent"
    echo "Updated release data file"
}

case "$release_phase" in

1)  release_phase_1
    ;;

2)  release_phase_2
    ;;

3)  release_phase_3
    ;;

4)  release_phase_4
    ;;

5)  release_phase_5
    ;;

6)  release_phase_6
    ;;

7)  release_phase_7
    ;;

8)  release_phase_8
    ;;

9)  release_phase_9
    ;;

10)  release_phase_10
    ;;

11)  release_phase_11
    ;;

12)  release_phase_12
    ;;

13)  release_phase_13
    ;;

14)  release_phase_14
    ;;

15)  release_phase_15
    ;;

*) echo "specified release phase '$release_phase' is invalid"
   ;;
esac
