---
layout: post
title:  "[JAVA_SSH] Spring 中的 IOC容器和 Bean 的配置"
date:   2018-04-06
desc: "Spring Bean 配置"
keywords: "java, spring, IOC, DI, Bean"
categories: [java, web]
---

# I. Spring 中 ICO 和 DI 的概述

## 1. IOC

```IOC```: Inversion of Control,反转控制， 其思想是反转资源获取的方向，传统的资源查找方式要求组件向容器发起请求查找资源，而作为回应，容器适时的返回资源; 而应用了 IOC 之后，则是容器主动地将资源推送给它所管理的组件，组件要做的仅仅是选择一种合适的方式来接受资源。这种行为也被称为查找的被动形式。

## 2. DI

```DI```: Dependency Injection, 依赖注入， IOC 的另一种表述方式，即组件以一些预先定义好的方式（比如 setter方法）接受来自容器的资源注入。

## 3.示例

实际上，反转控制和依赖注入表述的是一个意思，下面用图来解释传统的容器和IoC容器的区别：

![di_example](/assets/blog/2018/04/di_example.png)

如图所示，有一个类A和一个类B， A是B的一个属性，也就是B依赖于A。那么传统的方式，是声明一个a对象，一个b对象，然后通过set方法将a设置给b，建立关联关系; 而用IOC容器呢，在定义中，A和B需要通过 setter 方法来建立A和B的关联关系，所以这时候 IOC 容器会自动的将A和B关联起来，这时候只需要从IOC容器中 get B 对象就可以了，不需要再去手动建立 A 对象再set给B了

## 4. IOC 的发展过程

在写代码的时候，我们需要尽可能的降低代码的耦合度，即类与类之间的强依赖关系，来使得更加方便的维护代码。这个发展过程是这样的：

-   ***分离接口与实现***：传统的方式，由接口和对应的实现类来管理，service根据需求去创建所需要的具体实现类
-   ***采用工厂设计模式***：经典工厂设计模式，由工厂类去获得service想要的实例对象
-   ***采用反转控制***：由容器来自动给 service 注入其所需要的实例对象

# II. 配置 Bean

## 1. 配置形式

###  a. 基于 XML 文件的方式

