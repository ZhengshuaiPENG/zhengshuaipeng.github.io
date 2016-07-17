---
layout: post
title:  "[JAVA] Java Math 类的使用"
date:   2016-07-17
desc: "how to use math class  in Java"
keywords: "java, string, Math, random"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java Math 类的使用

## I. Java Math 类

```java.lang.Math```： Math 类包含用于执行基本数学运算的方法，如初等指数、对数、平方根和三角函数。是Java提供的一个封装好各种函数的一个类

## II. Math 类常用方法

```java
package org.lovian.math;

/**
 * Java Math class demo
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class MathDemo {
	public static void main(String[] args) {
		//public static final double PI
		System.out.println("PI: " + Math.PI);
		System.out.println("-------------------");
		//public static final double E
		System.out.println("E: " + Math.E);
		System.out.println("-------------------");

		//public static int abs(int a): 绝对值
		System.out.println("10 abs: " + Math.abs(10));
		System.out.println("-10.3 abs: " + Math.abs(-10.3));
		System.out.println("-------------------");

		//public static double ceil(double a): 向上取整
		System.out.println("12.34 ceil: " + Math.ceil(12.34));
		System.out.println("18.0 ceil: " + Math.ceil(18.0));
		System.out.println("-------------------");

		//public static double floor (double a): 向下取整
		System.out.println("12.34 floor: " + Math.floor(12.34));
		System.out.println("18.0 floor: " + Math.floor(18.0));
		System.out.println("-------------------");

		//public static int max(int a, int b): 最大值
		System.out.println("12, 23 max: " + Math.max(12, 23));
		System.out.println("12, 23, 18 max: " + Math.max(Math.max(12, 23), 18));
		System.out.println("-------------------");

		//public static double pow(double a, double b): a 的 b 次幂
		System.out.println("2 pow 3: " + Math.pow(2, 3));
		System.out.println("-------------------");

		//public static double random() : 随机数 [0.0, 1.0)
		System.out.println("random: " + Math.random());
		// get a random value from 1 - 100
		System.out.println("1-100 random: " + ((int) (Math.random() * 100) + 1));

		//public static int round(double a): 四舍五入
		System.out.println("13.24f round: "  + Math.round(13.24f));
		System.out.println("14.78 round: "  + Math.round(14.78));

		//public static double sqrt(double a): 正平方根
		System.out.println("16 sqrt: " + Math.sqrt(16));
		System.out.println("20.34 sqrt: " + Math.sqrt(20.34));
	}
}

```

result

```
PI: 3.141592653589793
-------------------
E: 2.718281828459045
-------------------
10 abs: 10
-10.3 abs: 10.3
-------------------
12.34 ceil: 13.0
18.0 ceil: 18.0
-------------------
12.34 floor: 12.0
18.0 floor: 18.0
-------------------
12, 23 max: 23
12, 23, 18 max: 23
-------------------
2 pow 3: 8.0
-------------------
random: 0.7129835382519233
1-100 random: 28
13.24f round: 13
14.78 round: 15
16 sqrt: 4.0
20.34 sqrt: 4.509988913511872
```

## III. 获取任意范围内的随机数

给出一个范围，返回这个范围内的任意随机整数

```java
package org.lovian.math;

import java.util.Scanner;

/**
 * Get random from [begin, end]
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class Random {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		System.out.println("Input begin: ");
		int begin = sc.nextInt();
		System.out.println("Input end: ");
		int end = sc.nextInt();

		for (int i = 0; i < 5; i++) {

			System.out.println("random: " + getRandom(begin, end));
		}

		sc.close();
	}

	public static int getRandom(int begin, int end){
		int number = (int) (Math.random() * (end - begin + 1)) + begin;
		return number;
	}
}
```

result：

```
Input begin:
34
Input end:
109
random: 53
random: 56
random: 109
random: 100
random: 54

```

## IV. Randon 类的使用

java 封装好了一个专门生成随机数的类，用于生成随机数(伪随机数)，有些时候，不如Math.random() 有效率

-	构造方法
	-	```public Random()``` : 不用给种子， 使用默认的种子，是当前时间的纳秒值（nanotime）
	-	```public Random(long seed)``` ： 给出指定种子进行随机数生成，每次生成的随机数是相同的

-	成员方法
	-	```public int nextInt()``` : 返回的是 int 范围的随机数
	-	```public int nextInt(int n)``` : 返回的是 [0, n) 范围的随机数

```java
package org.lovian.math;

import java.util.Random;

/**
 * Random Class demo
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class RandomClassDemo {
	public static void main(String[] args) {
		defaultSeedRandom();
		randomWithSeed();
	}

	public static void defaultSeedRandom(){
		// 默认种子：nanotime
		Random r = new Random();

		for (int i = 0; i < 5; i++) {
			// int 范围的随机数
			System.out.println(r.nextInt());
		}

		for (int i = 0; i < 5; i++) {
			// 0-100（不包括100）之间的随机数
			System.out.println(r.nextInt(100));
		}
	}

	public static void randomWithSeed(){
		// 给定种子
		Random r = new Random(1000);

		for (int i = 0; i < 5; i++) {
			// int 范围的随机数
			System.out.println(r.nextInt());
		}

		for (int i = 0; i < 5; i++) {
			// 0-100（不包括100）之间的随机数
			System.out.println(r.nextInt(100));
		}
	}
}
```
