#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t terminal
mv public ../site-out
git checkout master #Change branch
rm -drf * #Remove current files
mv ../site-out/* . #Fetch new static files into root directory

# Add changes to git.
git add -A

# Commit changes.
msg="Deploy commit `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Trigger the build
git push origin master

# Rmove local build
rm -drf ../site-out