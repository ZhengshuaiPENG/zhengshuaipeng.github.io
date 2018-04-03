---
layout: post
title:  "[JAVA] Code Blocks"
date:   2016-07-09
desc: "Code Blocks and their functions in Java"
keywords: "java, code block, local block, construction block, static block"
categories: [java]
---

# Code Blocks

## I. Code Block

In java, the code inside  a pair of ```{}``` called code block.

-	Local code block:
	-	Inside a method
	-	To limit the lifecycle of variable
	-	Release varaible to improve the performance of memory usage.
-	Construction code block:
	-	In the position of field of a class
	-	Will be executed before the constructor has been executed
	-	To put common codes of all constructors together
-	Static code block
	-	In the position of field of a class, with ```static```
	-	To initialize the class
-	Synchronized code block
	-	(to be continued)

```java
class Code {
	{
	// Construction Code Block
		int x = 10;
		System.out.println(x);
	}

	public Code(){}

	{
	// Construction Code Block
		int y = 100;
		System.out.println(x);
	}

	static {
	// Static Code Block
		int z = 200;
		System.out.println(x);
	}

	public static void main(String[] args){
		{
			// Local Code Block
			int y = 20;
			System.out.println(y);
		}
	}
}
```

## II. Question

The execution squence of local code block, construction code block, and static code block?

Answer:
static code block --> construction code block --> constructor

| static code block | construction code block --> constructor |
| -- | -- | -- |
| Executed only once when the class has been loaded| Executed when the constructor has been called |

Code:

```java
package org.lovain.codeblock;

/**
 * Code Block Demo: Student Class
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class Student {
	private String name;

	static {
		System.out.println("Student staitic code block");
	}

	{
		System.out.println("Student construction code block");
	}

	public Student(String name) {
		System.out.println("Student" + name + " constructor");
	}
}


package org.lovain.codeblock;

/**
 * Code Block Demo: Demo Class
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class StudentDemo {
	static {
		System.out.println("Demo static code block");
	}

	public static void main(String[] args) {
		System.out.println("Demo main method");

		Student s1 = new Student("James");
		Student s2 = new Student("Xiaoming");
	}
}

```

Result:

```
Demo static code block
Demo main method
Student staitic code block
Student construction code block
StudentJames constructor
Student construction code block
StudentXiaoming constructor

```
