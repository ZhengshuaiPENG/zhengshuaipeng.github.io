---
layout: post
title:  "[JAVA] Java 中的多线程编程一"
date:   2016-08-01
desc: "how to use thread in Java"
keywords: "java, thread"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中多线程编程一

## I. 单线程程序和多线程程序的引入

如图，我们先来看单线程程序的代码执行顺序：

![single-thread]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/single-thread-seq.png)

可以看得出来，代码的执行顺序是一条线从头开始执行直到结束，只有一条执行路径，该程序是单线程程序，那么如果在代码的执行过程中，从一个方法A转向执行另一个方法B的时候，A方法不停止，和B方法一起继续执行，那么这个程序就是多线程程序，如下图：

![multi-thread]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/multi-thread-seq.png)



## II. 进程线程相关概念

### 1. 线程和进程

线程依赖于进程而存在

-	进程： Process
	-	就是正在运行的程序，是系统进行资源分配和调用的独立单位
	-	进程是一个程序在内存中的运行实例
	-	每一个进程都有它自己的内存空间和系统资源

多进程有什么意义？

单进程计算机同时只能做一件事情，而多线程进程可以同时做多件事情，所以多线程能够在一段时间内，执行多个任务，提高cpu的使用效率。然而这并不是说，同一个时间点上，cpu 可以同时处理两个任务，而是在操作系统的资源管理与分配下，cpu 在程序间进行着高效率的切换，所以，在一段时间内，cpu 可以处理多任务。


-	线程： Thread
	-	在一个进程内执行多个任务，而这每一个任务就是一个线程
	-	线程是程序的执行单元，是进程中的单个顺序控制流，也叫一条执行路径
	-	是程序使用 cpu 的最基本单位
	-	单线程：程序只有一条执行路径
	-	多线程：程序有多条执行路径


多线程有什么意义？

多线程的存在，不是为了提高程序的执行速度，其实是为了提高程序的使用率。程序的执行其实都是在抢 cpu 的资源，即 cpu 的执行权。多个进程在抢 cpu 的资源，那么如果某一个进程如果执行路径更多，那么就有更高的几率抢到 cpu 的执行权。然而我们并不能保证某一个线程能够在某个时刻拿到 cpu 的资源，所以，线程的执行有随机性

### 2. 并发和并行

并行指物理上同时执行，并发指能够让多个任务在逻辑上交织执行的程序设计

-	并发：Concurrency
	-	逻辑上发生，指在某一个时间内同时运行多个程序
	-	并发指能够让多个任务在逻辑上交织执行的程序设计
	-	指的是程序的结构，即这个程序支持并发的设计
	-	正确的并发设计的标准是：使多个操作可以在重叠的时间段内进行
	-	并不一定是同时执行，单核单线程能支持并发

![concurrency]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/concurrency.png)

-	并行：Parallesim
	-	物理上发生，指某一个时间点同时运行多个程序
	-	判断程序是否处于并行的状态，就看同一时刻是否有超过一个“工作单位”在运行
	-	单线程永远无法达到并行状态
	-	要达到并行状态，最简单的就是利用多线程和多进程

举个例子（摘自知乎 龚昱阳 Dozer 的回答）

>你吃饭吃到一半，电话来了，你一直到吃完了以后才去接，这就说明你不支持并发也不支持并行。
>你吃饭吃到一半，电话来了，你停了下来接了电话，接完后继续吃饭，这说明你支持并发。
>你吃饭吃到一半，电话来了，你一边打电话一边吃饭，这说明你支持并行。

>并发的关键是你有处理多个任务的能力，不一定要同时。
>并行的关键是你有同时处理多个任务的能力。

>作者：龚昱阳 Dozer
>链接：https://www.zhihu.com/question/33515481/answer/58849148
>来源：知乎
>著作权归作者所有，转载请联系作者获得授权。

### 3. Java 程序的运行原理

Java 命令会启动 Java 虚拟机。启动 JVM， 等于启动了一个应用程序，也就是启动了一个进程。该进程会自动启动一个 “主线程” ， 然后该主线程去调用某个类的 main 方法。所以， main 方法运行在主线程中。在此之前，所有的程序都是单线程的。

而 JVM 启动主线程的同时，至少启动了垃圾回收，所以 JVM 的启动是多线程的


## III. Java 实现多线程

### 1.如果实现多线程的程序

根据了上面那些概念，我们知道多线程其实就是有多个执行路径的进程实例。那么如何实现多线程的程序呢？

由于线程是依赖进程而存在的，那么首先应该创建一个进程，而进程是由系统创建的，所以我们应该去调用系统功能创建一个进程，Java 是不能直接调用系统功能的，所以我们没有办法直接实现多线程程序。但是 Java 可以调用 C/C++ 程序来实现多线程程序，由 C/C++ 程序去调用系统功能创建进程，然后由 Java 去调用这个 C/C++ 程序，然后提供一些类供我们使用，我们就可以实现多线程程序了。

