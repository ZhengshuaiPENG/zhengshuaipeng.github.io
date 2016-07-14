---
layout: post
title:  "[JAVA] Java 中的匿名内部类"
date:   2016-07-14
desc: "anonymous inner class in Java"
keywords: "java, anonymous inner class"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的匿名内部类

## I. 匿名内部类

实际上匿名内部类 （anonymous inner class) 就是内部类的简化写法。

前提：已经存在了一个类（可以是具体类，也可以是抽象类）或者已经存在了一个接口

## II.声明一个匿名内部类

```java
new ClassName/InterfaceName（）{
	method(); //override
	...
};
```

## III. 匿名内部类的本质

匿名内部类实际上是一个对象！！ 它是继承了一个类的子类或者是实现了一个接口的实现类的匿名对象。


### Code

```java
package org.lovian.innerclass;

/**
 * Anonymous Inner Class Demon
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public interface Action {
	void show();
	void play();
}
```

```java
package org.lovian.innerclass;

/**
 * Anonymous Inner Class Demon
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class AnonymousInnerClass {
	public void method(){
		new Action() {

			@Override
			public void show() {
				// TODO Auto-generated method stub
				System.out.println("I'm a spy");
			}

			@Override
			public void play() {
				// TODO Auto-generated method stub

			}
		}.show();

		Action act = new Action(){
			@Override
			public void show() {
				// TODO Auto-generated method stub
				System.out.println("I'm an actor");
			}

			@Override
			public void play() {
				// TODO Auto-generated method stub
				System.out.println("let's play");
			}
		};

		act.show();
		act.play();
	}
}
```

```java
package org.lovian.innerclass;

/**
 * Anonymous Inner Class Test
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class AnonymousTest {
	public static void main(String[] args) {
		AnonymousInnerClass a = new AnonymousInnerClass();

		a.method();
	}
}

```

### Result

```java
I'm a spy
I'm an actor
let's play
```

## III. 匿名内部类的好处

当我们用匿名内部类（实际上是对象）作为方法的参数传递， 这个对象是没有被引用的，当方法执行结束，这个类就会被GC回收，那么在内存的消耗上来说是更有好处的。这种用法一般在安卓开发中比较常见
