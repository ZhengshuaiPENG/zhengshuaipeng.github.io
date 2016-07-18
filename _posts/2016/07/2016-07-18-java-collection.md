---
layout: post
title:  "[JAVA] Java 中的集合 Collection"
date:   2016-07-18
desc: "how to use collection in Java"
keywords: "java, collection"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的集合 Collection

## I. Collection 引用

由于对象数组 （比如 ```Student[] students = new Student[5]```) 在使用的时候，长度是固定不可变的，当我们需要动态的添加更多的对象时，数组是十分不方便的,  所以为了方便多个对象的操作， Java 提供了另一种容器来存储一系列相同的对象，叫做集合， Collection

## II. Java 中的集合类

### 1.集合类的关系图

首先先看在 java 中，集合类的关系图(此图来源于网络）：

！[collection](https://zhengshuaipeng.github.io/static/img/blog/2016/07/collection.png)


### 2. 集合类和数组的区别

-	数组：
	-	长度固定
	-	可以存储对象，也可以存储基本类型
	-	存储的是同一种类型的元素
-	集合
	-	长度可变
	-	只能存储对象
	-	可以存储不同类型元素

### 3. Java集合类

为了满足不同的存储需求，Java 提供了不同的集合类，这多个集合类的数据结构（数据的存储方式）不同。不管是什么数据结构，所有的集合类都应该提供一些共同的功能比如判断，获取等，把这些共性的地方提取出来，就构成了Java中集合类的继承体系。

简化上面的集合类关系图(此图来源于网络）：常用集合类

！[collection_img](https://zhengshuaipeng.github.io/static/img/blog/2016/07/collection_img.png)

我们可以发现，这是一个继承体系，所以我们从最高级的父类 Collection 来学习 Java 集合类

### 4. Collection 接口

java.util.Collection<E>:

-	继承超级接口 ```Iterable<E>``` , Collection 是集合层次结构中的根接口
-	Collection 表示一组对象，这些对象就是 Collection 的元素
-	某些集合允许有重复元素（list)，某些不允许(set)
-	某些集合有序，某些无序
-	JDK 不提供此接口的直接实现，它提供更具体的子接口的实现（如set和list）
-	实例化的时候必须用 Collection 的实现类

### 5. Collection 功能概述

-	添加功能
	-	```boolean add(E e)``` : 添加一个元素
	-	```boolean addAll(Collection<? extends E> c)``` : 添加一个集合的所有元素
-	删除功能
	-	```void clear()``` : 移除本集合内的所有元素
	-	```boolean remove(Object obj)``` : 移除一个指定的元素
	-	```boolean removeAll(Collection<?> c)``` : 移除在本集合中包含的指定集合中所有元素，只要有一个被移除，就返回 true
-	判断功能
	-	```boolean contains(Object obj)``` : 判断集合中是否包含指定的元素
	-	```boolean containsAll(Collection<?> c)``` : 判断集合中是否包含指定的集合元素，要全部包含才会返回 true， 部分包含或者不包含则是 false
	-	```boolean isEmpty()``` : 判断集合是否为空
-	获取功能
	-	```Iterator<E> iterator()``` ： 返回在此 collection 的元素上进行迭代的迭代器，用于集合的遍历
-	长度功能
	-	```int size()```: 返回元素的个数， （数组和字符串是 ```length```）
-	交集功能
	-	```boolean retainAll(Collection<?> c)``` ： 保留两个集合都有的元素
-	集合到数组的转换
	-	```Object[] toArray()``` ： 返回包含集合中所有的元素数组，通过数组进行集合的遍历


### 6. Iterator 的使用

```java
package org.lovian.collection;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/**
 * Iterator Demo
 *
 * Iterator iterator(): 迭代器，集合专用遍历方式 (实际是 pointer)
 * Object next() : 获取元素， 会返回 NoSuchElementException
 * boolean hasNext(): 判断是否有下个元素
 *
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class IteratorDemo {
	public static void main(String[] args) {
		Collection<String> c = new ArrayList<String>();

		c.add("hello");
		c.add("world");

		// while loop
		Iterator<String> it = c.iterator(); // 这里返回的子类对象，实际上是多态
		while(it.hasNext()){
			System.out.println("str: " + it.next());
		}

		System.out.println("==========");
		// for loop
		for(Iterator<String> it = c.iterator(); it.hasNext();){
			String s = it.next();
			System.out.println("str: " + s);
		}
	}
}
```

result:

```
str: hello
str: world
==========
str: hello
str: world
```
