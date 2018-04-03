---
layout: post
title:  "[Design Pattern] 设计模式之工厂模式"
date:   2016-08-17
desc: "OOP factory pattern programming"
keywords: "java, design pattern， oop， factory"
categories: [design_pattern]
---


# 设计模式之工厂模式

## I. 简单工厂模式

### 1.简单工厂模式概述

简单工厂模式：

-	创建型模式
-	又叫静态工厂方法模式，它定义一个具体的工厂类负责创建一些类的实例

### 2.简单工厂模式的优缺点

-	优点
	-	客户端不需要在负责对象的创建，从而明确了各个类的职责
-	缺点
	-这个静态工厂类负责所有对象的创建，如果有新的对象增加，或者某些对象的创建方式不同，就需要不断的修改工厂类，不利于后期的维护

### 3. 示例

首先我们定义一个抽象类 ```Animal```，定义一个 eat() 抽象方法

```java
package org.lovian.designpattern.simplefactory;

public abstract class Animal {
	public abstract void eat();
}
```

实现两个实现类 ```Dog``` 和 ```Cat```

```java
package org.lovian.designpattern.simplefactory;

public class Dog extends Animal {
	@Override
	public void eat() {
		System.out.println("狗吃肉");
	}
}


package org.lovian.designpattern.simplefactory;

public class Cat extends Animal {
	@Override
	public void eat() {
		System.out.println("猫吃鱼");
	}
}
```

创建一个工厂类 ```AnimalFactory```

```java
package org.lovian.designpattern.simplefactory;

public class AnimalFactory {
	private AnimalFactory() {

	}

	public static Animal createAnimal(String type) {
		if(type.equalsIgnoreCase("dog"))
			return new Dog();
		else if(type.equalsIgnoreCase("cat"))
			return new Cat();
		else
			return null;
	}
}
```

测试类：

```java
package org.lovian.designpattern.simplefactory;

public class AnimalDemo {

	public static void main(String[] args) {
		// 抽象类的具体类调用
		Dog dog = new Dog();
		Cat cat = new Cat();
		dog.eat();
		cat.eat();

		System.out.println("---------------------");

		// 通过工厂来创建
		Animal d = AnimalFactory.createAnimal("dog");
		d.eat();
		Animal c = AnimalFactory.createAnimal("cat");
		c.eat();

	}
}
```

result：

```
狗吃肉
猫吃鱼
---------------------
狗吃肉
猫吃鱼
```

从结果我们可以看到，具体类可以由工厂类来创建

## II. 工厂方法模式

为了解决简单工厂模式扩展麻烦的问题，就有了工厂方法模式

### 1. 工厂方法模式概述

工厂方法模式：

-	创建型模式
-	工厂方法模式中抽象工厂类负责定义创建对象的接口，让工厂接口的实现类绝对实例化哪一个类
-	工厂方式使一个类的实例化延迟到其子类

工厂方法模式的组成：

-	```工厂接口```或抽象类
	-	工厂方法模式的核心，用来提供产品
-	```工厂接口实现```
	-	工厂的实现决定如何实例化产品，是实现扩展的途径
	-	需要多少种产品，就需要多少个具体工厂实现
-	```产品接口```或产品抽象类
	-	用来定义产品规范，所有的产品都必须遵循产品接口定义的规范
-	```产品实现```或具体子类
	-	实现产品接口的具体类，决定了在客户端的具体行为


### 2. 工厂方法模式的优缺点

-	优点
	-	客户端不需要在负责对象的创建，对调用者屏蔽了具体的产品类，只需要知道产品接口即可，不需要关心产品实现
	-	如果有新的对象增加，只需要增加一个具体的类和具体的工厂类即可，不影响已有的代码，后期维护容易，增强了系统的扩展性
	-	降低耦合度，产品的实例化有时候需要依赖很多类，这些类对调用者来说根本不需要知道，使用工厂方法，就可以得到实例化对象
-	缺点
	-	需要额外的编写代码，增加了工作量

### 3.示例

使用上例中的 ```Animal``` 抽象类， ```Dog``` 和 ```Cat``` 具体类， 我们创建一个 ```AnimalFactory``` 的接口

```java
package org.lovian.designpattern.factorymethod;

public interface AnimalFactory {
	Animal createAnimal();
}
```

如果我们要得到 ```Dog``` 的对象，那么创建一个 ```DogFactory``` 来生成 ```Dog``` 的实例

```java
package org.lovian.designpattern.factorymethod;

public class DogFactory implements AnimalFactory {

	@Override
	public Animal createAnimal() {
		return new Dog();
	}

}
```

同理，我们要得到 ```Cat``` 的对象，那么创建一个 ```CatFactory``` 来生成 ```Cat``` 的实例

```java
package org.lovian.designpattern.factorymethod;

public class CatFactory implements AnimalFactory {

	@Override
	public Animal createAnimal() {
		return new Cat();
	}

}
```

在测试类中，我们用工厂来生产相应具体类的实例

```java
package org.lovian.designpattern.factorymethod;

public class AnimalDemo {
	public static void main(String[] args) {
		AnimalFactory dogFact = new DogFactory();
		Animal dog = dogFact.createAnimal();
		dog.eat();

		AnimalFactory catFact = new CatFactory();
		Animal cat = catFact.createAnimal();
		cat.eat();
	}
}
```

result：

```
狗吃肉
猫吃鱼
---------------------
狗吃肉
猫吃鱼
```

从结果我们可以看出，通过接口多态，我们可以拿到相应的实例。用工长方法模式，如果有新的动物类要增加，我们不需要去改已有的代码，只需要增加一个具体的类和具体的工厂类即可，后期维护容易，增强了系统的扩展性


### 4. 工厂方法模式使用场景

-	工厂方法作为一种创建类的模式，适合于需要生成复杂对象的场景
	-	生成简单对象（只需要 new 的情况），就不需要工厂模式了
-	工厂方法是一个典型的解耦模式
	-	如果调用者自己生成产品时，需要在客户端增加依赖关系，就可以使用工厂模式，降低客户端对象之间的耦合度
-	工厂模式依靠的是抽象架构，把实例化产品的任务交给实现类去完成，扩展性好
	-	不同的产品需要不同的实现工厂来组装
