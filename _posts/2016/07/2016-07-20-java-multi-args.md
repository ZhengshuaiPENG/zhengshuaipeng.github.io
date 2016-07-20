---
layout: post
title:  "[JAVA] Java 中的可变参数的应用"
date:   2016-07-20
desc: "how to use changeable args in Java"
keywords: "java, args"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# 可变参数

有时候我们写一个方法的时候，参数的数目可能是不确定的，比如 sum 函数， 可能我们需要计算两个数之和，也有可能要计算三个数之和，也有可能是好多个。如果我们重写 sum 方法去匹配多种参数的个数的化，这样是很麻烦的。于是 Java 提供了一个特性，可变参数。

我们直接来看代码：

```java
package org.lovian.multiargs;

/*
 * 可变参数：定义方法的时候，不知道定义多少个参数
 * 格式：
 * 		修饰符 返回值类型 方法名 (数据类型... 变量名){
 * 			doSomething();
 * 		}
 * 	可变参数实际上是个数组
 */
public class SumDemo {
	public static void main(String[] args) {
		System.out.println("1+2+3 = " + sum(1, 2, 3));
		System.out.println("1+2+3+4+5 = " + sum(1, 2, 3, 4, 5));
	}

	private static int sum(int... args) {
		// args is an array!
		int s = 0;

		for (int x : args) {
			s += x;
		}
		return s;
	}
}
```
