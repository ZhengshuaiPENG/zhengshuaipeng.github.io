---
layout: post
title:  "[Git] How to specify multiple users in Git"
date:   2018-06-04
desc: "how to specify multiple users in git"
keywords: "git, multiply users, github"
categories: [git]
---

# How to specify multiple users in Git

Believe that almost developers may have two git account(users) for Github repos and also for company's repos.
So sometimes, the wrong user config in git may cause some problems.

To distinguish the user information between different repos, we could set our git config as below listing.

First, it's better to set a global user config:

```shell
$ git config --global user.name "Your Name Here"
$ git config --global user.email your@email.com
``` 
to check if it has been well set, use commands below:

```shell
$ git config --global user.name
$ git config --global user.email
```

If you are in the company's computer, it's better to set your company identifier as global config.

And then for each repo standalone, you can also set the user config.

```shell
$ cd /path/to/your/repo/
$ git config user.name "Your Name Here"
$ git config user.email your@email.com
```

Then under this repo, the user config will override the global user config. You can check it in file ```/path/to/your/repo/.git/config```