在上一节[Spring Introduction](http://blog.lovian.org/java/web/2018/04/06/java-spring-introduction.html)中的hello world 示例中，已经用到了xml的方式去配置一个bean

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean id="helloBean" class="org.lovian.sping.bean.HelloBean">
        <property name="name" value="Sping"></property>
    </bean>

</beans>
```
-   ***class***: bean的全类名，通过反射的方式在 IOC 容器中创建 bean，所以要求 Bean 中必须有无参构造器
-   ***id***: 用来标识容器中的bean， id在IOC容器中是唯一的; 如果 id 没有被指定，那么 Spring 自动将权限定性类名作为 Bean的名字; id可以指定多个名字，名字之间可以用逗号，分号，或者空格来分隔

###  b. 基于注解的方式

## 2. Bean的配置方式

-   通过全类名反射
-   通过工厂方法（静态工厂方法和实例工厂方法）
-   通过 BeanFactory

## 3. IOC 容器 BeanFactory 和 ApplicationContext 概述

### a. Spring IOC 容器

在基于 Spring 的应用中，应用对象生存于 Spring 容器（container）中。Spring 容器负责创建对象，装配对象，配置它们并且管理它们的整个生命周期，从生存到死亡（new --> finalize）。

在 Spring IOC 容器读取 Bean 的配置来创建 Bean 实例之前，必须对容器本身进行实例化，只有在容器实例化之后，才可以从 IOC 容器中获取 Bean实例并使用

在 Spring 中提供了两种不同类型的容器实现：

- ***BeanFactory***:
    -   由 ```org.springframework.beans.factory.beanFactory``` 接口定义，是最简单的容器
    -   提供基本的 DI 支持
    -   是Spring框架的基础设施，面向Spring 本身
- ***ApplicationContext***:
    -   由```org.springframework.context.ApplicationContext``` 接口定义
    -   基于 BeanFactory 构建，提供应用框架级别的服务
    -   面向使用Spring框架的开发者
    -   比 bean 工厂更常用

### b. ApplicationContext

Sping 中，应用上下文 ApplicationContext 就是IOC容器，实际上是Spring的一个接口，在Spring中本身带有多种类型的实现类，几个常用的实现类如下：

-   ```ClassPathXmlApplicationContext```: 从类路径下的一个或者多个 XML 配置文件中加载上下文定义，把应用上下文的定义文件作为类的资源
-   ```AnnotationConfigApplicationContext```:从一个或者多个基于 Java 的配置类中加载 Spring 应用上下文
-   ```AnnotationConfigWebApplicationContext```:从一个或者多个基于 Java 的配置类中加载 Spring Web 应用上下文
-   ```FileSystemXmlApplicationContext```:从文件系统下的一个或者多个 XML 配置文件中加载上下文定义
-   ```XmlWebApplicationContext```:从 Web 应用下的一个或者多个 XML 配置文件中加载上下文定义


在ApplicationContext准备就绪之后，我们就可以调用 ApplicationContext的 ***getBean()*** 方法从Spring 容器中获取 bean 对象了

## 4. 依赖注入的方式

-   属性注入
-   构造器注入
-   工厂方法注入（很少使用）

### a. 属性注入

-   属性注入即通过 ***setter*** 方法注入 Bean 的属性值或依赖的对象
-   属性注入使用 ```<property>``` 元素，使用 ```name``` 属性指定 Bean 的属性名称， ```value``` 属性或者 ```<value>```子节点指定属性值
-   属性注入是实际应用中最常用的注入方式  

### b. 构造方法注入

-   通过构造方法注入 Bean 的属性值或者依赖的对象，它保证了 Bean 实例在实例化后就可以使用
-   构造器注入在 ```<constructor-arg>```元素里声明属性，注意```<constructor-arg>```中没有name属性

使用构造方法注入示例：
首先创建一个类 Car，创建4个属性和有参构造器

```java
package org.lovian.sping.bean;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Car {
    private String brand;
    private String model;
    private String price;
    private String maxSpeed;

    public Car(String brand, String model, String price, String maxSpeed) {
        this.brand = brand;
        this.model = model;
        this.price = price;
        this.maxSpeed = maxSpeed;
    }

    @Override
    public String toString() {
        return "Car{" +
                "brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", price='" + price + '\'' +
                ", maxSpeed='" + maxSpeed + '\'' +
                '}';
    }
}

```

然后在 xml 配置文件中，以 constructor-arg 的方式声明一个 Car 的 bean

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="org.lovian.sping.bean.Car">
        <constructor-arg value="AUDI"></constructor-arg>
        <constructor-arg value="A6L"></constructor-arg>
        <constructor-arg value="480000"></constructor-arg>
        <constructor-arg value="220"></constructor-arg>
    </bean>
</beans>
```

然后通过 ```getBean(Class.class)```方式去获得这个bean


```java
package org.lovian.sping.demo;

import org.lovian.sping.bean.Car;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Demo {
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");
 
        Car car = applicationContext.getBean(Car.class);
        System.out.println(car.toString());

    }
}

```

打印出的结果如下：

```
Apr 07, 2018 4:04:11 PM org.springframework.context.support.AbstractApplicationContext prepareRefresh
INFO: Refreshing org.springframework.context.support.ClassPathXmlApplicationContext@619a5dff: startup date [Sat Apr 07 16:04:11 CST 2018]; root of context hierarchy
Apr 07, 2018 4:04:11 PM org.springframework.beans.factory.xml.XmlBeanDefinitionReader loadBeanDefinitions
INFO: Loading XML bean definitions from class path resource [config/application_context.xml]
Car{brand='AUDI', model='A6L', price='480000', maxSpeed='220'}

Process finished with exit code 0
```

我们可以看到在 xml 文件中声明的属性值都被打印了出来，说明这个bean被成功的取到了。

```注意！```如果通过 class 去获得bean， 那么在xml配置中，这个class对应的bean只能有一个，如果由多个，那么只能使用 id 的方式去获取这个bean。

但是对于一个Bean类来说，是可以由多个构造器的，也就是构造方法重载，那仅仅通过构造器参数的顺序去给每一个参数赋值，就有可能造成歧义，容器不知道把哪个值赋给哪个参数，那么这时候就可以通过```constructor-arg``` 的 ```index``` 属性和 ```type```属性来规定我们声明参数的顺序，示例如下：

我们修改一下 Car 这个类，给两个构造器
```java
package org.lovian.sping.bean;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Car {
    private String brand;
    private String model;
    private int price;
    private double maxSpeed;

    public Car(String brand, String model, int price) {
        this.brand = brand;
        this.model = model;
        this.price = price;
    }

    public Car(String brand, String model, double maxSpeed) {
        this.brand = brand;
        this.model = model;
        this.maxSpeed = maxSpeed;
    }

    @Override
    public String toString() {
        return "Car{" +
                "brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", price='" + price + '\'' +
                ", maxSpeed='" + maxSpeed + '\'' +
                '}';
    }
}
```
然后在 application_context.xml 中定义两个 bean， 使用```index```和```type```去声明构造器参数的顺序使得两个bean使用不同的构造方法

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="Audi A6L" class="org.lovian.sping.bean.Car">
        <constructor-arg value="AUDI" index="0"></constructor-arg>
        <constructor-arg value="A6L" index="1"></constructor-arg>
        <constructor-arg value="220" type="double"></constructor-arg>
    </bean>
    <bean id="BMW 525" class="org.lovian.sping.bean.Car">
        <constructor-arg value="BMW" type="java.lang.String"></constructor-arg>
        <constructor-arg value="525" type="java.lang.String"></constructor-arg>
        <constructor-arg value="400000" type="int"></constructor-arg>
    </bean>
</beans>
```
执行 main 方法

```java
package org.lovian.sping.demo;

import org.lovian.sping.bean.Car;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Demo {
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");

        Car audi = (Car) applicationContext.getBean("Audi A6L");
        System.out.println(audi.toString());
        Car bmw = (Car) applicationContext.getBean("BMW 525");
        System.out.println(bmw.toString());

    }
}
```

结果如下

```
Apr 07, 2018 4:40:49 PM org.springframework.context.support.AbstractApplicationContext prepareRefresh
INFO: Refreshing org.springframework.context.support.ClassPathXmlApplicationContext@619a5dff: startup date [Sat Apr 07 16:40:49 CST 2018]; root of context hierarchy
Apr 07, 2018 4:40:49 PM org.springframework.beans.factory.xml.XmlBeanDefinitionReader loadBeanDefinitions
INFO: Loading XML bean definitions from class path resource [config/application_context.xml]
Car{brand='AUDI', model='A6L', price='0', maxSpeed='220.0'}
Car{brand='BMW', model='525', price='400000', maxSpeed='0.0'}

