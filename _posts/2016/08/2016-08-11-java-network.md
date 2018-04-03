---
layout: post
title:  "[JAVA] Java 网络编程"
date:   2016-08-11
desc: "network programming in Java"
keywords: "java, udp， tcp， network, io"
categories: [java]
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

![network-model](/assets/blog/2016/08/network_model.png)


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
![socket2](/assets/blog/2016/08/socket2.png)

Socket 举例图解：
![socket](/assets/blog/2016/08/socket.png)



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
-	多次启用接受端会报端口被占用异常

result：

```
Received: hello, this is udp sender!; From host: zhengshuai.lovian.xmi IP: 127.0.0.1
```

### 4. UDP 广播案例

接收键盘输入，通过udp来发送广播

接收端：

```java
package org.lovian.network.udp;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Date;

public class BroadcastReceiver {
	public static void main(String[] args) throws IOException {
		// 创建接收端 socket 对象
		DatagramSocket ds = new DatagramSocket(10086);

		// 接收数据
		while (true) {
			byte[] buf = new byte[1024];
			DatagramPacket dp = new DatagramPacket(buf, buf.length);
			ds.receive(dp);
			// 处理翻译数据
			String s = new String(dp.getData(), 0, dp.getLength());
			System.out.println("Recieved From: " + dp.getAddress().getHostAddress() + " Time: " + new Date() + " Data: " + s);
			// 结束
			if(s.equals("bye")){
				System.out.println("Terminated");
				break;
			}
		}
		ds.close();
	}
}
```

发送端：

```java
package org.lovian.network.udp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Date;

public class BroadcastSender {
	public static void main(String[] args) throws IOException{
		//创建 socket 对象
		DatagramSocket ds = new DatagramSocket();

		// 创建键盘输入对象
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String line = null;
		// 读取键盘数据
		while((line = br.readLine()) != null){
			System.out.println("Send From: " + InetAddress.getByName("localhost") + " Time: " + new Date());
			byte[] buf = line.getBytes();
			// 发送到广播地址： x.x.x.255, port: 10086
			DatagramPacket dp = new DatagramPacket(buf, buf.length, InetAddress.getByName("10.30.167.255"), 10086);
			// 发送数据
			ds.send(dp);
			//如果字符为 bye， 结束
			if(line.equals("bye")){
				System.out.println("Terminated");
				break;
			}
		}
		ds.close();
	}
}
```

result：


```
// 发送端：
hello
Send From: localhost/127.0.0.1 Time: Mon Aug 15 12:27:16 CEST 2016
how are you
Send From: localhost/127.0.0.1 Time: Mon Aug 15 12:27:23 CEST 2016
bye
Send From: localhost/127.0.0.1 Time: Mon Aug 15 12:27:30 CEST 2016
Terminated

// 接收端：
Recieved From: 10.30.164.189 Time: Mon Aug 15 12:27:16 CEST 2016 Data: hello
Recieved From: 10.30.164.189 Time: Mon Aug 15 12:27:23 CEST 2016 Data: how are you
Recieved From: 10.30.164.189 Time: Mon Aug 15 12:27:30 CEST 2016 Data: bye
Terminated
```

## IV. TCP 编程

### 1. TCP传输

-	```java.net.Socket```
	-	此类实现 TCP 客户端套接字
	-	套接字的实际工作由 SocketImpl 类的实例执行
-	```java.net.ServerSocket```
	-	此类实现 TCP 服务器套接字
	-	服务器套接字等待请求通过网络传入
	-	服务器套接字的实际工作由 SocketImpl 类的实例执行
-	TCP 传输思路
	-	建立客户端和服务器端
	-	建立连接后，通过Socket中的IO流进行数据的传输
	-	建立客户端和服务器端关闭socket
	-	建立客户端和服务器端同样，客户端与服务器端是两个独立的应用程序。


### 2. TCP传输--客户端思路

-	建立客户端的Socket服务,并明确要连接的服务器
-	如果连接建立成功,就表明,已经建立了数据传输的通道.就可以在该通道通过IO进行数据的读取和写入.该通道称为Socket流,Socket流中既有读取流,也有写入流
-	通过Socket对象的方法,可以获取这两个流
-	通过流的对象可以对数据进行传输
-	如果传输数据完毕,关闭资源

