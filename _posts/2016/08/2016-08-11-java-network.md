---
layout: post
title:  "[JAVA] Java 网络编程"
date:   2016-08-11
desc: "network programming in Java"
keywords: "java, thread， thread pool， timer"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 网络编程

## I. 网络编程概述

### 1. 计算机网络

计算机网络，是指将地理位置不同的具有独立功能的多台计算机及其外部设备，通过通信线路连接起来，在网络操作系统，网络管理软件及网络通信协议的管理和协调下，实现资源共享和信息传递的计算机系统。

### 2. 网络编程

网络编程，就是用来实现网络互连的不同计算机上运行的程序间可以进行数据交换

### 3. 网络模型

计算机网络之间以何种规则进行通信，就是网络模型研究问题。


#### ```OSI```（Open System Interconnection开放系统互连）参考模型

-	```应用层```：主要是一些终端的应用，比如说FTP（各种文件下载），WEB（IE浏览），QQ之类的（可以把它理解成我们在电脑屏幕上可以看到的东西．就是终端应用）
-	```表示层``` ：主要是进行对接收的数据进行解释、加密与解密、压缩与解压缩等（也就是把计算机能够识别的东西转换成人能够能识别的东西（如图片、声音等）
-	```会话层``` ：通过传输层（端口号：传输端口与接收端口）建立数据传输的通路。
	-	主要在你的系统之间发起会话或者接受会话请求（设备之间需要互相认识可以是IP也可以是MAC或者是主机名）
-	```传输层``` ：定义了一些传输数据的协议和端口号（WWW端口80等）
	-	```TCP``` ：传输控制协议，传输效率低，可靠性强，用于传输可靠性要求高，数据量大的数据
	-	```UDP```：用户数据报协议，与TCP特性恰恰相反，用于传输可靠性要求不高，数据量小的数据，如QQ聊天数据就是通过这种方式传输的
	-	主要是将从下层接收的数据进行分段和传输，到达目的地址后再进行重组
	-	这一层数据叫做```段```
-	```网络层``` ：主要将从下层接收到的数据进行IP地址（例192.168.0.1)的封装与解封装
	-	在这一层工作的设备是```路由器```
	-	这一层的数据叫做```数据包```
-	```数据链路层```：主要将从物理层接收的数据进行MAC地址（网卡的地址）的封装与解封装
	-	在这一层工作的设备是```交换机```，数据通过交换机来传输。
	-	这一层的数据叫做```帧```
-	```物理层```：主要定义物理设备标准，如网线的接口类型、光纤的接口类型、各种传输介质的传输速率等
	-	它的主要作用是传输比特流（就是由1、0转化为电流强弱来进行传输,到达目的地后在转化为1、0，也就是我们常说的数模转换与模数转换）
	-	这一层的数据叫做```比特```。


#### ```TCP/IP``` 参考模型

![network-model]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/network_model.png)


一个网络应用程序，实际上，是由 ```网络编程```， ```IO 流```， 和 ```多线程``` 组成

## II. 网络编程三要素

-	```IP地址``` : InetAddress，网络中计算机的唯一标识，可用主机名
	-	IP地址是用来找到要通信的那个计算机
-	```端口号``` ： Port，用于标识进程的逻辑地址，不同进程的标识
	-	端口用于区分计算机中不同的程序进程
-	```传输协议``` ： Protocol，通讯的规则，常见协议：TCP，UDP

### 1. IP 地址

要想让网络中的计算机能够互相通信，必须为每台计算机指定一个标识号，通过这个标识号来指定要接受数据的计算机和识别发送的计算机，在TCP/IP协议中，这个标识号就是IP地址，而且是唯一标识。

#### IP 地址的本质

-	IP 地址实际上是一个二进制数据：
	-	```192.168.1.100``` <==> ```11000000 10101000 00000001 01100100```
-	为了方便表示 IP地址：
	-	```点分十进制```： 把IP地址上的每一个字节上的数据换算成十进制，然后用 ```.``` 分开来表示
-	IP地址组成： 网络号段 + 主机号段


#### IP 的分类

