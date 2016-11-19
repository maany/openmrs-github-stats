#!/bin/bash
echo "What is your GitHub username "
read user
echo -n "Hey $user! Please enter your GitHub account password : "
read -s password #silent read
page=1
result=$(curl --user "$user":"$password" -X GET "https://api.github.com/orgs/openmrs/repos?type=all&page=$page&per_page=100&sort=full_name" | jq .[].name)
arr=($result)
number_of_results=${#arr[*]}
echo ${arr}
echo "$number_of_results"
for (( i=0; i<${number_of_results}; i++ ));
do
    echo ${arr[$i]}
    # obtain contribution details
done
