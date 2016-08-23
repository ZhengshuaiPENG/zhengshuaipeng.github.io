---
layout: post
title:  "[Date Structure] 数据结构之线性表"
date:   2016-08-21
desc: "linear list of data structure"
keywords: "java, data structure, linear list"
categories: [Algorithm]
tags: [Algorithm, Data Structure]
icon: fa-keyboard-o
---

# 数据结构之线性表

## I. 线性表


### 1. 什么是线性表

线性表： ```linear list```

-	零个或者多个数据元素的```有限```序列
-	由```相同数据类型```的 n 个数据元素 ```a0，a​1​​ ... an−1```​​ 组成的有限序列
-	```a​0```​​ 是唯一的“第一个”数据元素，又称为表头元素
-	```a​n−1```​​ 是唯一的“最后一个”数据元素，又称为表尾元素
-	元素之间是```有顺序```的，若有多个元素
	-	第一个元素无前驱
	-	最后一个元素无后继
	-	其他元素有且只有一个前驱和后继
-	举例： 小朋友排队


### 2. 线性表的分类

-	线性表按照存储结构，可以分为
	-	```顺序表```
	-	```链表```

### 3. 线性表的抽象数据类型

线性表的抽象数据类型定义如下：

```
ADT 线性表 (List)
Data
	DataType {a0, a2, ..., an−1}
Operation
	InitList (*L): 初始化操作，建立一个空的线性表
	ListEmpty (L): 若线性表为空，返回true，否则返回false
	ClearList (*L): 清空线性表
	GetElem (L, i，*e): 将线性表 L 中的第 i 个位置的元素值返回给 e
	LocateElem (L, e): 在线性表 L 中查找与给定 e 相等的元素，如果查找成功，返回该元素在表中的序号;否则返回 0 表示失败
	ListInsert (*L, i, e): 在线性表 L 中的第 i 个 位置插入新元素 e
	ListDelete (*L, i, *e): 删除线性表 L 中第 i 个位置的元素，并用 e 返回其值
	ListLength (L): 返回线性表 L 的元素个数
endADT
```

对于更复杂的线性表操作，可以使用这些基本操作的组合来实现

## II. 顺序表

### 1. 什么是顺序表

顺序表

-	是在计算机内存中以数组形式保存的线性表
-	是指用一组地址连续的存储单元依次存储数据元素的线性结构

注意：

-	线性表是逻辑结构，表示元素之间一对一的相邻关系
-	而顺序表是指存储结构，是指用一组地址连续的存储单元，依次存储线性表中的数据元素，从而使得逻辑上相邻的两个元素在物理位置上也相邻

![顺序表]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/linear-list.png)


### 2. 顺序表的实现

