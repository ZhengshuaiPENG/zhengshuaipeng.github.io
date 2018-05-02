---
layout: post
title:  "[JAVA_Spring] Spring 泛型依赖注入"
date:   2018-04-22
desc: "Spring generic dependency injection"
keywords: "java, spring, Bean， generic, dependency injection"
categories: [spring]
---

# I.范型依赖注入

```泛型依赖注入(Generic Dependency Injection)```是 Spring 4.0 开始有的新特性，可以为子类注入子类对应的泛型类型的成员变量的引用。

什么叫做泛型依赖注入呢，就是说我定义了一个泛型类 A， A 依赖于另一个泛型类 B, 那么， A 和 B 的具体子类也会被 Spring 对应的进行自动管理装配。

下面用讲个示例，UML 图如下：

![generic_injection](/assets/blog/2018/04/generic_injection.png)



如图所示， ```BaseService<T>``` 依赖于类 ```BaseRepository<T>```， 那么让 Spring 来装配这两个类; 然后它们的具体实现类分别是 ```UseService``` 和 ```UserRepository```， 具体类型由泛型 ```T``` 变成了 ```User```， 那么， Spring 也会自动去装配 ```UserService``` 和 ```UserRepository``` 之间的关联关系，也就是说，IOC 容器会把 UserRepository 这个 Bean对应的装配到 UserService 中去。

下面用代码来具体演示：

先创建一个 User 实体类：

```java
package org.lovian.spring.bean.generic.di;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */
public class User {
    private String userName;
    private String passWord;
}
```

创建 BaseRepository 类：

```java
package org.lovian.spring.bean.generic.di;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */
public class BaseRepository<T> {
}
```

创建 BaseService 类：

```java
package org.lovian.spring.bean.generic.di;

import org.springframework.beans.factory.annotation.Autowired;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */
public class BaseService<T> {

    @Autowired
    private BaseRepository<T> baseRepository;

    public void add(){
        System.out.println("add..");
        System.out.println(baseRepository.getClass());
    }
}
```

这里可以看到，使用了 ```@Autowired``` 注解，去给 BaseService 类中装配一个 BaseRepository的实例，然后我们在 BaseService 类中的 add 方法里，去打印实际装配到 BaseService 中的 BaseRepository 类的类型

然后根据 UML 图示，我们去分别创建两个类的子类：

UserRepository，继承 BaseRepository， 使用 ```@Repository``` 进行标注，让 IOC 容器进行管理， 会生成一个 ```userRepository``` 的 bean：

```java
package org.lovian.spring.bean.generic.di;

import org.springframework.stereotype.Repository;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */

@Repository
public class UserRepository extends BaseRepository<User> {
}
```

然后是 UserService 类， 继承 BaseService 类，使用 ```@Service``` 进行标注， 让 IOC 容器进行管理， 会生成一个 ```userService``` 的bean：

```java
package org.lovian.spring.bean.generic.di;

import org.springframework.stereotype.Service;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */

@Service
public class UserService extends BaseService<User> {
}
```

实际上此时，IOC 容器在扫描组件的时候，得到的应该是 ```userService``` 和 ```userRepository``` 两个 bean， 分别继承与 ```BaseService``` 和 ```BaseRepository```。但是现在 ```BaseService``` 作为父类，私有成员变量是 ```baseRepository```，在 ```add()``` 方法中被调用，如果我们从 ```userService``` 这个对象中去调用 ```add()``` 方法时, 打印出的类型是 ```BaseService``` 还是 ```UserService``` 呢？

创建一个 xml 配置文件，扫描包中的组件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="org.lovian.spring.bean.generic.di"/>
</beans>
```

然后我们测试一下：

```java
package org.lovian.spring.demo;

import org.lovian.spring.bean.generic.di.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/26/18
 * lovian.org
 */
public class GenericDiDemo {
    public static void main(String[] args) {
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/generic_di_beans.xml");
        UserService userService = (UserService) actx.getBean("userService");
        userService.add();
    }
}
```

得到的打印结果如下：

```
add..
class org.lovian.spring.bean.generic.di.UserRepository
```

从结果中可以看到，实际上打印出的是 ```UserRepository``` 这个类。这就说明了， ```IOC 容器，给 userService 自动装配了 userRepository```，这就是泛型依赖注入的特性