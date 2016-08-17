---
layout: post
title:  "[Design Pattern] 设计模式之单例模式"
date:   2016-08-17
desc: "OOP singleton programming"
keywords: "java, design pattern， oop， singleton"
categories: [Programming]
tags: [Java， OOP， Design Pattern]
icon: fa-keyboard-o
---


# 设计模式之单例模式

## I. 单例模式概述

单例模式（Singleton）：

-	创建型模式
-	单例模式就是要确保类在内存中只有一个对象，该实例必须自动创建，并且对外提供
-	私有的构造方法
-	指向自己实例的私有静态引用
-	返回自己实例的静态公有方法

## II. 单例模式的优缺点

-	优点：
	-	在系统内存中只存在一个对象，因此可以节约系统资源，
	-	对于一些需要频繁创建和销毁的对象单例模式无疑可以提高系统的性能
	-	避免对共享资源的多重占用
	-	可以全局访问
-	缺点：
	-	没有抽象层，因此扩展很难
	-	职责过重，在一定程度上违背了单一职责

## III. 常用单例模式

### 1. 饿汉式单例模式

```饿汉式单例模式```： 在单例类被加载时，就实例化一个对象交给自己引用

```java
package org.lovian.designpattern.singleton;

/*
 * 饿汉式单例模式
 */
public class HurrySingleton {
	private static HurrySingleton INSTANCE = new HurrySingleton();

	private HurrySingleton(){

	}

	public static HurrySingleton getInstance(){
		return INSTANCE;
	}
}
```

### 2. 懒汉式单例模式

```懒汉式单例模式```： 在调用取得实例方法时，才会实例化对象

```java
package org.lovian.designpattern.singleton;

/*
 * 懒汉式单例模式
 */
public class LazySingleton {
	private static LazySingleton INSTANCE;

	private LazySingleton(){

	}

	public static LazySingleton getInstance(){
		if(INSTANCE == null){
			INSTANCE = new LazySingleton();
		}

		return INSTANCE;
	}
}
```

测试类：

```java
package org.lovian.designpattern.singleton;

public class SingletonTest {
	public static void main(String[] args) {
		// 饿汉式单例模式
		HurrySingleton hs1 = HurrySingleton.getInstance();
		HurrySingleton hs2 = HurrySingleton.getInstance();
		System.out.println(hs1 == hs2);

		// 懒汉式单例模式
		LazySingleton ls1 = LazySingleton.getInstance();
		LazySingleton ls2 = LazySingleton.getInstance();
		System.out.println(ls1 == ls2);
	}
}
```

result：

```
true
true
```


## IV. 单例模式的应用场景和注意事项

-	应用场景：
	-	需要频繁的实例化然后销毁的对象
	-	创建对象时耗时过多或者消耗资源过多，但又经常用到的对象
	-	有状态的工具类对象
	-	频繁的访问数据库或者文件的对象
-	注意事项
	-	单例对象只能用单例类提供的方法得到，不能使用反射，否则会得到实例化的一个新对象
	-	不要断开单例类对象和类中静态引用的危险操作，否则对象可能被GC
	-	多线程使用单例模式来使用共享资源时，注意线程安全问题

## V. 单例模式的线程安全问题

### 1. 饿汉式

饿汉式单例模式线程安全，所以开发中常用的是饿汉式单例模式

### 2. 懒汉式

懒汉式是懒加载（延迟加载的思想），懒汉式线程不安全，所以我们可以改进懒汉式让它变成线程安全的单例模式

```java
package org.lovian.designpattern.singleton;

/*
 * 线程安全懒汉式单例模式
 */
public class LazySingleton {
	private static LazySingleton INSTANCE;

	private LazySingleton(){

	}

	public static LazySingleton getInstance(){
		if(INSTANCE == null){
            synchronized (LazySingleton.class) {
                if(INSTANCE == null){
                    INSTANCE = new LazySingleton();
                }
            }
        }

		return INSTANCE;
	}
}
```

在 getInstance 方法中，首先判断 INSTANCE 是否为 null， 如果是，则加锁来新建实例对象（静态方法用class文件对象作为锁），来进入同步代码块中，再次判断 INSTANCE 是否为 null 检查确保没有实例对象


## VI. 单例模式的继承问题

由于饿汉式单例模式和懒汉式单例模式的构造方法是被 ```private``` 修饰的，所以，他们是不可以被继承的
