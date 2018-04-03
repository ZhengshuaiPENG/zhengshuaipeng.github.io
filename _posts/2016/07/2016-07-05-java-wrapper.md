---
layout: post
title:  "[JAVA] Primitive Type, Wrapper, Autoboxing, Unboxing"
date:   2016-07-05
desc: "Wrapper, Autoboxing and Unboxing"
keywords: "java, primitive type, wrapper, autoboxing, unboxing"
categories: [java]
---


# I. Primitive types And Wrapper

## 1. Primitive types

In Java, it has 8 primitive types

-	```byte```: 1 byte (8 bits), -128 ~ 127
-	```short```: 2 bytes, -2^15 ~ 2^15-1
-	```int```: 4 bytes, -2^31 ~ 2^31-1
-	```long```: 8 bytes, -2^63 ~ 2^63-1
-	```float```: 4 bytes, -3.403E38 ~ 3.403E38
-	```double```: 8 bytes, -1.798E308 ~ 1.798E308
-	```char```: 2 bytes, unicode
-	```boolean```: 1 bytes, default value: false

Some notes:

-	```byte```, ```short```, ```char```, these types, when they are used in calculation, all of them will cast to ```int``` during the calculation. So after calculation, sometimes, we need to cast back to the original type.

```java
short i = 1;
short j = 2;
short a = i + j;
// this line has problem, because (i + j ), it's int value, not a short.
// so the correct answer is
short a = (short)(i + j);

short j += i;
// this one is ok, because the operator like += , it will cast to original type automatically
```

-	Conversion flow: ```byte, short, char - int - long - float - double```, conversion is allowed from left to right
-	```byte```, ```short```, and ```char```, they can not convert to each other, they will be convert to ```int``` first

## 2. Wrapper types

Primitive type is not an object, but the wrapper can operate them as an object. So sometimes the program expected an object of integer number, like ```ArrayList<T>``` for instance, we can not pass a primitive ```int```, it should pass an ```Integer``` into ArrayList.

| Primitive type | Wrapper type|
|--|--|
| byte | Byte|
| short| Short|
| int | Integer |
| long | Long |
| float | Float |
| double | Double |
| char | Character |
| boolean | Boolean |

```
int a = 1; // primitive type, value is 1
Integer a = new Integer(1); // a is a reference, points to an object, the value of this obejct is 1
```

## 3. Difference between primitive type and wrapper

we know that, when we pass an argument to a method, there is difference between primitive type value and object value:

-	For primitive type value: it will pass a copy of value into method
-	For object: it will pass the reference of object into method, in fact it pass a pointer

So when we pass a primitive type like ```int a```, in fact, the real value passed into method is a copy of ```a```, all the operations inside method won't affect the value of ```a```;

```java
package org.lovian.wrapper;

public class Demo1 {

	public static void main(String[] args) {
		int a = 1;
		intAddOne(a);

		System.out.println(a); // 1

	}

	public static void intAddOne(int a){
		a = a + 1;
	}
}
```

But if we pass an object, ```Student a``` for instance, it just pass the reference ```a``` into method, so in the method, it's an object, so we could use the methods defined in Student. To see the following example:

we define a Student class:

```java
package org.lovian.entity;

public class Student {
	private int id;
	private String name;

	public Student(int id, String name) {
		super();
		this.id = id;
		this.name = name;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
```

And then we do some test here:

```java
package org.lovian.wrapper;

import org.lovian.entity.Student;

public class Demo2 {
	public static void main(String[] args) {
		Student student = new Student(1, "lovian");
		System.out.println(student.getName()); // lovian

		changeStudentName(student); // pass the reference
		System.out.println(student.getName()); // hahaha
	}

	public static void changeStudentName(Student student) {
		student.setName("hahaha");
	}
}
```

In the result, we will see that the name of student has been changed. The reason is when we passed the student to the method ```changeStudentName()```, in fact it pass the reference of object 'student'. So Inside the method, student still points to the real object 'student'. That's why here the student name has changed.

