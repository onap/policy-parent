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
    echo "$SCRIPT_NAME - updates the inter-repo references in Policy Framework POM files"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h           - this help message"
    echo "         -d data_file - the policy release data file to use, generated by the 'getReleaseData.sh' script,"
    echo "                        defaults to '$release_data_file'"
    echo "         -l location  - the location of the policy framework repos on the file system,"
    echo "                        defaults to '$repo_location'"
    echo "         -r repo      - the policy repo to update"
    echo "         -p           - update policy/parent references"
    echo "         -c           - update policy/common references"
    echo "         -m           - update policy/model references"
    echo "         -o           - update policy/drools-pdp references"
    echo "         -k           - update docker base images in Dockerfiles"
    echo "         -s           - update release references to snapshot references,"
    echo "                        if omitted, snapshot references are updated to release references"
    echo ""
    echo " examples:"
    echo "  $SCRIPT_NAME -pcm -r policy/pap"
    echo "              update the parent, common, and models references of policy/pap"
    echo "              to the current released version"
    echo ""
    echo "  $SCRIPT_NAME -c -m -s -r policy/api"
    echo "              update the common and models references of policy/api"
    echo "              to the current snapshot version"
    exit 255;
}

update_parent=false
update_common=false
update_models=false
update_drools_pdp=false
update_snapshot=false
update_docker=false

while getopts "hd:l:r:pcmoks" opt
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
    p)
        update_parent=true
        ;;
    c)
        update_common=true
        ;;
    m)
        update_models=true
        ;;
    o)
        update_drools_pdp=true
        ;;
    k)
        update_docker=true
        ;;
    s)
        update_snapshot=true
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

read parent_repo \
     parent_latest_released_tag \
     parent_latest_snapshot_tag \
     parent_changed_files \
     parent_docker_images \
    <<< $( grep policy/parent $release_data_file | tr ',' ' ' )

read common_repo \
     common_latest_released_tag \
     common_latest_snapshot_tag \
     common_changed_files \
     common_docker_images \
    <<< $( grep policy/common $release_data_file | tr ',' ' ' )

read docker_repo \
     docker_latest_released_tag \
     docker_latest_snapshot_tag \
     docker_changed_files \
     docker_docker_images \
    <<< $( grep policy/docker $release_data_file | tr ',' ' ' )

read models_repo \
     models_latest_released_tag \
     models_latest_snapshot_tag \
     models_changed_files \
     models_docker_images \
    <<< $( grep policy/models $release_data_file | tr ',' ' ' )

read drools_pdp_repo \
     drools_pdp_latest_released_tag \
     drools_pdp_latest_snapshot_tag \
     drools_pdp_changed_files \
     drools_pdp_docker_images \
    <<< $( grep policy/drools-pdp $release_data_file | tr ',' ' ' )

read target_repo \
	 target_latest_released_tag \
	 target_latest_snapshot_tag \
	 target_changed_files \
	 target_docker_images \
	<<< $( grep $specified_repo $release_data_file | tr ',' ' ' )

if [ -z "$target_repo" ]
then
    echo "specified repo '$specified_repo' not found in policy release data file '$release_data_file'"
    exit 1
fi

if [ ! "$specified_repo" = "$target_repo" ]
then
    echo "specified repo '$specified_repo' does not match target repo '$target_repo'"
    exit 1
fi

if [ "$update_parent" = true ]
then
    if [ "$specified_repo" = "policy/parent" ]
    then
        if [ "$update_snapshot" = true ]
        then
            echo updating policy parent reference to $parent_latest_snapshot_tag on $repo_location/$target_repo . . .
            sed -i '' \
                "s/<version.parent.resources>.*<\/version.parent.resources>/<version.parent.resources>$parent_latest_snapshot_tag<\/version.parent.resources>/" \
                 $repo_location/policy/parent/integration/pom.xml
            result_code=$?
        else
            next_release_version=${parent_latest_snapshot_tag%-*}

            echo updating policy parent reference to $next_release_version on $repo_location/$target_repo . . .
            sed -i '' \
                "s/<version.parent.resources>.*<\/version.parent.resources>/<version.parent.resources>$next_release_version<\/version.parent.resources>/" \
                 $repo_location/policy/parent/integration/pom.xml
            result_code=$?
            result_code=$?
        fi
    else
        if [ "$update_snapshot" = true ]
        then
            echo updating policy parent reference to $parent_latest_snapshot_tag on $repo_location/$target_repo . . .
            updateParentRef.sh \
                -f $repo_location/$target_repo/pom.xml \
                -g org.onap.policy.parent \
                -a integration \
                -v $parent_latest_snapshot_tag
            result_code=$?
        else
            echo updating policy parent reference to $parent_latest_released_tag on $repo_location/$target_repo . . .
            updateParentRef.sh \
                -f $repo_location/$target_repo/pom.xml \
                -g org.onap.policy.parent \
                -a integration \
                -v $parent_latest_released_tag
            result_code=$?
        fi
    fi
    if [[ "$result_code" -eq 0 ]]
    then
        echo policy parent reference updated on $repo_location/$target_repo
    else
        echo policy parent reference update failed on $repo_location/$target_repo
        exit 1
    fi
