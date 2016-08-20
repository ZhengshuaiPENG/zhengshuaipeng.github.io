---
layout: post
title:  "[Web] Web 服务器和 Tomcat 的使用"
date:   2016-08-20
desc: "web server and tomcat"
keywords: "java, web， webserver，tomcat"
categories: [Web]
tags: [Web，Tomcat]
icon: fa-keyboard-o
---

# Web 服务器和 Tomcat 的使用

## I. Web 服务器

### 1.软件的结构

-	C/S (Client - Server  客户端-服务器端)
	-	典型应用：QQ软件 ，飞秋，红蜘蛛。
	-	特点：
		-	必须下载特定的客户端程序。
		-	服务器端升级，客户端升级。

-	B/S （Broswer -Server 浏览器端- 服务器端）
	-	典型应用： 腾讯官方（www.qq.com）  163新闻网站（俗称：网站）
	-	特点：
		-	不需要安装特定的客户端（只需要安装浏览器即可）
		-	服务器端升级，浏览器不需要升级
	-	javaweb的程序就是b/s软件结构

### 2. Web 服务软件

Web 服务软件就是安装在服务器上的一个 SocketServer， 它的作用就是把本地资源分享给外部访问，如下图

![webserver]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/webServer.png)

服务器软件在服务器端，监听者端口，而客户端的浏览器其实就是一个个的 Socket 客户端。如何编写一个简易的服务器端，请参考[[JAVA] Java 网络编程 ](http://blog.lovian.org/java/2016/08/11/java-network.html) 的最后一个章节， 多线程网络编程。

常用的 Web Server 有：

-	WebLogic: BEA 公司开发，支持 JavaEE 规范
-	WebSphere: IBM 公司开发，支持 JavaEE 规范
-	JBoss: Redhat 公司开发，支持 JavaEE 规范
-	Tomcat: apache开发，支持部分 JavaEE 规范（JSP/Servlet）

## II. Tomcat 的使用

### 1. 下载Tomcat

下载 Tomcat 请去 [http://tomcat.apache.org/](http://tomcat.apache.org/) 上下载，我们下载 Tomcat 8 的 [Core.zip](http://apache.mindstudios.com/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.zip), 在自己的电脑上解压到一个路径（本笔记使用 Linux 环境）

### 2. 启动，运行和关闭Tomcat

我的Tomcat路径是 ```/opt/web-server/tomcat/apache-tomcat-8```，目录下有这么几个文件夹：

![Tomcat——tree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tomcat_tree.png)

那么 Tomcat 的目录结构就是：

-	```bin```: 存放tomcat的命令。
-	```conf```: 存放tomcat的配置信息。其中server.xml文件是核心的配置文件。
-	```lib```：支持tomcat软件运行的jar包。其中还有技术支持包，如servlet，jsp
-	```logs```：运行过程的日志信息
-	```temp```: 临时目录
-	```webapps```： 共享资源目录。web应用目录
-	```work```： tomcat的运行目录。jsp运行时产生的临时文件就存放在这里



-	启动 Tomcat：
	-	先使用 Terminal 进入 Tomcat 路径
	-	在命令行里执行 ``` sh bin/catalina.sh run```
	-	在浏览器打开 [localhost:8080](localhost:8080), 如果出现下个画面，则运行成功

![Tomcat——run]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tomcat-run.png)

-	关闭 Tomcat：
	-	一般来说服务器会在后台运行，那么我们在启用的时候，在命令后加个 ```&``` 让 Tomcat 在后台运行
	-	```sh bin/catalina.sh run &```
	-	这时使用 ```bg``` 命令可以看到后台有一个tomcat在运行
	-	然后如果要关闭它，则执行 ```sh bin/catalina.sh stop```
	-	使用 ```bg``` 发现 tomcat 进程已经没有了

-	注意事项，在系统里必须设置好 Java 的环境变量


### 3. 设置 Tomcat 的监听端口

Tomcat 的配置文件位于 Tomcat 目录下的 ```conf/server.xml```, 这个文件中可以对 Tomcat 的端口进行更改

```
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```

### 4. 部署 WebApp

```webapps``` 目录： tomcat 的项目部署目录，把需要部署的项目放在此目录中

假如我们现在有个项目叫做 Mail， 然后我们把整个项目目录拷贝进 Tomcat 的 webapps 目录（也可以是打包好的 war 包），那么结构如下图：


![Tomcat——deploy]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tomcat-deploy.png)

然后在浏览器打开 [localhost:8080/Mail/index.html](localhost:8080/Mail/index.html) 就可以进行访问

这里要说一下 Web应用的目录结构：

-	```webapps```
	-	WebRoot :   web应用的根目录
		-	静态资源（html+css+js+image+vedio）
		-	WEB-INF ： 固定写法。
			-	classes： （可选）固定写法。存放class字节码文件
			-	lib： （可选）固定写法。存放jar包文件。
			-	web.xml

注意：

-	不可以直接在 webapps 目录下部署单个的 web 文件
-	WEB-INF目录里面的资源不能通过浏览器直接访问
-	如果希望访问到WEB-INF里面的资源，就必须把资源配置到一个叫web.xml的文件中。