-	```A类```:第一段号码为网络号码，剩下的三段号码为本地计算机的号码
	-	```1.0.0.1---127.255.255.254	``` ： 一个网络号段能够分配 256*256*256 = 16777216 台计算机
	-	```10.X.X.X``` ：私有地址，就是在互联网上不使用，而被用在局域网络中的地址
	-	```127.X.X.X``` ： 保留地址，用做循环测试用的
-	```B类```:前二段号码为网络号码，剩下的二段号码为本地计算机的号码
	-	```128.0.0.1---191.255.255.254```： 一个网络号段能够分配 256*256 = 65536 台计算机
	-	```172.16.0.0---172.31.255.255```： 私有地址
	-	```169.254.X.X```：保留地址
-	```C类```:前三段号码为网络号码，剩下的一段号码为本地计算机的号码
	-	```192.0.0.1---223.255.255.254```： 一个网络号段能够分配 256 台计算机（常见）
	-	```192.168.X.X``` ：私有地址
-	```D类``` ： ```224.0.0.1---239.255.255.254``` （保留，未使用）
-	```E类``` ： ```240.0.0.1---247.255.255.254``` （保留，未使用）
-	特殊地址:
	-	```127.0.0.1``` 回环地址,```localhost```
	-	```xxx.xxx.xxx.0``` 网络地址
	-	```xxx.xxx.xxx.255``` 广播地址




#### Java 中使用 IP地址

为了方便我们对IP地址的获取和操作，java提供了一个类 ```java.net.InetAddress``` 供我们使用， 我们来看代码：

```java
package org.lovian.network.ip;

import java.net.InetAddress;
import java.net.UnknownHostException;

/*
 * InetAddress 成员方法：
 * public static InetAddress getByName(String host): 根据主机名或 IP 地址的字符串表示来得到 IP 地址对象（静态方法返回）
 * public String getHostName() : 获取主机名（host）
 * public String getHostAddress(): 获取 IP 地址
 *
 */
public class InetAddressDemo {
	public static void main(String[] args) throws UnknownHostException {

		// 通过 host name 获取 InetAddress 实例对象
		InetAddress address = InetAddress.getByName("www.google.fr");
		// 获取 host
		String hostName = address.getHostName();
		String ip = address.getHostAddress();
		System.out.println("Host: " + hostName + " IP: " + ip);

		// 通过 ip 获取 InetAddress 实例对象
		InetAddress address2 = InetAddress.getByName("216.58.208.195");
		// 获取 host
		String hostName2 = address2.getHostName();
		String ip2 = address2.getHostAddress();
		System.out.println("Host2: " + hostName2 + " IP2: " + ip2);
	}
}
```

result：

```
Host: www.google.fr IP: 216.58.208.195
Host2: par10s21-in-f3.1e100.net IP2: 216.58.208.195
```

注意：

-	如果一个类没有构造方法，一般来说，有如下几种情况
	-	成员变量全部都是静态的（Math， Arrays， Collections)
	-	单例设计模式（Runtime）
	-	类中有静态方法返回该类的对象(InetAddress)

### 2. 端口号

-	物理端口 ：网卡口
-	逻辑端口 ：我们指的就是逻辑端口
	-	每个网络程序都会至少有一个逻辑端口
	-	用于标识进程的逻辑地址，不同进程的标识
	-	有效端口：0~65535，其中 0~1024 系统使用或保留端口


### 3. 协议UDP和TCP

#### UDP

-	将数据源和目的封装成数据包中
-	每个数据包的大小在限制在64k
-	不需要建立连接，```面向无连接```
-	因无连接，是```不可靠```协议
-	不需要建立连接，```速度快```
-	举例：
	-	聊天留言，在线视频，视频会议，发短信，邮局包裹

#### TCP

-	建立连接，形成传输数据的通道
-	```面向连接```，```速度慢```，是```可靠```协议
-	```三次握手```完成连接
-	```四次挥手```断开链接
-	在连接中进行```大数据量```传输
-	举例：
	-	下载，打电话，QQ聊天(你在线吗,在线,就回应下,就开始聊天了)


### 4. Socket 编程

-	```Socket``` ：
	-	网络套接字
	-	网络上具有唯一标识的IP地址和端口号组合在一起才能构成唯一能识别的标识符套接字
	-	```Socket包含： IP地址 + 端口```
-	Socket编程其实就是指的网络编程

#### Socket原理机制

