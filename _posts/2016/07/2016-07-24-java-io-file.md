---
layout: post
title:  "[JAVA] Java 中的 IO 之 File"
date:   2016-07-24
desc: "how to use io-file in Java"
keywords: "java, io, File"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# IO in Java

## I. File

### 1. File类

java.io.File： 文件和目录（文件夹）路径名的抽象形式表示方式

如果我们想实现 IO 的操作，就必须知道硬盘上文件的表示形式，所以 Java 就提供了一个类 File 供我们使用

### 2. File类的构造方法

-	```public File(String pathname)``` : 通过文件（夹）的路径来创建 File 对象
-	```public File(String parent, String child)``` : 根据一个目录，和此目录下的子文件（夹）得到 File 对象
-	```public File(File parent, String child)``` : 根据一个父 File 对象， 和此File对象下的子文件（夹）来得到 File 对象

```java
package org.lovian.io.file;

import java.io.File;

// 构造方法示例
public class FileDemo {
	public static void main(String[] args) {
		String filePath = "/home/zhengshuai/test.txt";
		File file = new File(filePath);

		String parent = "/home/zhengshuai";
		String child = "test.txt";
		File file2 = new File(parent, child);

		File file3 = new File(parent);
		File file4 = new File(file3, child);
	}
}
```

### 3. 创建文件

-	```public boolean createNewFile() throws IOException``` : 当且仅当不存在具有此抽象路径指定名称的文件时，不可分的创建一个新的空文件
-	```public boolean mkdir()``` : 创建此抽象路径名指定的目录
-	```public boolean mkdirs()``` : 创建此抽象路径名指定的目录，包括所有必须但不存在的父目录

上述方法创建成功返回 true， 如果文件或目录已经存在的话，则不创建且返回 false

```java
package org.lovian.io.file;

import java.io.File;
import java.io.IOException;

public class FileDemo {
	public static void main(String[] args) {
		// create a directory "demo" in home directory
		String dirPath = "/home/zhengshuai/demo";
		File demoDir = new File(dirPath);
		System.out.println("mkdir /home/zhengshuai/demo : " + demoDir.mkdir());

		// create a file "a.txt" in directory "demo";
		File aTxt = new File(demoDir, "a.txt");
		try {
			System.out.println("create file /home/zhengshuai/demo/a.txt: " + aTxt.createNewFile());
		} catch (IOException e) {
			e.printStackTrace();
		}

		// create a file "b.txt" under directory "~/io"
		// but this directory doesn't exist
		// this will cause the exception
		File bTxt = new File("/home/zhengshuai/io/b.txt");
		try {
			System.out.println("create file /home/zhengshuai/io/b.txt: " + bTxt.createNewFile());
		} catch (IOException e) {
			System.out.println("error with file path");
			e.printStackTrace();
		}

		// create dir "test" in dir "io", "io" doesn't exist
		File testDir = new File("/home/zhengshuai/io/test");
		System.out.println("mkdir /home/zhengshuai/io/test: " + testDir.mkdir()); // false
		System.out.println("mkdirs /home/zhengshuai/io/test: " + testDir.mkdirs()); // true
	}
}
```

result：

```
mkdir /home/zhengshuai/demo : true
create file /home/zhengshuai/demo/a.txt: true
error with file path
java.io.IOException: No such file or directory
mkdir /home/zhengshuai/io/test: false
	at java.io.UnixFileSystem.createFileExclusively(Native Method)
	at java.io.File.createNewFile(File.java:1012)
	at org.lovian.io.file.FileDemo.main(FileDemo.java:26)
mkdirs /home/zhengshuai/io/test: true
```

注意：

-	在一个目录 A 下创建文件或子目录，必须要确保 A 目录存在
-	要明确是创建目录还是文件，不要调错方法
-	如果创建文件时，```File file = new File("a.txt");```,忘记写盘符或者是目录路径， 当使用 createNewFile 方法时，那么Java会在当前项目目录下创建 ```a.txt``` 文件


### 4. 删除文件和目录

-	```public boolean delete()``` : 删除此抽象路径名表示的文件或目录。如果此路径名表示一个目录，则该目录必须为空才能删除
-	```public void deleteOnExit()``` ：在虚拟机终止时，请求删除此抽象路径名表示的文件或目录。 文件（或目录）将以与注册相反的顺序删除。调用此方法删除已注册为删除的文件或目录无效。根据 Java 语言规范中的定义，只有在虚拟机正常终止时，才会尝试执行删除操作。 一旦请求了删除操作，就无法取消该请求。所以应小心使用此方法

