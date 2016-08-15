---
layout: post
title:  "[JAVA] Java 中的多线程编程（三） 线程池，匿名线程，定时器"
date:   2016-08-10
desc: "how to use thread pool in Java"
keywords: "java, thread， thread pool， timer"
categories: [Java]
tags: [Java， Thread]
icon: fa-keyboard-o
---

# Java 中多线程编程（三）： 线程池，匿名线程， 定时器

## I. 线程池

### 1. 什么是线程池

因为程序启动一个新线程的成本是比较高的，因为它要涉及到要与操作系统进行交互，而使用```线程池``` 则可以很好的提供性能，尤其是，当程序中要创建大量生存期很短的线程时，更应该考虑使用线程池。

-	线程池中的每一个线程代码结束后，并不会死亡，而是再次回到线程池中成为空闲状态，等待下一个对象来使用
-	在 JDK5 之前，我们必须实现自己的线程池，从 JDK5 之后， Java 内置支持了线程池

### 2. 创建线程池

JDK5 增加了一个 ```java.util.concurrent.Executors``` 工厂类来产生线程池，有如下方法：

-	```public static ExecutorService newCachedThreadPool()``` : 创建一个可根据需要创建新线程的线程池，但是在以前构造的线程可用时将重用它们
-	```public static ExecutorService newFixedThreadPool(int nThreads)``` : 创建一个可重用固定线程数的线程池，以共享的无界队列方式来运行这些线程
-	```public static ExecutorService newSingleThreadExecutor()``` : 创建一个使用单个 worker 线程的 Executor，以无界队列方式来运行该线程

这些方法的返回值，是一个 ```ExecutorService``` 对象， 该对象表示一个线程池，可以执行 ```Runnable``` 或者 ```Callable```对象代表的线程

### 3. 线程池代码示例

如何实现线程池的代码：

-	创建线程池对象，控制要创建线程对象的数量
-	这种线程池的线程可以执行 ```Runnable``` 对象或者 ```Callable``` 对象代表的线程，所以我们要创建 Runnable 对象，或者 Callable 对象
-	调用线程池中的方法（```ExecutorService```）：
	-	```Future<?> submit (Runnable task)```
	-	```<T> Future<T> submit(Callable<T> task)```
-	结束线程池：
	-	```void shutdown()```

```java
package org.lovian.thread.pool;

public class MyRunnable implements Runnable {

	@Override
	public void run() {
		for(int x = 0; x < 5; x++){
			System.out.println(Thread.currentThread().getName() + " : " + x);
		}
	}
}


package org.lovian.thread.pool;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ExecutorsDemo {
	public static void main(String[] args) {
		// 创建一个线程池对象，里面有 2 个线程对象
		ExecutorService pool = Executors.newFixedThreadPool(2);

		// 创建两个可执行的 Runnable 对象，并调用线程池的方法
		pool.submit(new MyRunnable());
		pool.submit(new MyRunnable());

		// 结束线程池
		pool.shutdown();
	}
}
```

result：

```
pool-1-thread-2 : 0
pool-1-thread-2 : 1
pool-1-thread-2 : 2
pool-1-thread-2 : 3
pool-1-thread-1 : 0
pool-1-thread-2 : 4
pool-1-thread-1 : 1
pool-1-thread-1 : 2
pool-1-thread-1 : 3
pool-1-thread-1 : 4
```

### 4. Callable<V> 方式创建线程

java.util.concurrent.Callable<V>：

-	```Callable<V>``` 是带泛型的接口
-	使用方式与 ```Runnable``` 相似
-	但是```Callable<V>```是依赖于线程池```ExecutorService``` 来使用的。
-	好处：
	-	可以返回泛型返回值
	-	可以抛出异常

我们用它来实现一个求和的例子：

```java
package org.lovian.thread.pool;

import java.util.concurrent.Callable;

public class MyCallable implements Callable<Integer> {

	private int number;

	public MyCallable(int number){
		this.number = number;
	}

	@Override
	public Integer call() throws Exception {
		int sum = 0;
		// 计算从 1 加到 number 的求和
		for(int x =1; x <= number; x++){
			sum += x;
		}
		return sum;
	}

}

package org.lovian.thread.pool;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class ExecutorsDemo2 {
	public static void main(String[] args) throws InterruptedException, ExecutionException {
		// 创建一个线程池对象，里面有 2 个线程对象
		ExecutorService pool = Executors.newFixedThreadPool(2);

		// 创建两个可执行的 Callable 对象，并调用线程池的方法,获取 Future
		// Future 就是异步计算的结果
		Future<Integer> future1 = pool.submit(new MyCallable(100));
		Future<Integer> future2 = pool.submit(new MyCallable(200));

		// Future 的 get() 方法来获取线程的返回值
		Integer i1 = future1.get();
		Integer i2 = future2.get();

		System.out.println("i1: " + i1 + " i2: " + i2);

		// 结束线程池
		pool.shutdown();
	}
}
```

result：

```
i1: 5050 i2: 20100
```


## II. 匿名内部类方式来使用多线程

