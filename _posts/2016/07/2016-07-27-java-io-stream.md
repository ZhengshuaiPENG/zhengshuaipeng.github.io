---
layout: post
title:  "[JAVA] Java 中的 IO流 Stream"
date:   2016-07-27
desc: "how to use io-stream in Java"
keywords: "java, io, File， iostream"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# IO stream in Java

## I. IO 流

-	IO流：
	-	用来进行设备间的数据传输问题
-	分类
	-	按流向：
		-	输入流： 数据流入程序，即读取数据
		-	输出流： 数据流出程序，即写出数据
	-	按数据类型：（同时他们分别也可以是输入流或者输出流）
		-	字节流：如果不知道如何选择，那么就用字节流
		-	字符流：为了方便操作文本数据; 如果操作的数据是文本数据，就用字符流


## II. IO 流常用类

### 1.字节流的两个抽象基类

-	```InputStream``` ：java.io.InputStream， 表示字节输入流的所有类的超类（抽象类）
-	```OutputStream``` ：java.io.OutputStream，此抽象类是表示输出字节流的所有类的超类。输出流接受输出字节并将这些字节发送到某个接收器（抽象类）

### 2.字符流的抽象基类

-	```Reader``` ：java.io.Reader，用于读取字符流的抽象类。子类必须实现的方法只有 read(char[], int, int) 和 close()。但是，多数子类将重写此处定义的一些方法，以提供更高的效率和/或其他功能
-	```Writer``` ：java.io.Writer，写入字符流的抽象类。子类必须实现的方法仅有 write(char[], int, int)、flush() 和 close()。但是，多数子类将重写此处定义的一些方法，以提供更高的效率和/或其他功能

### 3. 字节流的常用子类

#### FileOutputStream

java.io.FileOutputStream

-	用于将数据写入 File 或 FileDescriptor 的输出流
-	用于```写入```诸如图像数据之类的原始```字节流```
-	文件是否可用或能否可以被创建取决于基础平台。特别是某些平台一次只允许一个 FileOutputStream（或其他文件写入对象）打开文件进行写入

构造方法：

-	```public FileOutputStream(File file) throws FileNotFoundException``` ：创建一个向指定 File 对象表示的文件中写入数据的文件输出流， 清空文件再写入
-	```public FileOutputStream(File file, boolean append) throws FileNotFoundException``` ：创建一个向指定 File 对象表示的文件中写入数据的文件输出流， append 为 true 时，追加写入文件
-	```public FileOutputStream(FileDescriptor fdObj)``` ：创建一个向指定文件描述符处写入数据的输出文件流，该文件描述符表示一个到文件系统中的某个实际文件的现有连接
-	```public FileOutputStream(String name) throws FileNotFoundException``` ： 创建一个向具有指定名称的文件中写入数据的输出文件流
-	```public FileOutputStream(String name, boolean append) throws FileNotFoundException``` ： 创建一个向具有指定名称的文件中写入数据的输出文件流


常用方法：

-	```public void write(byte[] b) throws IOException``` ：将 b.length 个字节从指定 byte 数组写入此文件输出流中
-	```public void write(byte[] b, int off, int len) throws IOException``` ：将指定 byte 数组中从偏移量 off 开始的 len 个字节写入此文件输出流
-	```public void write(int b) throws IOException``` ：将指定字节写入此文件输出流
-	```public void close() throws IOException``` ：关闭此文件输出流并释放与此流有关的所有系统资源。此文件输出流不能再用于写入字节


```java
package org.lovian.io.stream;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileOutputStreamDemo {
	public static void main(String[] args) throws IOException {
		// 创建字节输出流对象
		File file = new File("file.txt");
		FileOutputStream fos = new FileOutputStream(file);

		// 创建字节输出流对象
		FileOutputStream fos2 = new FileOutputStream("fos.txt");
		/*
		 * 创建字节输出流对象包含了以下步骤： A: 调用系统功能去创建文件或读取文件 B: 创建 fos2 对象 C: 把 fos2
		 * 对象指向这个文件
		 */

		// 写入文件
		String text = "hello,io, this is a test stream";
		// 写一个字节
		fos2.write(97); // 97 -- ASCII -- a
		// 换行
		// windows： \r\n
		// linux: \n
		// mac: \r
		fos2.write("\n".getBytes());

		// 写一个字节数组
		fos2.write(text.getBytes());
		fos2.write("\n".getBytes());

		// 写一个字节数组的一部分
		byte[] byteArr = { 97, 98, 99, 100, 101, 102 }; // abcdef
		fos2.write(byteArr, 2, 4); // cdef

		// 关闭字节输出流
		fos.close();
		fos2.close();
	}
}
```


