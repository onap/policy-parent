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

if [[ "$OSTYPE" == "darwin"* ]]
then
    SED="gsed"
else
    SED="sed"
fi

usage()
{
    echo ""
    echo "$SCRIPT_NAME - update the parent reference in a POM file"
    echo ""
    echo "       usage:  $SCRIPT_NAME [-options]"
    echo ""
    echo "       options"
    echo "         -h             - this help message"
    echo "         -f pom_file    - the POM file to update"
    echo "         -g group_id    - the parent group ID"
    echo "         -a artifact_id - the parent artifact ID"
    echo "         -v version     - the parent version"
    exit 255;
}

while getopts "hf:g:a:v:" opt
do
    case $opt in
    h)
        usage
        ;;
    f)
        pom_file=$OPTARG
        ;;
    g)
        group_id=$OPTARG
        ;;
    a)
        artifact_id=$OPTARG
        ;;
    v)
        version=$OPTARG
        ;;
    \?)
        usage
        exit 1
        ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    esac
done

if [ $OPTIND -eq 1 ]
then
    echo "no arguments were specified"
    usage
fi

if [ ! -f "$pom_file" ]
then
    echo "POM file '$pom_file' specified on '-f' flag not found"
    exit 1
fi

if [ -z "$group_id" ]
then
    echo "group ID not specified on '-g' flag"
    exit 1
fi

if [ -z "$artifact_id" ]
then
    echo "artifact ID not specified on '-a' flag"
    exit 1
fi

if [ -z "$version" ]
then
    echo "version not specified on '-v' flag"
    exit 1
fi

pom_lines=`wc -l $pom_file | $SED 's/^[ \t]*//' | cut -f1 -d' '`
parent_start_line=`grep -n '^[\t ]*<parent>[\t*]*$' $pom_file | cut -f1 -d':'`
parent_end_line=`grep -n '^[\t ]*</parent>[\t*]*$' $pom_file | cut -f1 -d':'`

pom_head_lines=$((parent_start_line-1))
pom_tail_lines=$((pom_lines-parent_end_line))

pom_temp_file=$(mktemp)

head -$pom_head_lines $pom_file                      >  $pom_temp_file
echo "    <parent>"                                  >> $pom_temp_file
echo "        <groupId>$group_id</groupId>"          >> $pom_temp_file
echo "        <artifactId>$artifact_id</artifactId>" >> $pom_temp_file
echo "        <version>$version</version>"           >> $pom_temp_file
echo "        <relativePath />"                      >> $pom_temp_file
echo "    </parent>"                                 >> $pom_temp_file
tail -$pom_tail_lines $pom_file                      >> $pom_temp_file

mv $pom_temp_file $pom_file
