---
layout: post
title:  "[JAVA] Java 中的异常 Exception"
date:   2016-07-24
desc: "how to use exception in Java"
keywords: "java, exception"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Exception in Java

## I. 异常的由来

异常， Exception, 就是程序出现了不正常的情况。程序的异常，有下面几种

-	程序的异常： java.lang.Throwable： 是所有异常类的父类
	-	错误：严重问题，Error
	-	异常：问题， Exception
		-	编译期的问题： 非 RuntimeException 的异常
		-	运行期的问题： RuntimeException 异常

图示如下：

![exceptionimg]( https://zhengshuaipeng.github.io/static/img/blog/2016/07/exception.png)

## II. 错误，Error

java.lang.Error：

-	Error 是 Throwable 的子类，用于指示合理的应用程序不应该试图捕获的严重问题
-	Error异常我们一般不处理，这种问题一般都是很严重的，比如说 内存溢出

## III. 运行期异常，RuntimeException

java.lang.RuntimeException：

-	所有的 RuntimeException 类及其子类的实例被称为运行时的异常，其它异常就是编译时异常
-	RuntimeException 是那些可能在 Java 虚拟机正常运行期间抛出的异常的超类
-	可能在执行方法期间抛出但未被捕获的 RuntimeException 的任何子类都无需在 throws 子句中进行声明
-	RuntimeException 这种问题我们可以不处理，因为这个异常的出现是因为代码不严谨，需要进行修正代码
-	当然也可以显式的处理 RuntimeException

## IV. 编译期异常

不是 RuntimeException 的异常，必须要显式的进行处理，否则，编译不通过


## V. 异常的处理

### 1. 默认处理

如果程序出现了问题，我们没有做任何处理，那么 JVM 会作出默认处理：

-	默认处理： 把异常的名称，原因以及出现的问题等信息输出在控制台，同时会结束程序的执行

```java
package org.lovian.exception;

public class ExceptionDemo {
	public static void main(String[] args) {
		int a = 10;
		int b = 0;

		System.out.println("a/b = " + a/b);
	}
}
```

result：

```
Exception in thread "main" java.lang.ArithmeticException: / by zero
	at org.lovian.exception.ExceptionDemo.main(ExceptionDemo.java:8)
```

在这个例子中，我们没有对异常没有做任何的处理，从而 JVM 会给出异常的信息，同时结束程序

### 2. 异常的处理方案

#### A. try...catch...finally

我们可以用 try/catch 去处理异常，当异常发生的时候，我们可以通过代码来处理这个异常

##### 处理一个异常

-	格式

```
try {
	可能出现问题的代码;
}catch(异常名 异常变量){
	针对问题的处理;
}finally {
	释放资源;
}
```

-	变形格式

```
try {
	可能出现问题的代码;
}catch(异常名 异常变量){
	针对问题的处理;
}
```

-	注意：
	-	try 中的代码越少越好
	-	catch 中必须有内容，哪怕是给处一个异常提示，否则异常就会被隐藏


我们用 try catch 来处理上面那个异常

```java
package org.lovian.exception;

public class ExceptionDemo {
	public static void main(String[] args) {
		int a = 10;
		int b = 0;

		try{
			System.out.println("a/b = " + a/b);
		}catch (ArithmeticException e) {
			// TODO: handle exception
			System.out.println("b can't be 0");
			e.printStackTrace();
		}
	}
}
```

result：

```
b can't be 0
java.lang.ArithmeticException: / by zero
	at org.lovian.exception.ExceptionDemo.main(ExceptionDemo.java:9)
```

可以看见异常被处理了，打印了不能为0的信息

##### 处理多个异常

我们可以用 try/catch 来一个一个处理异常，比如下面的代码，就处理了运算异常和数组越界异常：

```java
package org.lovian.exception;

public class ExceptionDemo2 {
	public static void main(String[] args) {
		multiException();
	}

	public static void multiException(){
		int a = 10;
		int b = 0;

		try{
			System.out.println(a/b);
		}catch (ArithmeticException e) {
			System.out.println("b can not be 0"); // 这是一个运行期异常
		}

		int[] arr = {1, 2, 3};
		try{
			System.out.println(arr[3]);	// 这是一个运行期异常
		}catch (ArrayIndexOutOfBoundsException e) {
			System.out.println("access index out of array bounds");
		}
	}
}
```

result：

```
b can not be 0
access index out of array bounds
```

但是，每一次都要去一个一个捕获每一个异常，是非常麻烦的，所以 java 允许用 try/catch 去一次性捕获多个异常，格式如下：

-	try/catch 处理多个异常格式

```
try {
	可能出现问题的代码;
}catch(异常名 异常变量){
	针对问题的处理;
}catch(异常名 异常变量){
	针对问题的处理;
}
	...
finally {
	释放资源;
}
```

代码如下：

```java
package org.lovian.exception;

public class ExceptionDemo2 {
	public static void main(String[] args) {
		multiException();
	}

	public static void multiException(){
		int a = 10;
		int b = 0;
		int[] arr = {1, 2, 3};

		try{
			System.out.println(a/b);
			System.out.println(arr[3]);
		}catch (ArithmeticException e) {
			System.out.println("b can not be 0");
		}catch(ArrayIndexOutOfBoundsException e){
			System.out.println("access index out of array bounds");
		}catch(Exception e){
			System.out.println("error");
		}

		System.out.println("over");
	}
}
```

result：

```
b can not be 0
over
```

-	注意：
	-	通过代码我们可以发现，一旦 try 语句块中的代码被捕获异常，那么程序就会转向执行相应的 catch 语句块， 原先 try 中的代码不会被继续执行,转而执行 try/catch 语句块之外的代码
	-	有时候我们可能不知道什么地方会出什么样的异常，所以在代码最后，可以用 catch 来捕获 Exception。 当 try 语句块中发生异常之后，如果 jvm 没有在 catch 语句块中找到对应的异常，那么它就会匹配 Exception 来处理
	-	能够明确的异常就尽量明确
	-	平级的异常谁先谁后无所谓，但如果出现了子父关系，那么，子异常必须在父异常的前面


-	另一种格式（JDK7 新特性）

JDK7 之后提出一个新特性可以在一个 catch 块中捕获多个异常。但是这个方式虽然简洁，但是也有缺陷，多个异常使用一个方式来处理，所以这些异常类型应该是统一类型的问题; 另外在一个 catch 中只能捕获平级的异常，不能出现子父类异常同时出现在一个 catch 中

```java
public static void multiException(){
	int a = 10;
	int b = 0;
	int[] arr = {1, 2, 3};

	try{
		System.out.println(a/b);
		System.out.println(arr[3]);
	}catch (ArithmeticException | ArrayIndexOutOfBoundsException  e) {
		System.out.println("error");
	}catch(Exception e){
			System.out.println("error");
	}
}
```

##### try/catch 匹配异常

通过上面的例子，我们发现 JVM 捕获异常，然后处理异常。其实是在 try 语句块中发现问题后， JVM 会生成一个异常对象，然后把这个对象抛出，和 catch 中的类进行匹配。 如果该对象是某个类型的，就会执行该 catch 里面的处理信息。

异常中要了解的几个方法，方法定义在所有异常的父类 Trowable 中：

-	```public String getMessage()``` : 异常的消息字符串
-	```public String toString()``` : 返回异常的简单信息描述
	-	此对象的类的 name （全路径名）
	-	": " (冒号和一个空格)
	-	调用此对象 getLocalizedMessage() 方法的结果
-	```public String getLocalizedMessage()``` : 默认返回与 getMessage() 相同的结果， 子类可以重写此方法用于生成特定的信息
-	```public void printStackTrace()``` : 获取异常类名和异常信息，以及异常出现在程序中的位置，返回值 void，把信息输出在控制台
	-	注意，使用这个方法不会终止程序，还会继续执行 try/catch 语句块之外的代码
-	```public void printStackTrace(PrintStream s)``` : 通常使用该方法将异常内容保存在日志文件中

#### B. throws

定义功能方法时，需要把出现的问题暴露出来让调用者去处理，那么就通过 throws 在方法上进行标识， 示例代码如下：

```java
package org.lovian.exception;

import java.text.ParseException;
import java.text.SimpleDateFormat;

public class ExceptionDemo3 {
	public static void main(String[] args) {
		System.out.println("begin");
		try {
			method();
		} catch (ParseException e) {
			// handle exception
			e.printStackTrace();
		}
		System.out.println("end");
	}

	private static void method() throws ParseException{
		String s = "2016-07-25";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 这是一个编译期异常， 必须要处理，要么 throws 要么 try/catch
		Date d = sdf.parse(s);  // throw exception
		System.out.println(d);
	}
}
```

为什么要用这种方式呢？ 原因是因为，有些时候，我们可以直接处理异常，但是有些时候，我们根本没有权限去处理某个异常，通俗点说，我处理不了，就不处理了，把这个异常交给调用该方法的人去处理。 所以 Java 针对这种情况，提供了 throws 处理方法。

throws 处理是将异常名抛出到方法声明上，是为了告诉调用者，你需要处理这个异常或这把它抛出去。

注意：
-	尽量不要在顶层方法（比如 main 方法） 中将异常抛出。
-	运行期异常抛出，调用者可以不进行处理
-	编译期异常进行抛出，调用者必须要处理
-	throws 后可以跟多个异常名


## VI. throw 关键字

### 1. throw

在功能方法中内部出现某种情况，程序不能继续运行，需要进行跳转时，就用 ```throw``` 把异常对象抛出，代码实例如下：

-	运行期异常

```java
package org.lovian.exception;

public class ThrowDemo {
	public static void main(String[] args) {
		method();
	}

	public static void method(){
		int a = 10;
		int b = 0;

		if(b == 0){
			throw new ArithmeticException("b can't be 0"); // 抛出的其实是异常的对象
		}else{
			System.out.println(a/b);
		}
	}
}
```

result：

```
Exception in thread "main" java.lang.ArithmeticException: b can't be 0
	at org.lovian.exception.ThrowDemo.method(ThrowDemo.java:13)
	at org.lovian.exception.ThrowDemo.main(ThrowDemo.java:5)
```

-	throw Exception 异常

```java
package org.lovian.exception;

public class ThrowDemo {
	public static void main(String[] args) {
		try {
			method();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void method() throws Exception{
		int a = 10;
		int b = 0;

		if(b == 0){
			throw new Exception(); // 抛出 Exception 则必须要处理， Exception 可能是编译期异常
		}else{
			System.out.println(a/b);
		}
	}
}
```

result：

```
java.lang.Exception: b can't be 0
	at org.lovian.exception.ThrowDemo.method(ThrowDemo.java:18)
	at org.lovian.exception.ThrowDemo.main(ThrowDemo.java:6)
```

### 2. throws 和 throw 的区别

-	throws:
	-	用在方法声明后， 跟的是异常类名
	-	可以跟多个异常类名，用逗号隔开
	-	表示抛出异常，由该方法的调用者来处理
	-	throws 表示出现异常的一种可能性，并不一定会发生这些异常
-	throw：
	-	用在方法体内，跟的是异常对象
	-	只能抛出一个异常对象
	-	表示抛出异常，由方法体内的语句处理
	-	throw是抛出了异常，执行throw则一定抛出了某种异常


## VII. 怎样处理异常

-	原则：
	-	如果该功能内部可以将问题处理，用 try/catch, 如果处理不了，交由调用者处理，用 throws
-	区别：
	-	后续程序需要运行就用 try/catch
	-	后续程序不需要继续运行就用 throws
	-	顶层调用方法一般用 try/catch 来处理


## VIII. finally的特点与作用

finally：是 try...catch...finally 的一部分，参与处理异常

-	finally的特点：
	-	被 finally 控制的语句体一定会执行
	-	特殊情况： 在执行到 finally 之前 jvm 退出了（比如 System.exit(0))
