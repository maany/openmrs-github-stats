#!/bin/bash
OUTPUT_FILE=~/github_details_openmrs.out
cp /dev/null ${OUTPUT_FILE}
printf "[\n" >> ${OUTPUT_FILE} #  start of JSON array
echo "What is your GitHub username "
read user
echo -n "Hey $user! Please enter your GitHub account password : "
read -s password #silent read
page=1
result=$(curl --user "$user":"$password" -X GET "https://api.github.com/orgs/openmrs/repos?type=all&page=$page&per_page=100&sort=full_name" | jq .[].name)
repos=($result)
number_of_results=${#repos[*]}
echo "$number_of_results"
for (( i=0; i<${number_of_results}; i++ ));
do
    printf "  {\n" >> ${OUTPUT_FILE}
    repo_name=${repos[$i]}
    repo_name="${repo_name:1:-1}"
    printf "    \"repo_name\" : \"${repo_name}\", \n" >> ${OUTPUT_FILE}
    # obtain number of commits
    echo "Finding number of weekly commits for $repo_name";
    commits_url="https://api.github.com/repos/openmrs"
    commits_url="$commits_url/${repo_name}/stats/commit_activity"
    weekly_commits_string=$(curl --user ${user}:${password} -X GET $commits_url | jq .[].total)
    weekly_commits=($weekly_commits_string)
    printf "    \"weekly_commits\" : \"${weekly_commits[*]}\",\n" >> ${OUTPUT_FILE}
    #echo " weekly_commits : ${weekly_commits_string}"
    #total_commits_year=0
    #for (( j=0; j<${#weekly_commits[*]}; j++ ))
    #do
    #  total_commits_year=$(( ${total_commits_year}+${weekly_commits[${j}]} ))
    #done
    #average_monthly_commits=$(( ${total_commits_year}/12 ))

    #find pull request details
    echo "Finding number of pull requests for $repo_name"
    pull_request_dates=$( curl --user ${user}:${password} -X GET "https://api.github.com/repos/openmrs/${repo_name}/pulls?state=all&page=1&per_page=100" | jq .[].created_at)
    pull_request_montly=$(python ./formatter.py -p "${pull_request_dates}")
    printf "    \"monthly_pr\" : ${pull_request_montly}\n" >> ${OUTPUT_FILE}
    #echo "Number of pull requests : $pull_request_count"

    #group number of commits by month

    #group number of pull requests by month
    printf "  },\n" >> ${OUTPUT_FILE}
done
echo "]" >> ${OUTPUT_FILE} #  end of JSON array
