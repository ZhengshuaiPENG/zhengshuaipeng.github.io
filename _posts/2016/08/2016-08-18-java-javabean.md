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
-	采用遍历 ```BeanInfo``` 的所有属性方式来查找和设置 JavaBean 类实例对象的属性
	-	在程序中把一个类当作 JavaBean 来看，就是调用 ```Introspector.getBeanInfo()``` 方法
	-	得到的 ```BeanInfo``` 对象封装了把这个类当作JavaBean 的结果信息

代码实例，通过 API 对 Student 类进行操作：

```java
package org.lovian.entity;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;

public class Test {
	public static void main(String[] args) throws Exception{
		Student s = new Student();
		s.setId(8532);
		s.setName("PENG");

		// 使用 getter 方法得到属性值
		System.out.println("Id: " + s.getId() + " Name: " + s.getName());
		System.out.println("-----------------------");

		// 使用 PropertyDescriptor API 获取属性值
		String idPropertyName = "id";
		PropertyDescriptor pd = new PropertyDescriptor(idPropertyName, s.getClass());
		Method methodGetId = pd.getReadMethod();
		Object idVal = methodGetId.invoke(s, null);
		System.out.println("Id: " + idVal);

		// 使用 PropertyDescriptor API 设置并获取属性值
		PropertyDescriptor pd2 = new PropertyDescriptor("name", Student.class);
		Method methodSetName = pd2.getWriteMethod();
		methodSetName.invoke(s, "Shen");
		Method methodGetName = pd2.getReadMethod();
		Object nameVal = methodGetName.invoke(s, null);
		System.out.println("Name: " + nameVal);
		System.out.println("-----------------------");

		// 使用 Introspector 类来把一个类当作 JavaBean 类来处理
		BeanInfo bi = Introspector.getBeanInfo(s.getClass());
		PropertyDescriptor[] allProperies = bi.getPropertyDescriptors();
		for (PropertyDescriptor propertyDescriptor : allProperies) {
			if(propertyDescriptor.getName().equals("id")){
				Method getId = propertyDescriptor.getReadMethod();
				Object val = getId.invoke(s, null);
				System.out.println("Id: " + val);
				break;
			}
		}
	}
}
```

result：

```
Id: 8532 Name: PENG
-----------------------
Id: 8532
Name: Shen
-----------------------
Id: 8532
```

## IV. 使用 BeanUtils 工具包来操作 JavaBean

```org.apache.commons.beanutils.BeanUtils``` 是 apache 提供的一个第三方的工具包，用来操作 JavaBean 的。注意它依赖于 apache 提供的日志包 ```

```java
package org.lovian.entity;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;

public class BeanUtilsDemo {
	public static void main(String[] args) throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		Student s  = new Student();

		// 通过 BeanUtils 来设置 id 属性， id 是 int 类型变量
		// 注意这里传入了一个字符串，但是，它可以被设置成功
		BeanUtils.setProperty(s, "id", "8532");
		// 注意这里返回的是也是一个字符串
		String id = BeanUtils.getProperty(s, "id");
		System.out.println("Id: " + id);

		// 通过 PropertyUtils 来设置 id 属性
		// 注意这里，不能传入字符串，必须传入 int 值
		PropertyUtils.setProperty(s, "id", 10086);
		Object idVal = PropertyUtils.getProperty(s, "id");
		System.out.println("IdVal: " + idVal + " Type: " + idVal.getClass().getName());

		// 用 BeanUtils 操作 map 的 key-value
		Map<String, String> map = new HashMap<String, String>();
		map.put("name", "PENG");
		BeanUtils.setProperty(map, "name", "Shen");
		System.out.println("Name in Map: " + BeanUtils.getProperty(map, "name"));

	}
}
```

result：

```
Id: 8532
IdVal: 10086 Type: java.lang.Integer
Name in Map: Shen
```