Process finished with exit code 0
```

## 5. 注入属性值的细节

### a.字面值

-   ```字面值```：可以用字符串表示的值，可以通过```<value>```元素标签或者```value```属性进行注入
-   ```基本数据类型及其封装类、String 等类型都可以采取字面值注入的方式```
-   如果字面值中包含特殊字符，可以使用```<![CDATA[]]>```把字面值包裹起来

那我们对上一节的 Car 的例子中的 xml 文件做一下修改，让其中一个 String 值包含左右尖括号，它们在 xml 中属于特殊字符，那么就用使用 ```<![CDATA[]]>```将这个值括起来， 否则就会报错

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="Audi A6L" class="org.lovian.sping.bean.Car">
        <constructor-arg value="AUDI" index="0"></constructor-arg>
        <constructor-arg value="A6L" index="1"></constructor-arg>
        <constructor-arg value="220" type="double"></constructor-arg>
    </bean>
    <bean id="BMW 525" class="org.lovian.sping.bean.Car">
        <constructor-arg type="java.lang.String">
            <value>BWM</value>
        </constructor-arg>
        <constructor-arg type="java.lang.String">
            <!-- include special character "<" and ">", use <![CDATA[xxxxx]]> -->
            <value><![CDATA[<525>]]></value>
        </constructor-arg>
        <constructor-arg type="int">
            <value>400000</value>
        </constructor-arg>
    </bean>
</beans>
```

