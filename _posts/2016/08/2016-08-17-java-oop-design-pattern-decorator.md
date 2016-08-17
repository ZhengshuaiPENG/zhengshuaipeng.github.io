---
layout: post
title:  "[Design Pattern] 设计模式之装饰者模式"
date:   2016-08-17
desc: "OOP decorator pattern programming"
keywords: "java, design pattern， oop， decorator"
categories: [Programming]
tags: [Java， OOP， Design Pattern]
icon: fa-keyboard-o
---

# 设计模式之装饰者模式

## I. 装饰者模式概述

装饰者模式（Decorator Pattern）：

-	装饰模式就是使用被装饰类的一个子类的实例，在客户端将这个子类的实例交给装饰类
-	是继承的替代方案
-	装饰者模式通过组合的方式扩展对象的特性
	-	允许我们在任何时候对对象的功能进行扩展甚至是运行时扩展
	-	用继承来完成对类的扩展则只能在编译阶段实现，所以在某些时候装饰者模式比继承要更加灵活


## II. 装饰者模式的特征


-	装饰者（decorator）和被装饰（扩展）的对象有着相同的超类（supertype）。
-	我们可以用多个装饰者去装饰一个对象。
-	我们可以用装饰过的对象替换代码中的原对象，而不会出问题（因为他们有相同的超类）。
-	装饰者可以在委托（delegate，即调用被装饰的类的成员完成一些工作）被装饰者的行为完成之前或之后加上他自己的行为。
-	一个对象能在任何时候被装饰，甚至是运行时。

## III. 装饰者模式的组成

-	```Component```:
	-	一般是一个抽象类（也有可能不是），是一组有着某种用途类的基类，包含着这些类最基本的特性。
-	```ConcreteComponent```：
	-	继承自Component
	-	一般是一个有实际用途的类，这个类就是我们以后要装饰的对象。
-	```Decorator```：
	-	继承自Component
	-	装饰者需要共同实现的接口（也可以是抽象类），用来保证装饰者和被装饰者有共同的超类，并保证每一个装饰者都有一些必须具有的性质，如每一个装饰者都有一个实例变量用来保存某个Component类型的类的引用。
-	```ConcreteDecorator```：
	-	继承自Decorator，用来装饰Component类型的类（不能装饰抽象类），为其添加新的特性
	-	可以在委托被装饰者的行为完成之前或之后的任意时候。

## IV. 装饰者模式的优缺点

-	优点
	-	使用装饰模式，可以提供比继承更灵活的扩展对象的功能，它可以动态的添加对象的功能，并且可以随意的组合这些功能
-	缺点
	-	正因为可以随意组合，所以就可能出现一些不合理的逻辑
	-	会引入大量的类（比如 Java IO 中的 API）

## V. 装饰者模式例子

我们来看这样一个例子，定了一个手机接口 ```Phone```， 在这个接口里定义了打电话的方法，然后有 IPone 和 Note7 两个实现类分别实现打电话的方法。如果，我要让手机加入打电话听彩铃的功能，或者打电话后听音乐的功能，该怎么实现？

解决方法之一是，修改 IPhone 和 Note7 的实现方法，加入功能，如果这么做，正常的没有彩铃功能的手机怎么办？这就违反了开闭原则。

所以我们可以用装饰者模式，来装饰 ```Phone```， 给 ```Phone``` 添加新的功能，图示如下：

![decorate]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/decorator.png)

那么首先我们来定义手机接口和两个实现类 IPone 和 Note7

```java
package org.lovian.designpattern.decorator;

public interface Phone {
	void call();

	String getPhoneName();
}


package org.lovian.designpattern.decorator;

public class IPhone implements Phone {

	private String name = "IPhone 6s";

	@Override
	public void call() {
		System.out.println(this.name + " call");
	}

	@Override
	public String getPhoneName(){
		return this.name;
	}
}


package org.lovian.designpattern.decorator;

public class Note7 implements Phone{

	private String name = "Note7";
	@Override
	public void call() {
		System.out.println(this.name + " call");
	}

	@Override
	public String getPhoneName() {
		return this.name;
	}

}
```

然后我们定义装饰者抽象类，实现 Phone 接口， 传入一个 ```Phone``` 的实现类对象作为被装饰对象

```java
package org.lovian.designpattern.decorator;

public abstract class PhoneDecorator implements Phone{
	private Phone phone;

	public PhoneDecorator(Phone phone){
		this.phone = phone;
	}

	@Override
	public void call() {
		this.phone.call();
	}

	@Override
	public String getPhoneName() {
		return this.phone.getPhoneName();
	}
}
```

然后我们提供彩铃装饰类，继承抽象装饰者类：

```java
package org.lovian.designpattern.decorator;

public class RingBackMusicPhoneDecorator extends PhoneDecorator{

	public RingBackMusicPhoneDecorator(Phone phone) {
		super(phone);

	}

	@Override
	public void call() {
		System.out.println(super.getPhoneName() + " plays Ringback music");
		super.call();
	}
}
```

同样的，提供音乐装饰类

```java
package org.lovian.designpattern.decorator;

public class MusicPhoneDecorator extends PhoneDecorator {

	public MusicPhoneDecorator(Phone phone) {
		super(phone);
	}

	@Override
	public void call() {
		super.call();
		System.out.println(super.getPhoneName() + " plays music");
	}
}
```

然后测试类来测试这几个类：

```java
package org.lovian.designpattern.decorator;

public class PhoneTest {
	public static void main(String[] args) {

		// Create an IPhone
		Phone iPhone6s = new IPhone();
		iPhone6s.call();
		System.out.println("---------------");

		// Play RingbackMusic before IPhone's call
		PhoneDecorator pd1 = new RingBackMusicPhoneDecorator(iPhone6s);
		pd1.call();

		System.out.println("---------------");
		// Play music after IPhone's call
		PhoneDecorator pd2 = new MusicPhoneDecorator(iPhone6s);
		pd2.call();
		System.out.println("---------------");

		// Play RingbackMusic before IPhone's call
		// And Play music after IPhone's call
		PhoneDecorator pd3 = new RingBackMusicPhoneDecorator(new MusicPhoneDecorator(iPhone6s));
		pd3.call();

		System.out.println("---------------");
		// Create a Note7
		Phone note7 = new Note7();
		note7.call();
		System.out.println("---------------");

		// Play RingbackMusic before Note7's call
		PhoneDecorator pd4 = new RingBackMusicPhoneDecorator(note7);
		pd4.call();
		System.out.println("---------------");

		// Play Music before Note7's call
		PhoneDecorator pd5 = new MusicPhoneDecorator(note7);
		pd5.call();
		System.out.println("---------------");

		// Play RingbackMusic before Note7's call
		// And Play music after Note7's call
		PhoneDecorator pd6 = new RingBackMusicPhoneDecorator(new MusicPhoneDecorator(note7));
		pd6.call();
	}
}
```

result：

```
IPhone 6s call
---------------
IPhone 6s plays Ringback music
IPhone 6s call
---------------
IPhone 6s call
IPhone 6s plays music
---------------
IPhone 6s plays Ringback music
IPhone 6s call
IPhone 6s plays music
---------------
Note7 call
---------------
Note7 plays Ringback music
Note7 call
---------------
Note7 call
Note7 plays music
---------------
Note7 plays Ringback music
Note7 call
Note7 plays music
```

我们可以看到，我们不需要改 ```Phone``` 的接口，也不需要更改其实现类的方法实现，就可以实现添加功能，这个就是装饰者模式
