#!/bin/bash

#
# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2026 Nordix Foundation.
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

# Use the bash internal OSTYPE variable to check for MacOS
if [[ "$OSTYPE" == "darwin"* ]]
then
    SED="gsed"
else
    SED="sed"
fi

usage()
{
    echo ""
    echo "$SCRIPT_NAME - execute the policy/clamp release process"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -i issue-id  - issue ID in the format POLICY-nnnn"
    echo "         -p phase     - the release phase to execute (1-4), if omitted all phases are executed"
    echo "         -t tag       - tag the release data file with the given tag"
    echo ""
    echo " phases:"
    echo "  1 - Release policy/clamp Maven artifacts"
    echo "      Generates release yaml file and commit for Maven artifacts."
    echo "      NOTE: Run 'stage-release' on policy/clamp in Gerrit before executing this phase."
    echo ""
    echo "  2 - Release policy/clamp Docker images"
    echo "      Generates docker release yaml file and commit for Docker images."
    echo ""
    echo "  3 - Update policy/clamp snapshots"
    echo "      Bumps snapshot version in pom.xml and version.properties."
    echo "      Does not update references to other repos (clamp is decoupled)."
    echo ""
    echo "  4 - Update release data in policy/parent"
    echo "      Copies release data file to policy/parent and generates commit."
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234"
    echo "    perform all release phases for policy/clamp"
    echo "  $SCRIPT_NAME -l /home/user/onap -d /home/user/data/pf_release_data.csv -i POLICY-1234 -p 2"
    echo "    perform only phase 2 (Docker image release)"
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

if ! echo "$issue_id" | grep -Eq '^POLICY-[0-9]+$'
then
  echo "issue ID is invalid, it should be of form 'POLICY-nnnn'"
  exit 1
fi

if [ -n "$release_phase" ] && ! [[ "$release_phase" =~ ^[1-4]$ ]]
then
  echo "release_phase is invalid, it should be 1, 2, 3, or 4"
  exit 1
fi

clamp_phase_1() {
    echo "Phase 1: Releasing policy/clamp Maven artifacts . . ."
    releaseRepo.sh -d "$release_data_file" -l "$repo_location" -r policy/clamp -i "$issue_id"
    echo "Phase 1 complete: policy/clamp Maven artifacts released"
}

clamp_phase_2() {
    echo "Phase 2: Releasing policy/clamp Docker images . . ."
    releaseRepoImages.sh -d "$release_data_file" -l "$repo_location" -r policy/clamp -i "$issue_id"
    echo "Phase 2 complete: policy/clamp Docker images released"
}

clamp_phase_3() {
    echo "Phase 3: Updating policy/clamp snapshots . . ."
    
    # shellcheck disable=SC2034
    # shellcheck disable=SC2046
    read -r repo \
            latest_released_tag \
            latest_snapshot_tag \
            changed_files \
            docker_images \
        <<< $(grep "policy/clamp" "$release_data_file" | tr ',' ' ' )

    if [ ! "$repo" = "policy/clamp" ]
    then
        echo "repo 'policy/clamp' not found in file '$release_data_file'"
        exit 1
    fi

    next_release_version=${latest_snapshot_tag%-*}

    if [ "$latest_released_tag" = "$next_release_version" ]
    then
        major_version=$(echo "$next_release_version" | $SED -E 's/^([0-9]*)\.[0-9]*\.[0-9]*$/\1/')
        minor_version=$(echo "$next_release_version" | $SED -E 's/^[0-9]*\.([0-9]*)\.[0-9]*$/\1/')
        patch_version=$(echo "$next_release_version" | $SED -E 's/^[0-9]*\.[0-9]*\.([0-9]*)$/\1/')
        # shellcheck disable=SC2004
        new_patch_version=$(($patch_version+1))

        new_snapshot_tag="$major_version"."$minor_version"."$new_patch_version"-SNAPSHOT

        echo "updating snapshot version of policy/clamp to $new_snapshot_tag . . ."
        mvn -f "$repo_location/policy/clamp" \
            "-DnewVersion=$new_snapshot_tag" -DgenerateBackupPoms=false \
            versions:set versions:update-child-modules versions:commit

        temp_file=$(mktemp)

        echo "updating snapshot version in $repo_location/policy/clamp/version.properties"
        $SED -e "s/patch=$patch_version/patch=$new_patch_version/" \
            "$repo_location/policy/clamp/version.properties" > "$temp_file"
        mv "$temp_file" "$repo_location/policy/clamp/version.properties"

        echo "generating commit to update snapshot version of policy/clamp . . ."

        generateCommit.sh \
            -l "$repo_location" \
            -r "policy/clamp" \
            -i "$issue_id" \
            -e "Update snapshot of policy/clamp to latest snapshot" \
            -m "policy/clamp updated to its latest snapshot"

        echo "commit to update snapshot version of policy/clamp generated"
    else
        echo "snapshot version already updated, skipping phase 3"
    fi
    
    echo "Phase 3 complete: policy/clamp snapshots updated"
}

clamp_phase_4() {
    echo "Phase 4: Updating release data in policy/parent . . ."
    
    release_data_file_name=$(basename "$release_data_file")

    if [ -n "$release_data_file_tag" ]
    then
        updateRefs.sh \
            -t "$release_data_file_tag" \
            -d "$release_data_file" \
            -l "$repo_location" \
            -r "policy/parent"
    else
        echo "updating release data at $repo_location/policy/parent/integration/src/main/resources/release/$release_data_file_name"
        cp "$release_data_file" \
            "$repo_location/policy/parent/integration/src/main/resources/release/$release_data_file_name"
    fi
    
    generateCommit.sh \
        -l "$repo_location" \
        -r "policy/parent" \
        -i "$issue_id" \
        -e "update release data in policy/parent" \
        -m "updated release data in policy/parent"
    
    echo "Phase 4 complete: release data updated in policy/parent"
}

if [ -z "$release_phase" ]
then
    echo "Executing all phases for policy/clamp release . . ."
    clamp_phase_1
    clamp_phase_2
    clamp_phase_3
    clamp_phase_4
    echo "All phases complete: policy/clamp release finished"
else
    case "$release_phase" in
    1)  clamp_phase_1
        ;;
    2)  clamp_phase_2
        ;;
    3)  clamp_phase_3
        ;;
    4)  clamp_phase_4
        ;;
    *)  echo "specified release phase '$release_phase' is invalid"
        exit 1
        ;;
    esac
fi