代码接上例
```java
		//delete
		System.out.println("delete demo " +demoDir.delete());
		System.out.println("delete a.txt " + aTxt.delete());
		System.out.println("delete demo " + demoDir.delete());
		System.out.println("delete b.txt " + bTxt.delete());
		System.out.println("delete test " + testDir.delete());
```

result：

```
delete demo false
delete a.txt true
delete demo true
delete b.txt true
delete test true
```

注意：

-	delete 方法删除的文件或目录是永久删除，不进回收站
-	删除目录时，必须要先删除目录下所有的文件和子目录


### 5.重命名功能

-	```public boolean renameTo(File dest)``` : 重新命名此抽象路径名表示的文件

```java
		// rename "b.txt" to "c.txt"
		File dest = new File("/home/zhengshuai/io/c.txt");
		System.out.println("rename b.txt to c.txt: " + bTxt.renameTo(dest));

		System.out.println("delete b.txt " + bTxt.delete());
		System.out.println("delete c.txt " + dest.delete());
```

result：

```
rename b.txt to c.txt: true
delete b.txt false
delete c.txt true
```

注意：

-	重命名相当于复制了一个新文件，删除了原先的旧文件

### 6. 判断功能

-	```public boolean isDirectory()``` : 判断是否为目录
-	```public boolean isFile()``` : 判断是否是文件
-	```public boolean exists()``` : 判断是否存在
-	```public boolean canRead()``` : 判断是否可读
-	```public boolean canWrite()``` : 判断是否可写
-	```public boolean isHidden()``` : 判断是否隐藏

```java
package org.lovian.io.file;

import java.io.File;
import java.io.IOException;

public class FileDemo2 {
	public static void main(String[] args) {
		File aTxt = new File("a.txt");
		try {
			System.out.println(aTxt.createNewFile());
		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println("isDirectory: " + aTxt.isDirectory());
		System.out.println("isFile: " + aTxt.isFile());
		System.out.println("exists: " + aTxt.exists());
		System.out.println("canRead: " + aTxt.canRead());
		System.out.println("canWrite: " + aTxt.canWrite());
		System.out.println("isHidden: " + aTxt.isHidden());

		System.out.println("==========================");

		System.out.println("deleta a.txt: " + aTxt.delete());
		System.out.println("isDirectory: " + aTxt.isDirectory());
		System.out.println("isFile: " + aTxt.isFile());
		System.out.println("exists: " + aTxt.exists());
		System.out.println("canRead: " + aTxt.canRead());
		System.out.println("canWrite: " + aTxt.canWrite());
		System.out.println("isHidden: " + aTxt.isHidden());
	}
}
```

result：

```
true
isDirectory: false
isFile: true
exists: true
canRead: true
canWrite: true
isHidden: false
==========================
deleta a.txt: true
isDirectory: false
isFile: false
exists: false
canRead: false
canWrite: false
isHidden: false
```

### 7. 获取功能

-	```public String getAbsolutePath()``` : 返回绝对路径
-	```public String getPath()``` : 返回相对路径
-	```public String getName()``` : 返回文件名
-	```public long length()``` : 返回长度，就是文件大小，以字节 （byte）为单位
-	```public long lastModified()``` : 返回最后一次的修改时间，返回时间的毫秒值
-	```public String[] list()``` : 获取指定目录下的所有文件或者文件夹的名称数组
-	```public File[] listFiles()``` : 获取指定目录下的所有文件或者文件夹的File数组

