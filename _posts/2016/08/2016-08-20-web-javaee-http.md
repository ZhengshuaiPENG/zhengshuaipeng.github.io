---
layout: post
title:  "[Web] HTTP 协议"
date:   2016-08-20
desc: "HTTP protocol"
keywords: "web，network，http，protocol"
categories: [Web]
tags: [Web，HTTP]
icon: fa-keyboard-o
---

# HTTP 协议

### I. HTTP 协议

### 1. 什么是 HTTP 协议

在 BS 结构中，数据是从在浏览器之间交换，如下图所示：

![bs]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/http1.png)

那么数据如何传输，就涉及到网络的问题，而一个web 服务器，简单的说其实就是一个 Socket 服务端，那么就会利用到 TCP/IP 来建立网络连接，然后进行数据的传输。那么，数据传输的格式应该有个标准或者说规范，这样在浏览器和服务器之间才能够根据这个规范来传输数据，所以，就有了 HTTP 协议。

```HTTP``` 协议：

-	```HyperText Transfer Trotocol``` 超文本传输协议
-	对浏览器客户端 和  服务器端 之间数据传输的格式规范
-	是 ```TCP/IP``` 协议的一个应用层协议，用于定义WEB浏览器与WEB服务器之间交换数据的过程
-	基于请求(request)/响应(response)模型
	-	每次联机只作一次请求/响应，没有请求就没有响应
-	是无状态(stateless)协议
	-	服务器响应客户端后，就不会记得客户端的信息，也不会维护与客户端有关的状态
-	HTTP协议的版本：HTTP/1.0、HTTP/1.1

### 2. HTTP 和 TCP/IP 的关系

HTTP 在协议栈中的位置如下

![http-tcpip]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/http_tcpip.png)

可以看出 HTTP 协议是封装在 TCP 上一层的协议

-	TCP/IP 关注的是数据传输是否成功
-	HTTP 关注的是数据传输的格式规范

### 3. HTTP 数据传输图示

实际上，把浏览器看作一个 Socket 客户端程序，服务器程序看作一个 Socket 服务端程序：

-	他们之间通过 TCP 进行三次握手进行连接
-	建立连接之后，浏览器向服务器通过HTTP协议发送请求 ```request``` 来请求服务器的资源
-	服务器接收到请求后进行读取和解析，然后给浏览器发送一个响应 ```response```，发送浏览器请求的资源内容
-	然后浏览器读取并解析响应，然后把得到的资源展示给用户看

![http]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/http2.png)


## II. HTTP 协议内容

### 1. 如何查看 HTTP 的请求和响应

可以通过 FireFox 的 Firebug 工具进行查看，下面我们请求一个简单的 Servlet 程序，可以从 Firebug 里面看到如下的内容：

![firebug]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/firebug.png)

### 2. HTTP 请求 Request

请求： 浏览器 -> 服务器

-	客户端连上服务器后，向服务器请求某个 web 资源，称为客户端向服务器发送了一个 HTTP 请求
-	一个完整的 HTTP 请求包含如下内容
	-	一个请求行
	-	若干个请求头
	-	一个空行和实体内容（可选）

```
GET /TomcatTest/ HTTP/1.1			// 请求行
Host: localhost:8080				// 请求头（多个 key-value 对象
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:48.0) Gecko/20100101 Firefox/48.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Cookie: JSESSIONID=ED5D141179E6996D890B2A1889D50437
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Cache-Control: max-age=0
									// 一个空行
//name=xiaoming&password=123456		// 实体内容， 这里这一行只是举例，实际上这次请求并不包括这一行
```


#### 请求行

```
GET /TomcatTest/ HTTP/1.1
```

格式： ```请求方法 URL HTTP协议版本```

-	HTTP 协议版本：
	-	HTTP/1.0 ：浏览器和服务器建立连接之后，只能发送一次请求，一次请求之后关闭连接
	-	HTTP/1.1 ：浏览器和服务器建立连接之后，可以在一次连接中发送多次请求（效率高，一般使用这个版本）
-	```URL```：
	-	Uniform Resource Locator, 统一资源定位符
	-	用来标记互联网的资源
	-	```http://localhost:8080/TomcatTest/index.html```
-	```URI```：Uniform Resource Identifier, 统一资源标记符
	-	URL 是 URI 的子集，用来标识任意的资源
-	请求方法：
	-	```GET``` : 向服务器取得（GET）指定的资源，并返回实体主体
	-	```POST``` ：向指定资源提交数据进行处理请求（例如提交表单或者上传文件）。数据被包含在请求体中。POST请求可能会导致新的资源的建立和/或已有资源的修改
	-	```PUT``` ：从客户端向服务器传送的数据取代指定的文档的内容
	-	```DELETE``` ：请求服务器删除指定的资源
	-	```HEAD``` ： 类似于get请求，只不过返回的响应中没有具体的内容，用于获取报头
	-	```TRACE``` ：回显服务器收到的请求，主要用于测试或诊断
	-	```CONNECT``` ：HTTP/1.1协议中预留给能够将连接改为管道方式的代理服务器

常用的方法是 GET 和 POST：

-	```GET``` 方式提交数据
	-	地址栏```URI```会跟上参数数据。以 ```？``` 开头，多个参数之间以 ```&``` 分割
	-	GET提交参数数据有限制，不超过1KB
	-	GET方式不适合提交敏感密码
	-	浏览器直接访问的请求，默认提交方式是GET方式

