---
layout: post
title:  "Use jekyll to test your github-blog on Ubuntu Linux"
date: 2015-11-06
desc: "use jekyll to test blog locally"
keywords: "Linux, ubuntu, github-pages, jekyll ruby rvm"
categories: [linux]
---

# Jekyll Envirnoment Configuration

This tutorial is to set the environment with jekyll, this is a kind of web server which you can test your github-pages blog locally in your laptop. Each times you can make the modification and test it locally , after testing, you can post to your github

## I. Install RUBY

*	Install rvm

```
sudo apt-add-repository ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm
```

*	Modified the Terminal Preference

In order to always load RVM, you need to set GNOME Terminal (or whatever terminal emulator you use) to run Bash as login shell. To do this for GNOME Terminal, from its menu select Edit > Profile Preferences and on the Title and Command tab, enable "Run command as login shell".

*	relogin

```
source /etc/profile.d/rvm.sh
```

*	Install ruby

```
rvm install ruby
```

	use

```
ruby --verison
```

	 to check the version of ruby you just instsalled.

## II. Install the Jekyll

*	Install Jekyll

```
gem install jekyll
```

if you met some faults when install the jekyll, please use sudo
*	How to use Jekyll
Enter into the folder of your blog, and type the command

```
cd /path/blog
jekyll serve --watch
```

*	Use broswer
For now, you can access your blog locally through

```
localhost:4000
```

## III. Bug Fixed

Second time when you open terminal and want to use jekyll server again, generally, it will return back an error. Because the terminal initialized and the ruby version now  default used 1.9.x, so we need do some modification and to use ruby 2.2.1 version.

*	Reset rvm

```
rvm reset
rvm version
```

	when it doesn't show warning infomation, we can do next step

*	use ruby 2.2.1 version

```
rvm use ruby-2.2.1
```

	it should return you back like following:

```
Using /home/zhengshuai/.rvm/gems/ruby-2.2.1
```


*	now we can change directory to your blog, and run the command

```
jekyll serve --watch
```

	and now go to broswer with ```localhost:4000```, you can see your site

## IV. Update

For now, we can install jekyll more easier. After installed gem, just use gem to install github-pages, this package will include jekyll and the same environment of github pages, you could use it to test your site locally:

```
gem install github-pages
```

Then, go to the folder of your site, just use

```
jeykll serve
```

Open browser, access ```127.0.0.1:4000``` you will see your site