```java
package org.lovian.io.file;

import java.io.File;
import java.io.IOException;

public class FileDemo3 {
	public static void main(String[] args) {
		File dir = new File("demo");
		System.out.println("mkdir: " + dir.mkdir());
		File file1 = new File(dir, "test.txt");
		File file2 = new File(dir, "a.txt");
		File file3 = new File(dir, "b.txt");
		File subDir = new File(dir, "test");
		try {
			System.out.println("create file: " + file1.createNewFile());
			System.out.println("create file: " + file2.createNewFile());
			System.out.println("create file: " + file3.createNewFile());
			System.out.println("mkdir: " + subDir.mkdir());

		} catch (IOException e) {
			e.printStackTrace();
		}

		System.out.println("=================================");

		System.out.println("getAbsolutePath: " + file1.getAbsolutePath());
		System.out.println("getPath: " + file1.getPath());
		System.out.println("getName: " + file1.getName());
		System.out.println("length: " + file1.length());
		System.out.println("lastModified: " + file1.lastModified());

		System.out.println("=================================");
		String[] fileNameArray = dir.list();
		for (int i = 0; i < fileNameArray.length; i++) {
			System.out.println("name: " + fileNameArray[i]);
		}

		System.out.println("=================================");
		File[] fileArray = dir.listFiles();
		for (File file : fileArray) {
			System.out.println("file: " + file);
		}

		System.out.println("=================================");

		System.out.println("delete file: " + file1.delete());
		System.out.println("delete file: " + file2.delete());
		System.out.println("delete file: " + file3.delete());
		System.out.println("delete dir: " + subDir.delete());
		System.out.println("delete dir: " + dir.delete());
	}
}

```

result：

```java
mkdir: true
create file: true
create file: true
create file: true
mkdir: true
=================================
getAbsolutePath: /home/zhengshuai/Workspace/java/demo_workspace/org.lovian.io/demo/test.txt
getPath: demo/test.txt
getName: test.txt
length: 0
lastModified: 1469566599000
=================================
name: test
name: a.txt
name: b.txt
name: test.txt
=================================
file: demo/test
file: demo/a.txt
file: demo/b.txt
file: demo/test.txt
=================================
delete file: true
delete file: true
delete file: true
delete dir: true
delete dir: true
```

注意： 绝对路径和相对路径，比较下列代码

```java
File file = new File("/home/zhengshuai/test.txt");
System.out.println("getAbsolutePath: " + file.getAbsolutePath());
System.out.println("getPath: " + file.getPath());
```

result：

```
create file: true
getAbsolutePath: /home/zhengshuai/test.txt
getPath: /home/zhengshuai/test.txt
```

#### 小问题

Q: 判断 E 盘目录下是否有后缀名为 .jpg 的文件，如果有，就输出此文件名称

思路：

-	封装 e 盘下的判断目录
-	获取该目录下的所有文件和文件夹的 File 数组
-	遍历该 File 数组，得到每一个 File 对象
-	判断是否为文件
	-	否： 跳过
	-	是： 判断文件名称是否以 .jpg 结尾
		-	是， 输出名称
		-	否， 跳过

注意：

-	这个需求的思路很简单，要注意区分每一个 File 对象是文件还是数组
-	在 windows 系统下，文件名不区分大小写： ```a.txt``` 和 ```A.txt``` 是一个文件
-	在 linux 系统下， 文件名区分大小写： ```a.txt``` 和 ```A.txt``` 是两个文件


### 8. 过滤功能

java.io.FilenameFilter: FilenameFilter 接口

-	实现此类接口实例可以用于过滤文件名
-	接口定义的方法：
	-	```boolean accept(File dir, String name)``` : 测试指定文件是否应该包含在某一个文件列表中，文件名满足规则返回true，否则返回false
-	一般使用匿名内部类作为对象传给相应的方法，方法如下：
	-	```public String[] list(FilenameFilter filter)``` : filter 返回 true， 对象文件加入数组，否则略过
	-	```public File[] listFiles(FilenameFilter filter)``` ：filter 返回 true， 对象文件加入数组，否则略过


以上个题目为例，输出目录下结尾为 jpg 的文件的文件名（这里忽略大小写，是为了代码在 windows 下也能工作）

```java
package org.lovian.io.file;

import java.io.File;
import java.io.FilenameFilter;

public class FileDemo4 {
	public static void main(String[] args) {
		File dir = new File("/home/zhengshuai");

		// filter file in dir and return file array
		File[] fileArray = dir.listFiles(new FilenameFilter() {

			@Override
			public boolean accept(File dir, String name) {

				// get file object
				File file = new File(dir, name);
				boolean flag = false;

				if(file.isFile()){
					String fileName = file.getName();
					String[] group = fileName.split("\\.");
					String fileNameEnd = group[group.length-1];
					if(fileNameEnd.equalsIgnoreCase("jpg"))
						flag = true;
				}

				return flag;
			}
		});

		// traverse file array
		for (File file : fileArray) {
			System.out.println(file);
		}
	}
}
```

result：

```
/home/zhengshuai/io.jpg
/home/zhengshuai/io.Jpg
/home/zhengshuai/io.JPG
```