```java
package org.lovian.network.tcp;

import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;

/*
 * TCP协议发送数据：
 * A: 创建发送端的socket对象
 *        这一步成功，就说明连接已经建立成功了
 * B：获取输出流，写数据
 * C: 释放资源
 */
public class Client {
	public static void main(String[] args) throws IOException{
		// 创建客户端的 Socket 对象, 两种主要构造方法
		// Socket(InetAddress address, int port);
		// Socket(String host, int port);
		Socket socket =  new Socket("localhost", 10086);

		// 获取输出流
		OutputStream os = socket.getOutputStream();
		// 写数据
		os.write("hello, this is TCP client".getBytes());

		// 释放资源
		socket.close();
	}
}
```


### 3. TCP传输--服务器端思路

-	建立服务器端的socket服务，需要一个端口
-	服务端没有直接流的操作,而是通过accept方法获取客户端对象，在通过获取到的客户端对象的流和客户端进行通信
-	通过客户端的获取流对象的方法,读取数据或者写入数据
-	如果服务完成,需要关闭客户端,然后关闭服务器，但是,一般会关闭客户端,不会关闭服务器,因为服务端是一直提供服务的

```java
package org.lovian.network.tcp;

import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

/*
 * TCP协议接收数据
 * A: 创建接收端的 ServerSocket 对象
 * B: 监听客户端，返回一个对象的 Socket 对象
 * C: 获取输入流读取数据，并处理显式
 * D: 释放资源
 */
public class Server {
	public static void main(String[] args) throws IOException{
		//创建接收端的 ServerSocket 对象
		// ServerSocket(int port);
		ServerSocket ss = new ServerSocket(10086);

		// 监听客户端，返回一个对象的 Socket 对象
		// public Socket accept()： 阻塞式方法
		Socket socket = ss.accept();

		// 获取输入流，读取数据并显示在控制台
		InputStream is = socket.getInputStream();

		byte[] buf = new byte[1024];
		int length = 0;
		while((length = is.read(buf)) != -1){
			String str = new String(buf, 0, length);
			System.out.println("From: " + socket.getInetAddress().getHostAddress() + " Time: " + new Date());
			System.out.println("Data: " + str);
		}
		// 释放资源 (关闭客户端的)
		socket.close();
		ss.close(); // 服务器端应该一直处于监听状态，不应该关闭
	}
}
```

result：

```
From: 127.0.0.1 Time: Mon Aug 15 14:54:09 CEST 2016
Data: hello, this is TCP client
```

注意：

-	要先运行服务器端进行监听， 再运行客户端，否则会出现连接被拒绝的错误
-	服务器端一般来说是一直运行的
	-	所以要关闭客户端的连接，释放资源
	-	服务器端可以不关闭
-	```serverSocket.accept()```:
	-	是一个阻塞方法， 用来接收客户端连接
	-	连接成功则建立通道
		-	通过 OutputStream 和 write 方法来发送数据
		-	通过 InputStream 和 read 方法来接收数据， read也是阻塞方法
	-	如果没有客户端连接，则服务器就阻塞在这


### 4. TCP 传输实例

客户端键盘录入数据，服务器输出到控制台

客户端：

```java
package org.lovian.network.tcp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.util.Date;

public class TcpClient {
	public static void main(String[] args) throws IOException {
		Socket socket = new Socket("localhost", 10086);

		// 键盘录入数据
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		// 包装 TCP 通道内的字节流 --> 字符流 --> 高效字符流
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

		String line = null;
		while ((line = br.readLine()) != null) {
			bw.write(line);
			bw.newLine();
			bw.flush();
			System.out.println("From: " + socket.getInetAddress().getHostAddress() + " Time: " + new Date());
			if ("bye".equals(line)) {
				// 键盘录入数据要自定义结束标记
				System.out.println("Termiated");
				break;
			}
		}
		socket.close();
	}
}
```

服务器端：

