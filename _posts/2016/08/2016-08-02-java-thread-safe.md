---
layout: post
title:  "[JAVA] Java 中的多线程编程（二） 多线程安全问题"
date:   2016-08-02
desc: "how to use thread in Java"
keywords: "java, thread"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---

# Java 中多线程编程二： 多线程安全问题


## I. 线程安全

### 1. 多线程的问题：

那么首先来看多线程为什么出现问题（出问题的标准）：

-	```是否是多线程环境```，因为单线程程序只要逻辑正确就没有问题
-	```是否有共享数据```， 没有共享数据的话，每个线程只访问和操作自己特有的数据，也不会出问题
-	```是否有多条语句操作共享数据```，
	-	因为 cpu 执行指令的原子性，cpu 一次执行一个原子性操作，比如一次加法或者一次赋值
	-	如果有多个线程，每个线程对共享数据的操作只有一个原子性的操作，那么数据也不会出问题
	-	但如果，每个线程中都有多条操作语句操作共享数据，比如 ```A；B；C;``` 三个语句，对共享数据进行操作，理想顺序是线程1执行完 ABC，线程2再执行ABC
	-	但是由于多线程执行的随机性，有可能线程1执行到B的时候，线程1就执行了A，那么得到的值就和期待值不同
	-	于是多线程问题就出现了

所以程序中，满足了上面三个条件，就存在线程的安全问题的！

### 2. 解决线程安全问题的基本思想

当程序满足了上面三个条件，出现了安全问题，那么如何解决呢？

-	基本思想：

前两个条件一般是不能进行更改的，所以要从第三个条件入手。如果我们把多条语句操作共享数据的代码给包装成一个整体，比如 ```A; B; C;``` 三个语句，我们让一个线程在执行这三个语句的时候，一次性把他们当作一个语句执行了。就是说，线程1在执行这个语句的整体的时候，线程2就不会去执行这个包装好的整体语句。所以就不会出现线程1才执行到 B 语句，线程二就执行到A语句的情况了。

-	怎么实现：Java 给我们提供了 ```同步机制```


### 3. 同步代码块

-	格式：
	-	```synchronized(对象){需要同步的代码}```
	-	这个对象：就是一个锁对象，用这个锁锁住所有需要操作共享数据的线程
	-	需要同步的代码：把多条语句操作共享数据的代码的部分给包起来
-	同步可以解决安全问题的根本原因就在那个对象上，该对象如同锁的功能
-	多个线程必须是同一把锁

```java
package org.lovian.thread.synchronize;

public class SellTicket implements Runnable {

	// share area of threads
	private int tickets = 100;
	// lock object
	private Object obj = new Object();

	@Override
	public void run() {
		while (true) {
			synchronized (obj) {	// the node need to be synchronized
				if (tickets > 0) {
					try {
						Thread.sleep(100); // simulate of the network delay
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					System.out.println(Thread.currentThread().getName() + " is selling No. " + (tickets--) + " ticket");
				}
			}
		}
	}
}

package org.lovian.thread.synchronize;

public class SellTicketDemo {
	public static void main(String[] args) {
		SellTicket sellTicket = new SellTicket();

		Thread window1 = new Thread(sellTicket,"Window 1");
		Thread window2 = new Thread(sellTicket,"Window 2");
		Thread window3 = new Thread(sellTicket,"Window 3");


		window1.start();
		window2.start();
		window3.start();
	}
}
```

上述代码中，用 ```synchronized``` 关键字把操作共享数据的代码区域锁住了，而 syncronized 需要一个对象，如果这个对象不在共享区，那么就相当于每一个线程都有一把锁，这是没有意义的。```锁``` 在有一个线程正在执行同步代码块的时候，把这个同步代码块锁住，如果这时候有另一个线程抢到了cpu的执行权，但是发现这里被锁住了，它就只能等着锁住的代码执行结束，然后锁打开，它才能进去执行代码块中的代码

