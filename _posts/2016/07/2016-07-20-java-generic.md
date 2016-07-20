---
layout: post
title:  "[JAVA] Java 中的泛型 Generics"
date:   2016-07-20
desc: "how to use generics in Java"
keywords: "java, generics"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中的泛型 Generics

## I. 泛型的由来

在泛型出现之前，我们是用 Object 类来代表任意类型。在使用对象的时候存在一个向下转型的问题，所以就会存在转型失败的隐患。而这个隐患在编译的时候，是检查不出来的，所以就存在了安全问题。所以在 JDK5之后，Java 提供了泛型来解决这个问题

## II. 泛型

泛型：

-	一种特殊的类型，把类型明确的工作推迟到到创建对象的时候或者使用方法的时候才去明确的类型。
-	也被称为参数化类型，就是说把类型当作参数一样传递
-	格式： ```<数据类型>```, 此处的数据类型只能是引用类型，可以是 ```T```， ```E```， ```K```， ```V```

泛型的好处：

-	把运行时期的问题提前到了编译期间（find problem befor runtime)
-	避免了强制类型转换

泛型在那些地方使用？

-	看 API， 如果类，接口，抽象类后面跟的有 <E> 就说要使用泛型，一般来说在集合类中使用


## III. 泛型的定义

-	泛型类：
	-	把泛型定义在类上
	-	格式： ```public class ClassName <泛型类型1...>{}```
	-	注意： 泛型类型必须是引用类型

```java
package org.lovian.generics;

/**
 * Generic Class
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 * @param <T>
 */
public class MyGenericClass<T> {
	private T t;

	public T get(){
		return t;
	}

	public void set(T t){
		this.t = t;
	}

	@Override
	public String toString() {
		return t.toString();
	}

}

package org.lovian.generics;

/**
 * MyGenericClass Test
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class MyGenericClassTest {
	public static void main(String[] args) {
		MyGenericClass<String> myGeneric = new MyGenericClass<>();
		myGeneric.set("hello world");
		System.out.println(myGeneric);

		MyGenericClass<Integer> intGeneric = new MyGenericClass<>();
		intGeneric.set(5);
		System.out.println(intGeneric);
	}
}
```

result:

```
hello world
5
```

-	泛型方法：
	-	把泛型定义在方法上
	-	格式： ```public <泛型类型> 返回类型 方法名（泛型类型...)```

```java
package org.lovian.generics;

/**
 * Generic Method
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class MyGenericMethod<E> {
	private E e;

	public E get(){
		return e;
	}

	public void set(E e){
		this.e = e;
	}

	@Override
	public String toString() {
		return e.toString();
	}

	//注意这里的泛型类型是 T， 而类上的泛型是 E
	public static <T> void show(T t){
		System.out.println(t.toString());
	}
}


package org.lovian.generics;

/**
 * Generic method test
 * @author PENG Zhengshuai
 * @lovian.org
 */
public class MyGenericMethodTest {
	public static void main(String[] args) {
		MyGenericMethod.show("hello method");
		MyGenericMethod.show("12345");

		MyGenericMethod<String> myGe = new MyGenericMethod<>();
		myGe.set("hello class");
		System.out.println(myGe);
	}
}

```

result

```
hello method
12345
hello class
```

-	泛型接口
	-	把泛型定义在接口上
	-	格式： ```public interface 接口名 <泛型类型1...>```


```java
package org.lovian.generics;
/**
 * Interface
 * @author PENG Zhengshuai
 *
 * @param <T>
 */
public interface MyGenericInterface<T> {
	public abstract void show(T t);
}

package org.lovian.generics;

/**
 * Interface Implementation
 *
 * @author PENG Zhengshuai
 *
 * @param <T>
 */
public class MyGenericInterfaceImpl<T> implements MyGenericInterface<T>{

	@Override
	public void show(T t) {
		// TODO Auto-generated method stub
		System.out.println("interface show: " + t);

	}

}

package org.lovian.generics;

/**
 * Generic Interface demo
 * @author PENG Zhengshuai
 *
 */
public class GenericInterfaceTest {

	public static void main(String[] args) {
		MyGenericInterface<String> i = new MyGenericInterfaceImpl<>();
		i.show("hello world");
	}


}
```

result

```
interface showhello world
```


## IV. 泛型通配符

-	```<?>``` : 任意类型，如果没有明确，那么就是 Object 以及任意的 Java 类了
-	```<? extends E>``` : 向下限定， E 及其子类
-	```<？ super E>``` ： 向上限定， E及其父类

```java
package org.lovian.generics.advance;

import java.util.ArrayList;
import java.util.Collection;

public class GenericAdvanceDemo {
	public static void main(String[] args) {
		// 泛型使用时，如果具体声明，前后必须一致
		Collection<Object> c1 = new ArrayList<Object>();  // okay
		Collection<Object> c2 = new ArrayList<String>();  // error!
		Collection<Object> c3 = new ArrayList<Integer>(); // error!
		Collection<Object> c4 = new ArrayList<Boolean>(); // error!

		// 而适用通配符 <?>，匹配所有类
		Collection<?> c5 = new ArrayList<Object>(); // ok
		Collection<?> c6 = new ArrayList<String>(); // ok
		Collection<?> c7 = new ArrayList<Integer>(); // ok
		Collection<?> c8 = new ArrayList<Boolean>(); // ok

		// <? extends E> : 匹配本身和其子类
		Collection<? extends Animal> c9 = new ArrayList<Object>(); // error!
		Collection<? extends Animal> c10= new ArrayList<Animal>(); // ok
		Collection<? extends Animal> c11= new ArrayList<Dog>();	   // ok
		Collection<? extends Animal> c12= new ArrayList<Cat>();	   // ok

		// <? super E> : 匹配自身和其父类
		Collection<? super Dog> c13 = new ArrayList<Object>(); // ok
		Collection<? super Dog> c14 = new ArrayList<Animal>(); // ok
		Collection<? super Dog> c15 = new ArrayList<Cat>(); // error!
		Collection<? super Animal> c16 = new ArrayList<Dog>(); // error!
	}
}

class Animal{}
class Dog extends Animal{}
class Cat extends Animal{}
```
