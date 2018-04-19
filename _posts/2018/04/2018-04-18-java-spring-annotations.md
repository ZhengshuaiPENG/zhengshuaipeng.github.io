---
layout: post
title:  "[JAVA_Spring] Spring 中通过注解装配 Bean"
date:   2018-04-18
desc: "Spring Bean wired by java annotation"
keywords: "java, spring, Bean，annotation"
categories: [java, web, spring]
---

# I. 基于注解方式配置 Bean

在之前的教程中, 配置 Bean 的方式都是通过 xml 配置文件中声明 bean 的定义来配置的，那么还有一种方式是通过 java 的注解（```annatation```） 的方式来进行 bean 的配置和装配 bean 的属性的, 下面我们来讲一下如和通过注解的方式来配置 bean

# II. 组件扫描

```组件扫描（component scanning）```： Spring 能够从 classpath 中进行自动扫描，侦测并实例化具有特定注解的组件。

这些特定组件包括：

-   ```@Component```： 基本注解，标识了一个受 Spring 管理的组件
-   ```@Repository```： 标识持久层组件
-   ```@Service```： 标识服务层（业务层） 组件
-   ```@Controller```： 标识表现层组件

对于扫描到的组件， Spring 中有```默认的命名策略```，即使用```非限定类名```，第一个字母小写; 也可以在注解中通过 ```value``` 属性来标识组件的名称。举个例子，比如一个类类名叫 ```CarFactory```, 那么默认的命名策略，这个组件就叫做 ```carFactory```，如果通过 value 来指定它叫 ```audiFactoryImpl，``` 那么这个组件就叫做 ```audiFactoryImpl```

如果只在class中标识了注解，这时候 IOC 容器还不能去管理这个组件，还需要进行配置：

-   当组件类上使用了特定的注解之后，还需要在Spring 的配置文件中声明 ```<context:component-scan>```
-   ```base-package``` 属性指定一个需要扫描的基类包， Spring 容器将会```扫描这个基类包里及其子包中的所有类```
-   如果需要扫描多个包的时候，可以使用 ```,``` 进行分隔
-   如果仅希望扫描特定的类而非基类包下所有的类，那么可以使用 ```resource-pattern``` 属性来过滤特定的类，比如：

```xml
<context:component-scan
    base-package="org.lovian.spring.beans"
    resource-pattern="autowire/*.class"
/>
```

-   ```<context:include-filter>``` 子节点表示要包含的目标类
-   ```<context:exclude-filter>``` 子节点标识要排除在外的目标类
-   ```<context:component-scan>``` 下可以拥有若干个 ```<context:include-filter>``` 和 ```<context:exclude-filter>```子节点
-   ```<context:include-filter>``` 和 ```<context:exclude-filter>```子节点支持多种类型的表达式
    -   type: ```annotation```
        -   expression: ```org.lovian.XxxAnnotation```
        -   所有标注了 XxxAnnotation 的类，该类型采用目标类是否标注了某个注解进行过滤
    -   type:```assinable```
        -   expression:```org.lovian.XxxService```
        -   所有继承或者扩展 XxxService 的类，该类型采用目标类是否继承或者扩展某个特定类进行过滤
    -   type:```aspectj```
        -   expression:```org.lovian..*Service+```
        -   所有类名以 Service 结束的类及继承或扩展它们的类，该类型采用 AspectJ 表达式进行过滤
    -   type:```regex```
        -   expression:```org.\lovian\.anno\..*```
        -   所有 org.lovian.anno 包下的类，该类型采用正则表达式根据类的类名进行过滤
    -   type:```custom```
        -   expression:```org.lovian.XxxTypeFilter```
        -   采用 XxxTypeFilter通过代码的方式定义过滤规则，该类必须实现 ```org.springframework.core.type.TypeFilter``` 接口

III. Annotation 代码示例

我们使用 annotation 来简单模拟一些三个层次的一个Spring 简单应用，同时拥有 repository 层， service 层和 controller 层

