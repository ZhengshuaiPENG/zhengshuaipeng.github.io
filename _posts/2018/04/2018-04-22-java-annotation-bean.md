---
layout: post
title:  "[JAVA_Spring] Spring 中通过注解装配 Bean 与 Bean 之间的关系"
date:   2018-04-22
desc: "Spring Bean wired by java annotation"
keywords: "java, spring, Bean，annotation"
categories: [spring]
---

# I. 组件装配

在 [Spring 中通过注解配置 Bean](http://blog.lovian.org/java/web/spring/2018/04/18/java-spring-annotations.html) 教程中讲述了如何通过注解的方式来配置 Bean， 这一节教程则是要介绍如和通过注解的方式来装配 Bean 与 Bean 之间的关系

```组件装配```：```<context:component-scan>``` 元素会自动注册 ```AutowiredAnnotationBeanPostProcessor``` 实例，该实例可以自动装配具有 ```@Autowired```，```@Resource```， 和 ```@Inject``` 注解的属性

下面介绍一下使用各个注解来装配 Bean 的细节

# II. 使用 @Autowired 自动装配 Bean

```@Autowired``` 注解自动装配具有兼容类型的单个 Bean 属性：

-   ```构造器```, 普通字段(即使是非 public), 一切```具有参数的方法```都可以应用@Authwired 注解
-   默认情况下, ```所有使用 @Authwired 注解的属性都需要被设置```. 当 Spring 找不到匹配的 Bean 装配属性时, 会抛出异常, ```若某一属性允许不被设置, 可以设置 @Authwired 注解的 required 属性为 false```
-   默认情况下, 当 IOC 容器里存在多个类型兼容的 Bean 时, 通过类型的自动装配将无法工作. 此时可以在 ```@Qualifier``` 注解里提供 Bean 的名称. ```Spring 允许对方法的入参标注 @Qualifiter 已指定注入 Bean 的名称```
 -  ```@Authwired``` 注解也可以应用在```数组类型```的属性上, 此时 Spring 将会把所有匹配的 Bean 进行自动装配.
-   ```@Authwired``` 注解也可以应用在```集合属性```上, 此时 Spring 读取该集合的类型信息, 然后自动装配所有与之兼容的 Bean. 
-   ```@Authwired ```注解用在 ```java.util.Map``` 上时, 若该 Map 的键值为 String, 那么 Spring 将自动装配与之 Map 值类型兼容的 Bean, 此时 ```Bean 的名称作为键值```


## 1. 使用 @Autowired 注解配置 Bean 代码示例

我们把上一节中的 repository， service 和 controller 的例子使用 Autowire 注解来改造一下：


在 UserService 类中， 使用 Autowire 注解来装配一个 UserRepository
```java
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public void add(){
        System.out.println("UserService add...");
        userRepository.save();
    }
}
```
然后在 UserController 中， 使用 Autowire 注解来装配一个 UserService

```java
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    public void execute(){
        System.out.println("UserController execute...");
        userService.add();
    }
}
```

然后通过 ApplicationContext 去获取 UserController 的 bean 实例

```java
public class AnnotationDemo {
    public static void main(String[] args) {
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/annotation-beans.xml");

        UserController userController = (UserController) actx.getBean("userController");
        System.out.println(userController);
        userController.execute();
    }
}
```

得到结果如下：

```
org.lovian.spring.bean.annotation.controller.UserController@101df177
UserController execute...
UserService add...
User Repository saved.
```

我们可以看到通过调用 UserController 的 execute 方法，每一层的方法依次都被调用了，说明通过 Autowire 注解配置的 bean 都被 IOC 容器所管理并且自动装配了。

## 2. 通过构造器方式和@Autowired来装配 bean 

但是，直接把 @Autowired 注解配置到字段属性上已经不是 Spring team 所推荐的：

```Spring Team Recommands ：Always use constructor based dependency injection in your beans. Always use assertions for mandatory dependencies".```

所以我们将上面的装配方式做一下修改，通过构造器的方式来配置，代码如下：

UserService类

```java
@Service
public class UserService {

    private UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void add(){
        System.out.println("UserService add...");
        userRepository.save();
    }
}
```

UserController类

```java
@Controller
public class UserController {

    private UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    public void execute(){
        System.out.println("UserController execute...");
        userService.add();
    }
}
```

然后我们再执行一遍 main 函数就可以发现， 得到的结果和之前直接在字段上使用 ```@Autowired``` 的结果是一样的。 

## 3.如果自动装配的 Bean 不存在

有一种情况，当使用了 @Autowired 注解来配置 bean， 但是这个 bean 实际上并不存在于 IOC 容器中， 那么这是就需要在 ```@Autowired``` 上 使用 ```required = fasle```属性 

修改 UserRepositoryImpl 类：

```java
@Repository(value = "userRepository")
public class UserRepositoryImpl implements UserRepository {

    @Autowired(required = false)
    private TestObject testObject;

    public void save() {
        System.out.println("User Repository saved.");
        System.out.println(testObject);
    }
}
```

这样 IOC 容器会把容器中的 bean 装配给 userRepository，然后我们修改配置文件，将 testObject 类从 IOC 容器中过滤掉：

```xml
    <context:component-scan base-package="org.lovian.spring.bean.annotation">
        <context:exclude-filter type="regex" expression="org.lovian.spring.bean.annotation.TestObject"/>
    </context:component-scan>
```

然后执行 main 方法，得到结果如下：

```
org.lovian.spring.bean.annotation.controller.UserController@12028586
UserController execute...
UserService add...
User Repository saved.
null
```

可以看到，testObject bean 打印结果为 null， 也就是说， 即使 IOC 容器中没有这个 Bean， 也并不影响程序的运行，bean 就被初始化成 null。

## 4.如果有两个相同接口的实现类

我们从上面的例子可以看出来， Sping IOC 容器会自动扫描指定包中的class,但是如果一个接口，有两个实现类，比如说，UserRepository 接口有两个实现类 UserRepositoryImpl 和 UserJdbcRepository， 那么在 UserService 中，@Autowired 是怎么装配的。

-   通过 ```@Autowired``` 修饰的字段名字或者构造函数的参数名指定 bean 
-   通过 ```@Qualifier``` 指定 bean

我们先增加一个 UserJdbcRepository的实现类

```java
package org.lovian.spring.bean.annotation.repository;

import org.springframework.stereotype.Repository;

/**
 * Author: PENG Zhengshuai
 * Date: 4/22/18
 * lovian.org
 */

@Repository
public class UserJdbcRepository implements UserRepository{

    public void save() {
        System.out.println("UserJdbcRepository saved....");
    }
}
```

那么在 UserService 中，我们要装配 UserRepository：

```java
@Service
public class UserService {

    private UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userJdbcRepository) {
        this.userRepository = userJdbcRepository;
    }

    public void add(){
        System.out.println("UserService add...");
        userRepository.save();
    }
}
```

注意这里的构造器的参数名是 userJdbcRepository， 而不是 userRepository，那么打印结果是：

```
org.lovian.spring.bean.annotation.controller.UserController@11c20519
UserController execute...
UserService add...
UserJdbcRepository saved....
```

可以发现这里 IOC 容器给 UserService 装配的 UserRepository 的实例是 UserJdbcRepository 的 bean。如果这里参数名用 userRepository 的话，那么 IOC 容器将给其装配名字叫 userRepository 的 Bean。

同理，如果是用 ```@Autowired``` 来修饰字段的话，那么字段的名字和 bean 的名称做匹配

```java
@Service
public class UserService {

    @Autowired
    private UserRepository userJdbcRepository;

    public void add(){
        System.out.println("UserService add...");
        userJdbcRepository.save();
    }
}
```

这样，IOC 容器给 UserService 装配的也是 UserJdbcRepository 的实例。

还可以通过 ```@Qualifier```来指定要装配的 bean 的名称：

```java
@Service
public class UserService {

    @Autowired
    @Qualifier("userJdbcRepository")
    private UserRepository userRepository;

    public void add(){
        System.out.println("UserService add...");
        userRepository.save();
    }
}
```

以及用````@Qualifier````修饰构造函数中的参数：

```java
@Service
public class UserService {

    private UserRepository userRepository;

    @Autowired
    public UserService(@Qualifier("userJdbcRepository") UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void add(){
        System.out.println("UserService add...");
        userRepository.save();
    }
}
```

这样装配的结果都是把 UserJdbcRepository 装配给 UserService


# III. 使用 @Resource 或者 @Inject 自动装配 Bean

-   Spring 还支持 ```@Resource``` 和 ```@Inject``` 注解，这两个注解和 ```@Autowired``` 注解的功用类似
-   ```@Resource``` 注解要求提供一个 Bean 名称的属性，若该属性为空，则自动采用标注处的变量或方法名作为 Bean 的名称
-   ```@Inject``` 和 ```@Autowired``` 注解一样也是按类型匹配注入的 Bean， 但```没有 reqired 属性```
-   建议使用```@Autowired ```注解
