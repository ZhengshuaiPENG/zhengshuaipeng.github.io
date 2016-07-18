---
layout: post
title:  "[JAVA] Java 中的日期与时间"
date:   2016-07-17
desc: "how to use date and time in Java"
keywords: "java, date， time"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的日期与时间

## I. Date 类 和 Calendar 类

### 1.Date类

#### Date 类

java.util.Date：

-	类 Date 表示特定的瞬间，精确到毫秒
-	由于 Date 类的格式化和解析字符串 API 不易于实现国际化，所以从 JDK 1.1 开始，应该使用 ```Calendar``` 类

#### Date 类的构造方法

-	```public Date()``` : 根据当前默认时间的毫秒值创建日期对象
-	```public Date(long date)``` : 根据给定的毫秒值创建日期对象

```java
package org.lovian.date;

import java.util.Date;

/**
 * java.util.Date Demo
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class DateDemo {
	public static void main(String[] args) {
		// 无参构造器，默认为当前时间
		Date date = new Date();
		System.out.println("date: " + date);

		// 带参构造器, 给定当前时间的毫秒值
		long time = System.currentTimeMillis();
		Date date2 = new Date(time);
		System.out.println("date2: " + date2);

		// 给定时间一小时，结果应该是 1970-01-01 01：00
		long time2 = 1000 * 60 * 60;
		Date date3 = new Date(time2);
		System.out.println("date3: " + date3);
	}
}
```

result：

```
date: Sun Jul 17 23:35:36 CEST 2016
date2: Sun Jul 17 23:35:36 CEST 2016
date3: Thu Jan 01 02:00:00 CET 1970
```

这里我们会发现， date 和 date 2 给出的系统当前时间， （GTM+1， Paris），但是，date3, 我们给出的是 1 个小时，输出结果应该是 ```1970-01-01 01：00``` 才对，为什么这里是 ```02:00:00```, 原因是本地时区（GTM+1）的问题，本地是```01：00：00```, CET时间就应该加上对应的时区。

#### Date 类的常用方法

Date类大部分方法现在已经废弃，但还有一些常用方法

-	```public long getTime():``` 获取时间，以毫秒为单位， date --> 毫秒值
-	```public void setTime（long time）：``` 设置时间， 毫秒值 --> date


### 2. DateFormat 类

有些时候，我们需要把 Stirng 表示的日期，转换成 Date 类型，反之亦然。尤其在网页应用中选择出生年月的时候比较常见。这时候，我们需要用 ```DateFormat``` 类来把我们的日期进行格式化

#### DateFormat类

java.text.DateFormat: 抽象类

-	DataFormat 是日期/时间格式化子类的抽象，以与语言无关的方式格式化并解析日期或时间
-	日期/时间格式化子类（如 SimpleDateFormat）允许进行格式化（日期 -> 文本）、解析（文本-> 日期）和标准化
-	将日期表示为 Date 对象，或者表示为从 GMT（格林尼治标准时间）1970 年 1 月 1 日 00:00:00 这一刻开始的毫秒数

#### SimpleDateFormat类

java.text.SimpleDateFormat：具体子类

-	SimpleDateFormat 是一个以与语言环境有关的方式来格式化和解析日期的具体类
-	它允许进行格式化（日期 -> 文本）、解析（文本 -> 日期）和规范化

#### SimpleDateFormat 构造方法

-	```public SimpleDateFormat()``` : 默认模式
-	```public SimpleDateFormat(Sting pattern)``` : 给定的模式

