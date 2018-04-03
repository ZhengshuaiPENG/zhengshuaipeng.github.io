---
layout: post
title:  "[JAVA] Java 类加载器和反射"
date:   2016-08-15
desc: "reflection in Java"
keywords: "java, class, reflection, class loader"
categories: [java]
---

# Java 中类的加载器和反射

## I. 类加载器

### 1. 类的加载

当程序要使用某个类时，如果该类还未被加载到内存中，则系统会通过加载，连接，初始化三步来实现对这个类进行初始化：

-	```加载``` ：
	-	就是指将```class文件```读入内存，并为之创建一个```Class对象```
	-	一个class文件基本组成： 成员变量，构造方法，成员方法，静态成员
	-	任何类被使用时系统都会建立一个Class对象。
-	```连接``` ：
	-	```验证```： 是否有正确的内部结构，并和其他类协调一致
	-	```准备```： 负责为类的```静态成员```分配内存，并设置默认初始化值
	-	```解析```： 将类的二进制数据中的符号引用替换为直接引用
-	```初始化``` ： 就是在多态的部分提到的初始化步骤

### 2. 类的初始化时机

-	创建类的实例
-	访问类的静态变量，或者为静态变量赋值
-	调用类的静态方法
-	使用反射方式来强制创建某个类或接口对应的java.lang.Class对象
-	初始化某个类的子类
-	直接使用java.exe命令来运行某个主类

### 3. 类加载器

-	类加载器：
	-	负责将.class文件加载到内存中，并为之生成对应的Class对象。
	-	虽然我们不需要关心类加载机制，但是了解这个机制我们就能更好的理解程序的运行
-	类加载器的组成
	-	```Bootstrap ClassLoader``` ：
		-	根类加载器，也叫引导类加载器
		-	负责 Java 核心类的加载（比如 System, String 类）
		-	加载在JDK中，```JRE 的 lib 目录下的 rt.jar 文件```
	-	```Extension ClassLoader``` ：
		-	扩展类加载器
		-	负责 JRE 的扩展目录中 jar 包的加载
		-	加载 JDK 中， ```JRE 的lib 目录下的 ext 目录```
	-	```Sysetm ClassLoader```  ：
		-	系统类加载器
		-	负责在 JVM 启动时加载来自 Java 命令的 class 文件
		-	以及 ```classpath 环境变量所指定的 jar 包和类路径```

## II. 反射

### 1. 反射机制

反射： ```class文件 --> class 文件对象 --> 属性和方法```， 就是通过 class 文件对象，去使用该文件中成员变量，构造方法，成员方法

-	Java 反射机制是在运行状态中，对于任意一个类，都能够知道这个类的所有属性和方法
	-	对于任意一个对象，都能够调用它的任意一个方法和属性
	-	这种动态获取的信息以及动态调用对象的方法的功能称为java语言的反射机制
-	要想解剖一个类,必须先要获取到该类的字节码文件对象。而解剖使用的就是Class类中的方法.所以先要获取到每一个字节码文件对应的Class类型的对象

### 2. 反射的使用

Class 类：

-	成员变量：```Field```
-	构造方法：```Constructor```
-	成员方法：```Method```

首先先通过 class 文件，得到 class 对象，然后通过 class 对象，分别获取成员变量，构造方法，成员方法的对象，然后通过这些对象去获取相应的属性或方法。

获取class 文件对象的方式：

-	Object类的 ```getClass()``` 方法
	-	```Student s = new Student();```
	-	```Class c = s.getClass();```
-	数据类型的静态属性 ```class```
	-	```int.class```
	-	```Student.class```
-	Class 类中的静态方法
	-	```public static Class forName(String className);```
	-	```Class c = Class.forName("Student");```
	-	抛出 ClassNotFoundException， 参数要带全路径，就是带包名

开发中，建议使用 Class 类中的静态方法，因为传入的参数是字符串，所以可以把字符串配置到配置文件中

#### A.通过反射获取构造方法

通过 ```Class``` 类中的方法获取类的构造方法对象：

-	```public Constructor<?>[] getConstructors() throws SecurityException```
	-	返回一个包含某些 Constructor 对象的数组
	-	这些对象反映此 Class 对象所表示的类的所有```公共构造方法```， 即 public 修饰的
	-	如果该类没有公共构造方法，或者该类是一个数组类，或者该类反映一个基本类型或 void，则返回一个长度为 0 的数组
