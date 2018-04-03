---
layout: post
title:  "[String] How many subStirngs"
date:   2016-07-16
desc: "count how many substrings in Java"
keywords: "string, Java, Algorithm"
categories: [algorithm]
---

# How many subStrings Java implenmentation

## I. Question

Given a string ```s1``` and another string ```substr```, count how many ```substr``` in ```s```.

For example:
```s1```: helloworldhello
```substr``` : llo
return 2.


## II. Idea

First, find the index of substr from s1, cut the head of s1 which contains first substr(length need to cut = index + substr.length). And then find the index of substr from rest part, and repeat

## III. Java implenmentation

```java
package org.lovian.string;

/**
 * How many substrings
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class HowManySubStr {
	public static int countSubString(String originalStr, String subStr) {
		int count = 0;
		String tmp = originalStr;
		int index = tmp.indexOf(subStr);
		while (index != -1) {	//if index = -1, means substr doesn't exist
			count++;
			tmp = tmp.substring(index + subStr.length());	//rest part of string
			index = tmp.indexOf(subStr);
		}
		return count;
	}

	public static void main(String[] args) {

		String s1 = "woaijavawoaijavawozhendeaijavawotaiaijavale";
		String subStr = "java";
		System.out.println("count: " + countSubString(s1, subStr));
		;
	}
}
```

result:

```
count: 4
```