### b. 引用其他的 bean

通过 value 字面值我们可以给bean的设置一些标准类型属性的值，那么如果 bean 和 bean 之间存在着引用关系，这又该怎么处理呢？

-   组成应用程序的 Bean 经常需要相互写作以完成应用程序的功能，要使得 Bean 能够相互访问，就必须在 Bean 配置文件中指定对 Bean 的引用
-   在 Bean 的配置文件中，可以通过 ```<ref>``` 元素或者 ```ref```属性为 Bean的属性或者构造器参数指定对 Bean 的引用
-   当Bean 实例仅仅给一个特定属性使用时，可将其声明为```内部 Bean```
    -  在```属性或者构造器中包含 Bean 的声明```
    -  内部 Bean 声明直接包含在```<property>```或者```<constructor-arg>```元素里
    -   不需要设置任何 id 或者 name 属性 
    -   ```内部 Bean 不能被外部引用```，只能在内部使用


来做个示例，代码如下：

定义一个 Person 类，包含 Car 的引用

```java
package org.lovian.sping.bean;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Person {
    private String name;
    private int age;
    private Car car;

    public Person() {
    }

    public Person(String name, int age, Car car) {
        this.name = name;
        this.age = age;
        this.car = car;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age='" + age + '\'' +
                ", car=" + car +
                '}';
    }
}
```

然后我们在application_context.xml中加入 Person类的 bean

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="Audi A6L" class="org.lovian.sping.bean.Car">
        <constructor-arg value="AUDI" index="0"></constructor-arg>
        <constructor-arg value="A6L" index="1"></constructor-arg>
        <constructor-arg value="220" type="double"></constructor-arg>
    </bean>

    <bean id="BMW 525" class="org.lovian.sping.bean.Car">
        <constructor-arg type="java.lang.String">
            <value>BWM</value>
        </constructor-arg>
        <constructor-arg type="java.lang.String">
            <!-- include special character "<" and ">", use <![CDATA[xxxxx]]> -->
            <value><![CDATA[<525>]]></value>
        </constructor-arg>
        <constructor-arg type="int">
            <value>400000</value>
        </constructor-arg>
    </bean>

    <bean id="lovian" class="org.lovian.sping.bean.Person">
        <constructor-arg type="java.lang.String">
            <value>Lovian</value>
        </constructor-arg>
        <constructor-arg type="int">
            <value>25</value>
        </constructor-arg>
        <constructor-arg type="org.lovian.sping.bean.Car">
            <!--use ref tag-->
            <ref bean="BMW 525"></ref>
        </constructor-arg>
    </bean>

    <bean id="zhshpeng" class="org.lovian.sping.bean.Person">
        <property name="name">
            <value>zhshpeng</value>
        </property>
        <property name="age">
            <value>24</value>
        </property>
        <!-- use ref attribute -->
        <property name="car" ref="Audi A6L"></property>
    </bean>

</beans>
```

然后执行代码

```java
package org.lovian.sping.demo;

import org.lovian.sping.bean.Car;
import org.lovian.sping.bean.Person;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Demo {
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");

        Person lovian = (Person) applicationContext.getBean("lovian");
        System.out.println(lovian.toString());

        Person zhshpeng = (Person) applicationContext.getBean("zhshpeng");
        System.out.println(zhshpeng.toString());
    }
}