-	```public Constructor<?>[] getDeclaredConstructors() throws SecurityException```
	-	返回 Constructor 对象的一个数组，这些对象反映此 Class 对象表示的类声明的```所有构造方法```
-	```public Constructor<T> getConstructor(Class<?>... parameterTypes) throws NoSuchMethodException, SecurityException```
	-	返回指定的公共构造方法对象
-	```public Constructor<T> getDeclaredConstructor(Class<?>... parameterTypes) throws NoSuchMethodException, SecurityException```
	-	返回指定的构造方法对象（包括私有）

通过 ```Constructor``` 类中的方法来创建实例
-	```newInstance()``` 方法来创建该构造方法的声明类的新实例，并用指定的初始化参数初始化该实例
-	```setAccessible(true)```: 设置反射的对象可以访问非公有的构造方法

代码示例：
待获取的类：

```java
package org.lovian.reflection;

public class Person {
	private String name;
	int age;
	public String address;

	Person() {
		super();
	}

	public Person(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}

	private Person(String name, int age, String address) {
		super();
		this.name = name;
		this.age = age;
		this.address = address;
	}

	public void show() {
		System.out.println("name: " + name + " age: " + age);
	}

	@Override
	public String toString() {
		return "Person [name=" + name + ", age=" + age + ", address=" + address + "]";
	}
}
```

测试类：

```java
package org.lovian.reflection;

import java.lang.reflect.Constructor;

public class GetConstructorDemo {
	public static void main(String[] args) throws Exception {
		// 获取 Class 对象
		Class c = Class.forName("org.lovian.reflection.Person");

		// 获取所有公共构造方法
		Constructor[] cons = c.getConstructors();
		for (Constructor constructor : cons) {
			System.out.println(constructor);
		}
		System.out.println("=====================================");

		// 获取所有构造方法
		Constructor[] allCons = c.getDeclaredConstructors();
		for (Constructor constructor : allCons) {
			System.out.println(constructor);
		}
		System.out.println("=====================================");

		// 获取指定的公共构造方法
		Constructor constructor1 = c.getConstructor(String.class, int.class);
		Object obj1 = constructor1.newInstance("Xiaoming", 23);
		Person s1 = (Person) obj1;
		s1.show();
		System.out.println("=====================================");

		// 获取指定的任一构造方法，此处获取私有构造方法
		Constructor constructor2 = c.getDeclaredConstructor(String.class, int.class, String.class);
		constructor2.setAccessible(true);
		Object obj2 = constructor2.newInstance("Xiaohong", 20, "Pekin");
		Person s2 = (Person) obj2;
		s2.show();
	}
}
```

result：

```java
public org.lovian.reflection.Person(java.lang.String,int)
=====================================
private org.lovian.reflection.Person(java.lang.String,int,java.lang.String)
public org.lovian.reflection.Person(java.lang.String,int)
org.lovian.reflection.Person()
=====================================
name: Xiaoming age: 23
=====================================
name: Xiaohong age: 20
```

#### B.通过反射获取成员变量并使用

通过 ```Class``` 类中的方法获取类的成员变量对象：

-	```public Field[] getFields() throws SecurityException```
	-	获取所有的公共的成员变量对象
-	```public Field getDeclaredField(String name) throws NoSuchFieldException, SecurityException```
	-	获取所有的成员变量对象
-	```public Field getField(String name) throws NoSuchFieldException, SecurityException```
	-	返回一个指定的公共的成员变量对象
-	```public Field getDeclaredField(String name) throws NoSuchFieldException, SecurityException```
	-	返回一个任意的成员变量对象

通过 ```Filed``` 类的 set 方法来设置或者通过 get 方法获取值
-	```public void set(Object obj, Object value)```: 将指定对象变量上此 Field 对象表示的字段设置为指定的新值
-	```setAccessible(true)```： 来访问非公有成员

代码示例：

