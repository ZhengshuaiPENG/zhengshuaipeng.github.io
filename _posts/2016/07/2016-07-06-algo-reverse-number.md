---
layout: post
title:  "[Array] Reverse Integer Number"
date:   2016-07-06
desc: "Array, how to reverse a number"
keywords: "reverse integer number, Array, Java, Algorithm"
categories: [Algorithm]
tags: [Java,Algorithm, Array]
icon: fa-keyboard-o
---

# Reverse Integer Number

## I. Question

Give an integer number, get the reverse number and print.

## II. Idea

To reverse an integer, first, we need an array to store this integer number, and reverse the array. Then convert this array to an integer.

The question is how to get the length of the number when create the array.

## III. Code

```java
package org.lovian.array;
/**
 * Reverse number
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class ReverseNumber {
	public static void main(String[] args) {
		Integer num = 123456789;
		Integer result = reverseInt(num);
		System.out.println(result);
	}

	public static int reverseInt(Integer number){
		Integer result = 0;

		// To get the length of number
		int numCopy = number;
		int count = 0;
		while(numCopy > 0){
			numCopy /= 10;
			count++;
		}

		int[] arr = new int[count];
		// Store the number into array reversely
		for (int i = 0; i < arr.length; i++) {
			arr[i] = number % 10;
			number /= 10;
		}

		for (int j = 0; j < arr.length; j++) {
			result = result + (int) (arr[j] * (Math.pow(10, (arr.length-j-1))));
		}

		return result;
	}
}
```
