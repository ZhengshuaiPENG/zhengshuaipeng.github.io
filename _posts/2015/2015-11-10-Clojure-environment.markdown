---
layout: post
title:  "Clojure Environment With VIM/Emacs On Linux"
date: 2015-11-10
desc: "set clojure environment with vim/emacs on linux"
keywords: "Linux, VIM, emacs, Clojure, leinigen"
categories: [Linux]
tags: [Linux,VIM, Emacs, Clojure]
icon: fa-linux
---
# How to set Clojure environment with vim/Emacs

[Clojure](http://clojure.org/), is a dynamic programming language which tagets the JVM. It is a dialect of Lisp, and shares with Lisp the code-as-data philosophy and a powerful macro system. Clojure has many features which diferrent with OOP languages like C++.

Here I will introduce you how to set the environment on Linux. Although in the offical site, there is tutorials about this, but it's not very clair.

I recommend that it's better to use an editor like VIM or Emacs and a Clojure tool with Terminal. Absolutely, There is the plugins for IDEs like La Clojure with IDEAJ, etc. You can choose whatever you like.

For VIM/Emacs beginner, you'd better to follow vim tutorial first. It will last probably one hour, but worth it! Just go ahead.

Now, you should be sure that you have a machine with Linux(here I use LinuxMint) and network.

---

## 1 Install Leiningen

Leiningen is a tool for Clojure, it makes you feel more easier with Clojure.

*	Go to [Leiningen](leiningen.org), to download the script
*	Open Terminal

		```bash
		cd Downloads/
		ls
		sudo mv lein /usr/local/bin/
		cd /usr/local/bin/
		sudo chmod +x lein
		./lein
		```

*	Set profiles.clj

		```bash
		cd ~/.lein && vim profiles.clj
		{:user {:plugins [[cider/cider-nrepl "0.10.0-SNAPSHOT"]]
				:dependencies [[org.clojure/tools.nrepl "0.2.12"]]}}
		```

	use :wq save it


*	To see if success

		```
		lein version
		```

*	Some commands

		```bash
		Several tasks are available:
		change              Rewrite project.clj by applying a function.
		check               Check syntax and warn on reflection.
		classpath           Print the classpath of the current project.
		clean               Remove all files from project's target-path.
		compile             Compile Clojure source into .class files.
		deploy              Build and deploy jar to remote repository.
		deps                Download all dependencies.
		do                  Higher-order task to perform other tasks in succession.
		help                Display a list of tasks or help for a given task.
		install             Install the current project to the local repository.
		jar                 Package up all the project's files into a jar file.
		javac               Compile Java source files.
		new                 Generate project scaffolding based on a template.
		plugin              DEPRECATED. Please use the :user profile instead.
		pom                 Write a pom.xml file to disk for Maven interoperability.
		release             Perform :release-tasks.
		repl                Start a repl session either with the current project or standalone.
		retest              Run only the test namespaces which failed last time around.
		run                 Run a -main function with optional command-line arguments.
		search              Search remote maven repositories for matching jars.
		show-profiles       List all available profiles or display one if given an argument.
		test                Run the project's tests.
		trampoline          Run a task without nesting the project's JVM inside Leiningen's.
		uberjar             Package up the project files and dependencies into a jar file.
		update-in           Perform arbitrary transformations on your project map.
		upgrade             Upgrade Leiningen to specified version or latest stable.
		vcs                 Interact with the version control system.
		version             Print version for Leiningen and the current JVM.
		with-profile        Apply the given task with the profile(s) specified.


		Run `lein help $TASK` for details.

		Global Options:
		  -o             Run a task offline.
		  -U             Run a task after forcing update of snapshots.
		  -h, --help     Print this help or help for a specific task.
		  -v, --version  Print Leiningen's version.

		These aliases are available:
		downgrade, expands to upgrade
		```

## II. VIM

### 1. Install VIM

*	You can install vim from package manager

		```bash
		sudo apt-get install vim
		```


### 2. Configure VIM


*	Generally, vim is supported by kinds of plugins which implemented by vimscript. As a beginner, I recommend you to use other people's vim configuration

*	Here for example, I use the configuration [spf13/spf13-vim](https://github.com/spf13/spf13-vim), you can install it just follow the tutorial

###3. Install vim-fireplace

*	There is many tools to develop Clojures, Here I will introduce a plugin for VIM, called [vim-fireplace](https://github.com/tpope/vim-fireplace)

*	After you install the spf13/spf13-vim, in your home directory, press CTRL-H, you will see the hidden files

*	Create a new file called  ***.vimrc.bundles.local***, and add the following command, and save it

		```
		Bundle 'tpope/vim-fireplace'
		```
*	Open Terminal

		```bash
		 vim +BundleInstall! +BundleClean +q
		```

*	So far, we have done with Clojure environment

### 3. How to use

*	Open Terminal

		```bash
		lein repl
		```
	you will get return back the information of host, port, and some others

*	Open vim, new a .clj file, and type some Clojure codes
*	Execute

		```
		:Connect
		```

	 fill with port address, and scope, i.e. test.clj just returned you back in the Terminal

*	Stop the cursor in the Clojure function snippet and execute

		```
		: Eval
		```

	thus you can see the result


## III. Emacs

### 1. Install emacs

*	You can install emacs 24.3 in package manager

		```bash
		sudo apt-get install emacs
		```

*	Or you can go to the offical site to download and install the newer version, but I think 24.3 is enough to use

### 2. Configuration

*	First, you may need some simple configuration to make your emacs more effective, here I recommand a [emacs.d](https://github.com/purcell/emacs.d) of purcell. His configuration already integrated the environment which we need for clojure.

		```bash
		git clone https://github.com/purcell/emacs.d.git ~/.emacs.d
		```

*	Or you can get your own configuration, and install [cider](https://github.com/clojure-emacs/cider)  according to this [doc-tutorial](http://clojure-doc.org/articles/tutorials/emacs.html)

### 3. How to use

*	Use emacs to open a clojure file, i.e. test.clj
*	Press **C-c M-j** to open a REPL session, or **M-c cider-jack-in**
*	Then you will see a new window of buffer, you can write the clojure code directly
*	In the test.clj, press **C-c C-k** to compile your file, and you will see the result
*	Or you can go to the end of each statement in the file, press **C-c C-e**, the result will be shown after your code directly
*	**C-c C-o** , to clean the information of repl seesion
*	**C-c C-d**, to check the doc of function
*	**C-c M-n**, to switch the namespace of repl session


Now, Enjoy your Clojure time!