```java
package org.lovian.reflection;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;

public class GetFieldDemo {
	public static void main(String[] args) throws Exception {
		// 获取字节码文件对象
		Class c = Class.forName("org.lovian.reflection.Person");

		// 获取所有公共的成员变量对象
		Field[] fields = c.getFields();
		for (Field field : fields) {
			System.out.println(field);
		}
		System.out.println("===========================");

		// 获取所有的成员变量对象
		Field[] allFields = c.getDeclaredFields();
		for (Field field : allFields) {
			System.out.println(field);
		}
		System.out.println("===========================");

		// 通过无参构造来创建对象
		Constructor con = c.getDeclaredConstructor();
		con.setAccessible(true);
		Object obj = con.newInstance();

		// 获取成员变量 address
		// 将指定对象变量上值设置为新值
		Field addressField = c.getField("address");
		addressField.set(obj, "Pekin"); // 给 obj 对象的 addressFiled 字段设置值为“Pekin”
		Field nameField = c.getDeclaredField("name");
		nameField.setAccessible(true);
		nameField.set(obj, "Xiaoming"); // 给 obj 对象的 nameFiled 字段设置值为“Xiaoming”
		Field ageField = c.getDeclaredField("age");
		ageField.setAccessible(true);
		ageField.set(obj, 20); // 给 obj 对象的 ageFiled 字段设置值为 20
		((Person) obj).show();
	}
}
```

result：

```
public java.lang.String org.lovian.reflection.Person.address
===========================
private java.lang.String org.lovian.reflection.Person.name
int org.lovian.reflection.Person.age
public java.lang.String org.lovian.reflection.Person.address
===========================
name: Xiaoming age: 20
```

#### C.通过反射获取成员方法并使用

通过 ```Class``` 类中的方法获取类的成员方法对象：

-	```public Method[] getMethods() throws SecurityException```
	-	返回所有公共方法对象， 包括继承的方法
-	```public Method[] getDeclaredMethods() throws SecurityException```
	-	返回所有方法对象， 不包括继承的方法
-	```public Method getMethod(String name, Class<?>... parameterTypes) throws NoSuchMethodException, SecurityException```
	-	返回一个指定的公共方法对象
-	```public Method getDeclaredMethod(String name, Class<?>... parameterTypes) throws NoSuchMethodException, SecurityException```
	-	返回一个指定的任意方法对象

通过 ```Method``` 类中的方法来调用方法

-	通过 ```invoke()``` 方法来调用通过反射得到的方法
-	```setAccessible(true)``` 来访问非共有方法


代码示例：

```java
package org.lovian.reflection;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public class GetMethodDemo {
	public static void main(String[] args) throws Exception{
		// 获取字节码文件对象
		Class c = Class.forName("org.lovian.reflection.Person");

		// 获取所有公共方法
		Method[] methods = c.getMethods();
		for (Method method : methods) {
			System.out.println(method);
		}
		System.out.println("==================================");

		// 获取所有方法
		Method[] allMethods = c.getDeclaredMethods();
		for (Method method : allMethods) {
			System.out.println(method);
		}
		System.out.println("==================================");

		// 通过反射创建对象
		Constructor con = c.getDeclaredConstructor();
		con.setAccessible(true);
		Object obj = con.newInstance();

		// 获取 show 方法并访问
		Method m1 = c.getMethod("show", null);
		m1.invoke(obj, null);
	}
}
```

result：

```
public void org.lovian.reflection.Person.show()
public java.lang.String org.lovian.reflection.Person.toString()
public final void java.lang.Object.wait(long,int) throws java.lang.InterruptedException
public final native void java.lang.Object.wait(long) throws java.lang.InterruptedException
public final void java.lang.Object.wait() throws java.lang.InterruptedException
public boolean java.lang.Object.equals(java.lang.Object)
public native int java.lang.Object.hashCode()
public final native java.lang.Class java.lang.Object.getClass()
public final native void java.lang.Object.notify()
public final native void java.lang.Object.notifyAll()
==================================
public void org.lovian.reflection.Person.show()
public java.lang.String org.lovian.reflection.Person.toString()
==================================
name: null age: 0
```

### 3. 反射的应用

-	```可以通过 property 文件配合反射动态的执行某个类```
	-	在properties文件中配置className，methodName， fieldName, constructorName
	-	用 ```Properties```类来获取定义好的这些属性
	-	用反射调用指定类的方法