通俗的举例，相当于在火车上上厕所，每个人相当于一个线程，上厕所的操作相当于同步代码块，厕所门锁就是那个同步 object。所以当一个人抢到了厕所的使用权，上厕所，锁住门，另一个人就没法进去;当一个人上完了，另一个人才能抢到厕所的使用权

### 4.同步的特点

-	前提条件：
	-	有多个线程
	-	多个线程必须使用同一把锁
-	同步的好处：
	-	解决了多线程的安全问题
-	同步的弊端：
	-	当线程很多时，每个线程都会去判断同步上的锁，这是很耗费资源的，无形中会降低程序的运行效率
-	同步代码块的锁对象： 是任意对象

### 5. 同步方法的格式及锁对象问题

-	同步方法： 把 ```synchronized``` 关键字加在方法的声明上
-	同步方法的锁对象：```this```
-	静态方法锁对象： 类的字节码文件对象，```当前类.class```, 因为静态内容是随着 class 文件被加载到方法区的时候而加载，所以这个对象就是这个类的字节码文件对象

我们把上面例子的代码改成下面使用同步方法的代码

```java
package org.lovian.thread.synchronize;

public class SellTicket implements Runnable {

	// 1000 tickets
	private int tickets = 100;

	// lock object
	private Object obj = new Object();

	@Override
	public void run() {
		while (true) {
			sellTikets();
		}
	}
 	//同步方法
	private synchronized void sellTikets() {
		if (tickets > 0) {
			try {
				Thread.sleep(100);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println(Thread.currentThread().getName() + " is selling No. " + (tickets--) + " ticket");
		}
	}
}
```

## II. Java 中线程安全的类

我们知道 Java 中有一些类是线程安全的，比如 ```StringBuffer```, ```Vector```, 和 ```Hashtable```， 他们中的成员方法大多数都被 ```synchronized``` 标注了。但是安全的同时，效率会更低。

即使我们有 ```Vector``` 和 ```Hashtable```， 但是实际上开发的时候，也不会去用它们，而是使用 ```Coollections``` 工具类提供的返回线程安全的 list 集合等，比如：

-	```public static <T> List<T> synchronizedList(List<T> list)``` ： 返回指定列表支持的同步（线程安全的）列表
-	```public static <K,V> SortedMap<K,V> synchronizedSortedMap(SortedMap<K,V> m)``` ： 返回由指定映射支持的同步（线程安全的）映射
-	```public static <T> Set<T> synchronizedSet(Set<T> s)``` ：返回指定有序 set 支持的同步（线程安全的）有序 set


## III. JDK5 中 Lock 锁的使用

为了清晰的表达如何加锁和释放锁，JDK5 以后提供了一个新的锁对象 ```Lock```, 有了它以后，我们就可以明确的知道在哪里加了锁，在哪里释放了锁

### 1. Lock 接口

java.util.concurrent.locks.Lock:

Lock 实现提供了比使用 ```synchronized``` 方法和语句可获得的更广泛的锁定操作

-	```void lock()``` : 获取锁
-	```void unlock()``` : 释放锁


### 2. Lock 接口主要实现类

java.util.concurrent.locks.ReentrantLock:

一个可重入的互斥锁，比 synchronized 功能更强大，使用 ```lock()``` 方法在需要同步的代码块的位置上加锁，使用 ```unlock``` 在同步代码块结束的位置上解锁。

```java
package org.lovian.thread.lock;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class SellTicket implements Runnable {

	private int tickets = 100;

	// define a lock
	private Lock lock = new ReentrantLock();

	@Override
	public void run() {
		while (true) {

			try {
				lock.lock(); // add lock

				if (tickets > 0) {
					try {
						Thread.sleep(100);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					System.out.println(Thread.currentThread().getName() + " is selling No. " + (tickets--) + " ticket");
				}
			} finally {
				// release lock anyway
				lock.unlock();
			}
		}
	}
}
```

这里使用了 ```try/finally``` 语句块，是因为无论同步代码块有没有出问题，锁都是要释放的



### 3. 死锁问题

-	同步的弊端：
	-	效率低
	-	如果出现了同步嵌套，就容易产生死锁问题
