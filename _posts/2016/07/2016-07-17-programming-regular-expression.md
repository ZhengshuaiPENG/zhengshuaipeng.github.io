---
layout: post
title:  "Regular Expression 正则表达式的使用"
date:   2016-07-17
desc: "how to use regual expression"
keywords: "Linux, reguar expression"
categories: [regex]
---

# 正则表达式的使用

## I. 正则表达式

正则表达式（Regex）： regular expression， 是指一个用来描述或者匹配一系列复合某个句法规则的字符串的单个字符串。其实就是一种规则，有自己特殊的应用。简而言之，就是复合一定规则的字符串

## II. 正则表达式的组成规则

Java 中， 规则字符在 ```java.util.regex.Pattern``` 类中

### 常见的组成规则

-	字符：
	-	```x``` : 表示字符 x , 举例：'a' 表示字符 a
	-	```\\``` : 表示反斜线 \
	-	```\n``` : 表示换行符（'\u000A'）
	-	```\r``` : 表示回车符（'\u000D'）
-	字符类
	-	```[abc]``` : 表示 a 、b 或 c (简单类)
	-	```[^abc]``` : 表示除了 a 、b 或 c 的其他字符
	-	```[a-zA-z]``` : 表示 a - z 或者 A - Z 的任一字符，两头的字母包括在内 （范围）
	-	```[0-9]``` : 表示 0 - 9 的任一字符
-	预定义字符类：
	-	```.``` : 表示任何字符，```\.``` 表示点字符本身, 使用时，需要用两个反斜线```\\.```
	-	```\d``` : 表示任一数字， 等同于 ```[0-9]```, 使用的需要用两个反斜线 ```\\d```, 以下等同
	-	```\D``` : 表示非数字，等同于 ```[^0-9]```
	-	```\s``` : 表示空白字符， 等同于 ```[ \t\n\x0B\f\r]```
	-	```\S``` : 表示非空白字符， 等同于 ```[^\s]```
	-	```\w``` : 表示单词字符， 等同于 ```[a-zA-Z_0-9]```,这些都是单词字符
	-	```\W``` : 非单词字符， 等同于 ```[^\w]```
-	边界匹配器
	-	```^``` : 行的开头
	-	```$``` : 行的结尾
	-	```\b``` : 单词边界，就是非单词字符的地方，举例 ```hello world?hahaha;xixi```
	-	```\B``` : 非单词边界
-	Greedy 数量词: X 可以代表小括号括起来的内容
	-	```X?``` ：X，一次或一次也没有
	-	```X*``` ：X，零次或多次
	-	```X+``` ：X，一次或多次
	-	```X{n}``` ：X，恰好 n 次
	-	```X{n,}``` ：X，至少 n 次
	-	```X{n,m}``` ： X，至少 n 次，但是不超过 m 次

## III. 正则表达式的应用

### 1. 判断功能

```String``` 类的 matches 方法： ``` public boolean matches(String regex)```

```java
public void boolean matchString(String string){
	String regex = "1[358]\\d{9}";
	boolean flag = string.matches(regex);
	return flag;
}
```

### 2. 分割功能

```String``` 类的 split 方法： ```public String[] split(String regex)```

```java
public void splitString(String string){
	String regex = "#";	// 以 # 作为分隔符，来分割字符串
	String[] strArray = string.split(regex);	// 返回的是被 # 分割开的字符串数组（不包括#）

	for(int x = 0; x < strArray.length; x++){
		System.out.println(strArray[x]);
	}
}
```

### 3. 替换功能

```String``` 类的 replaceAll 方法： ```public String replaceAll(String regex, String replacement)```
使用给定 replacement 替换此字符串所有匹配给定的正则表达式的子字符串

```java
public String replaceString(String string){
	String regex = "\\d+";	// 匹配一个或多个数字
	String replacement = "";	// 将数字从string中去除
	String result = string.replaceAll(regex, replacement);
	return result;
}
```

### 4. 获取功能

```Pattern``` 类和 ```Matcher``` 类的使用

-	```Pattern``` 是正则表达式的编译表示形式。
指定为字符串的正则表达式必须首先被编译为此类的实例。然后，可将得到的模式用于创建 Matcher 对象，依照正则表达式，该对象可以与任意字符序列匹配。执行匹配所涉及的所有状态都驻留在匹配器中，所以多个匹配器可以共享同一模式。
因此，典型的调用顺序是

```
 Pattern p = Pattern.compile("a*b");
 Matcher m = p.matcher("aaaaab");
 boolean b = m.matches();
```

-	```Matcher``` 通过解释 Pattern 对 character sequence 执行匹配操作的引擎。
通过调用模式的 matcher 方法从模式创建匹配器。创建匹配器后，可以使用它执行三种不同的匹配操作：
	-	matches 方法尝试将整个输入序列与该模式匹配。
	-	lookingAt 尝试将输入序列从头开始与该模式匹配。
	-	find 方法扫描输入序列以查找与该模式匹配的下一个子序列。
每个方法都返回一个表示成功或失败的布尔值。通过查询匹配器的状态可以获取关于成功匹配的更多信息。

```java
package org.lovian.pattern;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Pattern 和 Matcher 使用
 * @author PENGzhengshuai
 * @lovian.org
 *
 */
public class PatternDemo {
	public static void main(String[] args) {
		// 定义字符串
		String s = "da jia ting wo shuo yao hao hao xue java, java hen zhong yao";

		String[] strings = matchString(s);

		for(int i = 0; i < strings.length; i++){
			System.out.println(strings[i]);
		}

	}

	public static String[] matchString(String string) {
		// 定义规则, 匹配三个字符的单词，要使用单词边界
		String regex = "\\b\\w{3}\\b";
		ArrayList<String> array = new ArrayList<>();

		// 把规则编译成对象
		Pattern p = Pattern.compile(regex);
		// 通过 Pattern 对象得到 Matcher 对象
		Matcher m = p.matcher(string);

		// 调用匹配器对象的功能
		// find：查找有没有满足条件的子序列
		while(m.find()){
			// 调用 group 之前，必须要用 find 方法找到
			String matched = m.group();
			array.add(matched);
		}

		// string 数组是不可以改变长度的，所以这里用 ArrayList 添加元素
		String[] strings = new String [array.size()];
		// 用 arraylist 转成数组
		array.toArray(strings);
		return strings;
	}

}
```

result

```
jia
yao
hao
hao
xue
hen
yao

```
