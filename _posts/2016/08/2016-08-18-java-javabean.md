---
layout: post
title:  "[JAVA] 了解JavaBean"
date:   2016-08-18
desc: "javabean in Java"
keywords: "java, javabean"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# 内省 -> 了解 JavaBean

## I. 什么是 JavaBean

JavaBean 是一种特殊的 Java 类：

-	主要用于传递数据信息
-	JavanBean 中的方法主要用于访问私有的字段
-	方法名符合某种命名规则（setter/getter)


## II. 使用 JavaBean

如果要在两个模块之间，传递多个信息，那么可以将这些信息封装到 JavaBean 中：

-	这种 JavaBean 的实例对象通常称之为```值对象```，（```Value Object```， 简称 VO）
-	这些信息在类中用私有字段来存储
-	通过 ```setter/getter``` 来设置/读取这些值
-	一个类被当作 JavaBean 来使用时， JavaBean 的属性是根据方法名推断出来的，它根本看不到 Java 类内部的成员变量


比如下面的一个 ```Student``` 类就是一个典型的 JavaBean 类：

```java
package org.lovian.entity;

public class Student {
	private int id;
	private String name;

	public Student() {
		super();
	}

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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
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
		Student other = (Student) obj;
		if (id != other.id)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Student [id=" + id + ", name=" + name + "]";
	}

}
```

## III. 使用 JavaBean 的好处

一个复合 JavaBean 特点的类，可以当作普通类一样进行使用，但把它当作 JavaBean 用有一些额外的好处：

-	在 JEE 开发中，经常要使用 JavaBean
-	JDK中提供了一些对 JavaBean 进行操作的一些API，这套API就称为```内省， IntroSpector```，我们可以通过 API 来访问私有变量

代码实例，通过 API 对 Student 类进行操作：

```java
package org.lovian.entity;

import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;

public class Test {
	public static void main(String[] args) throws Exception{
		Student s = new Student();
		s.setId(8532);
		s.setName("PENG");

		// 使用 getter 方法得到属性值
		System.out.println("Id: " + s.getId() + " Name: " + s.getName());

		// 使用 API 获取值
		String idPropertyName = "id";
		PropertyDescriptor pd = new PropertyDescriptor(idPropertyName, s.getClass());
		Method methodGetId = pd.getReadMethod();
		Object idVal = methodGetId.invoke(s, null);
		System.out.println("Id: " + idVal);

		// 使用 API 设置并获取值
		PropertyDescriptor pd2 = new PropertyDescriptor("name", Student.class);
		Method methodSetName = pd2.getWriteMethod();
		methodSetName.invoke(s, "Shen");
		Method methodGetName = pd2.getReadMethod();
		Object nameVal = methodGetName.invoke(s, null);
		System.out.println("Name: " + nameVal);
	}
}
```

result：

```
Id: 8532 Name: PENG
Id: 8532
Name: Shen
```
