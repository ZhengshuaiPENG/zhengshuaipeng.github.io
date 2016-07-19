---
layout: post
title:  "[JAVA] Java 中的集合 Collection 和 迭代器 Itrator"
date:   2016-07-18
desc: "how to use collection in Java"
keywords: "java, collection， iterator"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的集合 Collection 和 迭代器

## I. Collection 引用

由于对象数组 （比如 ```Student[] students = new Student[5]```) 在使用的时候，长度是固定不可变的，当我们需要动态的添加更多的对象时，数组是十分不方便的,  所以为了方便多个对象的操作， Java 提供了另一种容器来存储一系列相同的对象，叫做集合， Collection

## II. Java 中的集合类

### 1.集合类的关系图

首先先看在 java 中，集合类的关系图(此图来源于网络）：

![collection](https://zhengshuaipeng.github.io/static/img/blog/2016/07/collection.png)


### 2. 集合类和数组的区别

-	数组：
	-	长度固定
	-	可以存储对象，也可以存储基本类型
	-	存储的是同一种类型的元素
-	集合
	-	长度可变
	-	只能存储对象
	-	可以存储不同类型元素

### 3. Java集合类

为了满足不同的存储需求，Java 提供了不同的集合类，这多个集合类的数据结构（数据的存储方式）不同。不管是什么数据结构，所有的集合类都应该提供一些共同的功能比如判断，获取等，把这些共性的地方提取出来，就构成了Java中集合类的继承体系。

简化上面的集合类关系图：常用集合类

![collectionimg]( https://zhengshuaipeng.github.io/static/img/blog/2016/07/collection_img.png)

我们可以发现，这是一个继承体系，所以我们从最高级的父类 Collection 来学习 Java 集合类

### 4. Collection 接口

java.util.Collection<E>:

-	继承超级接口 ```Iterable<E>``` , Collection 是集合层次结构中的根接口
-	Collection 表示一组对象，这些对象就是 Collection 的元素
-	某些集合允许有重复元素（list)，某些不允许(set)
-	某些集合有序，某些无序
-	JDK 不提供此接口的直接实现，它提供更具体的子接口的实现（如set和list）
-	实例化的时候必须用 Collection 的实现类

### 5. Collection 功能概述

-	添加功能
	-	```boolean add(E e)``` : 添加一个元素
	-	```boolean addAll(Collection<? extends E> c)``` : 添加一个集合的所有元素
-	删除功能
	-	```void clear()``` : 移除本集合内的所有元素
	-	```boolean remove(Object obj)``` : 移除一个指定的元素（第一次出现的）
	-	```boolean removeAll(Collection<?> c)``` : 移除在本集合中包含的指定集合中所有元素，只要有一个被移除，就返回 true
-	判断功能
	-	```boolean contains(Object obj)``` : 判断集合中是否包含指定的元素
	-	```boolean containsAll(Collection<?> c)``` : 判断集合中是否包含指定的集合元素，要全部包含才会返回 true， 部分包含或者不包含则是 false
	-	```boolean isEmpty()``` : 判断集合是否为空
-	获取功能
	-	```Iterator<E> iterator()``` ： 返回在此 collection 的元素上进行迭代的迭代器，用于集合的遍历
-	长度功能
	-	```int size()```: 返回元素的个数， （数组和字符串是 ```length```）
-	交集功能
	-	```boolean retainAll(Collection<?> c)``` ： 保留两个集合都有的元素
-	集合到数组的转换
	-	```Object[] toArray()``` ： 返回包含集合中所有的元素数组，通过数组进行集合的遍历


## II. 迭代器

### 1. Iterator 的使用

迭代器，是遍历集合的一种方式，是依赖于集合而存在的

-	```boolean hasNext()``` : 如果仍有元素可以迭代，则返回 true
-	```E next()``` : 返回迭代的下一个元素
-	```void remove()``` : 从迭代器指向的 collection 中移除迭代器返回的最后一个元素（可选操作）。每次调用 next 只能调用一次此方法。如果进行迭代时用调用此方法之外的其他方式修改了该迭代器所指向的 collection，则迭代器的行为是不确定的。

```java
package org.lovian.collection;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/**
 * Iterator Demo
 *
 * Iterator iterator(): 迭代器，集合专用遍历方式 (实际是 pointer)
 * Object next() : 获取元素， 会返回 NoSuchElementException
 * boolean hasNext(): 判断是否有下个元素
 *
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class IteratorDemo {
	public static void main(String[] args) {
		Collection<String> c = new ArrayList<String>();

		c.add("hello");
		c.add("world");

		// while loop
		Iterator<String> it = c.iterator(); // 这里返回的子类对象，实际上是多态
		while(it.hasNext()){
			System.out.println("str: " + it.next());
		}

		System.out.println("==========");
		// for loop
		for(Iterator<String> it = c.iterator(); it.hasNext();){
			String s = it.next();
			System.out.println("str: " + s);
		}
	}
}
```

result:

```
str: hello
str: world
==========
str: hello
str: world
```

### 2. Iterator 原理

因为所有的集合类，内部存储的数据结构是不同的，所以迭代器就应该定义成一个行为接口，让所有的集合类去实现迭代器中的方法，从而提供相同的调用方法。而迭代器接口的真正实现类实在集合子类的内部类当中（看 Iterator JDK 源码和其实现类的源码）

上文提到 Collection 接口还继承了一个接口 ```Iterable```， Iterable 中定义了一个方法 ```Iterator iterator()```, 这个方法是用来得到迭代器的实例的（实际上是 Iterator 的实现类的实例）。这个方法被每个集合具体类所实现，比如 ArrayList。

所以我们打开 ArrayList 的源码， 找到 Iterator 的实现方法：

```java
    /**
     * Returns an iterator over the elements in this list in proper sequence.
     *
     * <p>The returned iterator is <a href="#fail-fast"><i>fail-fast</i></a>.
     *
     * @return an iterator over the elements in this list in proper sequence
     */
    public Iterator<E> iterator() {
        return new Itr();
    }
```

我们可以发现，这个方法返回了一个类 ```Itr``` 的对象, 这个类就是 ArrayList 中的内部类，也就是 Iterator 真正的实现类，代码如下：

```java
 	/**
     * An optimized version of AbstractList.Itr
     */
    private class Itr implements Iterator<E> {
        int cursor;       // index of next element to return
        int lastRet = -1; // index of last element returned; -1 if no such
        int expectedModCount = modCount;

        public boolean hasNext() {
            return cursor != size;
        }

        @SuppressWarnings("unchecked")
        public E next() {
            checkForComodification();
            int i = cursor;
            if (i >= size)
                throw new NoSuchElementException();
            Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length)
                throw new ConcurrentModificationException();
            cursor = i + 1;
            return (E) elementData[lastRet = i];
        }

        public void remove() {
            if (lastRet < 0)
                throw new IllegalStateException();
            checkForComodification();

            try {
                ArrayList.this.remove(lastRet);
                cursor = lastRet;
                lastRet = -1;
                expectedModCount = modCount;
            } catch (IndexOutOfBoundsException ex) {
                throw new ConcurrentModificationException();
            }
        }

        @Override
        @SuppressWarnings("unchecked")
        public void forEachRemaining(Consumer<? super E> consumer) {
            Objects.requireNonNull(consumer);
            final int size = ArrayList.this.size;
            int i = cursor;
            if (i >= size) {
                return;
            }
            final Object[] elementData = ArrayList.this.elementData;
            if (i >= elementData.length) {
                throw new ConcurrentModificationException();
            }
            while (i != size && modCount == expectedModCount) {
                consumer.accept((E) elementData[i++]);
            }
            // update once at end of iteration to reduce heap write traffic
            cursor = i;
            lastRet = i - 1;
            checkForComodification();
        }

        final void checkForComodification() {
            if (modCount != expectedModCount)
                throw new ConcurrentModificationException();
        }
    }

```


