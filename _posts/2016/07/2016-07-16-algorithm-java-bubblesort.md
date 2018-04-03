---
layout: post
title:  "[Sort] Bubble Sort Java Implementation"
date:   2016-07-16
desc: "Bubble sort implementation"
keywords: "Bubble Sort, Array, Java, Algorithm"
categories: [algorithm]
---

# 冒泡排序的 Java 实现 （Bubble Sort）

## I. Bubble Sort 原理

冒泡排序： 相邻元素两两比较，如果前一个元素比后一个元素大，则交换。第一次完毕后，最大的元素就出现在最大索引处，同理继续以上步骤，最后可得排好序的数组。

## II. Java 代码

```java
package org.lovian.sort;

/**
 * Bubble Sort
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class BubbleSort {

	public static void bubbleSort(int[] array){
		boolean sorted = false;
		int n = array.length - 1; //防止数组越界

		while(!sorted){
			//每一次扫描
			sorted = true;  //假定这次扫描能够完成排序
			for(int i = 0; i < n; i++){
				//每一次比较
				if(array[i] > array[i+1]){
					swap(array, i, i+1);
					sorted = false;  //经过一次交换，说明还需要一次扫描
				}
			}
			n--;	//每一次扫描最大值已经就绪，下一次扫描不需要再次比较已经排好位置的最大值
			printArray(array);

		}
	}

	public static void swap(int[] array, int src, int des){
		int tmp = array[src];
		array[src] = array[des];
		array[des] = tmp;
	}

	public static void printArray(int[] array){
		System.out.print("[");
		for(int i = 0; i < array.length; i++){
			if(i != array.length -1){
				System.out.print(array[i] + " ,");
			}else{
				System.out.print(array[i] + "]");
			}
		}
		System.out.println();
	}

	public static void main(String[] args) {
		int[] array = { 76, 23, 49,28,48,10,3,97,65};
		bubbleSort(array);
		printArray(array);
	}
}
```

result

```
[23 ,49 ,28 ,48 ,10 ,3 ,76 ,65 ,97]
[23 ,28 ,48 ,10 ,3 ,49 ,65 ,76 ,97]
[23 ,28 ,10 ,3 ,48 ,49 ,65 ,76 ,97]
[23 ,10 ,3 ,28 ,48 ,49 ,65 ,76 ,97]
[10 ,3 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
[3 ,10 ,23 ,28 ,48 ,49 ,65 ,76 ,97]
```

## III.和双层for循环冒泡排序的比较

除了上面用一个全局循环标志 ```sorted``` 来控制外层循环，一般来说，还有另一种很常见的双层 for 循环实现

```java
public static void bubbleSort(int[] array){
	for(int i = 0; i < array.length -1; i++){
		//每一次扫描循环
		for(int i = 0; i < array.length - 1 - i; i++){
			//逐一比较
			if(array[i] > array[i+1]){
				swap(array, i, i+1);
			}
		}
	}
}
```

这种双层 for 循环是必须把外循环全部执行一遍的，无论在中间的步骤数组排好序与否，都要执行 数组长度-1 次循环。而用 ```sorted``` 控制的循环是当数组排好序即退出循环。这两种方法在最坏的情况下，复杂度相同 （n square), 但是其他情况下，while 循环版本效率更高
