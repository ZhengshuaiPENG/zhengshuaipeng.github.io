---
layout: post
title:  "[JAVA_Spring] Spring 中使用外部属性文件以及 SPEL"
date:   2018-04-09
desc: "Spring Bean relation and scope"
keywords: "java, spring, Bean, 外部属性文件， SPEL"
categories: [java, web, spring]
---

# I. 使用外部属性文件

从一般的开发可维护性角度来说，一些类似于数据库信息的配置文件，不应该被直接写进 java 类中，而是应该使用配置文件的方式，一方面，在配置文件需要改动的时候，我们并不需要去修改代码，直接修改配置文件即可，非常灵活;另外一方面，这也大大降低了出错的概率。

同理，在 Spring bean 的 xml 配置中， 这些信息也不应该被写进 xml 中，也应该放在配置文件里，Spring 提供了外部属性文件的方式，去加载配置的属性

-   在配置文件里配置 Bean 时, 有时需要在 Bean 的配置里混入系统部署的细节信息(例如: ```文件路径, 数据源 DataSource配置信息```等). 而这些```部署细节实际上需要和 Bean 配置相分离```
-   Spring 提供了一个 ```PropertyPlaceholderConfigurer``` 的 ```BeanFactory``` 后置处理器, 这个处理器允许用户将 Bean 配置的部分内容外移到属性文件中. 可以在 Bean 配置文件里使用形式为 ```${var}``` 的变量, ```PropertyPlaceholderConfigurer``` 从属性文件里加载属性, 并使用这些属性来替换变量.
-   Spring 还允许在属性文件中使用 ```${propName}```，以实现属性之间的相互引用。

举个例子，如果我们要配置一个数据库的 DataSource， 用 bean 的写法应该是类似于下面这种：

```xml
<bean id="dbDataSource" class="org.lovian.spring.db.DataSource">
    <property name="user" value="root"/>
    <property name="password" value="1234"/>
    <property name="driver" value="com.mysql.jdbc.driver"/>
    <property name="url" value="jdbc:mysql://test">
</bean>
```
这是一个普通的 Spring 单例 bean，value都是直接被写死的。能够从 ApplicationContext 中得到这个 dataSource 的实例。使用配置文件的方式，我们在 classpath 中，加入一个配置文件 ```resources/config/host.properties```

```
user=root
password=1234
driver=com.mysql.jdbc.driver
url=jdbc:mysql://test
```

这个时候我们就可以用 Spring 提供的方式去加载这个配置：

```xml
<!-- import property file -->
<context:property-placeholder location="classpath:host.properties">

<bean id="dbDataSource" class="org.lovian.spring.db.DataSource">
    <property name="user" value="${user}"/>
    <property name="password" value="${password}"/>
    <property name="driver" value="${driver}"/>
    <property name="url" value="${url}">
</bean>
```
这样 bean 生成的时候， value 值就根据 properties 文件中定义的来取。如果配置文件发生变化，我们也不需要去修改 xml 文件了


# II. SPEL

SPEL， Spring 表达式语言(```Spring Expression Language```), 是一个支持运行时查询和操作对象图的强大的表达式语言。

-   语法类似于 ```EL```， 使用 ```#{...}``` 作为界定符，所有在花括号中的字符都被解析成 SPEL
-   SPEL 为 bean 的属性进行动态赋值提供了便利

通过 SPEL 可以实现：
-   通过 bean 的 id 对 bean 对象进行引用
-   调用方法以及引用对象的属性
-   计算表达式的值
-   正则表达式的匹配   


## 1. SPEL 字面量

字面量的表示：
-   整数：```<property name="count" value="#{5}"/>```
-   小数：```<property name="frequency" value="#{89.7}"/>```
-   科学计数法：```<property name="capacity" value="#{1e4}"/>```
-   String可以使用单引号或者双引号作为字符串的定界符号：```<property name=“name” value="#{'Chuck'}"/>``` 或 ```<property name='name' value='#{"Chuck"}'/>```
-   Boolean：```<property name="enabled" value="#{false}"/>```

## 2. SPEL 引用 Bean、 属性和方法

-   引用其他对象

```xml
<!--通过 value 属性和 SPEL 配置 Bean 之间的应用关系-->
<property name="perfix" value="#{prefixGenerator}"/>
```
-   引用其他对象的属性

```xml
<!--通过 value 属性和 SPEL 配置 suffix 值为另一个 Bean 的suffix 属性值-->
<property name="suffix" value="#{sequenceGenerator2.suffix}"/>
```
-   调用其他方法，还可以链式操作

```xml
<!--通过 value 属性和 SPEL 配置 suffix 值为另一个 Bean 的suffix 返回值-->
<property name="suffix" value="#{sequenceGenerator2.toString()}"/>

<!-- 方法的连缀 -->
<property name="suffix" value="#{sequenceGenerator2.toString().toUpperCase()}"/>
```
-   调用静态方法或者静态属性： 通过``` T()``` 调用一个类的```静态方法```，它将返回一个 ```Class Object```，然后再调用相应的方法和属性

```xml
<propery name="piValue" value="#{T(java.lang.Math).PI}"/>
```


## 3. SPEL 支持的运算符

-   算数运算符：```+, -, *, /, %, ^：```
    -   加号还可以用作字符串连接
-   比较运算符： ```<, >, ==, <=, >=, lt, gt, eq, le, ge```
-   逻辑运算符号： ```and, or, not, |```
-   if-else 运算符：```?: (ternary), ?: (Elvis)```
-   正则表达式：```matches```