Until to here, maybe you will think, in the code ```Demo1```, if we pass a Integer into method ```addOne()```, the value shoud be changed. Let's see example, we update Demo1 as follow:

```java
package org.lovian.wrapper;

public class Demo1 {

	public static void main(String[] args) {
		int a = 1;
		Integer b = new Integer(1);

		intAddOne(a);
		intAddOne(b);

		System.out.println(a); // 1
		System.out.println(b); // 1

		integerAddOne(a);
		integerAddOne(b);

		System.out.println(a); // 1
		System.out.println(b); // 1

		System.out.println(b.compareTo(a)); // 0
	}

	public static void intAddOne(int a){
		a = a + 1;
	}

	public static void integerAddOne(Integer a){
		a = a + 1;
	}

}
```

You may have the questions:

-	Why all the result is ```1```? It should change because ```b``` is a ```Integer``` object, why it not change to ```2```?
-	Why ```a``` can pass into ```intAddOne()``` and also ```integerAddOne()```?
-	Why ```b``` can pass into ```intAddOne()``` and also ```integerAddOne()```?

The reason is ```Autoboxing``` and ```Unboxing```.


# II. Autoboxing and Unboxing

## 1. Autoboxing

When we define a Integer variable, we could define like this:

-	```Integer i = new Integer(1);```

But also we could define like this:

-	```Integer i = 1;```

The second way to define a Integer variable, we call it ```Autoboxing```. It will wrap the primitive type value ```1``` to a Integer object.

## 2.Unboxing

If we define a int variable like this:

```java
Integer a = 10;
int b = a;
```

When assign a to b, it will give the value of object a to b. This is ```Auto Unboxing```.
During the calculation, it's the same:

```java
Integer i = 10;
System.out.println(i + 10); // Auto Unboxing i, then do calculation

Boolean foo = true;
System.out.println(foo && false); // Auto unboxing foo, then do the calculation
```

## 3.Essence of Autoboxing and Unboxing

In fact ```Autoboxing``` and ```Unboxing``` is a compiler sugar.
When we define

```java
Integer number = 100;
```

Oracle JDK will compile it as

```java
Integer localInteger = Integer.valueOf(100)
```

So here ```valueOf()``` is the way to wrap a primitive type into an object. So the following example can pass the compilation, but it will report an error during the runtime:

```java
package org.lovian.wrapper;

public class Demo3 {
	public static void main(String[] args) {
		Integer i = null;
		int j = i;

		j = 5;
		System.out.println(j);
	}
}

```

The error message:

```
Exception in thread "main" java.lang.NullPointerException
	at org.lovian.wrapper.Demo3.main(Demo3.java:6)
```

It's because during the compilation, it will be compiled to

```java
Object localObject = null;
int i = localObject.intValue(); // here will report the null pointer exception
```

## 4. Cache in Integer

Let's do the test as follow:

```java
package org.lovian.wrapper;

public class Demo4 {
	public static void main(String[] args) {
		Integer i = 100;
		Integer j = 100;

		if(i == j)
			System.out.println("i = j");
		else
			System.out.println("i != j");

		Integer k = 200;
		Integer l = 200;

		if(k == l)
			System.out.println("k = l");
		else
			System.out.println("k != l");
	}
}

```

The result is

```
i = j
k != l
```

Why here ```i = j```, but ```k != l```?
That's because the compiler will use ```Integer.valueOf()``` to create Integer instance. The implementation as follow:

```java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```

```IntegerCache.low``` is ```-128``` by default, ```IntegerCache.high``` is ```127``` by default.

-	For i and j: it will create instance ```i = 100``` first, then when create instance j, it will check that if 100 is in the cache or not. Because -128 < 100 < 127, it won't create a new instance, it just return the instance of i. That's means i and j reference to the same object, the value of this object is 100; So ```i = j```
-	For k and l: because 200 is greater then 127, so it will create two different instances for k and l, so ```k != l```