其实就是 C/C++ 程序在底层进行实现，然后 Java 把这个实现封装成类，供我们调用，这个类就是 ```java.lang.Thread```

### 2. Thread 类

java.lang.Thread， 实现接口 Runable：

JDK 中对这个类的描述：

>线程 是程序中的执行线程。Java 虚拟机允许应用程序并发地运行多个执行线程。
>每个线程都有一个优先级，高优先级线程的执行优先于低优先级线程。每个线程都可以或不可以标记为一个守护程序。当某个线程中运行的代码创建一个新 Thread 对象时，该新线程的初始优先级被设定为创建线程的优先级，并且当且仅当创建线程是守护线程时，新线程才是守护程序。

>当 Java 虚拟机启动时，通常都会有单个非守护线程（它通常会调用某个指定类的 main 方法）。Java 虚拟机会继续执行线程，直到下列任一情况出现时为止：

>1.调用了 Runtime 类的 exit 方法，并且安全管理器允许退出操作发生。

>2.非守护线程的所有线程都已停止运行，无论是通过从对 run 方法的调用中返回，还是通过抛出一个传播到 run 方法之外的异常。

### 3. 实现多线程程序

JDK 提供了两种创建新执行线程的方法

#### 方法一

-	自定义继承 Thread 的子类
-	在子类中重写 run() 方法
-	创建子类的实例对象
-	启动线程

为什么要在子类中重写 run() 方法？

因为不是类中的所有方法都需要被线程执行的，而这个时候，为了区分哪些代码能够被线程执行， java 提供了 Thread 类中的 run() 用来包含那些被线程执行的代码。换句话说，线程只需要执行 run() 方法内的代码。


#### 方法二

#### 方法一实现实例

来看下列代码：

```java
package org.lovian.thread;

public class MyThread extends Thread {
	// 子类继承 Thread 类并重写 run 方法
	@Override
	public void run() {
		for(int x = 0; x < 50; x++){
			System.out.print(x + " ");
		}
		System.out.println();
	}
}


package org.lovian.thread;

public class MyThreadTest {
	public static void main(String[] args) {
		// 创建线程子类对象
		MyThread myThread = new MyThread();
		// 调用 run 方法
		myThread.run();
		myThread.run();
	}
}

```

result:

```
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
```

这里我们看到执行 run 方法，我们得到的是单线程的结果，为什么呢？ 因为 run 方法直接调用其实就相当于普通的方法调用，所以结果是单线程的。

要想看到多线程的效果，就必须使用 ```start()``` 方法：

-	```public void start()``` ：使该线程开始执行；Java 虚拟机调用该线程的 run 方法

结果是两个线程并发地运行；当前线程（从调用返回给 start 方法）和另一个线程（执行其 run 方法）。```多次启动一个线程是非法的```。特别是当线程已经结束执行后，不能再重新启动。


注意： start() 和 run() 的区别

-	run(): 仅仅是封装被线程执行的代码，直接调用就是普通方法
-	start(): 首先启动了线程，然后由 jvm 去调用该线程的 run() 方法


那么我们修改代码，调用两次 start 方法来看结果：

```java
package org.lovian.thread;

public class MyThreadTest {
	public static void main(String[] args) {
		// 创建线程子类对象
		MyThread myThread = new MyThread();
		// 调用 start 方法
		myThread.start();
		myThread.start();
	}
}
```

result:

```
Exception in thread "main" 0 1 2 3 4 5 6 7 java.lang.IllegalThreadStateException8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
30 31 32 33 34 	at java.lang.Thread.start(Thread.java:705)
35 36 	at org.lovian.thread.MyThreadTest.main(MyThreadTest.java:9)37
38 39 40 41 42 43 44 45 46 47 48 49
```

这里我们发现抛出了 ```IllegalThreadStateException``` 异常，这是非法的线程状态异常，为什么呢？
因为这里是 myThread 线程被调用了两次，而不是两个线程同时启动，而多次启动一个线程是非法的。所以正确代码应该如下所示：

```java
package org.lovian.thread;

public class MyThreadTest {
	public static void main(String[] args) {
		// 创建线程子类对象
		MyThread myThread = new MyThread();
		MyThread myThread2 = new MyThread();
		// 调用 start 方法
		myThread.start();	// 线程1 启动
		myThread2.start();	// 线程2 启动
	}
}
```

result：

```
0 0 1 1 2 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 3 31 4 32 5 6 7 8 33 9 34 10 35 11 36 12 37 13 38 14 39 15 40 16 41 42 17 18 19 20 21 22 23 43 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49
44 45 46 47 48 49
```

这里我们可以看出两个线程是交替执行的，这里是并发执行！同一段时间内，两个线程交替执行。

### 4. 设置和获取线程名称

根据上述代码执行结果，问题又来了，我们并不知道先后执行的是哪个线程，那么我们就需要 ``` getName()``` 方法去获取线程的名称：

-	```public final String getName()``` : 获取线程的名称

