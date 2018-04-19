---
layout: post
title:  "[JAVA_Spring] Spring 中 Bean 的生命周期"
date:   2018-04-11
desc: "Spring Bean Life Cycle"
keywords: "java, spring, Bean，Life Cycle"
categories: [java, spring]
---

# I. 传统 Java 中 Bean 对象的生命周期

在传统java应用中， bean 的```生命周期 （Lift Cycle）```很简单， 使用 Java 关键字 ```new``` 进行一个类的实例化来得到 bean 对象，当一个 bean 不再被使用，则会被 ```GC (Garbage Collection)```。


# II. IOC 容器中 Bean 的生命周期方法

```Spring IOC 容器可以管理 Bean 的生命周期```, Spring 允许在 Bean 生命周期的特定点执行定制的任务. 
-   Spring IOC 容器对 Bean 的生命周期进行管理的过程:
    -   通过构造器或工厂方法创建 Bean 实例
    -   为 Bean 的属性设置值和对其他 Bean 的引用
    -   调用 Bean 的初始化方法
    -   Bean 可以使用了
    -   当容器关闭时, 调用 Bean 的销毁方法
-   在 Bean 的声明里设置 ```init-method``` 和 ```destroy-method``` 属性, 为 Bean 指定初始化和销毁方法.

而 Spring 中， 理解一个 bean 的生命周期则非常重要，因为我们可能需要 Spring 提供的扩展点来自定义 bean 的创建过程。



# III. 创建 Bean 后置处理器

Spring 如和在初始化 bean 的时候，来检查 bean 的状态或者在初始化 bean 示例的时候对bean做一定的处理呢？答案是使用 bean 的后置处理器 ```BeanPostProcessor```

-   Bean ```后置处理器```允许在```调用初始化方法（init-method）前后```对 Bean 进行额外的处理.
-   Bean 后置处理器```对 IOC 容器里的所有 Bean 实例逐一处理, 而非单一实例```
    -   其典型应用是: 检查 Bean 属性的正确性或根据特定的标准更改 Bean 的属性.
-   对Bean 后置处理器而言, 需要实现 ```beanPostProcessor``` 接口. 在初始化方法被调用前后, Spring 将把每个 Bean 实例分别传递给上述接口的以下两个方法:
    -   ```postProcessAfterInitialization(Object bean, String beanName)```
    -   ```postProcessBeforeInitialization(Object bean, String beanName)```

要注意的地方：
-   后置处理器的作用是在调用 bean 的初始化方法的前后
-   这个后置处理器是对 IOC 容器中所有的 bean 都使用的,所以如果是对特定类型的 bean 进行处理，那么就可以用 ```instanceof``` 或者 ```beanName``` 或者其他属性来做条件处理
-   后置处理器的作用非常强大，在实现接口后的方法实现里，可以做 bean 属性的修改，同时也可以返回一个新的 bean 给 IOC 容器

具体代码示例请看第5部分的示例

# IV. 图解 Bean 的周期

下图展示了在 Spring 中，当一个 bean 被装载到 Spring ApplicationContext中的典型的生命周期过程：
![spring_bean_life_cycle](/assets/blog/2018/04/spring_bean_life.png)


既然 bean 是由 IOC 容器使用构造器或者 bean 工厂来创建的，并由 IOC 容器来销毁，那么执行了哪些步骤呢？结合图示我们来说明：

1.  Spring 对 bean 进行实例化
2.  Spring 将值和 bean 的引用注入到 bean 的对应的属性中
3.  如果 bean 实现了 ```BeanNameAware``` 接口， Spring 将 bean 的 id 传递给 ```setBeanName()``` 方法
4.  如果 bean 实现了 ```ApplicationContextAware``` 接口， Spring 将调用 ```setApplicationContext()``` 方法，将 bean 所在的 ```ApplicationContext``` 的引用传入进来
5.  如果 bean 实现了 ```BeanPostProcessor``` 接口， Spring 将调用它们的 ```postProcessBeforeInitialization()``` 方法
6.  如果 bean 实现了 ```InitializingBean``` 接口， Spring 将调用它们的 ```afterPropertiesSet()``` 方法，类似的，如果 bean 使用 ```init-method``` 声明了初始化方法，该方法也会被调用
8.  如果 bean 实现了 ```BeanPostProcessor``` 接口， Spring 将调用它们的 ```ProcessAfterInitialization()``` 方法
9.  这时， bean 已经准备就绪，就可以被程序使用了，它们将一直驻留在 ```ApplicationContext``` 中直到 ```ApplicationContext``` 被销毁





# V. 代码示例

我们用代码来演示一下使用 init-method 和 destroy-method 方法来看看 bean 创建和销毁的顺序

首先，建立一个 Car 类， 写好 init() 方法和 destroy() 方法：

```java
package org.lovian.spring.bean.lifecycle;

/**
 * Author: PENG Zhengshuai
 * Date: 4/11/18
 * lovian.org
 */
public class Car {
    private String brand;

    public Car() {
        System.out.println("Car's constructor");
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public void init(){
        System.out.println("Initializing car...");
    }

    public void destroy(){
        System.out.println("Destroying car...");
    }

    @Override
    public String toString() {
        return "Car{" +
                "brand='" + brand + '\'' +
                '}';
    }
}

```

然后我们建立一个新的配置文件 lifecycle_beans.xml 文件来配置 bean

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">


    <bean id="car" class="org.lovian.spring.bean.lifecycle.Car" init-method="init" destroy-method="destroy">
        <property name="brand" value="Audi"/>
    </bean>
</beans>
```

然后写个 main 方法，打印每一步的步骤

```java
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/11/18
 * lovian.org
 */
public class LifeCycleDemo {

    public static void main(String[] args) {
        System.out.println("Create Application Context...");
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/lifecycle_beans.xml");

        System.out.println("Get bean...");
        Car car = (Car) actx.getBean("car");
        System.out.println(car);

        System.out.println("Destroy Application Context...");
        ((ClassPathXmlApplicationContext) actx).close();
    }
}

```

结果如下：

```
Create Application Context...
...
INFO: Loading XML bean definitions from class path resource [config/lifecycle_beans.xml]
Car's constructor
Initializing car...
...
Get bean...
Car{brand='Audi'}
Destroy Application Context...
Destroying car...
```

通过这个示例我们可以看到一个 bean 在 ApplicationContext 中创建和销毁的顺序，下面我们给这个代码加入一个 bean 的后置处理器

首先创建一个 ```BeanPostProcessor``` 的后置处理器的实现类：

```java
package org.lovian.spring.bean.lifecycle;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;

/**
 * Author: PENG Zhengshuai
 * Date: 4/11/18
 * lovian.org
 */
public class MyBeanPostProcessor implements BeanPostProcessor {

    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessBeforeInitialization: " + beanName);
        return bean;
    }

    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("postProcessAfterInitialization: " + beanName);
        return bean;
    }
}
```

然后在 xml 配置文件中加入这个后置处理器的定义：

```xml
    <!-- config bean post processor -->
    <bean class="org.lovian.spring.bean.lifecycle.MyBeanPostProcessor"/>
```

执行之前的 main 方法会得到如下结果：

```
Create Application Context...
...
INFO: Loading XML bean definitions from class path resource [config/lifecycle_beans.xml]
Car's constructor
postProcessBeforeInitialization: car
Initializing car...
postProcessAfterInitialization: car
Get bean...
Car{brand='Audi'}
Destroy Application Context...
Destroying car...
```