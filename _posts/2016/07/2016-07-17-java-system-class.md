---
layout: post
title:  "[JAVA] Java System 类的使用"
date:   2016-07-17
desc: "how to use system class  in Java"
keywords: "java, system"
categories: [java]
---

# Java 中 System 类的使用

## I. System 类

```java.lang.System``` ：System 类包含一些有用的类字段和方法。它不能被实例化。 在 System 类提供的设施中，有标准输入、标准输出和错误输出流；对外部定义的属性和环境变量的访问；加载文件和库的方法；还有快速复制数组的一部分的实用方法。

## II. System 类常见方法

-	```public static void gc()``` :
	-	垃圾回收，释放资源。
	-	默认情况下， JVM 通过调用 Object 类的 ```finalize()``` 方法来进行对象的垃圾回收。```finalize()``` 方法的作用是用来释放一个对象占用的内存空间，被释放的对象是在堆内存中没有被引用变量所引用的对象
	-	而 Object 类的子类重写该方法，就可以清理该类对象所占用的资源。所以，当 ```System.gc``` 被调用的时候，系统会自动调用 Object 子类重写的 ```finalize()``` 方法来释放资源
	-	通过 ```super.finalize()``` 方式可以实现从下到上的 ```finalize()``` 方法调用。即先释放自己的资源，再释放父类的资源
	-	但是不要在程序中频繁调用垃圾回收，因为每一次执行垃圾回收，JVM 就会强制启动垃圾回收器运行，这会耗费更多的系统资源，会与正常的 Java 程序运行争抢资源，只有在执行大量的对象释放时，才适合调用垃圾回收
-	```public static void exit(int status)``` :
	-	终止当前正在运行的 Java 虚拟机，参数用作状态码，一般非 0 的状态码表示异常终止
	-	实际上该方法调用了 ```Runtime``` 类的 exit 方法，等同于 ```Runtime.getRuntime().exit(n)```
	-	该方法永远不会正常返回
	-	调用该方法时，该方法直接退出，可以 if 语句控制
-	```public static long currentTimeMills()```:
	-	以毫秒为单位的当前时间
	-	返回的不是精细时间，而是时间与世界协调时 ```1970-01-01 00：00``` （Unix时间纪元，32位int表示时间的限制）之间的时间差
	-	值的粒度取决于底层操作系统，粒度可能比较大，比如有的操作系统以几十毫秒为单位测量时间
	-	一般来说，调用两次这个方法得到的时间差，额可以用这个时间差值来统计程序的运行时间
-	```public static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length)```：
	-	从指定源数组中复制一个数组，复制从指定的位置开始，到目标数组的指定位置结束
	-	从 src 引用的源数组到 dest 引用的目标数组，数组组件的一个子序列被复制下来。被复制的组件的编号等于 length 参数
	-	源数组中位置在 srcPos 到 srcPos+length-1 之间的组件被分别复制到目标数组中的 destPos 到 destPos+length-1 位置
	-	浅层复制：无论是```System.arraycopy()``` 还是 ```Arrays.copyOf()``` 在复制的过程中，只复制每个元素的引用，而不复制这个引用所引用的对象，堆内存中，对象的总数并没有增加
	-	如果要深度复制一个数组，需要手动挨个复制每个对象
