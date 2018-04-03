---
layout: post
title:  "[JAVA] How to monitor Java memory usage"
date:   2016-05-22
desc: "how to monitor java memory usage in Java"
keywords: "java, memory monitor, runtime, garbage collection"
categories: [java]
---

# How to monitor Java memory usage

## I. Why we need monitor Java memory usage

As the developping of hardware, nowadays, Java developers may ignore how to save memory usage during the programming. But sometimes, there may have some bugs will cause the memory leak problem. So we need to know some mechanism which can monitor the memory usage when the process has been executed.

## II. Tools

There are some tools will provide the function of monitoring memory useage. Here I just introduce some tools but not the usage

###	JProfile
-	A powerful commercial software
-	Can monitor memory usqge and also the cpu consumption
-	Can give the hierarchy of all the calls
-	Easy integrated with Eclipse and IDEA
-	Porvide dump feature

### VisualVM
-	A tool provided by Oracle Java JDK, located at JAVA_HOME/bin/jvisualvm
-	Provide dump feature (system dump, java dump and heap dump) and also snapshot feature(cpu snapshot, memory snapshot)
-	Provide performance analysis(cpu performance, memory performance, thread preformance)
-	Support plugins

## III. Use log

If you are not used to use the tools, also we could analyze the memory usage by printing log.

For example, we can implemented a static method in Util class

```java
public static printMemoryInfo(String callName){
	String currentProcess = "";
	if(info != null)
		currentProcess = callName;
	System.gc();
	Runtime rt = Runtime.getRuntime();
	long usedMem = (rt.totalMemory() - rt.freeMemory()) / 1024 / 1024;
	// change the unit to MB
	System.out.println("The process: " + callName + " used " + usedMem + " MB of memory");
}
```

Then, in your method, you could call ```printMemoryInfo``` to monitor the memory.

```java
public void example(){
	//some code here;
	printMemoryInfo("before call doSomething");
	doSomething();
	printMemoryInfo("After call doSomething");
}
```

In the console, it will print the memory usage information twice. The difference between these two values is the memory which used by method ```doSomething```.


## III. Debug util class
To improve it as a class for debug, use a boolean variable to control the output in console

```java
public class Debug{
	private static boolean DEBUG = true;

	public static printMemoryInfo(String callName){
		if(DEBUG){
			String currentProcess = "";
			if(info != null)
				currentProcess = callName;
			System.gc();
			Runtime rt = Runtime.getRuntime();
			long usedMem = (rt.totalMemory() - rt.freeMemory()) / 1024 / 1024;
			// change the unit to MB
			System.out.println("The process: " + callName + " used " + usedMem + " MB of memory");
		}

	}

	public static printMemoryInfo(){
		if(DEBUG){
			System.gc();
			Runtime rt = Runtime.getRuntime();
			long usedMem = (rt.totalMemory() - rt.freeMemory()) / 1024 / 1024;
			// change the unit to MB
			System.out.println("The process:  used " + usedMem + " MB of memory");
		}
	}


	// This part is for the log
	public static void info(String message){
		if(DEBUG){
			System.out.println(message);
		}
	}

	public static void info(){
		if(DEBUG){
			System.out.println();
		}
	}

	public static void info(Object obj){
		if(DEBUG){
			System.out.println(obj);
		}
	}

	public static void error(String message){
		if(DEBUG){
			System.err.println(message);
		}
	}
}
```
Just add some additional methods in this class, you will have your own debug util class
