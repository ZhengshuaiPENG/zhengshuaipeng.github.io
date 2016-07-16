---
layout: post
title:  "[Sort] Selection Sort Java Implementation"
date:   2016-07-16
desc: "selection sort implementation"
keywords: "Selection Sort, Array, Java, Algorithm"
categories: [Algorithm]
tags: [Java,Algorithm, Sort]
icon: fa-keyboard-o
---

# 选择排序的 java 实现（Selection Sort）

## I. 选择排序的原理

选择排序： 从 0 索引开始，依次和后面的元素比较，小的往前排，第一次扫描完毕，最小值就出现了最小索引处，然后重复以上步骤。简单点说就是，每一次扫描，都从待排序数组中拿出最小的一个排在最前面，然后排成一个新数组，这个数组就是从小到大排好序的了。

## II. Java 代码

```java
package org.lovian.sort;

/**
 * Selection Sort
 *
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class SelectionSort {

	public static void selectionSort(int[] array) {
		for (int i = 0; i < array.length - 1; i++) {
			// 每一趟扫描
			for (int j = i; j < array.length; j++) {
				// 每一次选择剩余待排序数组的最小值
				if (array[i] > array[j]) {
					// 把最小值换到最小索引处
					swap(array, i, j);
				}
			}
			printArray(array);
		}
	}

	public static void swap(int[] array, int src, int des) {
		int tmp = array[src];
		array[src] = array[des];
		array[des] = tmp;
	}

	public static void printArray(int[] array) {
		System.out.print("[");
		for (int i = 0; i < array.length; i++) {
			if (i != array.length - 1) {
				System.out.print(array[i] + " ,");
			} else {
				System.out.print(array[i] + "]");
			}
		}
		System.out.println();
	}

	public static void main(String[] args) {
		int[] array = { 76, 23, 49, 28, 48, 10, 3, 97, 65 };
		selectionSort(array);
		printArray(array);
	}
}
```

result：

```
[3 ,76 ,49 ,28 ,48 ,23 ,10 ,97 ,65]
[3 ,10 ,76 ,49 ,48 ,28 ,23 ,97 ,65]
[3 ,10 ,23 ,76 ,49 ,48 ,28 ,97 ,65]
[3 ,10 ,23 ,28 ,76 ,49 ,48 ,97 ,65]
[3 ,10 ,23 ,28 ,48 ,76 ,49 ,97 ,65]
[3 ,10 ,23 ,28 ,48 ,49 ,76 ,97 ,65]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,97 ,76]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]

```

