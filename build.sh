#!/bin/bash
# Author: Hugo ChunHo Lin
# Date: 2024/03/30
# Version: v0.0.1

# Delete the gh-pages branch (forcefully)
git branch -D gh-pages

# Clean up the public folder
hexo clean

# Generate static files
hexo generate

# Clear the contents of .deploy_git folder
rm -rf .deploy_git/*

# Copy contents from public folder to .deploy_git folder
cp -r public/* .deploy_git/

# Create or overwrite CNAME file with desired content
echo "blog.1chooo.com" > .deploy_git/CNAME

# Commit and push changes to gh-pages branch
timestamp=$(date +"%Y-%m-%d %T")
commit_message="feat: site updated $timestamp"
cd .deploy_git || exit
git init
git add .
git commit -m "$commit_message"
git remote add origin git@github.com:1chooo/blog.1chooo.com.git # Replace <repository_url> with your actual repository URL
git checkout -b gh-pages
git push -u origin gh-pages
