---
layout: post
title:  "[JAVA_Spring] Spring 中 Bean 之间的关系以及作用域"
date:   2018-04-08
desc: "Spring Bean relation and scope"
keywords: "java, spring, Bean Relation, Bean Scope"
categories: [java, web, spring]
---

# I. Bean 之间的关系

Bean 之间的关系分为```继承关系```和```依赖关系```

## 1.继承 Bean 配置
这里继承并不是指的面向对象的父子类继承，而是指的 bean 配置上的继承

-   Spring 允许继承 bean 的配置，使用 ```parent``` 属性, 被继承的 bean 称为```父 bean```. 继承这个父 Bean 的 Bean 称为```子 Bean```
-   子 Bean 从父 Bean 中继承配置, 包括 Bean 的属性配置
-   子 Bean 也```可以覆盖```从父 Bean 继承过来的配置
-   父 Bean 可以作为配置模板, 也可以作为 Bean 实例. 若只想把父 Bean 作为模板, 可以设置 ```<bean>``` 的 ```abstract``` 属性为 ```true```, 这样 Spring 将不会实例化这个 Bean
-   并不是 ```<bean>``` 元素里的所有属性都会被继承. 比如: ```autowire```, ```abstract``` 等.
-   也可以```忽略父 Bean 的 class 属性```, 让子 Bean 指定自己的类, 而共享相同的属性配置. 但此时 ```abstract``` 必须设为 ```true```

### a. 继承示例

来个示例，新建一个 spring xml 配置文件，```relation_beans.xml```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="Audi A6" class="org.lovian.spring.bean.Car"  p:maxSpeed="250" >
        <constructor-arg value="Audi" />
        <constructor-arg value="A6L"/>
        <constructor-arg value="50000" type="int"/>
    </bean>

    <bean id="father" class="org.lovian.spring.bean.Person" p:name="Wang Jianlin" p:age="60" p:car-ref="Audi A6"/>

    <bean id="son" class="org.lovian.spring.bean.Person" parent="father" p:name="Wang Sicong" p:age="30" />
</beans>
```

正常的先声明了一个 Person bean father，然后我们再声明一个 Person bean son，使用 ```parent``` 标签，继承 father bean，然后覆盖 name 属性和 age 属性，执行 main 方法：

```java
package org.lovian.spring.demo;

import org.lovian.spring.bean.Person;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/9/18
 * lovian.org
 */
public class RelationDemo {
    public static void main(String[] args) {
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/relation_beans.xml");
        Person father = (Person) actx.getBean("father");
        System.out.println(father);

        Person son = (Person) actx.getBean("son");
        System.out.println(son);
    }
}
```

执行结果如下：

```
Person{name='Wang Jianlin', age='60', car=Car{brand='Audi', model='A6L', price='50000', maxSpeed='250.0'}}
Person{name='Wang Sicong', age='30', car=Car{brand='Audi', model='A6L', price='50000', maxSpeed='250.0'}}
```

从结果中我们看到，son 继承了 father 的 Audi A6

### b. 抽象 bean

前文提到了父 bean 可以做模板，使用 ```abstract``` 标签，也就是说，当一个 bean 的 ```abstract``` 属性设置为 ```true``` 的时候，这个 bean 就是一个```抽象 bean```。 ```抽象 bean 不可以被实例化```，只能被继承配置

比如我们把 father bean 定义成抽象 bean

```xml
    <bean id="father" class="org.lovian.spring.bean.Person" p:name="Wang Jianlin" p:age="60" p:car-ref="Audi A6" abstract="true"/>

    <bean id="son" class="org.lovian.spring.bean.Person" parent="father" p:name="Wang Sicong" p:age="30" />
```

这个时候， 就只能得到 son 这个 bean 的实例。

同时，如果一个 bean 的 class 属性没有被指定，那么一定要设置这个 bean 是一个抽象 bean


## 2. 依赖 Bean 配置

Bean 和 Bean 之间存在依赖关系，比如说 Bean A 依赖于 Bean B, 那么我们就可以在 xml 中配置 bean 的依赖

-   Spring 允许用户通过 ```depends-on``` 属性设定 Bean 前置依赖的Bean，前置依赖的 Bean 会在本 Bean 实例化之前创建好
-   如果前置依赖于多个 Bean，则可以通过逗号 ```(,)```，空格 ```( )```的方式配置 Bean 的名称
    -   如果被依赖的bean的 id 中包含空格，那么我们可以使用```<alias>```标签来避免报错
-   如果配置了依赖 bean， 而

在前面的例子中， father bean 中引用了一个 car bean，那么如果我们需要 father bean 中必须有特定的 car bean， 那么我们可以将 这个 bean 配置成 father bean 的依赖; 相应的，这个特定的 car bean 必须要存在于 xml 配置中，否则会报错

```xml
    <bean id="Audi A6" class="org.lovian.spring.bean.Car"  p:maxSpeed="250" >
        <constructor-arg value="Audi" />
        <constructor-arg value="A6L"/>
        <constructor-arg value="50000" type="int"/>
    </bean>
    <!-- use alias to avoid white space in bean name(id) -->
    <alias name="Audi A6" alias="Audi_A6" />

    <bean id="father" class="org.lovian.spring.bean.Person" p:name="Wang Jianlin" p:age="60" p:car-ref="Audi A6" depends-on="Audi_A6"/>

    <bean id="son" class="org.lovian.spring.bean.Person" parent="father" p:name="Wang Sicong" p:age="30" />
```


# II. Bean 的作用域（Scope）

什么是 Bean 的作用域呢？

默认情况下，我们在 xml 中配置的 bean 在 IOC 容器中```默认是单例(singleton)```的，也就是说 IOC 容器只会创建一个 bean 对象实例，而每次调用 ```ApplicationContext``` 去调用 ```getBean()``` 方法，返回的都是同一个 bean 对象。那么这个 bean 的作用域就是 ```singleton```，它是所有 Bean 的```默认作用域```

在 Spring 的 xml 配置中，我们可以在 ```<bean>``` 元素中的 ```scope``` 属性来配置 bean 的作用域：

-   ```singleton```： 
    -   在 Spring IOC 容器初始化时创建bean 的实例
    -   在整个容器的生命周期内只创建这一个 Bean 的实例，以单例的方式存在
-   ```prototype```： 
    -   在容器初始化时，不会创建 Bean 的实例
    -   每次调用 ```getBean()```的时候，都会返回一个新的实例
-   ```request```： 
    -   每次 HTTP 请求，都会创建一个新的 Bean 实例
    -   该作用域仅适用于 ```WebApplicationContext``` 环境
-   ```session```：
    -   同一个 HTTP session 共享一个 bean，不同的 HTTP session 使用不同的 bean
    -   该作用域仅适用于 ```WebApplicationContext``` 环境

