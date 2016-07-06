---
layout: post
title:  "[Array] Yanghui Triangle"
date:   2016-07-06
desc: "Array, how to print Yanghui triangle"
keywords: "Yanghui triangle, Array, Java, Algorithm"
categories: [Algorithm]
tags: [Java,Algorithm, Array]
icon: fa-keyboard-o
---

# Yanghui Triangle

## I. Q

To print the triangle as the following format:

```
1
1 1
1 2 1
1 3 3 1
1 4 6 4 1
1 5 10 10 5 1
```

## II. Idea

For this triangle, we can found:

-	The first element and last element of each line is 1
-	For other elements, the value is the sum of two elements in previous line
-	For line n, it has n element

So we could use two dimension array to store these value, and traverse this array to print.

## III. Code

```java
package org.lovian.array;
/**
 * Yanghui Triangle
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class Yanghui {
	public static void main(String[] args) {
		printTriangle(-1);
		System.out.println("===========");
		printTriangle(3);
		System.out.println("===========");
		printTriangle(4);
		System.out.println("===========");
		printTriangle(5);
		System.out.println("===========");
		printTriangle(6);
		System.out.println("===========");
	}

	public static void printTriangle(int n) {
		if (n <= 0) {
			System.out.println("Argument error");
			return;
		}
		int[][] array = new int[n][n];

		for (int i = 0; i < array.length; i++) {
			array[i][0] = 1;
			array[i][i] = 1;
		}

		// Calculate the value and store it to array
		for (int i = 2; i < array.length; i++) {
			// begin with 3rd line
			for(int j = 1; j< i; j++){
				array[i][j] = array[i-1][j-1] + array[i-1][j];
			}
		}

		for (int i = 0; i < array.length; i++) {
			for (int j = 0; j <= i; j++) {
				// for each line i, print the i elements
				System.out.print(array[i][j] + " ");
			}
			System.out.println();
		}
	}
}
```