```

结果如下：

```
Apr 07, 2018 5:24:21 PM org.springframework.context.support.AbstractApplicationContext prepareRefresh
INFO: Refreshing org.springframework.context.support.ClassPathXmlApplicationContext@619a5dff: startup date [Sat Apr 07 17:24:21 CST 2018]; root of context hierarchy
Apr 07, 2018 5:24:21 PM org.springframework.beans.factory.xml.XmlBeanDefinitionReader loadBeanDefinitions
INFO: Loading XML bean definitions from class path resource [config/application_context.xml]
Person{name='Lovian', age='25', car=Car{brand='BWM', model='<525>', price='400000', maxSpeed='0.0'}}
Person{name='zhshpeng', age='24', car=Car{brand='AUDI', model='A6L', price='0', maxSpeed='220.0'}}
```

我们可以看到，在使用了 ```ref``` 属性或者 ```<ref>```标签之后，是可以将 Car 的 bean 对象和 Person 的 bean 对象建立起引用关系。

Bean的配置是可以嵌套的，下面我们演示一些```内部 Bean```的声明，我们在上面的 aplication_context.xml 中加入一个bean的声明：在一个 Person Bean 中，直接声明一个 Car Bean。

```xml
    <bean id="sq" class="org.lovian.sping.bean.Person">
        <property name="name" value="sq"/>
        <property name="age" value="23"/>
        <property name="car">
            <bean class="org.lovian.sping.bean.Car">
                <constructor-arg value="Tesla" type="java.lang.String"/>
                <constructor-arg value="S3" type="java.lang.String"/>
                <constructor-arg value="700000" type="int"/>
            </bean>
        </property>
    </bean>
```

然后在main方法中获取这个 bean

```java
public class Demo {
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");

        Person lovian = (Person) applicationContext.getBean("lovian");
        System.out.println(lovian.toString());

        Person zhshpeng = (Person) applicationContext.getBean("zhshpeng");
        System.out.println(zhshpeng.toString());

        Person sq = (Person) applicationContext.getBean("sq");
        System.out.println(sq.toString());
    }
}
```

我们可以看到结果如下：

```
Apr 07, 2018 5:35:26 PM org.springframework.context.support.AbstractApplicationContext prepareRefresh
INFO: Refreshing org.springframework.context.support.ClassPathXmlApplicationContext@619a5dff: startup date [Sat Apr 07 17:35:26 CST 2018]; root of context hierarchy
Apr 07, 2018 5:35:26 PM org.springframework.beans.factory.xml.XmlBeanDefinitionReader loadBeanDefinitions
INFO: Loading XML bean definitions from class path resource [config/application_context.xml]
Person{name='Lovian', age='25', car=Car{brand='BWM', model='<525>', price='400000', maxSpeed='0.0'}}
Person{name='zhshpeng', age='24', car=Car{brand='AUDI', model='A6L', price='0', maxSpeed='220.0'}}
Person{name='sq', age='23', car=Car{brand='Tesla', model='S3', price='700000', maxSpeed='0.0'}}

Process finished with exit code 0
```

### c. null 值和级联属性

-   可以使用专用的 ```<null/>``` 元素标签为 Bean 的字符串或者其他对象类型的属性注入 null 值（但实际java引用对象的默认值就是 null，所以意义不大）
-   和 Structs、Hibernate 框架一样， ```Spring 支持级联属性的配置```;为级联属性赋值，属性必须先要初始化后，才可以为级联属性赋值

下面是级联属性配置的例子，在上面的例子中，Car的构造器只有三个参数，那么我们在配置 Person bean的时候，给其引用的 Car bean 另外一个属性赋值，xml实例如下，我们修改一些 zhshpeng 这个bean，给它加入 ```car.maxSpeed```：

```xml
    <bean id="zhshpeng" class="org.lovian.sping.bean.Person">
        <property name="name">
            <value>zhshpeng</value>
        </property>
        <property name="age">
            <value>24</value>
        </property>
        <!-- use ref attribute -->
        <property name="car" ref="Audi A6L"></property>
        <property name="car.maxSpeed">
            <value>250</value>
        </property>
    </bean>
