---
layout: post
title:  "[JAVA_SSH] Spring 简介"
date:   2018-04-06
desc: "Spring 框架简介"
keywords: "java, spring"
categories: [java, web]
---

# I. Spring 简介

Spring  是一个java 的开源框架，用来解决企业级应用开发而创建的，目的是为了简化Java的开发。使用 Spring 可以使简单的 JavaBean 实现以前只有 EJB 才能实现的功能。项目网站： [sping.io](http://spring.io/)

## 1.Spring 具体描述

Spring 特性：
-	***轻量级***： 基于 POJO 的轻量级和最小侵入式编程
-	***依赖注入***：DI - dependency injection, IOC
-	***面向切面编程***: AOP - aspect oriented programming
-	***容器***: spring 是一个容器，它包含并管理应用对象的生命


## 2. Spring 模块

Spring 模块图如下所示：
![Spring-Model](/assets/blog/2018/04/spring_model.png)

# II. Sping Hello World 示例

首先在IDE中创建一个简单的maven项目，叫做spring-demo，结构大概如下：

```
spring-demo
    -src
	  -main
	    -java
		  -org.lovian.spring.bean
		  -org.lovian.spring.demo
		-resources
		  -config
	  -test
	    -java
		-resources
	pom.xml
```



在 *pom.xml* 定义中加入 Sping Framework 的依赖，maven 依赖可以在[https://projects.spring.io/spring-framework/](https://projects.spring.io/spring-framework/) 这里找到，复制粘贴到 pom.xml里，pom 文件如下所示

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.lovian</groupId>
    <artifactId>spring-demo</artifactId>
    <version>1.0-SNAPSHOT</version>


    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
    </dependencies>
</project>
```

然后创建一个java bean 类 ***HelloBean***，代码如下：

```java
package org.lovian.sping.bean;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class HelloBean {

    private String name;

    public void setName(String name) {
        this.name = name;
    }

    public void sayHello(){
        System.out.println("Hello: " + name);
    }
}

```

在这个Bean中定义了一个属性 name， 定义了一个 setter 方法和 sayHello 方法。对于一般的java程序来说，我们通过 new HelloBean() 可以得到一个helloBean 的对象，并且给他set一个name属性，再调用 sayHello() 方法，则会打印出相应的结果。

而spring框架，本身就可以用一个容器去管理 java bean，那我们用 xml 的方式，去配置这个bean。 首先要新建一个 ***spring config xml*** 文件： ```config/application_context.xml"```,在里面生明一个bean对象，如下所示：

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

这个config文件里，```<beans></beans>``` 中定义了所有要管理的bean对象， 用```<bean></bean>```表示. ```class```表示这个bean对象所对应的类，```id``` 则是给这个bean起的名字。```<property></property>```标签中定义了这个bean的属性的值，对应到HelloBean class中的属性，给 ```name``` 属性赋值 ```Spring```。

然后我们写一个main方法去测试它，代码如下：

```java
package org.lovian.sping.demo;

import org.lovian.sping.bean.HelloBean;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/7/18
 * lovian.org
 */
public class HelloWorld {
    public static void main(String[] args) {
        ApplicationContext applicationContext = new ClassPathXmlApplicationContext("config/application_context.xml");
        HelloBean helloBean = (HelloBean)applicationContext.getBean("helloBean");
        helloBean.sayHello();
    }
}

```

代码中，先声明了一个 spring 的容器对象 ```ApplicationContext```， 这个对象加载了我们刚刚定义的 xml 文件，然后从这个容器对象中拿到我们定义的helloBean这个bean，并执行 sayHello 方法，结果如下：

```
Apr 07, 2018 12:16:36 AM org.springframework.context.support.AbstractApplicationContext prepareRefresh
INFO: Refreshing org.springframework.context.support.ClassPathXmlApplicationContext@619a5dff: startup date [Sat Apr 07 00:16:36 CST 2018]; root of context hierarchy
Apr 07, 2018 12:16:36 AM org.springframework.beans.factory.xml.XmlBeanDefinitionReader loadBeanDefinitions
INFO: Loading XML bean definitions from class path resource [config/application_context.xml]
Hello: Sping

Process finished with exit code 0
```

可以在结果中看到，我们定义在xml中的 helloBean 对象 name 属性的值 ```Spring``` 被打印了出来