注意：

-	为什么一定要关闭流：
	-	让流对象变成垃圾，这样就可以被GC
	-	通知系统去释放跟该文件相关的资源
-	字节流写入进行异常处理：可以抛出，但是最好用 try/catch 处理

```java
package org.lovian.io.stream;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileOutputStreamException {
	public static void main(String[] args) {

		// 一起进行 try/catch 处理
		FileOutputStream fos = null;
		try {
			fos = new FileOutputStream("fos.txt");
			fos.write("hello world".getBytes());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			// 如果 fos 不是 null， 则需要释放资源
			if(fos != null){
				// 为了确保能够释放资源
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
```

#### FileInputStream

java.io.FileInputStream:

-	从文件系统中的某个文件中获得输入字节
-	用于```读取```诸如图像数据之类的原始```字节流```

构造方法：

-	```public FileInputStream(File file) throws FileNotFoundException``` ：通过打开一个到实际文件的连接来创建一个 FileInputStream，该文件通过文件系统中的 File 对象 file 指定
-	```public FileInputStream(FileDescriptor fdObj)``` ：  通过使用文件描述符 fdObj 创建一个 FileInputStream，该文件描述符表示到文件系统中某个实际文件的现有连接
-	```public FileInputStream(String name) throws FileNotFoundException``` ：通过打开一个到实际文件的连接来创建一个 FileInputStream，该文件通过文件系统中的路径名 name 指定

常用方法：

-	```public int read() throws IOException``` ：从此输入流中读取一个数据字节，如果没有输入可用，则此方法将阻塞; 如果已到达文件末尾，则返回 -1
-	```public int read(byte[] b) throws IOException``` ：从此输入流中将最多 b.length 个字节的数据读入一个 byte 数组中，返回读入数组的字节总数，如果因为已经到达文件末尾而没有更多的数据，则返回 -1
-	```public int read(byte[] b, int off, int len) throws IOException``` ：从此输入流中将最多 len 个字节的数据读入一个byte 数组中
-	```public void close() throws IOException``` ：关闭此文件输入流并释放与此流有关的所有系统资源

```java
package org.lovian.io.stream;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

public class FileInputStreamDemo {
	public static void main(String[] args) {

		FileInputStream fis = null;
		FileInputStream fis2 = null;
		try {
			fis = new FileInputStream("fos.txt");
			fis2 = new FileInputStream("fos.txt");

			// read 1 byte from a input stream
			int by = 0;
			int count = 0;
			while((by = fis.read()) != -1){  // return -1 means EOF
				count++;
				System.out.println(count + " time read byte: " + by);
				System.out.println("char: " + (char)by);
			}

			System.out.println("========================");
			// read input stream into a byte array
			byte[] bys = new byte[20];
			fis2.read(bys);
			printArray(bys);


		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			if(fis != null){
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if(fis2 != null){
				try {
					fis2.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
	}

	private static void printArray(byte[] bytes){
		System.out.print("[");
		for(int i = 0; i < bytes.length; i++){
			if(i != bytes.length -1){
				System.out.print(bytes[i] + ", ");
			}else{
				System.out.println(bytes[i] + "]");
			}
		}
		System.out.print("[");
		for(int i = 0; i < bytes.length; i++){
			if(i != bytes.length -1){
				System.out.print((char)bytes[i] + ", ");
			}else{
				System.out.println((char)bytes[i] + "]");
			}
		}
	}
}
```

result：

```
1 time read byte: 104
char: h
2 time read byte: 101
char: e
3 time read byte: 108
char: l
4 time read byte: 108
char: l
5 time read byte: 111
char: o
6 time read byte: 32
char:
7 time read byte: 119
char: w
8 time read byte: 111
char: o
9 time read byte: 114
char: r
10 time read byte: 108
char: l
11 time read byte: 100
char: d
12 time read byte: 10
char:

========================
[104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 10, 0, 0, 0, 0, 0, 0, 0, 0]
[h, e, l, l, o,  , w, o, r, l, d,
,
```