```

```注意```：
-   必须要先在 person bean 中声明 car bean，才能给 car 的属性赋值
-   如果不先声明 car bean，那么Spring不会自动创建一个 car 的 bean 对象，会报错 
-   在 Person 类中必须要由 car 属性的 getter 方法，并且 Car 类中要有 maxSpeed 的 setter 方法才可以，否则会报错。

执行结果如下：

```
Person{name='zhshpeng', age='24', car=Car{brand='AUDI', model='A6L', price='0', maxSpeed='250.0'}}
```

### d.集合属性
在 Java 中集合有 Collection 和 Map，同样的 Spring 也支持集合属性，在 Spring中可以通过一组内置的 xml 标签(例如: ```<list>```, ```<set>``` 或 ```<map>```) 来配置集合属性

***对于 List， Array 和 Set的集合属性：***

-   配置 ```java.util.List``` 类型的属性, 需要指定 ```<list>```  标签, 在标签里包含一些元素. 这些标签可以通过 ```<value>``` 指定简单的常量值, 通过 ```<ref>``` 指定对其他 Bean 的引用. 通过 ```<bean>``` 指定内置 Bean 定义. 通过 ```<null/>``` 指定空元素. 甚至可以内嵌其他集合.
-   数组 ```Array``` 的定义和 ```List``` 一样, 都使用 ```<list>```
-   配置 ```java.util.Set``` 需要使用 ```<set>``` 标签, 定义元素的方法与 List 一样.

集合属性示例如下，先重新写一个类 Person, 包括了一个 ```List<Car>```成员变量：

```java
package org.lovian.sping.bean.collections;

import org.lovian.sping.bean.Car;

import java.util.List;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class Person {
    private String name;
    private int age;
    private List<Car> cars;

    public Person() {

    }

    public Person(String name, int age, List<Car> cars) {
        this.name = name;
        this.age = age;
        this.cars = cars;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public List<Car> getCars() {
        return cars;
    }

    public void setCars(List<Car> cars) {
        this.cars = cars;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", cars=" + cars +
                '}';
    }
}
```

那么接下来就需要在 application_context.xml 中配置这个 Person 类的bean，并让它拥有两个我们之前配置好的 Car bean 对象

```xml
    <bean id="Tom" class="org.lovian.sping.bean.collections.Person">
        <property name="name" value="Tom" />
        <property name="age" value="18"/>
        <property name="cars">
            <list>
                <ref bean="BMW 525"/>
                <ref bean="Audi A6L"/>
            </list>
        </property>
    </bean>
```

执行 main 方法：

```java
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");

        Person tom = (Person) applicationContext.getBean("Tom");
        System.out.println(tom.toString());
    }
```

打印结果如下：

```
Person{name='Tom', age=18, cars=[Car{brand='BWM', model='<525>', price='400000', maxSpeed='0.0'}, Car{brand='AUDI', model='A6L', price='0', maxSpeed='250.0'}]}
```

从这个结果来看，我们用了 ```<list>```来给 Person 类中 ```List<Car>``` 成员变量添加了两个值。但实际上我们并没有显式的让这个成员变量初始化，Spring 自动的给 new 出了一个 List 对象，并把关联的两个 Car 对象添加了进去。


***对于 Map 和 Properties 的集合属性：***

-   ```Java.util.Map``` 通过 ```<map>``` 标签定义, ```<map>``` 标签里可以使用多个 ```<entry>``` 作为子标签. 每个条目包含一个键和一个值 
-   必须在 ```<key>``` 标签里定义键
-   因为键和值的类型没有限制, 所以可以自由地为它们指定 ```<value>```, ```<ref>```, ```<bean>``` 或 ```<null/>``` 元素
-   可以将 Map 的键和值作为 ```<entry>``` 的属性定义: 简单常量使用 ```key``` 和 ```value``` 来定义; Bean 引用通过 ```key-ref``` 和 ```value-ref``` 属性定义
-   使用 ```<props```> 定义 ```java.util.Properties```, 该标签使用多个 ```<props>``` 作为子标签. 每个 ```<property>``` 标签必须定义 key 属性

示例如下，同样新建一个包含 Map 成员变量的 MapPerson 类：

```java
package org.lovian.sping.bean.collections;

import org.lovian.sping.bean.Car;

import java.util.Map;

/**
 * Author: PENG Zhengshuai
 * Date: 4/8/18
 * lovian.org
 */
public class MapPerson {
    private String name;
    private int age;

    private Map<String, Car> cars;

    public MapPerson() {
    }