```
// GET 请求 示例
GET /testMethod.html?name=eric&password=123456 HTTP/1.1
Host: localhost:8080
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: zh-cn,en-us;q=0.8,zh;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Referer: http://localhost:8080/day09/testMethod.html
Connection: keep-alive
```

-	```POST``` 方式提交数据
	-	参数不会跟着URI后面，参数而是跟在请求的实体内容中。```没有？开头```，多个参数之间以 ```&``` 分割
	-	POST提交的参数数据没有限制
	-	POST方式提交敏感数据
	-	POST方式避免请求缓存数据

```
// POST 请求 示例
POST /day09/testMethod.html HTTP/1.1
Host: localhost:8080
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:35.0) Gecko/20100101 Firefox/35.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: zh-cn,en-us;q=0.8,zh;q=0.5,en;q=0.3
Accept-Encoding: gzip, deflate
Referer: http://localhost:8080/day09/testMethod.html
Connection: keep-alive

name=eric&password=123456
```

#### 请求头

常见的请求头：

```
Accept: text/html,image/*      // 浏览器接受的数据类型
Accept-Charset: ISO-8859-1     // 浏览器接受的编码格式
Accept-Encoding: gzip,compress  //浏览器接受的数据压缩格式
Accept-Language: en-us,zh-       //浏览器接受的语言
Host: www.it315.org:80          //（必须的）当前请求访问的目标地址（主机:端口）
If-Modified-Since: Tue, 11 Jul 2000 18:23:51 GMT  //浏览器最后的缓存时间
Referer: http://www.it315.org/index.jsp      // 当前请求来自于哪里
User-Agent: Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0)  // 浏览器类型
Cookie:name=eric                     // 浏览器保存的cookie信息
Connection: close/Keep-Alive            // 浏览器跟服务器连接状态。close: 连接关闭  keep-alive：保存连接。
Date: Tue, 11 Jul 2000 18:23:51 GMT      // 请求发出的时间
```

注意： 一般情况下，一旦 WEB 服务器向浏览器发送了请求数据，它就要关闭 TCP 连接，然后如果浏览器或者服务器在其头信息加入了这行代码，```Connetion： Keep-Alive``` 那么 TCP 连接在发送数据后仍然保持打开状态，然后浏览器可以通过相同的连接发送请求，保持连接节省了每个请求建立新连接所需的时间，还节约了网络带宽


#### 实体内容

只有 POST 提交的参数会放到实体内容中

#### 如果在 Servlet 中得到请求的信息示例

如果获得请求信息，如果获得提交的数据，请参考 [ZhengshuaiPENG/org.lovian.javaee](https://github.com/ZhengshuaiPENG/org.lovian.javaee/tree/master/src/org/lovian/javaee/servlet/request)



### 3. HTTP 响应 Response

响应： 服务器 -> 浏览器

响应头信息 Response Header

```
HTTP/1.1 200 OK		// 响应行
Server: Apache-Coyote/1.1		//响应头（key-value）
Content-Type: text/html;charset=UTF-8
Content-Length: 263
Date: Sun, 21 Aug 2016 13:42:15 GMT
									// 一个空行
this is hello servlet.				// 实体内容
```

#### 响应行

```
HTTP/1.1 200 OK		// 响应行
```

-	格式：```HTTP 协议版本 状态码 状态描述```
-	状态码： 用于表示服务器对请求的处理结构，是一个三位的十进制数，分为五类
	-	```100-199``` ： 表示成功接到请求，要求客户端继续提交下一次请求才能完成整个处理过程
	-	```200-299``` ： 表示成功接收请求并已完成整个处理过程，常用 200
	-	```300-399``` ： 为完成请求，客户端需要进一步细化请求，比如请求的资源已经移动到一个新地址，常用 302, 304,307
	-	```400-499``` ： 客户端请求有错误，常用 404
	-	```500-599``` ： 服务器端出现错误，常用 500

#### 响应头

常见的响应头：

```
Location: http://www.it315.org/index.jsp 	// 重定向的地址，该头和302状态码一起使用
Server:apache tomcat 						// 表示服务器的类型
Content-Encoding: gzip						// 表示服务器发送给浏览器的数据压缩类型
Content-Length: 80							// 表示服务器发送给浏览器的数据长度
Content-Language: zh-cn						// 表示服务器支持的语言
Content-Type: text/html; charset=GB2312		// 表示服务器发送给浏览器的数据类型及内容编码
Last-Modified: Tue, 11 Jul 2000 18:23:51 GMT		// 服务器资源的最后修改时间
Refresh: 1;url=http://www.it315.org 				// 表示定时刷性
Content-Disposition: attachment; filename=aaa.zip  	// 表示告诉浏览器以下载方式打开资源
Transfer-Encoding: chunked
Set-Cookie:SS=Q0=5Lb_nQ; path=/search 				// 表示服务器发送给浏览器的 cookie 信息
Expires: -1											// 表示通知浏览器不进行缓存
Cache-Control: no-cache								// 表示通知浏览器不进行缓存
Pragma: no-cache									// 表示通知浏览器不进行缓存
Connection: close/keep-alive  						// 表示服务器和浏览器的连接状态
```
#### 如果在 Servlet 中设置响应的信息示例

如果要在sevlet里设置响应的信息，请参考 [ZhengshuaiPENG/org.lovian.javaee](https://github.com/ZhengshuaiPENG/org.lovian.javaee/tree/master/src/org/lovian/javaee/servlet/response)
