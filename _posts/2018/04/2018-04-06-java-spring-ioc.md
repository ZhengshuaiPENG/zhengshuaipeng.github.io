---
layout: post
title:  "[JAVA_Spring] Spring IOC 容器"
date:   2018-04-06
desc: "Spring IOC 容器"
keywords: "java, spring"
categories: [java, spring]
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

## 5. Spring IOC 容器

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

### 6. ApplicationContext

Sping 中，应用上下文 ApplicationContext 就是IOC容器，实际上是Spring的一个接口，在Spring中本身带有多种类型的实现类，几个常用的实现类如下：

-   ```ClassPathXmlApplicationContext```: 从类路径下的一个或者多个 XML 配置文件中加载上下文定义，把应用上下文的定义文件作为类的资源
-   ```AnnotationConfigApplicationContext```:从一个或者多个基于 Java 的配置类中加载 Spring 应用上下文
-   ```AnnotationConfigWebApplicationContext```:从一个或者多个基于 Java 的配置类中加载 Spring Web 应用上下文
-   ```FileSystemXmlApplicationContext```:从文件系统下的一个或者多个 XML 配置文件中加载上下文定义
-   ```XmlWebApplicationContext```:从 Web 应用下的一个或者多个 XML 配置文件中加载上下文定义


在ApplicationContext准备就绪之后，我们就可以调用 ApplicationContext的 ***getBean()*** 方法从Spring 容器中获取 bean 对象了
