---
layout: post
title:  "[JAVA] Java 中注解的使用"
date:   2016-08-19
desc: "annotation in Java"
keywords: "java, annotation"
categories: [java]
---

# Java 中注解的使用

## I. 注解 Annotation

注解是 JDK 1.5 提供的一个新特性，在框架中大面积的使用了注解，所以在这里讲一下注解

### 1. 什么是注解

-	注解相当于一种标记，加了注解就等于打上了某种标记
-	javac， 开发工具，和其他程序可以通过反射来来了解你的类和各种元素上是否有标记，通过标记去执行相应的处理
-	标记可以加在包，类，字段，方法，方法的参数以及局部变量上

### 2. Java 提供的几个基本注解

在 ```java.lang``` 包中，JDK 提供了最基本的三种 annotation

-	```@SuppressWarnings()``` :
	-	压缩警告
	-	去除Java代码中由于过时API（```deprecation```）或没有使用的变量(```unused```)所引起的warning
-	```@Deprecated```:
	-	API 过时注解
	-	用于标注方法已过时
-	```@Override```：
	-	重写父类方法
	-	用于多态


## II. 注解的应用

注解就相当于一个你的源程序中要调用的一个类，要在源程序中应用某个注解，得先准备好了这个注解类。

### 1. 注解的应用结构

-	注解类 A：

```java
@interface A{

}
```

-	应用了 “注解类” 的类 B

```java
@A
Class B{

}
```

-	对应用了注解类的类 B 进行反射操作的类

```java
Class C {
	B.class.isAnnotationPresent(A.class);
	A a = B.class.getAnnotation(A.class);
}
```

### 2.自定义注解

按照上面讲的结构，我们来自定义注解，先创建一个注解类 ```MyAnnotation```

```java
package org.lovian.annotation;

public @interface MyAnnotation {

}
```

然后创建一个测试类 ```MyAnnotationTest```， 把我们自定义的注解加到这个测试类上

```java
package org.lovian.annotation;

@MyAnnotation
public class MyAnnotationTest {

	public static void main(String[] args) throws Exception{
		// 如果当前类存在注解
		if(MyAnnotationTest.class.isAnnotationPresent(MyAnnotation.class)){
			// 通过反射来得到当前类的注解对象
			MyAnnotation annotation =(MyAnnotation) MyAnnotationTest.class.getAnnotation(MyAnnotation.class);
			System.out.println(annotation);
		}else{
			System.out.println("No annotation");
		}
	}
}
```

运行结果：

```
No annotation
```

结果我们发现，我们并没有得到这个注解对象，说明，当前类是不存在这个注解的，但是我们的确在这个类上加了```@MyAnnotation```了啊，这是为什么？

原因是，我们需要给我们自定义的注解类加入 ```元注解```：

```java
package org.lovian.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

// 元注解（注解的注解）
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {

}
```

再运行：

```
@org.lovian.annotation.MyAnnotation()
```

这说明了测试类存在了我们自定义的注解对象了，这就要引入注解的生命周期了

### 3. 元注解和注解的生命周期

从上面的例子，我们需要给自定义的注解类加入元注解 ```@Retention```, 它有三种取值，分别对应了注解的不同的生命周期

-	```RetentionPolicy.Source```:
	-	注解的生命周期只存在于源代码文件
-	```RetentionPolicy.Class```:
	-	注解的生命周期持续到编译后的Java Class 文件
-	```RetentionPolicy.RUNTIME```:
	-	注意的生命周期持续到内存当中的字节码，即 runtime 阶段

这里要注意：

-	当我们使用 ```javac``` 编译 Java 源文件之后得到 class 文件，实际上，并不是字节码，只有在 class 文件被加载到 JVM 的内存当中，执行了一些操作，才是字节码
-	如果不声明元注解，那么默认的生命周期是处于 class 文件阶段。
-	```@Override``` 和 ```@SuppressWarnings``` 这两个注解是给编译器在编译代码时使用的，所以生命周期只存在于源代码阶段
-	```@Deprecated``` 则是先把类加载到内存后，编译器再检查方法是否过期，所以生命周期是 runtime 阶段