在开发中，有时候可能随时要开一个线程，但是只需要开一次，就不需要去新建一个线程类，所以就有匿名内部类

### 1. 匿名内部类

-	本质：是该类或者该接口的子类对象
-	匿名内部类格式

```
new 类名或接口名(){
	重写方法;
};
```


### 2. 匿名线程

-	```继承 Thread 类来实现多线程```

```java
new Thread(){
	public void run(){
		doSomething;
	}
}.start();
```

-	```实现 Runable 接口来实现多线程```

```java
new Thread(new Runable(){
	@Override
	public void run(){
		doSomething;
    }
}){}.start();
```

-	注意：如果既重写了子类的run()方法，又实现了接口中的 run() 方法，只会执行子类中的，当然这个在开发中是不会出现的

```java
new Thread(new Runable(){
	@Override
	public void run(){
		doSomething;
    }
}){
	public void run(){
		doAnotherthing; // 实际上执行的是这个 run 方法
    }
}.start();
```

## III. 定时器 timer

定时器是一个应用十分广泛的线程工具，可以用于调度多个定时任务以后各线程的方式执行。在java中，可以通过 ```Timer``` 和 ```TimerTask``` 类来实现定义调度的功能

### 1. Timer 类

java.util.Timer：

-	一种工具，线程用其安排以后在后台线程中执行的任务
-	可安排任务执行一次，或者定期重复执行
-	每个 Timer 对象对应单个后台线程，用于顺序地执行所有计时器任务
-	常用方法
	-	```public void cancer()``` : 终止此计时器，丢弃所有当前已安排的任务
	-	```public void schedule(TimerTask task, Date time)``` : 安排在指定的时间执行指定的任务
	-	```public void schedule(TimerTask task, long delay)``` : 安排在指定延迟后执行指定的任务
	-	```public void schedule(TimerTask task, long delay, long period)``` : 安排指定的任务在指定的时间开始进行重复的固定延迟执行

### 2. TimerTask 类

java.util.TimerTask:

-	抽象类, 一般使用其子类
-	由 Timer 安排为一次执行或重复执行的任务
-	常用方法：
	-	```public boolean cancel()``` ：取消此计时器任务
	-	```public abstract void run()``` : 此计时器任务要执行的操作


### 3. 代码示例

#### 执行一次任务并且终止

```java
package org.lovian.thread.timer;

import java.util.Timer;
import java.util.TimerTask;

public class TimerDemo {
	public static void main(String[] args) {
		System.out.println("Excute boom task once after 3 sec: ");
		executeTaskOnceAndCancer();
		System.out.println("----------------------------------");
		System.out.println("Excute boom task once after 2 sec: ");
		executeTaskOnceAndCancel2();
	}

	private static void executeTaskOnceAndCancer() {
		// 创建定时器对象
		Timer timer = new Timer();

		// 3秒后执行一次爆炸任务
		timer.schedule(new BoomTask(), 3000);
		// 任务执行完毕，终止任务
		timer.cancel();
		// 这里会发现，boom 并没有打印出来
		// 原因是，还没有执行任务（有延迟），任务就被终止了
	}

	private static void executeTaskOnceAndCancel2(){
		Timer timer = new Timer();
		// 2秒后执行另一个爆炸任务，任务执行完毕自动终止
		timer.schedule(new BoomTask2(timer), 2000);
	}
}

class BoomTask extends TimerTask {

	@Override
	public void run() {
		System.out.println("Boom!");
	}

}

class BoomTask2 extends TimerTask {

	private Timer timer;

	public BoomTask2() {
	}

	public BoomTask2(Timer timer) {
		this.timer = timer;
	}

	@Override
	public void run() {
		System.out.println("Another Boom!");
		timer.cancel();
	}

}
```

result:

```
Excute boom task once after 3 sec:
----------------------------------
Excute boom task once after 2 sec:
Another Boom!
```

注意：

-	每一个任务开始，就相当与开启了一个线程
-	要终止任务，应该将计时器写进任务的 run 方法中，否则任务可能还没被执行，就被终止了

#### 执行多次任务

```java
package org.lovian.thread.timer;

import java.util.Timer;
import java.util.TimerTask;

public class TimerDemo2 {
	public static void main(String[] args) {
		System.out.println("Excute boom task once after 3 sec: ");
		executeTaskMultiTimes();
		System.out.println("----------------------------------");
	}

	private static void executeTaskMultiTimes() {
		// 创建定时器对象
		Timer timer = new Timer();

		// 3秒后执行一次爆炸任务,然后每隔2秒继续执行爆炸任务
		timer.schedule(new BoomTask3(System.currentTimeMillis()), 3000, 2000);
	}

}

class BoomTask3 extends TimerTask {

	private long startTime;

	public BoomTask3(long startTime){
		this.startTime = startTime;
	}
	@Override
	public void run() {
		System.out.println("Boom! " + (System.currentTimeMillis() - startTime)/1000 + " sec");
	}
}
```

result:

```
Excute boom task once after 3 sec:
----------------------------------
Boom! 3 sec
Boom! 5 sec
Boom! 7 sec
...
```
