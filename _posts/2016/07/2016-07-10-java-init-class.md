---
layout: post
title:  "[JAVA] Class Initialization"
date:   2016-07-10
desc: "Class Initialization in Java"
keywords: "java, code block, constructor, initialization, class, inheritance"
categories: [Java]
tags: [Java, JavaSE]
icon: fa-keyboard-o
---

# I.Class Initialization

In Java, we know a class can extend a father class. When we create a instance of a class in Java, how this instance has been initialized?

## The sequence of initializing a class

-	Initialize member variables first (before constructor)
	1	Default: null, 0, false
	2	Assign a value directly
	3	Through constructor to assign the value

-	Multiple level initialization (initialize member variables)
	1	Initialize father class first
	2	Then children classes

# II. Example

## Example 1

Code:

```java
class Father {
	static {
		System.out.println("Father: static code block");
	}

	{
		System.out.println("Father: construction code block");
	}

	public Father(){
		System.out.println("Father: constructor");
	}
}


class Son extends Father{
	static {
		System.out.println("Son: static code block");
	}

	{
		System.out.println("Son: construction code block");
	}

	public Son(){
		System.out.println("Son: Constructor");
	}
}

class Demo1 {
	public static void main(String[] args) {
		Son s = new Son();
	}
}
```

Result:

```
Father: static code block
Son: static code block
Father: construction code block
Father: constructor
Son: construction code block
Son: Constructor

```

## Example2

Code:

```java
package org.lovian.inheritance;

class X {
	Y y = new Y();
	X() {
		System.out.println("X");
	}
}

class Y {
	Y(){
		System.out.println("Y");
	}
}

public class Z extends X{
	Y y = new Y();

	Z() {
		//super();
		System.out.println("Z");
	}

	public static void main(String[] args) {
		new Z();
	}
}

```

Result:

```
Y
X
Y
Z

```

Note here: Even if there is a ```super()``` in the constructor of class Z, but the sequence of initialization is not as execute super() first, then print Z. Here is using multiple level initialization
