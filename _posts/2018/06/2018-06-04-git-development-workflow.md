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
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

# II. Development Workflow

First, clone the repo to local.

```
$ cd /to/local/path
#clone repository
$ git clone ssh:xxxxxxxx.git
```

After clone has been done, you will have the master branch.
Then you may need to develop a feature or make a bugfix. 

Normally, we don't develop directly on master branch. So ```it's better to create a seperate branch for each feature or bug fix```.

```
# Create a feature branch
$ git checkout -b feature/foo master

# Make edits
$ git add changed files

# Commit your changes
# It's better to create jira ticket id or github issue id in each commit message
$ git commit -m "jira id:xxx"
```

Once the development is done, ```push the branch to server(github/bitbuket) and create a pull request to merge your changes```.

```
# Once the feature is done, merge lastest changes from master
$ git checkout master
$ git pull
$ git checkout feature/foo
$ git merge master

# Then push your branch to server and create a pull request
$ git push

# Once your pull request is merged and remote branch is deleted, clean up local branches
$ git fetch -p
```

The branch must build and pass all the tests before it can be merged.

# III. Branch Name Conventions

Use lowercase letters & numbers, 
-   ```-``` (minus/dash) for separators.

Branch names start with
-   ```feature/``` for new features
-   ```release/``` for releases
-   ```bugfix/``` for bug fixes


# IV. Some Git Commands

## 1. Diff before commit
Before commit, you can see what is about to be commited using ```git diff``` with ```--cached``` option

```
$ git add file1 fiel2
$ git diff --cached
```

To get a brief summary of the situation with ```git status```

## 2. Viewing project history

```
# At any point you can view history of changes
$ git log

# to see complete diffs at each step
$  git log -p

# overview of the change
$ git log --start --summary
```

## 3. Branch management

- create a new branch:

```
# Create a feature branch
$ git checkout -b feature/foo master
# or
$ git branch feature/foo 
```

- list all branches:

```
# list all branches
$ git branch

# you will get the result as below
 feature/foo
*master

# the asterisk(*) means the branch you currently on
```

- switch branch

```
# switch to feature/foo branch
$ git checkout feature/foo
```

- delete branch

```
# -d: ensures the changes in feature/foo are already in its upstream branch
$ git branch -d feature/foo

# -D: shortcut for --delete --force
$ git branch -D feature/foo
```

- update branch from master branch

```
$ git fetch origin
$ git merge origin/master
```