-	finally的作用：
	-	用于释放资源，在 IO 操作和数据库操作中会见到
-	特殊情况：
	-	单独使用 try...finally, 不处理异常，目的是为了释放资源

问题：

-	如果 catch 语句块中有 return 语句， 那么 finally 的代码还会执行吗？ 如果会，请问是在 return 前还是在 return 后？
	-	会执行，在 return 之前
	-	准确的说，应该是在 return 中

```java
package org.lovian.exception;

public class FinallyDemo {
	public static void main(String[] args) {
		System.out.println(getInt());
	}

	public static int getInt(){
		int a = 10;
		try{
			System.out.println(a/0);
			a = 20;
		} catch(ArithmeticException e){
			a = 30;
			return a;
		} finally {
			a = 40;
		}
		return a;
	}
}
```

result：

```
30
```

为什么明明 finally 中的语句块在 catch 中的 ```return a;``` 语句执行之前已经执行 ```a = 40;``` 了，为什么这里结果是 30？
因为在 catch 语句中，```return a;``` 在执行到这一步的时候，这里不是 return a， 而是 ``` return 30;``` 这个返回路径就形成了，但是它又发现 catch 语句块后，还有 finally 语句块，所以就继续执行 finally 的内容，就是 ``` a = 40```, 再次回到以前的返回路径，再此走return 30


## IX. 自定义异常

有些时候，在工程上，我们需要定义自己的异常类，用来描述项目中的异常类型，而 Java 不可能提供所有的情况，所以这时候，我们需要自己定义异常：

-	继承 Exception 类
-	继承 RuntimeException 类

而自定义异常 ``` MyException``` 时，一般可以不添加任何东西，完全继承于父类的构造方法和成员方法，当然也可以重写这些方法，在使用的时候，可以通过条件判断语句来 ```throw new MyException()```

示例代码如下：

```java
package org.lovian.exception;

public class MyException extends Exception{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public MyException() {
		super();
	}

	public MyException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public MyException(String message, Throwable cause) {
		super(message, cause);
	}

	public MyException(String message) {
		super(message);
	}

	public MyException(Throwable cause) {
		super(cause);
	}
}
```

## X. 异常注意事项

-	子类覆写父类方法时，子类的方法必须抛出相同的异常或父类异常的子类
-	如果父类抛出了多个异常，子类覆写父类时，只能抛出相同的异常或者是它的子集，子类不能抛出父类没有的异常
-	如果被覆写的方法没有异常的抛出，那么子类的方法绝对不可以抛出异常;如果子类方法内有异常发生，那么子类只能 try/catch , 不能 throws
