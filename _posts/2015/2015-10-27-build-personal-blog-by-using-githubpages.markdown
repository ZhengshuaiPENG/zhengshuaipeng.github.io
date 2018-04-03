---
layout: post
title:  "Use Github Pages To Build a Personal Blog"
date: 2015-10-27
desc: "use github-pages and jekyll to create a blog"
keywords: "github-pages, jekyll, github, gem, cname"
categories: [linux]
---


# Use Github Pages To Generate Blog

## I. Introduction

[Github](https://github.com/) is a code repository powerd by Git, we can put our project on Github. Github also provides us Github-Pages to generate personal blog. We can put our articles on it.

There is some advantages of Github Pages:

*	simple to deploy
*	Non-server requirement
*	Use Markup Language: [Markdown](https://help.github.com/articles/markdown-basics/)
*	Can blind your domain name

And also some drawback with Pages:

*	Use [Jekyll](https://github.com/jekyll/jekyll) system , like static pages
*	No comment, no search function, but there will be some ways to figure it out
*	Based on Git, you need some background about this

## II. Use Github to get your Github-Pages

Note that this tutorial based on Linux ubuntu distribution, other OS is similar.

### 1. Preparing work

You need some environment on your OS and some basic background as following:

*	Git
*	A Github account
*	Know how to connect to Github with a terminal

### 2. New a Github-Pages repository

1.	Login your account on Github and click + new repository ![new repository](https://github.com/ZhengshuaiPENG/BlogPictures/blob/master/Use%20Github%20Pages%20To%20Generate%20Blog/new_repository.png?raw=true){: .img-responsive} Remember the projectName!

2.	Create a local  folder on your disk, it's better that the folder's name is same as your repository

3.	Open Terminal:
	*	change directory to your folder

		```
		cd /path/directory
		```
	*	init the the git repository

		```
		git init
		```
	*	create your site by using jekyll


4.	Organize your site structure
	*	_includes: the folder consists the contents which the model can reference
	*	_layouts: the folder consists the common pages
	*	_posts: the folder consists the articles of blog
	*	_config.yml: the configuration of Jekyll model
	*	index.html: the default page
	*	You can follow my site structure on my Github: [blog](https://github.com/ZhengshuaiPENG/zhengshuaipeng.github.io)

5. Return your terminal
	*	save the modified in your local repository

		```
		git add .
		```
	*	commit your modified

		```
		git commit -m " first post"
		```
	*	Add a reference of remote repository to local repository

		```
		git remote add orgin https://github.com/username/projectName.git
		```
	*	push your commit, after it will let you input Username and password

		```
		git push origin master
		```
	*	After push, open a browser, and type the URL as follow:

		```
		http://username.github.io
		```

		you will see your blog in the website

## III. Bind a domain name

1.  First your should have a domain name, I would recommand to register one in Godaddy. Let's suppose that you have ```example.org```
2.  Go to your DNS Manager or DNS provider, we need to set the A record and CName here. As to what is A record and what is CName, please google it. My DNS manager is provided by Linode, So here I will use Linode DNS manager as example.
    *   Go to Linode DNS manager, first your should create a domain zone with ```example.org```
    *   Edit your domain done, in A/AAAA Records section, add the following ip addresses by add new A record:

    ```
    192.30.252.153
    192.30.252.154
    ```

    *   Then go to CNAME Records section, Add new CNAME record:

    ```
    Hostname: blog
    Aliases to: username.github.io
    TTL: Default
    ```

    *   Save the changes in your domain zone, now we need to check your domain name by using

    ```
    dig username.github.io +nostats +nocomments +nocmd
    dig blog.example.org +nostats +nocomments +nocmd
    ```

    if you see something like

    ```
    ➜  ~ dig zhengshuaipeng.github.io +nostats +nocomments +nocmd

    ; <<>> DiG 9.10.4-P1 <<>> zhengshuaipeng.github.io +nostats +nocomments +nocmd
    ;; global options: +cmd
    ;zhengshuaipeng.github.io.	IN	A
    zhengshuaipeng.github.io. 2610	IN	CNAME	github.map.fastly.net.
    github.map.fastly.net.	15	IN	A	185.31.19.133
    ➜  ~ dig blog.lovian.org +nostats +nocomments +nocmd

    ; <<>> DiG 9.10.4-P1 <<>> blog.lovian.org +nostats +nocomments +nocmd
    ;; global options: +cmd
    ;blog.lovian.org.		IN	A
    blog.lovian.org.	21599	IN	CNAME	zhengshuaipeng.github.io.
    zhengshuaipeng.github.io. 2583	IN	CNAME	github.map.fastly.net.
    github.map.fastly.net.	5	IN	A	185.31.18.133

    ```

    your setting should be okay.

    *   now ```blog.example.org``` should be binded to ```usernamae.github.io```. Next we need to go to your site folder, create a new file ```CNAME```, add ```blog.example.org```
    *   In your ```_config.yml```file, you should add following code:

    ```
    url: blog.example.org
    domain: example.org
    ```