### 4. Target 注解

```@Target``` 注解用于标注自定义的注解应该标注在哪里， 是标注在包上，类上，字段上，还是方法上。Target 说明了Annotation所修饰的对象范围：Annotation可被用于 packages、types（类、接口、枚举、Annotation类型）、类型成员（方法、构造方法、成员变量、枚举值）、方法参数和本地变量（如循环变量、catch参数）。在Annotation类型的声明中使用了target可更加明晰其修饰的目标

改进一下我们自定义的注解类：

```java
package org.lovian.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

// 元注解（注解的注解）
@Retention(RetentionPolicy.RUNTIME)
// 目标注解，此自定义注解应该标注在方法上
@Target(ElementType.METHOD)
public @interface MyAnnotation {

}
```

然后我们发现，如果再把这个注解加在类上，则编译器会报错。 可以从 ```ElementType```  得到所有的取值，也可以将 ```@Target``` 注解的值定义为类型（比如接口名 Type），从而 ```Type``` 所有的实现类都可以使用此注解


## III. 为注解增加参数

### 1. 注解的参数

使用@interface自定义注解时，自动继承了```java.lang.annotation.Annotation``` 接口，由编译程序自动完成其他细节。在定义注解时，不能继承其他的注解或接口。

```@interface``` 用来声明一个注解，其中的每一个方法实际上是声明了一个```配置参数``` （也叫 属性）。方法的名称就是参数的名称，返回值类型就是参数的类型（返回值类型只能是基本类型、Class、String、enum）。可以通过default来声明参数的默认值

### 2. 注解参数的可支持数据类型：

-	所有基本数据类型（int,float,boolean,byte,double,char,long,short)
-	String类型
-	Class类型
-	enum类型
-	Annotation类型
-	以上所有类型的数组

### 3. 设定参数

Annotation类型里面的参数该怎么设定:

-	只能用 public 或默认(default)这两个访问权修饰
	-	例如,String value();这里把方法设为defaul默认类型；　 　
-	参数成员只能用基本类型byte,short,char,int,long,float,double,boolean八种基本数据类型和 String,Enum,Class,annotations等数据类型,以及这一些类型的数组
	-	例如,String value();这里的参数成员就为String;　　
-	如果只有一个参数成员,最好把参数名称设为"value",后加小括号

### 4. 注解参数的实例

在我们自定义的注解类中，添加一个颜色属性

```java
package org.lovian.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

// 元注解（注解的注解）
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface MyAnnotation {
	String color();
}
```

然后在测试类的注解中，声明参数的值

```java
package org.lovian.annotation;

// 声明注解中属性的值
@MyAnnotation(color = "red")
public class MyAnnotationTest {

	public static void main(String[] args) throws Exception{
		if(MyAnnotationTest.class.isAnnotationPresent(MyAnnotation.class)){
			// 通过反射来得到当前类的注解对象
			MyAnnotation annotation =(MyAnnotation) MyAnnotationTest.class.getAnnotation(MyAnnotation.class);
			System.out.println(annotation);
			System.out.println(annotation.color());
		}else{
			System.out.println("No annotation");
		}
	}
}
```

运行结果：

```
@org.lovian.annotation.MyAnnotation(color=red)
red
```


这里要注意：

-	有一个特殊属性 ```String value();```
	-	如果，一个自定义的注解里，只有这个属性，那么，在使用的时候，注解后面的括号可以简写
	-	比如 ```@SuppressWarnings("deprecation")```, 实际上就是一个 value 属性
-	可以用 default 为属性添加默认值
	-	比如 ```String color() default "red";```
-	注解的返回值，可以是基本类型，数组，枚举，或者是注解