```java
// 读取 propeties 配置文件
// 注意： 在加载配置文件的时候，路径可以用绝对路径，也可以使用默认的项目下路径
// 还可以使用反射的方式： 当前类.class.getClassLoader.getResourceAsStream("config.properties") 来加载
InputStream is = new FileInputStream("config.properties");
Properties props = new Properties();
// 加载 inputstream
props.load(is);
ips.close();

// 获取配置的 className
String className = props.getProperty("className");
// 获取相应的 class 文件
Class c = Class.forName(className);
// 创建配置的 className 的实例对象
c.newInstance();
```



-	```框架一般使用反射来调用用户写的类```
	-	框架需要调用用户写的类，而工具类则是被用户调用的类
	-	框架在实现的时候，用户的类不存在，不能用 new 方法来调用， 那框架怎么调用用户的类？使用反射

示例： 有一个 ```ArrayList<Integer>``` 集合对象，在这个集合中添加一个字符串，如何实现？

```
package org.lovian.reflection;

import java.lang.reflect.Method;
import java.util.ArrayList;

public class ArrayListDemo {
	public static void main(String[] args) throws Exception{
		ArrayList<Integer> array = new ArrayList<>();

		Class c = Class.forName("java.util.ArrayList");

		Method method = c.getMethod("add", Object.class);

		method.invoke(array, "hello");
		method.invoke(array, "world");
		method.invoke(array, "java");

		System.out.println(array);
	}
}
```

result：

```
[hello, world, java]
```

我们知道， ArrayList 可以添加泛型对象，这里是 Integer，而这个泛型对象的类型检查是编译时期检查的，所以，如果我们这里传入了一个 String 对象，编译器会报错。但是，如果我们使用反射，让 array 在运行期来添加这个 String 对象，绕过编译器的检查，是可以的


## III. 动态代理


### 1.代理和动态代理

-	```代理```：本来应该自己做的事情，却请了别人来做，被请的人就是代理对象。
	-	举例：春季回家买票让人代买
-	```动态代理```：在程序运行过程中产生的这个对象
	-	而程序运行过程中产生对象其实就是我们刚才反射讲解的内容，所以，动态代理其实就是通过反射来生成一个代理

### 2.Java 中使用动态代理

-	在 Java 中 ```java.lang.reflect ```包下提供了一个 ```Proxy 类```和一个 ```InvocationHandler接口```，通过使用这个类和接口就可以生成动态代理对象
	-	```Proxy``` 提供用于创建动态代理类和实例的静态方法，它还是由这些方法创建的所有动态代理类的超类
	-	```InvocationHandler``` 是代理实例的调用处理程序 实现的接口
	-	JDK提供的代理只能针对接口做代理。我们有更强大的代理 ```cglib```
-	Proxy 类中的方法创建动态代理类对象
	-	```public static Object newProxyInstance(ClassLoader loader,Class<?>[] interfaces,InvocationHandler h)```
	-	最终会调用 ```InvocationHandler``` 的方法
-	```InvocationHandler```
	-	```Object invoke(Object proxy,Method method,Object[] args)```

### 3. Proxy类

-	```Proxy``` 类中创建动态代理对象的方法的三个参数；
	-	```ClassLoader 对象```，定义了由哪个 ClassLoader 对象来对生成的代理对象进行加载
	-	```Interface对象的数组```，表示的是我将要给我需要代理的对象提供一组什么接口，如果我提供了一组接口给它，那么这个代理对象就宣称实现了该接口(多态)，这样我就能调用这组接口中的方法了
	-	```InvocationHandler对象```，表示的是当我这个动态代理对象在调用方法的时候，会关联到哪一个 InvocationHandler 对象上

每一个动态代理类都必须要实现 ```InvocationHandler ```这个接口，并且每个代理类的实例都关联到了一个 handler，当我们通过代理对象调用一个方法的时候，这个方法的调用就会被转发为由 ```InvocationHandler ```这个接口的 ```invoke 方法```来进行调用。

-	```InvocationHandler接口``` 中invoke方法的三个参数：
	-	```proxy``` : 代表动态代理对象
	-	```method``` : 代表正在执行的方法
	-	```args``` : 代表调用目标方法时传入的实参

-	```Proxy.newProxyInstance```
	-	创建的代理对象是在 jvm 运行时动态生成的一个对象，它并不是我们的 InvocationHandler 类型，
	-	也不是我们定义的那组接口的类型，而是在运行是动态生成的一个对象，并且命名方式都是这样的形式，
	-	以$开头，proxy为中，最后一个数字表示对象的标号。
	-	```System.out.println(u.getClass().getName());```


