---
layout: post
title:  "[JAVA] StringBuffer的使用"
date:   2016-07-16
desc: "how to use string buffer  in Java"
keywords: "java, string, string buffer"
categories: [java]
---

# Java 中 StringBuffer 的使用

## I. StringBuffer

StringBuffer 是线程安全的可变字符序列， 一个类似于 String 的字符串缓冲区，但不能修改。在任意时间点上它都包括某种特定的字符序列，但通过某些方法调用可以改变该序列的长度和内容。 所谓线程安全，意思是可以将 StringBuffer 安全的用于多个线程，可以在必要时对这些方法进行同步，从而任意特定实例上的所有操作就像是串行顺序发生的，该顺序和所涉及的每个线程进行的方法调用顺序一致。

## II. StringBuffer 和 String 的区别

-	由于 String 生成的字符串都是字面常量，这些字符串都被保存在方法区内存中的字符串池（string pool）中，它们是不可改变的。而 StringBuffer 的长度和内容是可以通过方法的调用来改变。
-	在字符串拼接时，String 是先在字符串池中找字符串是否已经存在，不存在就在字符串池创造一个新的字符串，存在则直接返回。这样带来的问题是字符串池中可能会有很多不再使用的字符串常量，造成空间的浪费。StringBuffer 进行字符串拼接时，则不会造成太多的空间浪费


## III. StringBuffer 的构造方法

-	```public StringBuffer()``` : 无参构造
-	```public StringBuffer(int capacity)``` : 指定容量的字符串缓冲区对象
-	```public StringBuffer(String str)``` : 指定字符串内容的字符串缓冲区对象

## IV. StringBuffer 的方法

-	```public int capacity()``` : 返回当前容量， 理论长度， 默认16个字符，动态分配
-	```public int length()``` : 返回长度（字符数）， 实际长度

```java
public class StringBufferDemo {
	public static void main(String[] args) {
		StringBuffer sb = new StringBuffer();
		System.out.println(sb);
		System.out.println(sb.capacity());
		System.out.println(sb.length());
		System.out.println("==================");

		StringBuffer sb2 = new StringBuffer(50);
		System.out.println(sb2);
		System.out.println(sb2.capacity());
		System.out.println(sb2.length());
		System.out.println("==================");

		StringBuffer sb3 = new StringBuffer("helloworld");
		System.out.println(sb3);
		System.out.println(sb3.capacity());
		System.out.println(sb3.length());
		System.out.println("==================");
	}
}
```

```
//result

16
0
==================

50
0
==================
helloworld
26
10
==================
```

-	```public StringBuffer append()``` : 把任意类型添加到字符串缓冲区里，并返回字符串缓冲区本身
-	```public StringBuffer insert(int offset, String str)``` : 在指定位置把任意类型的数据插入到字符串缓冲区里面，并返回字符串缓冲区本身， 注意字符串 index 从 0 开始
-	```public StringBuffer deleteCharAt(int index)``` : 删除指定位置的字符，并返回本身
-	```public StringBuffer delete(int start, int end)``` : 删除从之指定位置开始，指定位置结束的内容（左闭右开），并返回本身
-	```public StringBuffer replace(int start, int end, String str)``` : 替换从start开始到end （左闭右开），用str替换
-	```public StringBuffer reverse()``` : 反转字符串本身，并返回自身
-	```public String subString(int start)``` : 截取 StringBuffer 字符串， 从 start 位置到结束，返回一个新String
-	```public String subStirng(int start, int end)``` : 截取从start到end的字符串 （左闭右开）， 返回一个新String

## V. String 和 StringBuffer 的互换

有时候，我们需要用 StringBuffer 的功能， 就要把 String 对象转换成一个 StringBuffer对象，但最后我们可能需要的结果是一个 String 类型，所以还要转换回来

### String 转换成 StringBuffer

不能直接把一个 String 赋值给一个 StringBuffer， 但有两种方式可以将一个 String 对象转换成一个 StringBuffer 对象：

-	通过构造方法

```java
public StringBuffer string2StringBuffer(String string){
		return new StringBuffer(string);
}
```

-	通过 append 方法

```java
public StringBuffer string2StringBuffer(String string){
	StringBuffer sb = new StringBuffer();
	sb.append(string);
	return sb;
}
```

### StringBuffer 转换成 String

同样也不能直接把一个 StringBuffer 直接转换成 String

-	通过 String 的构造方法

```java
public stringBuffer2String(StringBuffer sb){
	return new String(sb)
}
```

-	通过 toString 方法

```java
public stringBuffer2String(StringBuffer sb){
	return sb.toString();
}
```

## VI. Array to String

将数组拼接成一个字符串 给出一个数组 ```{ 5, 4, 5, 2, 6}```， 将它转换成 ```[5, 4, 5, 2, 4]```


-	字符串拼接： 浪费内存资源，会在字符串池中生成很多无关的字符串

```java
package org.lovian.stringbuffer;

/**
 * ArrayToString
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class ArrayToString {
	public static void main(String[] args) {
		int[] array = { 5, 4, 5, 2, 6};
		System.out.println(arrayToString(array));
	}

	public static String arrayToString(int[] array){
		String s = "";

		s += "[";
		for(int i = 0; i < array.length; i++){
			if(i == array.length - 1){
				s += i;
			}else{
				s += array[i];
				s += ", ";
			}
		}

		s += "]";
		return s;
	}

}
```

-	用 StringBuffer 做拼接， 不会生成多个字符串常量，所以效率更好

```java
package org.lovian.stringbuffer;

/**
 * ArrayToString
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class ArrayToString2 {
	public static void main(String[] args) {
		int[] array = { 5, 4, 5, 2, 6};
		System.out.println(arrayToString(array));
	}

	public static String arrayToString(int[] array){
		StringBuffer sb = new StringBuffer();
		sb.append("[");

		for(int i = 0; i < array.length; i++){
			if(i == array.length -1){
				sb.append(array[i]);
			}else{
				sb.append(array[i] + ",");
			}
		}

		sb.append("]");

		return sb.toString();
	}

}

```

## VII. StringBuilder

StringBuilder 是一个可变的字符序列，它提供了一个和 StringBuffer 兼容的 API，但不能保证同步。StringBuilder 被设计用作 StringBuffer 的一个替换类，用在 StringBuffer 被某个单线程适用的时候，建议在不考虑线程安全的情况下，优先使用 StringBuilder， 使用API 和 StringBuffer 相同。因为大多数情况下， StringBuilder 比 StringBuffer 要快
