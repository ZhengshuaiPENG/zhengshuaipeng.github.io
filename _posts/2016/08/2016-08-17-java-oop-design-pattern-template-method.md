---
layout: post
title:  "[Design Pattern] 设计模式之模板方法模式"
date:   2016-08-17
desc: "OOP template method pattern programming"
keywords: "java, design pattern， oop， template method"
categories: [Programming]
tags: [Java， OOP， Design Pattern]
icon: fa-keyboard-o
---

# 设计模式之模板方法模式

## I. 模板方法模式概述

模板方法模式 （Template Method）：

-	行为型模式
-	定义一个算法的骨架，而将具体的算法延迟到子类中来实现
-	使得子类可以不改变算法结构，即可重新定义算法中的某些步骤

## II. 模板方法模式的结构

一般由一个```抽象类```和其```实现类```通过继承结构组成：

抽象类中```方法```有三种：
-	抽象方法： 定义好规范由子类来实现
-	模板方法：
	-	抽象类声明此方法且加以实现
	-	模板方法是调用抽象方法来完成主要的逻辑功能
	-	大多会被定义为 ```final``` 方法
-	钩子方法：
	-	抽象类声明此方法且加以实现
	-	子类可以通过钩子方法来影响模板方法的逻辑

## III. 模板方法模式的优缺点

-	优点：
	-	容易扩展
		-	一般来说，抽象类中的模版方法是不易反生改变的部分，而抽象方法是容易反生变化的部分
		-	因此通过增加实现类一般可以很容易实现功能的扩展，符合开闭原则。
	-	便于维护
		-	对于模版方法模式来说，正是由于他们的主要逻辑相同，才使用了模版方法
		-	假如不使用模版方法，任由这些相同的代码散乱的分布在不同的类中，维护起来是非常不方便的。
	-	比较灵活
		-	因为有钩子方法，因此，子类的实现也可以影响父类中主逻辑的运行
		-	但是，在灵活的同时，由于子类影响到了父类，违反了里氏替换原则，也会给程序带来风险。这就对抽象类的设计有了更高的要求。
-	缺点：
	-	如果算法骨架有修改的话，则需要修改抽象类

## IV. 适用场景

-	在多个子类拥有相同的方法，并且这些方法逻辑相同时，可以考虑使用模版方法模式。
-	在程序的主框架相同，细节不同的场合下，也比较适合使用这种模式

## V. 例子

我们来看一个需要排序的需求，抽象类中定义了抽象方法 sort(), 然后在模板方法中使用此 sort() 方法来对数据进行排序

先来定义抽象类

```java
package org.lovian.designpattern.template;

import java.util.Arrays;

public abstract class AbstractSort {
	private int[] array;

	public AbstractSort(int[] array){
		this.array = array;
	}

	// 抽象方法
	protected abstract void sort(int[] array);

	// 模板方法，调用抽象方法完成逻辑
	public void showResult(){
		System.out.println("Before Sort");
		System.out.println(Arrays.toString(array));
		this.sort(array);
		System.out.println("-----------------------------");
		System.out.println("After Sort:");
		System.out.println(Arrays.toString(array));
	}
}
```

然后实现这个抽象类，在实现类中实现抽象方法，第一个子类用冒泡排序实现：

```java
package org.lovian.designpattern.template;

public class BubbleSort extends AbstractSort {

	public BubbleSort(int[] array) {
		super(array);
	}

	@Override
	protected void sort(int[] array) {
		bubbleSort(array);
	}

	private void bubbleSort(int[] array) {
		int length = array.length;
		boolean sorted = false;
		while (!sorted) {
			sorted = true;
			for (int i = 0; i < length - 1; i++) {
				if (array[i] > array[i + 1]) {
					int tmp = array[i];
					array[i] = array[i + 1];
					array[i + 1] = tmp;
					sorted = false;
				}
			}
			length--;
		}
	}
}
```

第二个子类用选择排序实现：

```java
package org.lovian.designpattern.template;

public class SelectionSort extends AbstractSort {

	public SelectionSort(int[] array) {
		super(array);
	}

	@Override
	protected void sort(int[] array) {
		selectionSort(array);
	}

	private void selectionSort(int[] array){
		int minIndex = 0;
		for(int i = 0; i < array.length - 1; i++){
			minIndex = i;
			for(int j = i+1; j < array.length; j++){
				if(array[minIndex] > array[j])
					minIndex = j;
			}

			if(minIndex != i){
				int tmp = array[minIndex];
				array[minIndex] = array[i];
				array[i] = tmp;
			}
		}
	}
}
```

测试类：

```java
package org.lovian.designpattern.template;

public class SortTest {
	public static void main(String[] args) {
		System.out.println("Bubble Sort");
		int[] array = {12 , 4, 53, 23, 17, 2, 31, 26, 45};
		AbstractSort as = new BubbleSort(array);
		as.showResult();

		System.out.println("========================");
		System.out.println("Selection Sort");
		int[] array2 = {12 , 4, 53, 23, 17, 2, 31, 26, 45};
		AbstractSort as2 = new SelectionSort(array2);
		as2.showResult();
	}
}
```

result：

```
Bubble Sort
Before Sort
[12, 4, 53, 23, 17, 2, 31, 26, 45]
-----------------------------
After Sort:
[2, 4, 12, 17, 23, 26, 31, 45, 53]
========================
Selection Sort
Before Sort
[12, 4, 53, 23, 17, 2, 31, 26, 45]
-----------------------------
After Sort:
[2, 4, 12, 17, 23, 26, 31, 45, 53]
```