### 4. 动态代理代码示例

定义一个 UserDao 接口定义增删改查功能，并实现一个实现类 UserDaoImpl

```java
package org.lovian.reflection.proxy;

public interface UserDao {

	void add();

	void delete();

	void update();

	void find();
}


package org.lovian.reflection.proxy;

public class UserDaoImpl implements UserDao{

	@Override
	public void add() {
		System.out.println("add method");
	}

	@Override
	public void delete() {
		System.out.println("delete method");
	}

	@Override
	public void update() {
		System.out.println("update method");
	}

	@Override
	public void find() {
		System.out.println("find method");
	}

}
```

测试类：

```java
package org.lovian.reflection.proxy;

import java.lang.reflect.Proxy;

public class Test {
	public static void main(String[] args) {
		UserDao ud = new UserDaoImpl();
		System.out.println("-----original--");
		ud.add();
		ud.delete();
		ud.update();
		ud.find();
	}
}
```

result：

```
-----original--
add method
delete method
update method
find method
```

这是一个正常的使用接口多态的代码，如果需求现在改为在使用 UserDao 的增删改查功能时，加入权限校验和日志记录的功能，那么该怎么实现呢？

可以修改接口实现，由开闭原则，扩展新增加一个接口实现，然后在方法的实现中，分别加入权限校验功能和日志记录功能。但是问题来了，如果有加入新的功能，我们又要扩展新的接口实现，而且需要在每个方法上都要添加同样的功能。这种方式太过于麻烦。

所以，我们可以使用动态代理来为 UserDaoImpl 实现的方法加入新的功能，而不用去修改原有的代码实现。

首先实现一个 InvocationHandler 接口， 在其中使用反射来调用方法，返回代理对象

```java
package org.lovian.reflection.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class MyInvocationHandler implements InvocationHandler {

	private Object target; //目标对象

	public MyInvocationHandler(Object target) {
		this.target = target;
	}

	@Override
	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

		// 添加权限校验功能
		System.out.println("Check privilege");
		Object result = method.invoke(target, args);
		// 添加日志记录功能
		System.out.println("Log Info");
		// 返回代理对象
		return result;
	}
}
```

然后修改测试类：

```java
package org.lovian.reflection.proxy;

import java.lang.reflect.Proxy;

public class Test {
	public static void main(String[] args) {
		UserDao ud = new UserDaoImpl();
		System.out.println("-----original--");
		ud.add();
		ud.delete();
		ud.update();
		ud.find();

		System.out.println();
		System.out.println("-------Proxy---");

		// 使用 Proxy 类来创建一个动态代理对象
		// public static Object newProxyInstance(ClassLoader loader,Class<?>[] interfaces,InvocationHandler h)
		// 创建一个 InvacationHandler 的实现类对象， 传入 ud 作为目标对象
		MyInvocationHandler handler = new MyInvocationHandler(ud);
		// 创建代理对象，返回一个对象
		Object proxyObj = Proxy.newProxyInstance(ud.getClass().getClassLoader(), ud.getClass().getInterfaces(), handler);
		// 这个返回的对象，其实和传入的对象是同一个类型
		UserDao proxyUd = (UserDao) proxyObj;

		proxyUd.add();
		proxyUd.delete();
		proxyUd.update();
		proxyUd.find();
	}
}

```

result：

```
-----original--
add method
delete method
update method
find method

-------Proxy---
Check privilege
add method
Log Info
Check privilege
delete method
Log Info
Check privilege
update method
Log Info
Check privilege
find method
Log Info
```

由结果我们可以得知，新功能通过动态代理的方法被加入到了 UserDaoImpl 的对象中，这个是运行时加入的。

这里在使用代理对象 ```proxyUd``` 的时候，调用方法，其实是同时传入了 ```proxyUd```， 调用的方法名， 方法内的参数， 三个要素传给了 ```Handler``` 中 ```invoke``` 方法， 而在 ```Handler``` 中 invoke 方法里，使用了反射去调用这个方法，并返回原方法的期待返回值。而在用反射调用方法的时候，方法前后可以加其他的功能，就实现了 ```AOP``` 编程的思想