-	```死锁问题``：
	-	是指两个或者两个以上的线程在执行的过程中， 因争夺资源产生的一种互相等待的现象


死锁的代码示例：

```java
package org.lovian.thread.lock;

public class MyLock {
	// create two locks
	public static final Object LOCK_A= new Object();
	public static final Object LOCK_B = new Object();
}

package org.lovian.thread.lock;

public class DieLock extends Thread {

	private boolean flag;

	public DieLock(boolean flag) {
		this.flag = flag;
	}

	@Override
	public void run() {
		if (flag) {
			synchronized (MyLock.LOCK_A) {
				System.out.println("if LOCK_A");
				synchronized (MyLock.LOCK_B) {
					System.out.println("if LOCK_B");
				}
			}
		} else {
			synchronized (MyLock.LOCK_B) {
				System.out.println("else LOCK_B");
				synchronized (MyLock.LOCK_A) {
					System.out.println("else LOCK_A");
				}
			}
		}
	}
}

package org.lovian.thread.lock;

public class DieLockDemo {
	public static void main(String[] args) {
		DieLock dl1 = new DieLock(true);
		DieLock dl2 = new DieLock(false);

		dl1.start();
		dl2.start();
	}
}
```

result:

```
if LOCK_A
else LOCK_B
```

从结果我们可以看出，程序卡在这里了，线程1执行了 if 语句块中的 A 锁，而线程2 执行了 else 语句块的 B 锁， 所以线程1 在等 B 锁的释放，而线程2在等 A 锁的释放，结果两个线程都卡在这里了，造成了死锁



## IV. 线程间通信

```线程间通信问题```，其实就是不同种类的线程之间针对一个资源的操作。
举个例子， 早餐店卖包子，至少有做新包子和顾客买包子两种操作，那么包子就是资源，两个线程一个增加资源，一个减少资源。所以线程间通信，其实就是通过```设置线程``` （生产者）和```获取线程```（消费者）针对同一个对象进行操作。

### 1.代码示例

我们以学生类（student）作为资源类来进行线程间通信的演示，首先分析关系：

-	资源类： Student
-	设置学生数据： SetThread （设置线程，生产者）
-	获取学生数据： GetThread （获取线程，消费者）
-	测试类： StudentDemo

Student 类代码：

```java
package org.lovian.thread.communication;

public class Student {
	private String name;
	private int age;

	...

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	...
}

```

SetThread 类代码：

```java
package org.lovian.thread.communication;

public class SetThread implements Runnable {

	private Student s;
	private int count = 0;

	public SetThread(Student s) {
		this.s = s;
	}

	@Override
	public void run() {
		while (true) {
			synchronized (s) {
				if (count % 2 == 0) {
					s.setName("James");
					s.setAge(25);
				} else {
					s.setName("Lili");
					s.setAge(18);
				}
			}
			count++;
		}
	}
}
```

GetThread 类代码：

```java
package org.lovian.thread.communication;

public class GetThread implements Runnable {

	private Student s;

	public GetThread(Student s) {
		this.s = s;
	}

	@Override
	public void run() {
		while (true) {
			synchronized (s) {
				System.out.println(s.getName() + " -- " + s.getAge());
			}
		}
	}

}
```

测试类：

```java
package org.lovian.thread.communication;