代码请参见 [DataStructure-Java/src/org/lovian/datastructure/linearlist/sequencelist](https://github.com/ZhengshuaiPENG/DataStructure-Java/tree/master/src/org/lovian/datastructure/linearlist/sequencelist)

由于顺序表在内存中是连续的，而且存放的是相同数据类型的数据元素，所以可以用 ```一维数组``` 来实现顺序表结构：

-	一维数组可以是静态分配的
	-	由于数组的大小和空间是固定的，一旦空间占满，就无法再新增数据，否则会导致数据溢出
-	也可以是动态分配的
	-	存储数组的空间在程序执行过程中会动态调整大小，当空间占满时，可以另行开辟更大的存储空间来储存数据


在这里用 Java 语言来实现，由于 Java 中基本类型和其包装类无法直接通过方法改变值，所以这里先实现了一个类用于包装 int 类型

```DataType```接口

```java
package org.lovian.datastructure.linearlist.datatype;

public interface DataType {
	Object getData();

	void SetData(Object obj);
}
```

int 类型的包装类：

```java
package org.lovian.datastructure.linearlist.datatype;

public class IntDataType implements DataType {

	private Integer a;

	public IntDataType(int num) {
		a = num;
	}

	@Override
	public Object getData() {
		return a;
	}

	@Override
	public void SetData(Object obj) {
		if (obj instanceof Integer)
			a = (Integer) obj;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((a == null) ? 0 : a.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		IntDataType other = (IntDataType) obj;
		if (a == null) {
			if (other.a != null)
				return false;
		} else if (!a.equals(other.a))
			return false;
		return true;
	}
}
```

顺序表 ```SequenceList``` 的基本组成

```java
package org.lovian.datastructure.linearlist.sequencelist;

import org.lovian.datastructure.linearlist.datatype.DataType;
import org.lovian.datastructure.linearlist.datatype.IntDataType;

public class SequenceList {
	private DataType[] data;
	private int length;

	public SequenceList(int maxSize) {
		this.data = new IntDataType[maxSize];
		this.length = 0;
	}
}
```

所以描述顺序表需要三个属性

-	存储空间的起始位置： 数组 data， 它的存储位置就是存储空间的存储位置
-	线性表的最大存储容量： 数组长度 maxSize
	-	这个量一般在分配后是不变的
	-	当然也可以动态分配，这里暂时不考虑
-	线性表的当前长度： length
	-	是线性表中数据元素的个数
	-	这个量随着线性表的插入和删除，是变化的
	-	length <= maxSize


### 3. 顺序表的操作实现

#### A. 获取元素操作

将线性表的第 i 个位置的元素值返回，失败返回false，成功返回true，时间复杂度 O(1)

```java
public boolean getElem(int i, DataType element) {
	if (length == 0 || i < 0 || i > length - 1)
		return false;
	element.SetData(data[i].getData());
	return true;
}
```

#### B. 插入操作

插入算法的思路：

-	如果插入的位置不合里，抛出异常
-	如果线性表长度大于等于数组长度，则抛出异常或者动态增加容量
-	从最后一个元素开始向前遍历到第 i 个位置，分别将它们向后移动一个位置
-	将要插入元素填入位置 i 的地方
-	表的长度加 1

java 代码实现，插入失败返回false，成功返回true

```java
public boolean ListInsert(int i, DataType element) {
	// 顺序线性表已满
	if (length == data.length)
		return false;

	// i 不再范围内
	if (i < 0 || i > length)
		return false;

	// 如果插入数据位置不再表尾
	if (i < length) {
		// 要将插入位置后数据元素向后移动一位
		for (int k = length - 1; k > i - 1; k--) {
			data[k + 1] = data[k];
		}
	}
	// 插入新元素
	data[i] = element;
	// 表长度增加
	length++;
	return true;
}
```

#### C. 删除操作

删除算法的思路：

-	如果删除的位置不合理，抛出异常
-	取出删除元素
-	从删除元素位置开始遍历到最后一个元素，分别将他们向前移动一个位置
-	表长减 1

java 代码实现，删除失败返回false，成功返回true，removedEle 用于拿到被删除的元素

```java
public boolean ListDelete(int i, DataType removedEle) {
	// 线性表为空
	if (length == 0)
		return false;

	// 删除的位置不正确
	if (i < 0 || i > length - 1)
		return false;

	// 拿到删除元素
	removedEle.SetData(data[i].getData());

	// 如果删除的元素不是最后一个
	if (i < length) {
		// 删除位置后继元素前移一个位置
		for (int k = i; k < length - 1; k++) {
			data[k] = data[k + 1];
		}
	}
	// 表长减1
	length--;
	return true;
}
```

插入操作和删除操作的复杂度分析：

-	最好情况：
	-	插入或删除的元素位置是最后一个位置
	-	复杂度 O(1)
-	最坏情况：
	-	如果要插入到第一个位置或者删除第一个元素，需要移动 n-1 个元素
	-	复杂度 O(n)
-	平均情况：
	-	元素平均移动次数和最中间那个元素的移动次数相等，为 (n-1)/2
	-	复杂度 O(n)

### 4. 顺序表的特点

-	顺序表优点
	-	可以快速存取表中任一位置的元素
	-	不需要为表示表中元素之间的逻辑关系而增加额外的存储控件
-	顺序表的缺点
	-	插入和删除操作需要移动大量的元素，从而保持逻辑上和物理上的连续性
	-	当线性表长度变化较大时，难以确定存储空间的容量