fi

if [ "$update_common" = true ]
then
    if [ "$update_snapshot" = true ]
    then
        echo updating policy common reference to $common_latest_snapshot_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.common.version>.*<\/policy.common.version>/<policy.common.version>$common_latest_snapshot_tag<\/policy.common.version>/" \
            -e "s/<version.policy.common>.*<\/version.policy.common>/<version.policy.common>$common_latest_snapshot_tag<\/version.policy.common>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    else
        echo updating policy common reference to $common_latest_released_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.common.version>.*<\/policy.common.version>/<policy.common.version>$common_latest_released_tag<\/policy.common.version>/" \
            -e "s/<version.policy.common>.*<\/version.policy.common>/<version.policy.common>$common_latest_released_tag<\/version.policy.common>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    fi
    if [[ "$result_code" -eq 0 ]]
    then
        echo policy common reference updated on $repo_location/$target_repo
    else
        echo policy common reference update failed on $repo_location/$target_repo
        exit 1
    fi
fi

if [ "$update_models" = true ]
then
    if [ "$update_snapshot" = true ]
    then
        echo updating policy models reference to $models_latest_snapshot_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.models.version>.*<\/policy.models.version>/<policy.models.version>$models_latest_snapshot_tag<\/policy.models.version>/" \
            -e "s/<version.policy.models>.*<\/version.policy.models>/<version.policy.models>$models_latest_snapshot_tag<\/version.policy.models>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    else
        echo updating policy models reference to $models_latest_released_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.models.version>.*<\/policy.models.version>/<policy.models.version>$models_latest_released_tag<\/policy.models.version>/" \
            -e "s/<version.policy.models>.*<\/version.policy.models>/<version.policy.models>$models_latest_released_tag<\/version.policy.models>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    fi
    if [[ "$result_code" -eq 0 ]]
    then
        echo policy models reference updated on $repo_location/$target_repo
    else
        echo policy models reference update failed on $repo_location/$target_repo
        exit 1
    fi
fi

if [ "$update_drools_pdp" = true ]
then
    if [ "$update_snapshot" = true ]
    then
        echo updating policy drools-pdp reference to $drools_pdp_latest_snapshot_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.drools-pdp.version>.*<\/policy.drools-pdp.version>/<policy.drools-pdp.version>$drools_pdp_latest_snapshot_tag<\/policy.drools-pdp.version>/" \
            -e "s/<version.policy.drools-pdp>.*<\/version.policy.drools-pdp>/<version.policy.drools-pdp>$drools_pdp_latest_snapshot_tag<\/version.policy.drools-pdp>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    else
        echo updating policy drools-pdp reference to $drools_pdp_latest_released_tag on $repo_location/$target_repo . . .
        sed -i '' \
            -e "s/<policy.drools-pdp.version>.*<\/policy.drools-pdp.version>/<policy.drools-pdp.version>$drools_pdp_latest_released_tag<\/policy.drools-pdp.version>/" \
            -e "s/<version.policy.drools-pdp>.*<\/version.policy.drools-pdp>/<version.policy.drools-pdp>$drools_pdp_latest_released_tag<\/version.policy.drools-pdp>/" \
            $repo_location/$target_repo/pom.xml
        result_code=$?
    fi
    if [[ "$result_code" -eq 0 ]]
    then
        echo policy drools-pdp reference updated on $repo_location/$target_repo
    else
        echo policy drools-pdp reference update failed on $repo_location/$target_repo
        exit 1
    fi
fi

if [ "$update_docker" = true ] && [ "$target_docker_images" != "" ]
then
    echo updating docker base images to version $docker_latest_released_tag on repo $repo_location/$target_repo
    find $repo_location/$target_repo \
        -name '*Docker*' \
        -exec sed -r -i '' "s/^(FROM onap\/policy-j[d|r][k|e]-alpine:)2.3.1$/\1$docker_latest_released_tag/" {} \;
    result_code=$?
    if [[ "$result_code" -eq 0 ]]
    then
        echo docker base images updated on $repo_location/$target_repo
    else
        echo docker base images update failed on $repo_location/$target_repo
        exit 1
    fi
fi
