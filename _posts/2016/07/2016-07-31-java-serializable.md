---
layout: post
title:  "[JAVA] Java 中的序列化"
date:   2016-07-31
desc: "how to use serializable in Java"
keywords: "java, io, File， iostream， serializable， transient"
categories: [Java]
tags: [Java]
icon: fa-keyboard-o
---


# Java 中的序列化

## I. 序列化与反序列化

序列化是一种对象持久化的手段，普遍应用于网络传输和 RMI 的场景

-	序列化：
	-	把对象按照流一样的方式，存入文本文件或者在网络中传输
	-	对象 --> 流
	-	ObjectOutputStream
-	反序列化：
	-	把文本中的流对象数据或者网络中的流对象数据还原成对象
	-	流	--> 对象
	-	ObjectInputStream

### 1. 序列化

Java 对象一般在 JVM 运行的情况下才存在，这些对象的生命周期比 JVM 的生命周期短。所以现实中就可能要求 JVM 停止运行后，能够保存（持久化）指定对象并在将来读取被保存的对象，序列化就可以实现此功能：使用 Java 对象序列化，在保存对象时，会把其状态保存为一组字节，在未来，再将这些字节组装成对象。

对象序列化保存的是对象的状态，即成员变量，对象序列化不会关注类中的静态变量

### 2. 如何进行序列化和反序列化

-	实现接口 ```java.io.serializable```, 类似于这样没有方法的接口称为标记接口
-	实现接口后，需要加入序列化 ID： ```private static final long serialVersionUID = 1L;```
-	通过 ObjectOutputStream 和 ObjectInputStream 对对象进行序列化以及反序列化

注意：

-	JVM 是否允许反序列化，不仅取决于类路径和功能代码是否一致，序列化ID也要一致
-	序列化并不保存静态变量
-	想要将父类对象也序列化，就必须让父类也实现 serializable 接口
-	序列话的时候，可以将某些敏感变量（密码） 进行加密，然后反序列时进行解密，从而保证序列化对象的安全

### 3. 序列化的本质

在序列化过程中，如果被序列化的类定义了 ```writeObject()``` 和 ```readObject()```， JVM 会试图通过反射来调用对象类中的这两个方法来进行用户自定义的序列化和反序列化。

用户自定义的 writeObject() 和 readObject() 方法可以允许用户控制序列化的过程，比如在序列化的过程中动态的改变序列化的值。

如果对象类中没有这样的方法，那么 JVM 会调用 ObjectInputStream 中的 ```readObject()``` 和 ObjectOutputStream 中的 ```writeObject()``` 方法来进行序列化和反序列化。

### 4. Transient 关键字

``` transient``` 关键字的作用是控制变量的序列化，在变量声明前加上 transient， 可以阻止改变量被序列化到文件中，在被反序列化后，transient 变量的值为初始值，基本类型的值是 0, 引用类型为 null


### 5. 为什么 Serializable 接口能够保证序列化

因为序列化一个类，实际上是这个类被调用了 writeObject() 和 readObject() 方法（或者是 ObjectOutputStream/ObjectInputStream中默认的方法）。 在方法实现中，方法会判断要被序列化的类是否是 ```Enum```， ```Array```， 或者是```Serializable``` 类型（```obj instanceof Serializable```), 如果不是，则抛出 ```NotSerializableException``` 异常。实际上 Enum 类型，数组类型都实现了 serializable 接口

### 6. Java 中实现序列化的3中方式

1. 将类实现 serializable 接口
2. 将对象包装成 JSON 字符串
3. 用google的 protobuf


参考 [深入分析Java的序列化与反序列化](http://www.hollischuang.com/archives/1140)