repository 层：
```java
package org.lovian.spring.bean.annotation.repository;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */
public interface UserRepository {
    void save();
}
```
实现UserRepository接口，并指定 annotation 的 value属性

```java
package org.lovian.spring.bean.annotation.repository;

import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */

@Repository(value = "userRepository")
public class UserRepositoryImpl implements UserRepository {
    public void save() {
        System.out.println("User Repository saved.");
    }
}
```

service 层：

```java
package org.lovian.spring.bean.annotation.service;

import org.springframework.stereotype.Service;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */

@Service
public class UserService {
    public void add(){
        System.out.println("UserService add...");
    }
}
```

controller 层：

```java
package org.lovian.spring.bean.annotation.controller;

import org.springframework.stereotype.Controller;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */

@Controller
public class UserController {
    public void execute(){
        System.out.println("UserController execute...");
    }
}
```

然后定义一个 model，指定 ```@Component```

```java
package org.lovian.spring.bean.annotation;

import org.springframework.stereotype.Component;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */

@Component
public class TestObject {
}
```

然后需要配置一个 Spring 的配置文件 annotation_bean.xml，引入 ```context namespace```， 指定 IOC 容器扫描的包

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="org.lovian.spring.bean.annotation"/>
</beans>
```

然后我们就可以从 IOC 东西中获取刚才用 annotation 标注的类的 bean 实例：

```java
package org.lovian.spring.demo;

import org.lovian.spring.bean.annotation.TestObject;
import org.lovian.spring.bean.annotation.controller.UserController;
import org.lovian.spring.bean.annotation.repository.UserRepository;
import org.lovian.spring.bean.annotation.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/19/18
 * lovian.org
 */
public class AnnotationDemo {
    public static void main(String[] args) {
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/annotation-beans.xml");
        TestObject testObject = (TestObject) actx.getBean("testObject");
        System.out.println(testObject);

        UserRepository userRepository = (UserRepository) actx.getBean("userRepository");
        System.out.println(userRepository);
        userRepository.save();

        UserService userService = (UserService) actx.getBean("userService");
        System.out.println(userService);
        userService.add();

        UserController userController = (UserController) actx.getBean("userController");
        System.out.println(userController);
        userController.execute();
    }
}
```

得到结果如下：

```
org.lovian.spring.bean.annotation.TestObject@5e955596
org.lovian.spring.bean.annotation.repository.UserRepositoryImpl@50de0926
User Repository saved.
org.lovian.spring.bean.annotation.service.UserService@2473b9ce
UserService add...
org.lovian.spring.bean.annotation.controller.UserController@60438a68
UserController execute...
```

可以看出，通过注解的方式，和通过xml配置bean的方式一样，都可以从 IOC 容器中拿到 bean。

接下来要通过 ```context:component-scan``` 中的属性标签来进行 bean 扫描的过滤：

-   通过 ```resource-pattern``` 扫描指定包下的类：

```xml
<!-- 只扫描  org.lovian.spring.bean.annotation.repository 包下的 class 文件-->
<context:component-scan
    base-package="org.lovian.spring.bean.annotation"
    resource-pattern="repository/*.class" 
/>
```

-   通过 ```context:include-filter``` 来指定包含的类

```xml
<!-- 指定一定要包含(not only）标注了 @Repository 的类-->
<context:component-scan base-package="org.lovian.spring.bean.annotation">
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>

<!-- 指定只包含(only）标注了 @Repository 的类,需要设置 use-default-filters属性为 false，意思是说，只用我们定义的 filter，而不用默认的filter-->
<context:component-scan
    base-package="org.lovian.spring.bean.annotation"
    use-default-filters="false">

    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```

-   通过 ```context:exclude-filter``` 来指定不包含的类

```xml
<!-- 指定不包含标注了org.springframework.stereotype.Repository 的 bean， 即不包含标注了@Repository的所有类-->
<context:component-scan base-package="org.lovian.spring.bean.annotation">
    <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
</context:component-scan>
```