public class StudentDemo {
	public static void main(String[] args) {

		// 创建资源
		Student s = new Student();

		// 设置线程
		SetThread st = new SetThread(s);
		Thread t1 = new Thread(st, "SetStudent");

		// 获取线程
		GetThread gt = new GetThread(s);
		Thread t2 = new Thread(gt, "GetStudent");

		t1.start();
		t2.start();
	}
}
```

result：

```
null -- 0
null -- 0
...
Lili -- 18
Lili -- 18
Lili -- 18
...
```

注意：

-	资源类 student 的对象 s， 必须被设置线程和获取线程共有
	-	通过构造器参数传入
	-	通过 set 方法
-	由于现在资源类对象 s 被两个线程同时拥有，而且还同时被两个线程操作，就会出现线程安全问题
	-	设置线程和获取线程要同时上锁
	-	两个线程必须上同一把锁，这里的锁就是传入的资源类 Student 的对象 s
-	问题：
	-	如结果所示，获取线程可能在设置线程之前得到了 CPU 的执行权，所以结果为 null -- 0
	-	而且可能每个线程都连续的获得了 CPU 的执行权，无论是生产者还是消费者，这都是不合理的
-	解决问题思路：
	-	生产者：先看是否有资源，有就等待，没有就生产，生产完通知消费者来消费
	-	消费者：先看是否有资源，有就消费，没有就等待，通知生产者生产数据
-	为了解决这个问题，java 提供了```等待唤醒机制```


### 2.等待唤醒机制

```等待唤醒机制``` 使用了 ```Object``` 类中提供的方法：

-	```wait()``` : 在其他线程调用此对象的 notify 方法时， 导致当前线程等待，等待的时候，会将锁释放
-	```notify()``` ： 唤醒此对象监视器上等待的单个线程
-	```notifyAll()``` ： 唤醒此对象监视器上等待的所有线程

为什么这些方法不定义在```Thread``` 类中呢？
因为，这些方法应该是```锁对象```来调用的，然而在多线程中，锁对象可能是任意一个对象，所以，就把方法定义在所有类的超类 Object 里。

```等待唤醒机制思想```：

-	生产者：先看是否有资源，有就等待，没有就生产，生产完通知消费者来消费
-	消费者：先看是否有资源，有就消费，没有就等待，通知生产者生产数据
-	线程执行时，要保证必须先有资源

那么应用等待唤醒机制，修改代码：

Student类
```java
package org.lovian.thread.communication.waitnotify;

public class Student {
	private String name;
	private int age;
	private boolean flag; // 是否有数据，有 true， 没有 false

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isFlag() {
		return flag;
	}

	public void setFlag(boolean flag) {
		this.flag = flag;
	}
}

```

生产者 SetThread 类：

```java
package org.lovian.thread.communication.waitnotify;

public class SetThread implements Runnable {

	private Student s;
	private int count = 0;

	public SetThread(Student s) {
		this.s = s;
	}

	@Override
	public void run() {
		while (true) {
			synchronized (s) {
				if(s.isFlag()){ // 判断是否有资源 --> 有
					try {
						s.wait(); // 生产者线程等待，释放锁;被唤醒后，生产者继续从这里执行
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}

				if (count % 2 == 0) {
					s.setName("James");
					s.setAge(25);
				} else {
					s.setName("Lili");
					s.setAge(18);
				}
				count++;

				// 生产资源了，改标记
				s.setFlag(true);
				// 唤醒消费者线程
				s.notify();
			}
		}
	}
}
```

消费者 GetThread 类：

```java
package org.lovian.thread.communication.waitnotify;

public class GetThread implements Runnable {

	private Student s;

	public GetThread(Student s) {
		this.s = s;
	}

	@Override
	public void run() {
		while (true) {
			synchronized (s) {
				if(!s.isFlag()){ // 判断是否有资源 --> 没有
					try {
						s.wait(); // 消费者等待，释放锁;
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				System.out.println(s.getName() + " -- " + s.getAge());
				// 消费完资源，修改标记
				s.setFlag(false);
				// 唤醒生产者线程
				s.notify();
			}

		}
	}
}
```

测试类代码不变， 结果：

```
James -- 25
Lili -- 18
James -- 25
Lili -- 18
James -- 25
Lili -- 18
...
```

从结果可以看见这里生产者线程和消费者线程就交替执行了。注意，在 ```wait()``` 方法被执行时，会同时释放锁，让另一个拥有此锁的线程可以被执行。 当线程被唤醒时，代码从 ```wait()``` 代码处继续开始执行，但是，被唤醒后，```线程不是立刻执行的```，它还需要抢夺 CPU 的执行权。

### 3. 线程状态转换图

![thread_state]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/thread-state.png)