Date Pattern遵循如下格式：
![img](https://zhengshuaipeng.github.io/static/img/blog/2016/07/java-date-pattern.png)

常用模式： 年 y 月 M 日 d 时 H 分 m 秒 s

#### 日期的格式化与解析

```java
package org.lovian.date;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Date format demo: Date -- Sting (格式化） String -- Date （解析）
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class DateFormatDemo {
	public static void main(String[] args) {
		// Date -- String, 格式化
		// 创建日期对象
		Date date = new Date();
		// 默认格式创建格式化对象
		DateFormat df = new SimpleDateFormat();
		// 格式化日期
		String s = df.format(date);
		System.out.println(s);

		// 给定模式创建格式化对象
		DateFormat df2 = new SimpleDateFormat("yyyy年MM月dd日HH：mm：ss");
		String s2 = df2.format(date);
		System.out.println(s2);

		// String -- Date 解析
		String str = "2008-08-08 12:12:12";
		DateFormat df3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //这里格式必须要匹配
		Date date2 = null;
		try {
			date2 = df3.parse(str);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.err.println("parse error");
		}
		System.out.println(date2);
	}
}
```
result

```
7/18/16 12:11 AM
2016年07月18日00：11：33
Fri Aug 08 12:12:12 CEST 2008
```

### 2.Calendar类

#### Calendar类

java.util.Calendar：

-	抽象类，为特定瞬间与一组如 YEAR， MONTH， DAY_OF_MONTH, HOUR 等日历字段提供了转换方法
-	瞬间用毫秒值（表示为从 GMT（格林尼治标准时间）1970 年 1 月 1 日 00:00:00 这一刻开始的毫秒数）
-	提供 ```getInstance``` 方法来获得实例，返回一个 Calendar 对象，（因为是语言环境敏感类）
-	Calendar 对象能生成特定语言和日历风格的实现 日期 - 格式化 所需的所有日历字段值

#### 生成实例

Calendar 没有公开构造方法，只能通过 getInstance 来获得实例对象，其实获得的是其子类对象

-	```public static Calendar getInstance()```
-	```public static Calendar getInstance(Locale alocale)```
-	```public static Calendar getInstance(TimeZone zone)```
-	```public static Calendar getInstance(TimeZone zone, Locale alocale)```

#### Calendar 实例常见方法

-	```public int get(int filed)```: 返回给定日历字段的值， 日历字段，就是年分秒等字段（Calendar类静态成员变量，int类型），可以直接通过 Calendar 得到
-	```public void add(int field, int amount)```: 根据日历规则，为给定日历字段添加或者减去指定的时间量
	-	如 ```add(Calendar.DAY_OF_MONTH, -5)```: 从当前日历减去 5 天
-	```public final void set(int year, int month, int date)```: 设置当前日历的年月日
-	```public Date getTime()```: 返回当前Calendar日历时间值的一个Date对象
-	```public long getTimeInMillis()```: 返回当前 Calendar 的时间值，以毫秒为单位，类似于```System.currentTimeMillis()```

```java
package org.lovian.calendar;

import java.util.Calendar;

/**
 * Calendar Class Demo
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class CalendarDemo {
	public static void main(String[] args) {
		// get instance of calendar
		Calendar c = Calendar.getInstance();

		// get year
		int year = c.get(Calendar.YEAR);

		// get month, Remember month count from 0!!!
		int month = c.get(Calendar.MONTH);

		// get date
		int date = c.get(Calendar.DATE);
		System.out.println("now: " + year + "-" + (month + 1) + "-" + date);
		System.out.println("===================");

		// today of three years ago
		c.add(Calendar.YEAR, -3);
		System.out.println("3 years ago: " + c.get(Calendar.YEAR) + "-" + (c.get(Calendar.MONTH) + 1) + "-"
				+ c.get(Calendar.DATE));

		// set date as 2011-11-11
		c.set(2011, 10, 11);
		System.out.println("single day: " + c.get(Calendar.YEAR) + "-" + (c.get(Calendar.MONTH) + 1) + "-"
				+ c.get(Calendar.DATE));
	}
}
```

result

```
now: 2016-7-18
===================
3 years ago: 2013-7-18
single day: 2011-11-11
```

#### 面试题，获得任意一年的二月的天数

```java
package org.lovian.date;

import java.util.Calendar;

/**
 * Get the day numbers of each Feb
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class EachFebrary {
	public static void main(String[] args) {
		System.out.println("2014-02 has " + getDaysOfFeb(2014) + "days");
		System.out.println("2016-02 has " + getDaysOfFeb(2016) + "days");
	}

	public static int getDaysOfFeb(int year) {
		Calendar c = Calendar.getInstance();
		// set year-01-31
		c.set(year, 2, 1);
		c.add(Calendar.DATE, -1); // last day of Feb
		int date = c.get(Calendar.DATE);
		return date;

		/*
		Calendar c = Calendar.getInstance();
		// set year-02-1
		c.set(year, 1, 1);
		long lastDayofJan = c.getTimeInMillis();
		c.getTime();

		// set year-03-01
		c.set(year, 2, 1);
		long firstDayOfMar = c.getTimeInMillis();

		//3月1号 - 1月31 = 二月天数 + 1, 所以这里需要用3月1号-2月1号
		int date = (int) ((firstDayOfMar - lastDayofJan) / 1000 / 60 / 60 / 24);
		return date;
		 */
	}
}
```

result：

```
2014-02 has 28days
2016-02 has 29days
```