-	通信的两端都有Socket
-	网络通信其实就是Socket间的通信
-	数据在两个Socket间通过```IO传输```

Socket 机制图解：
![socket2]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/socket2.png)

Socket 举例图解：
![socket]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/socket.png)



## III. UDP 编程

### 1. UDP传输

-	```java.net.DatagramSocket```：
	-	此类表示用```UDP```来发送和接收数据报包的套接字
	-	数据报套接字是包投递服务的发送或接收点
	-	每个在数据报套接字上发送或接收的包都是单独编址和路由的
	-	从一台机器发送到另一台机器的多个包可能选择不同的路由，也可能按不同的顺序到达
	-	不对包投递做出保证（不可靠）
	-	在 DatagramSocket 上总是启用 UDP 广播发送
-	 ```java.net.DatagramPacket```：
	-	此类表示数据报包
	-	包含的信息指示：
		-	将要发送的数据
		-	数据长度
		-	远程主机的 IP 地址和远程主机的端口号
-	UDP传输思路
	-	建立发送端，接收端。
	-	建立数据包。
	-	调用Socket的发送接收方法。
	-	关闭Socket。
	-	发送端与接收端是两个独立的运行程序

### 2. UDP传输-发送端思路

-	建立udp的socket服务
-	将要发送的数据封装成数据包
-	通过udp的socket服务,将数据包发送出
-	关闭资源 (底层是 IO 流)

```java
package org.lovian.network.udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/*
 * UDP发送端发送数据：
 * A: 创建发送端Socket对象
 * B: 创建数据，并把数据打包
 * C: 调用 Socket 对象的发送方法发送数据包
 * D: 释放资源（底层是 IO 流）
 */
public class UDPSender {
	public static void main(String[] args) throws IOException {
		// Create UDP Socket Object
		DatagramSocket ds = new DatagramSocket();

		// Create data and data package
		// Includes: data, length, ip address, port
		// public DatagramPacket(byte[] buf, int length, InetAddress address, int port): 用于发送数据包
		byte[] bys = "hello, this is udp sender!".getBytes();
		int length = bys.length;
		InetAddress address = InetAddress.getByName("localhost");
		int port = 10086;
		DatagramPacket dp = new DatagramPacket(bys, length, address, port);

		// Send package
		ds.send(dp);
		// Close
		ds.close();
	}
}
```

### 3. UDP传输-接收端思路

-	建立udp的socket服务.
-	通过receive方法接收数据
-	将收到的数据存储到数据包对象中
-	通过数据包对象的功能来完成对接收到数据进行解析.
-	可以对资源进行关闭

```java
package org.lovian.network.udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

/*
 * UDP接收端接受数据：
 * A: 创建发送端Socket对象
 * B: 创建一个数据包（接收容器）
 * C: 调用Socket对象的接收方法接收数据
 * D: 解析数据并处理
 * D: 释放资源（底层是 IO 流）
 */
public class UDPReceiver {
	public static void main(String[] args) throws IOException {
		// Create Socket Object, port is 10086
		DatagramSocket ds = new DatagramSocket(10086);

		// Create a data package
		// public DatagramPacket(byte[] buf, int length) : 用于接收数据包
		byte[] bys = new byte[1024]; // 1k
		int length = bys.length;
		DatagramPacket dp = new DatagramPacket(bys, length);

		// Receive data
		ds.receive(dp);

		// Parse data package (DatagramPacket)
		// public InetAddress getAddress(): 获取发送方 ip 地址
		// public byte[] getData(): 获取数据缓冲区
		// public int getLength(): 获取数据实际长度
		InetAddress address = dp.getAddress();
		byte[] data = dp.getData();
		int dataLength = dp.getLength();
		String s = new String(data, 0, dataLength);
		System.out.println(
				"Received: " + s + "; From host: " + address.getHostName() + " IP: " + address.getHostAddress());

		// Close
		ds.close();
	}
}
```

注意：

-	```receive(DatagramPacket dp)``` 方法在接收到数据前一直处于阻塞状态
-	如果接收到的信息比接收数据包的长度长，那么该信息将被截短
-	在运行发送端之前，必须先运行接收端

result：

```
Received: hello, this is udp sender!; From host: zhengshuai.lovian.xmi IP: 127.0.0.1
```

## IV. TCP 编程
