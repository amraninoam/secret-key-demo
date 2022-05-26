#!/bin/bash
# Author: Noam Amrani
# This script creates an empty git repo
# It then creates 'dummy' commits (till total_commits)
# During the process, selects a place in the commit chain, and inserts a private key to it.
# The idea is to show that the key can be found with git log -S "PRIVATE"

# Variables
total_commits=50

# Dangerous script!
[[ "$PWD" != *temp* ]] && echo "This script will run only in a *temp* folder" && exit 1

# Create a temporary folder
temp_directory_name=$(date +%Y%m%d%H%M%S)
mkdir $temp_directory_name
cd $temp_directory_name

# Cleaning the git folder
git init
git checkout -b main

# Iterate to create commits
iterator=0
bug_location=$(( RANDOM % ($total_commits-1) ))
while [ $iterator -lt $total_commits ]
do
   if [[ $iterator -ne $bug_location ]] && [[ $iterator -ne 'bug_location + 1' ]]; then
      # Standard case - random string
      random_file_suffix=$(( RANDOM % 10 ))
      echo $RANDOM | md5sum | head -c 20 >> ./file-$random_file_suffix
      echo '' >> ./file-$random_file_suffix

      git add ./file-$random_file_suffix
      git commit -m "commit # $iterator"
      (( iterator++ ))
   else
      # add some sensitive key
      ssh-keygen -f secret_rsa -t rsa -b 4096 -q -N ""
      rm secret_rsa.pub
      git add secret_rsa
      git commit -m "commit # $iterator"
      (( iterator++ ))
      # delete the key!
      git revert HEAD --no-edit
      git commit --amend -m "commit # $iterator"
      (( iterator++ ))
   fi
done

# get the first sha introducing the private key
key_added_in_sha=$(git log -S "PRIVATE" --pretty=format:"%h" --no-patch -n 1)
# get the next shadeleting the private key
key_removed_in_sha=$(git log -S "PRIVATE" --pretty=format:"%h" --no-patch -n 2 | head -2 | tail -1)
# getting the diff and presenting the hidden key
echo -e "\n\nFound the key in $key_added_in_sha"
git diff $key_added_in_sha $key_removed_in_sha