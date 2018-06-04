---
layout: post
title:  "[Git] Git Development Workflow"
date:   2018-06-04
desc: "Development workflow in Git"
keywords: "git, workflow, bitbucket"
categories: [git]
---

# I. Prerequisites

Install Git in system.

Make sure it in the ```PATH```, and set the name and email

```
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
```

# II. Development Workflow

First, clone the repo to local.

```
cd /to/local/path
#clone repository
git clone ssh:xxxxxxxx.git
```

After clone has been done, you will have the master branch.
Then you may need to develop a feature or make a bugfix. 

Normally, we don't develop directly on master branch. So ```it's better to create a seperate branch for each feature or bug fix```.

```
# Create a feature branch
git checkout -b feature/foo master

# Make edits
git add changed files

# Commit your changes
# It's better to create jira ticket id or github issue id in each commit message
git commit
```

Once the development is done, ```push the branch to server(github/bitbuket) and create a pull request to merge your changes```.

```
# Once the feature is done, merge lastest changes from master
git checkout master
git pull
git checkout feature/foo
git merge master

# Then push your branch to server and create a pull request
git push

# Once your pull request is merged and remote branch is deleted, clean up local branches
git fetch -p
```

The branch must build and pass all the tests before it can be merged.

# III. Branch Name Conventions

Use lowercase letters & numbers, 
-   ```-``` (minus/dash) for separators.

Branch names start with
-   ```feature/``` for new features
-   ```release/``` for releases
-   ```bugfix/``` for bug fixes