```java
package org.lovian.network.tcp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

public class TcpServer {
	public static void main(String[] args) throws IOException{
		ServerSocket ss = new ServerSocket(10086);
		// 监听客户端
		Socket socket = ss.accept();

		// 包装通道内的输入字节流 --> 输入字符流 --> 高效字符流
		BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		String line = null;
		while((line = br.readLine()) != null){
			System.out.println("From: " + socket.getInetAddress().getHostAddress() + " Time: " + new Date());
			System.out.println("Data: " + line);
			if("bye".equals(line)){
				System.out.println("Termiated");
				break;
			}
		}

		socket.close();
		ss.close();
	}
}
```

result：

```
// 客户端：
hello
From: 127.0.0.1 Time: Mon Aug 15 16:00:14 CEST 2016
how are you
From: 127.0.0.1 Time: Mon Aug 15 16:00:28 CEST 2016
bye
From: 127.0.0.1 Time: Mon Aug 15 16:00:34 CEST 2016
Termiated

// 服务器端：
From: 127.0.0.1 Time: Mon Aug 15 16:00:14 CEST 2016
Data: hello
From: 127.0.0.1 Time: Mon Aug 15 16:00:28 CEST 2016
Data: how are you
From: 127.0.0.1 Time: Mon Aug 15 16:00:34 CEST 2016
Data: bye
Termiated
```


## V. 多线程网络编程

一个网络应用程序，实际上，是由 ```多线程```， ```网络编程``` 和 ```IO流``` 组成。因为同一台服务器也许要同时处理很多个客户端连接，而这些客户端可能是并发的连接到服务器的。

下面看一个多客户端上传文件的案例：

客户端代码：

```java
package org.lovian.network.tcp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;

public class UploadClient {
	public static void main(String[] args) throws IOException {
		// 创建客户端socket对象，指定服务器的 host 和端口
		Socket s = new Socket("localhost", 10086);

		// 封装要上传的文本文件
		BufferedReader br = new BufferedReader(new FileReader("text.txt"));

		// 封装通道内的客户端的输出流
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));

		// 读取文件内容
		String line = null;
		while ((line = br.readLine()) != null) {
			// 通过通道输出流传送文件内容
			bw.write(line);
			bw.newLine();
			bw.flush();
		}

		// 发送传输结束标志，发送结束之前的所有内容
		s.shutdownOutput();

		// 通过客户端输入流获取服务器的反馈信息
		BufferedReader brClient = new BufferedReader(new InputStreamReader(s.getInputStream()));
		String serverFeedBack = brClient.readLine(); // 阻塞方法，有反馈就执行，没有反馈就阻塞
		System.out.println(serverFeedBack);

		br.close();
		s.close();
	}
}
```

处理线程代码：

```java
package org.lovian.network.tcp;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;

public class processThread implements Runnable {

	private Socket s;

	// 通过构造方法传入每一个客户端线程的 socket 对象
	public processThread(Socket s) {
		this.s = s;
	}

	@Override
	public void run() {
		BufferedWriter bw = null;
		try {
			// 上传文件，相当于读取文件-->发送数据到服务器-->服务器把数据写入服务器中的文件
			// 为了防止名称冲突，使用时间作为存储文件名（小规模并发）
			bw = new BufferedWriter(new FileWriter(System.currentTimeMillis() + "_text.txt"));
			// 封装通道输入流用来读取客户端发来的数据
			BufferedReader br = new BufferedReader(new InputStreamReader(s.getInputStream()));

			// 读取数据
			String line = null;
			while ((line = br.readLine()) != null) { // 阻塞方法
				// 将读取到的数据写入服务器
				bw.write(line);
				bw.newLine();
				bw.flush();
			}
			// 当服务器收到客户端发来的结束信号，读取操作停止

			// 给出上传成功反馈
			BufferedWriter bwServer = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));
			bwServer.write("File uploaded successfully");
			bwServer.newLine();
			bwServer.flush();

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				bw.close();
				s.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
```

服务器端代码：

```java
package org.lovian.network.tcp;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class UploadServer {
	public static void main(String[] args) throws IOException{
		// 创建TCP服务器 Socket 对象，指定监听端口
		ServerSocket ss = new ServerSocket(10086);

		while(true){
			// 监听客户端连接
			Socket s = ss.accept(); // 阻塞方法，成功则建立通道
			// 执行每一个客户端的线程
			new Thread(new processThread(s)).start();
		}
	}
}
```