注意：

-	计算机的中文存储：
	-	两个字节：第一个字节肯定是负数，第二个字节常见的是负数，也有可能是正数

```java
	public static void main(String[] args) {
		String s = "我爱你中国";
		byte[] bys = s.getBytes();
		System.out.println(Arrays.toString(bys));

		String e = "hello";
		byte[] bytes = e.getBytes();
		System.out.println(Arrays.toString(bytes));
	}
```

result：

```
[-26, -120, -111, -25, -120, -79, -28, -67, -96, -28, -72, -83, -27, -101, -67]
[104, 101, 108, 108, 111]
```

### 4. 字节缓冲流

-	字节流一次读写一个数组 （```fis.read(byte[] bytes) ```） 的速度，明显比读写一个字节 （```fis.read() ```）的速度快很多，这是加入了数组当作缓冲区的效果
-	java 考虑到这样的设计思想（装饰设计模式），所以提供了字节缓冲区流
-	字节缓冲输出流： ```BufferedOutputStream```
-	字节缓冲输入流： ```BufferedInputStream```
-	效率比字符流要高
-	构造方法： 可以指定缓冲区大小，但一般用默认的缓冲区大小，即默认构造即可(传入一个字符流对象)
-	使用方法： 与字符流大致相同，释放资源时只需要 close 字节缓冲流对象即可

### 5. 字符流的常用子类

字节流操作中文不是特别方便，如下代码所示

```java
	public static void main(String[] args) throws IOException {
		// file content: hello你好
		FileInputStream fis = new FileInputStream("file.txt");
		int bt = 0;
		while((bt = fis.read()) != -1){
			System.out.print((char) bt);
		}
		System.out.println();
		FileInputStream fis2 = new FileInputStream("file.txt");
		byte[] bytes = new byte[1024];
		int len = 0;
		while((len = fis2.read(bytes)) != -1){
			System.out.println(new String(bytes, 0, len));
		}

		fis.close();
		fis2.close();
	}
```

result：

```
helloä½ å¥½
hello你好
```

我们可以发现，这里出现了编码问题。所以 Java 为了方便就提供了转换流， 把字节转换成字符，所以 ```字符流 = 字节流 + 编码表```

java 使用 unicode 的编码，unicode 是国际标准码，所有文字多用两个字节来表示，但有时候还是不够，所以有了 UTF-8 来当作 unicode 的实现， 最多可以用三个字节表示一个字符。

编码解码：String 类的方法

-	编码： String --> byte[]
	-	```byte[] getBytes(String charsetName)```:  通过指定的字符集合把字符串编码为字符数组
-	解码： byte[] --> String
	-	```String(byte[] bytes, String charsetName)```: 通过指定的字符集解码字符数组

所以，编码不一样，比如 “GBK” 和 “UTF-8” ,那么解码的时候得到的结果就会出错，所以要保证编码解码的字符集相同

#### OutputStreamReader



#### OutputStreamWriter

java.io.OutputStreamWriter:

-	字符流转换成字节流：可使用指定的 charset 将要写入流中的字符编码成字节
-	字符流 = 字节流 + 编码表
-	它使用的字符集可以由名称指定或显式给定，否则将接受平台默认的字符集

常用构造方法：

-	```public OutputStreamWriter(OutputStream out)``` ：创建使用默认字符编码的 OutputStreamWriter
-	```public OutputStreamWriter(OutputStream out, String charsetName) throws UnsupportedEncodingException``` ：创建使用指定字符集的 OutputStreamWriter

常用方法：

-	```public void write(int c) throws IOException``` ：  写入单个字符
-	```public void write(char[] cbuf, int off, int len) throws IOException``` ：  写入字符数组的某一部分
-	```public void write(String str, int off, int len) throws IOException``` ： 写入字符串的某一部分
-	```public String getEncoding()``` ：  返回此流使用的字符编码的名称
-	```public void flush() throws IOException``` ：刷新该流的缓冲
-	```public void close() throws IOException```： 关闭此流，但要先刷新它。在关闭该流之后，再调用 write() 或 flush() 将导致抛出 IOException。关闭以前关闭的流无效

