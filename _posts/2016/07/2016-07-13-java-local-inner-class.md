---
layout: post
title:  "[JAVA] 为什么局部内部类访问外部类的局部变量必须是final类型的"
date:   2016-07-13
desc: "why local inner class access final local varaible in Java"
keywords: "java, anonymous inner class"
categories: [java]
---

# Java 中为什么局部内部类访问的局部变量必须是final类型的

## I.局部内部类

局部内部类是内部类的一种，不同于内部类定义在类的成员位置，局部内部类定义在类的成员方法里。

## II.代码示例

我们让局部内部类中的方法去访问外部类的成员变量和外部类的局部变量，代码如下

```java
package org.lovian.innerclass;

/**
 * Local Inner Class
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class LocalOuter {
	private int num = 10; //外部类成员变量

	public void show(){

		int num2 = 200; //外部类局部变量
		class Inner{
			public void show(){
				System.out.println(num);
				System.out.println(num2);
			}
		}

		Inner i = new Inner();
		i.show();
	}
}

package org.lovian.innerclass;

/**
 * Local Inner Class Test
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class LocalOuterTest {
	public static void main(String[] args) {
		LocalOuter locOut = new LocalOuter();
		locOut.show();
	}
}

```

然后我们看结果

```
10
200
```

我们可以看见这里，是有结果的（Oracle JDK 8 编译）。但是，通过jad反编译后，我们可以发现局部变量 ```num2``` 是被 ```final``` 修饰的！
笔者猜测可能在 Oracle JDK8 中， 编译器会自动把 ```num2``` 编译成 final 类型，那我们来测试一下：

```java
package org.lovian.innerclass;

/**
 * Local Inner Class
 *
 * @author PENG Zhengshuai
 * @lovian.org
 *
 */
public class LocalOuter {
	private int num = 10;

	public void show(){

		int num2 = 200;
		class Inner{
			public void show(){
				System.out.println(num);
				System.out.println(num2); // local variable must be final
			}
		}

		Inner i = new Inner();
		i.show();

		num2= 20; // 修改num2的值
	}
}

```

我们知道，如果一个变量被 ```final``` 所修饰，那么，这个变量就是一个常量，不可被修改，所以看运行结果

```
Exception in thread "main" java.lang.Error: Unresolved compilation problem:
	Local variable num2 defined in an enclosing scope must be final or effectively final

	at org.lovian.innerclass.LocalOuter$1Inner.show(LocalOuter.java:19)
	at org.lovian.innerclass.LocalOuter.show(LocalOuter.java:24)
	at org.lovian.innerclass.LocalOuterTest.main(LocalOuterTest.java:13)

```

结果说明，我们的猜测是正确的。那么为什么这里 ```num2``` 必须是 ```final``` 类型呢？

## III.局部内部类访问的局部变量为什么必须是 final 修饰的？

原因是，局部变量是随着方法的调用而在栈（stack）内存中生成，方法执行完毕，局部变量会从栈内存中消失。而类的对象是在堆内存（heap）中，堆内存中的内容是被 JVM 的 GC 管理的，一般来说不会立即被回收，所以局部变量被局部内部类所访问的时候，必须定义成常量， 即被 ```final``` 修饰，否则就会出错。
