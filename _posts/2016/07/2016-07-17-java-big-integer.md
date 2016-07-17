---
layout: post
title:  "[JAVA] Java 里的 BigInteger & BigDecimal"
date:   2016-07-17
desc: "how to use big integer in Java"
keywords: "java, BigInteger， BigDecimal"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的 BigInteger & BigDecimal

## I. BigInteger

### 1.Integer & int

我们直到，在 java 中， ```Integer``` 是 ```int``` 基本类型的包装类。但是，由于 ```int``` 类型在 java 中是32位的，只占 4 个字节，所以它能表示的长度是有限的，是 ```2147483647```。

```java
public void testIntger(){
	System.out.println(Integer.MAX_VALUE);
}
```
result

```
2147483647
```

所以在表示更大的数字时，无论是 ```Integer``` 还是 ```int```， 都是无能为力的，所以为了表示更大的数字，我们使用另外一个类: ```BigInteger```

### 2.BigInteger

```java.math.BigInteger```:

-	是不可变的任意精度的整数
-	所有的操作都以二进制的补码进行
-	提供了math类的所有操作方法

### 3.BigInteger 的主要构造方法

```public BigInteger(String string)```: 以一个 String 类型表示的数字来构造 BingInteger 对象

```java
package org.lovian.math;

import java.math.BigInteger;

/**
 * BigInteger Demo
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class BigIntegerDemo {

	public static void main(String[] args) {
		// int 在java中表示的最大值
		Integer intMax = new Integer(Integer.MAX_VALUE);
		System.out.println("int max: " + intMax);

		// 用 string 来表示一个大整数
		String s = "28346748478237884";

		BigInteger bigInt = new BigInteger(s);
		System.out.println("big int: " + bigInt);
	}
}
```

result：

```
int max: 2147483647
big int: 28346748478237884
```

### 4.BigInteger 常用方法

-	```public BigInteger add(BigInteger val)``` : +
-	```public BigInteger substract(BigInteger val)``` : -
-	```public BigInteger multiply(BigInteger val)``` : *
-	```public BigInteger divide(BigInteger val)``` : /
-	```public BigInteger[] divideAndRemainder(BigInteger val)``` : / & %, 返回商和余数的数组


## II. BigDecimal

### 1.BigDecimal 的引入

首先，我们先来看关于 float 和 double 表示的小数运算：

```java
package org.lovian.math;

/**
 * BigDecimal Demo
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class BigDecimalDemo {
	public static void main(String[] args) {
		System.out.println(0.09 + 0.01);
		System.out.println(1.0 - 0.32);
		System.out.println(1.015 * 100);
		System.out.println(1.301 / 100);
	}
}
```

result:

```
0.09999999999999999
0.6799999999999999
101.49999999999999
0.013009999999999999
```

我们会发现，结果和我们想要的值并不一样，这是为什么呢？
原因是浮点数的小数部分在运算时换算成二进制，是用乘法来运算的， 每次都乘以2（可以看十进制到二进制转换的小数部分）。而这种乘法转换在有些情况总会无限的循环下去。比如 0.5, 实际上就是 1/2, 而 0.3 则是 1/3 - 1/30, 这样运算下来， 1 实际上就是 0.9999999.....， 这样就存在一个数据精度的问题，因此，才会有有效数字用来精确一个浮点数。

所以为了精确表示浮点数，和为了浮点数的的精确运算（尤其是金融项目）， java提供了 ```BigDecimal``` 类

### 2.BigDecimal 类

由于在运算时，```float``` 类型和 ```double``` 类型很容易丢失精度，为了能够精确的表示、计算浮点数，Java 提供了 ```BigDecimal```.

```java.math.BigDecimal```:

-	不可变的、任意精度的有符号十进制数
-	BigDecimal 由任意精度的整数非标度值 和 32 位的整数标度 (scale) 组成。
-	如果为零或正数，则标度是小数点后的位数。如果为负数，则将该数的非标度值乘以 10 的负 scale 次幂。因此，BigDecimal 表示的数值是 (unscaledValue × 10^(-scale))。

### 3.BigDecimal 类的主要构造方法

```public BigDecimal(String val)```， 这个是最精确的一个构造方法，因为即使用 double 作为参数传入构造方法，也会首先用 toString 方法，把 double 转换成 String 类型，并且，这种转换，有不可预知性，有可能会造成错误。所以推荐用 String 作为构造方法的参数

### 4.BigDecimal 的常用方法

-	```public BigDecimal add(BigDecimal augend)```: +
-	```public BigDecimal substract(BigDecimal subtrahend)```: -
-	```public BigDecimal multiply(BigDecimal multplicand)```: ×
-	```public BigDecimal divide(BigDecimal divisor)```: /
-	```public BigDecimal divide(BigDecimal divisor, int scale, int roundingMode)```: 带精度的除法， 几位小数，如何舍取

```java
package org.lovian.math;

import java.math.BigDecimal;

/**
 * BigDecimal Demo
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class BigDecimalDemo {
	public static void main(String[] args) {
		// double 运算
		System.out.println("0.09 + 0.01 = " + (0.09 + 0.01));
		System.out.println("1.0 - 0.32 =  " + (1.0 - 0.32));
		System.out.println("1.015 * 100 =  " + (1.015 * 100));
		System.out.println("1.301 / 100 = " + (1.301 / 100));

		System.out.println("====================");
		// BigDecimal 运算
		BigDecimal bd1 = new BigDecimal("0.09");
		BigDecimal bd2 = new BigDecimal("0.01");
		System.out.println("0.09 + 0.01 = " + bd1.add(bd2));

		bd1 = new BigDecimal("1.0");
		bd2 = new BigDecimal("0.32");
		System.out.println("1.0 - 0.32 =  " + bd1.subtract(bd2));

		bd1 = new BigDecimal("1.015");
		bd2 = new BigDecimal("100");
		System.out.println("1.015 * 100 =  " + bd1.multiply(bd2));

		bd1 = new BigDecimal("1.301");
		bd2 = new BigDecimal("100");
		System.out.println("1.301 / 100 = " + bd1.divide(bd2));

		// 商保留3位，并且四舍五入
		bd1 = new BigDecimal("1.371");
		bd2 = new BigDecimal("100");
		System.out.println("1.371 / 100 = " + bd1.divide(bd2, 3, BigDecimal.ROUND_HALF_UP));
	}
}
```

result:

```
0.09 + 0.01 = 0.09999999999999999
1.0 - 0.32 =  0.6799999999999999
1.015 * 100 =  101.49999999999999
1.301 / 100 = 0.013009999999999999
====================
0.09 + 0.01 = 0.10
1.0 - 0.32 =  0.68
1.015 * 100 =  101.500
1.301 / 100 = 0.01301
1.371 / 100 = 0.014
```
