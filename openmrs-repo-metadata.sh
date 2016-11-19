#!/bin/bash
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
    repo_name=${repos[$i]}
    repo_name="${repo_name:1:-1}"

    # obtain number of commits
    echo "Finding number of weekly commits for $repo_name";
    commits_url="https://api.github.com/repos/openmrs"
    commits_url="$commits_url/${repo_name}/stats/participation"
    #curl --user ${user}:${password} -X GET $commits_url

    #find pull request details
    echo "Finding number of pull requests for $repo_name"
    pull_request_count=$( curl --user ${user}:${password} -X GET "https://api.github.com/repos/openmrs/${repo_name}/pulls?state=all&page=1&per_page=100" | jq .[].id | wc -l)
    echo "Number of pull requests : $pull_request_count"
done