    public MapPerson(String name, int age, Map<String, Car> cars) {
        this.name = name;
        this.age = age;
        this.cars = cars;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Map<String, Car> getCars() {
        return cars;
    }

    public void setCars(Map<String, Car> cars) {
        this.cars = cars;
    }

    @Override
    public String toString() {
        return "MapPerson{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", cars=" + cars +
                '}';
    }
}

```

接下来就在application_context.xml中添加 MapPerson bean的定义：

```xml
<bean id="Jerry" class="org.lovian.sping.bean.collections.MapPerson">
        <property name="name" value="Jerry"/>
        <property name="age" value="17"/>
        <property name="cars">
            <map>
                <entry key="First Car" value-ref="Audi A6L"/>
                <entry key="Second Car" value-ref="BMW 525"/>
            </map>
        </property>
    </bean>
```

我们在 Map 中定义了两条 entry， key 是一个 String， 而 value 则是一个 bean 的引用，执行一下 main 方法看看结果：

```java
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");

        MapPerson jerry = (MapPerson) applicationContext.getBean("Jerry");
        System.out.println(jerry.toString());
    }
```

结果如下：

```
MapPerson{name='Jerry', age=17, cars={First Car=Car{brand='AUDI', model='A6L', price='0', maxSpeed='250.0'}, Second Car=Car{brand='BWM', model='<525>', price='400000', maxSpeed='0.0'}}}
```

我们可以看到和 List 的示例一样，Map 被初始化且添加了两个键值对。而对于```java.util.Properties```用法和```java.util.Map```相似，xml示例如下：

```xml
<bean id="properties" class="xxxxxxx">
    <property name="properties">
        <props>
            <prop key="user">root</prop>
            <prop key="password">pna</prop>
        </props>
    </property>
</bean>
```

### e.使用  Utility Schema 定义集合

由于使用基本的集合标签定义集合时, 不能将集合作为独立的 ```Bean``` 定义, 导致其他 ```Bean``` 无法引用该集合, 所以无法在不同 ```Bean``` 之间共享集合.就如上小节的例子中，我们在 Person 或者是 MapPerson 的 bean 中定义了集合的成员变量，但这些集合是无法被其他 bean 所引用的，如果由其他类需要引用这些集合，那怎么处理？

可以使用 ```utility schema``` 里的集合标签定义独立的集合 ```Bean```. 需要注意的是, 必须在 ```<beans>``` 根元素里添加 ```utility schema``` 定义。通俗的来说，就是把我们之前定义的那些集合单独拿出来，当作一个 bean 来配置，也就是说，我们```需要配置单例的集合 bean，从而供多个 bean 进行引用```

示例如下，我们在 application_context.xml 中添加一个 ```util:list``` 和一个集合 Person bean

```xml
    <util:list id="bba-cars">
        <ref bean="BMW 525"/>
        <ref bean="Audi A6L"/>
        <bean id="Benz C200" class="org.lovian.sping.bean.Car">
            <constructor-arg value="BENZ" type="java.lang.String"/>
            <constructor-arg value="C200" type="java.lang.String"/>
            <constructor-arg value="240"  type="double"/>
            <property name="price" value="300000"/>
        </bean>
    </util:list>

    <bean id="Jack" class="org.lovian.sping.bean.collections.Person">
        <property name="name" value="Jack" />
        <property name="age" value="23"/>
        <property name="cars">
            <ref bean="bba-cars"/>
        </property>
    </bean>
```

这里我们可以看到，Person中本来应该设置 ```List<Car>``` 的地方，我们引用了上面 ```util:list``` 定义的 bean，执行一些 main 方法得到结果如下：

```
Person{name='Jack', age=23, cars=[Car{brand='BWM', model='<525>', price='400000', maxSpeed='0.0'}, Car{brand='AUDI', model='A6L', price='0', maxSpeed='250.0'}, Car{brand='BENZ', model='C200', price='300000', maxSpeed='240.0'}]}
```


## 6. 使用 p 命名空间

为了简化 XML 文件的配置，越来越多的 XML 文件采用属性而非子元素配置信息。从 Sping 2.5 版本开始引入了一个新的 ```p 命名空间（p namespace）```，可以通过 ```<bean>``` 元素属性的方式来配置 Bean 的属性，我们可以可以把上面那个 ```Jack``` 那个 bean 改写成如下方式：

```xml
<bean id="Rose" class="org.lovian.sping.bean.collections.Person" p:name="Rose" p:age="22" p:cars-ref="bba-cars"/>
```