所以我们修改以下 run() 内的代码：

```java
package org.lovian.thread;

public class MyThread extends Thread {
	@Override
	public void run() {
		for(int x = 0; x < 50; x++){
			System.out.println(getName() + ": "+ x + " ");
		}
	}
}
```

result:

```
Thread-0: 0
Thread-0: 1
Thread-1: 0
Thread-0: 2
Thread-1: 1
Thread-0: 3
Thread-1: 2
Thread-0: 4
。。。
```

这里调用的 ```getName()``` 方法返回的是 Thread 类自定义的线程名称（参考 JDK 源码）， 我们也可以自定义线程的名称，通过 ```setName()``` 方法：

-	```public final void setName(String name)``` ：改变线程名称，使之与参数 name 相同。 首先调用线程的 checkAccess 方法，且不带任何参数。这可能抛出 SecurityException。

修改一下 Test 方法：

```java
package org.lovian.thread;

public class MyThreadTest {
	public static void main(String[] args) {
		// 创建线程子类对象
		MyThread myThread = new MyThread();
		MyThread myThread2 = new MyThread();

		// 设置线程名称
		myThread.setName("许嵩");
		myThread2.setName("黄龄");

		// 调用 start 方法
		myThread.start();
		myThread2.start();
	}
}
```

result:

```
黄龄: 0
黄龄: 1
黄龄: 2
许嵩: 0
黄龄: 3
许嵩: 1
许嵩: 2
...
```

当然我们也可以通过带参构造器来给线程起名字，注意这里需要重写构造参数

```java
package org.lovian.thread;

public class MyThread extends Thread {

	public MyThread() {
		super();
	}

	public MyThread(String name) {
		super(name);
	}

	@Override
	public void run() {
		for(int x = 0; x < 50; x++){
			System.out.println(getName() + ": "+ x + " ");
		}
	}
}

package org.lovian.thread;

public class MyThreadTest {
	public static void main(String[] args) {
		// 创建线程子类对象
		MyThread myThread = new MyThread("许嵩");
		MyThread myThread2 = new MyThread("黄龄");

		// 获取 main 线程的名称
		System.out.println("main 线程名称： " + Thread.currentThread().getName());

		// 调用 start 方法
		myThread.start();
		myThread2.start();
	}
}
```

result：

```
main 线程名称： main
许嵩: 0
许嵩: 1
黄龄: 0
许嵩: 2
黄龄: 1
...
```

### 5. 线程的调度

假如我们的计算机只有一个 CPU， 那么 CPU 在某一个时刻只能执行一条指令，线程只有得到 CPU 时间片，也就是使用权，才可以执行指令，那么 Java 是如何对线程进行调用的呢？

-	线程调度的两种模型：
	-	```分时调度模型```：所有线程轮流使用 CPU 的使用权，平均分配每个线程占用 CPU 的时间片
	-	```抢占式调度模型```：优先让优先级高的线程使用 CPU， 如果线程的优先级相同，那么随机选择一个，优先级高的线程获取 CPU 时间片会多一点

Java 中使用的是抢占式调度模型，所以就需要设置和获取 java的优先级， 通过 ```getPriority()``` 和 ``` setPriority()``` 方法

```java
package org.lovian.threadpriority;

public class ThreadPriority extends Thread {

	@Override
	public void run() {
		for (int x = 0; x < 50; x++) {
			System.out.println(getName() + ": " + x);
		}
	}
}

package org.lovian.threadpriority;

public class ThreadPriorityDemo {
	public static void main(String[] args) {
		ThreadPriority tp1 = new ThreadPriority();
		ThreadPriority tp2 = new ThreadPriority();
		ThreadPriority tp3 = new ThreadPriority();

		tp1.setName("张无忌");
		tp2.setName("赵敏");
		tp3.setName("周芷若");

		// 获取线程默认优先级
		System.out.println(tp1.getPriority());
		System.out.println(tp2.getPriority());
		System.out.println(tp3.getPriority());

		// 设置线程默认优先级 1-10，默认5
		tp1.setPriority(Thread.NORM_PRIORITY); // 最高优先级：10
		tp2.setPriority(Thread.MAX_PRIORITY);  // 默认优先级：5
		tp3.setPriority(Thread.MIN_PRIORITY);  // 最小优先级1

		tp1.start();
		tp2.start();
		tp3.start();
	}
}
```

result：

```
5
5
5
张无忌: 0
张无忌: 1
张无忌: 2
张无忌: 3
张无忌: 4
赵敏: 0
张无忌: 5
张无忌: 6
赵敏: 1
赵敏: 2
赵敏: 3
周芷若: 0
赵敏: 4
...
```

注意：

-	线程默认优先级是 5
-	线程优先级的范围是 1-10
-	线程优先级高仅仅表示线程获取的 CPU 时间片的几率高，但是要在次数比较多，或者多次运行的时候才能看到比较好的效果（因为存在随机性）

### 6. 线程控制
