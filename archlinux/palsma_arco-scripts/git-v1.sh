#!/bin/bash
#set -e
# checking if I have the latest files from github
echo "Checking for newer files online first"
git pull

# Below command will backup everything inside the project folder
git add --all .

read input
# Committing to the local repository with a message containing the time details and commit text
git commit -m "$input"
# Push the local files to github

git push -u origin main

