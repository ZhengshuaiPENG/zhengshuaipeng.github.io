---
layout: post
title:  "[Search] Binary Search Java Implementation"
date:   2016-07-16
desc: "binary search java implementation"
keywords: "Binary Search, Array, Java, Algorithm"
categories: [algorithm]
---

# 二分查找法的 Java 实现（Binary Search）

## I. 二分查找法原理

首先说基本查找，基本查找是从一个无序的数组中，从头到位挨个查找，找到就返回，找不到就返回 -1;

不同于基本查找，基本查找当输入规模非常大的时候，挨个查找效率非常低，所以二分查找这里就是为了解决基本查找效率低下的问题而提出的。

二分查找： 也叫折半查找，首先要将数组排序，然后用待查找元素和待查找数组的中间元素相比较，看待查找元素在左右哪个范围里，然后丢弃掉不需要的那一半，这样，每次查找就相当于少了一半的范围。这样效率有着极大的提升，时间复杂度是 O(log n)。

简而言之，就是和中间值比较大小，缩小一半范围

## II. Java 代码实现

```java
package org.lovian.search;

/**
 * Binary search
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class BinarySearch {
	public static void main(String[] args) {
		int[] array = { 76, 23, 49, 28, 48, 10, 3, 97, 65 };
		int target1 = 65;
		int target2 = 24;

		// sort array
		bubbleSort(array);

		printArray(array);

		// binary search
		System.out.println("index of 65: " + binarySearch(array, target1));
		System.out.println("index of 24: " + binarySearch(array, target2));

	}

	public static int binarySearch(int[] array, int target){

		int index = -1;	// default index of target
		int min = 0;	// min index
		int max = array.length - 1;	// max index
		int mid = (min + max)/2;	// mid index
		while(min < max){
			if(target == array[mid]){
				// find target, return
				return mid;
			}else if(target < array[mid]){
				// target in left side
				max = mid - 1;	// shrink the max
				mid = (min + max)/2;	// update mid index
			}else if(target > array[mid]){
				// target in right side
				min = mid + 1;	// reset the min
				mid = (min + max)/2;	//update mid index
			}
		}
		return index;
	}

	public static void bubbleSort(int[] array) {
		boolean sorted = false;
		int n = array.length - 1;
		while (!sorted) {
			sorted = true;
			for (int i = 0; i < n; i++) {
				if (array[i] > array[i + 1]) {
					swap(array, i, i + 1);
					sorted = false;
				}
			}
			n--;
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
}
```

result：

```
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
index of 65: 6
index of 24: -1

```

注意，这里改变了数组的原有索引，所以一般对于无序数组，用基本查找。但是这个思想可以应用于某些特定的需求，
