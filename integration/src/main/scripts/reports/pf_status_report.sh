#!/bin/bash

# ============LICENSE_START================================================
# ONAP
# =========================================================================
# Copyright (C) 2022 Nordix Foundation.
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

function health_check() {
    health_dir="$1"

    health_report_temp_file=$(mktemp)

    report_month=$( \
        curl -s "https://logs.onap.org/onap-integration/daily/$health_dir"/ | \
        grep href | \
        sort | \
        tail -1 | \
        sed -e 's/^.*href="//' \
            -e 's/\/".*$//'
    )

    report_last_health=$( \
        curl -s "https://logs.onap.org/onap-integration/daily/$health_dir/$report_month/" | \
        grep href | \
        sort | \
        tail -1 | \
        sed -e 's/^.*href="//' \
            -e 's/\/".*$//'
    )

    curl -s --output "$health_report_temp_file" \
        "https://logs.onap.org/onap-integration/daily/$health_dir/$report_month/$report_last_health/xtesting-healthcheck/full/full/report.html"

    if file "$health_report_temp_file" | grep -q gzip
    then
        health_check_result=$(
            gunzip -c "$health_report_temp_file" | \
                grep 'window.output\["stats"\]' | \
                sed 's/},{/}\n{/g' | \
                grep health-policy | \
                sed -e 's/{//g' \
                    -e 's/}//g' \
                    -e 's/"//g' \
                    -e 's/label://' | \
             awk -F',' '{printf("%s,%s,%s\n", $3,$4,$2)}'
        )

        report_day="${report_last_health%%_*}"
        report_hour_minute="${report_last_health#*_}"
        report_hour_minute="${report_hour_minute/-/:}"
        printf "$health_dir,$report_month-$report_day $report_hour_minute,$health_check_result\n"
        printf "\thttps://logs.onap.org/onap-integration/daily/$health_dir/$report_month/$report_last_health/xtesting-healthcheck/full/full/report.html\n"
    else
        printf "$health_dir,$report_month-$report_day $report_hour_minute,result not available\n"
        printf "\thttps://logs.onap.org/onap-integration/daily/$health_dir/$report_month/$report_last_health/xtesting-healthcheck/full/full/report.html\n"
    fi
}

echo ""
echo "health checks"
echo "-------------"

health_check onap-daily-dt-oom-master
health_check onap-daily-dt-oom-kohn
health_check onap-daily-dt-oom-jakarta
health_check onap-daily-dt-oom-istanbul

jenkins_report_temp_file=$(mktemp)

curl -s https://jenkins.onap.org/view/policy/ |
    sed -e 's/<tr id=/\n<tr id=/g' \
        -e 's/><td data=/\n><td data=/g' |
    grep 'tr id=' |
    sed -e 's/"//g' \
        -e 's/<tr id=//' \
        -e 's/class= //' |
    grep '^job_' > "$jenkins_report_temp_file"

echo ""
echo "failing jobs"
echo "------------"

grep "job-status-red" "$jenkins_report_temp_file" |
    grep -v stage |
    grep -v release-merge |
    cut -f1 -d' ' |
    sed 's/_/\//' |
    awk '{printf("https://jenkins.onap.org/%s\n", $1)}'

echo ""
echo "warning jobs"
echo "------------"

grep "job-status-yellow" "$jenkins_report_temp_file" |
    grep -v clm |
    cut -f1 -d' ' |
    sed 's/_/\//' |
    awk '{printf("https://jenkins.onap.org/%s\n", $1)}'

echo ""
echo "invalid jobs"
echo "------------"
grep -v -E "(job-status-red|job-status-yellow|job-status-blue)" "$jenkins_report_temp_file" |
    grep -v stage |
    cut -f1 -d' ' |
    sed 's/_/\//' |
    awk '{printf("https://jenkins.onap.org/%s\n", $1)}'

echo ""
echo "bugs"
echo "----"
curl -s https://jira.onap.org/issues/?jql=PROJECT%20%3D%20POLICY%20AND%20issuetype%20%3D%20Bug%20AND%20status%20!%3D%20Closed%20ORDER%20BY%20key%20ASC |
    grep 'data-issue-table-model-state' |
    sed -e 's/&quot/\"/g' \
        -e 's/.*";jiraHasIssues";:true,";page";:[0-9]*,";pageSize";:[0-9]*,";startIndex";:[0-9]*,";table";:\[//' \
        -e 's/,";title";:";";,";total";:[0-9]*,";url";:";";,";sortBy";:\].*$//' \
        -e 's/}}/}}\n/g' |
    grep 'POLICY-' |
    sed -e 's/^.*key=/key=/g' \
        -e 's/";:";/=/g' \
        -e 's/";,";/,/g' \
        -e 's/^.*key=/key=/g' \
        -e 's/";:{";description=.*$//' \
        -e 's/key=POLICY-\([0-9]*\),/https:\/\/jira.onap.org\/browse\/POLICY-\1 /'

