---
layout: post
title:  "[JAVA_Spring] Spring 中通过工厂方法装配 Bean"
date:   2018-04-17
desc: "Spring Bean wired by factory"
keywords: "java, spring, Bean，factory"
categories: [java, web, spring]
---

# I. Bean 的装配方式

在之前的教程中，我们都是通过在 application_context.xml 配置文件中 ```bean 的结点里的 class``` 属性来配置 Bean 的```全类名```，底层是通过```反射```的机制来装配 Bean 的。还有一种方法是通过```工厂方法```来进行 Bean 的装配，主要有三种：

-   静态工厂方法
-   实例工厂方法
-   Spring Factory Bean

# II. 通过调用静态工厂方法创建 Bean

-   调用静态工厂方法创建 Bean是```将对象创建的过程封装到静态方法```中. 当客户端需要对象时, 只需要简单地调用静态方法, 而不同关心创建对象的细节.
-   在配置文件中要配置通过静态工厂方法来创建的 Bean
    -   需要在 Bean 的 ```class 属性里指定拥有该工厂的方法的类```
    -   同时在 ```factory-method``` 属性里指定工厂方法的名称
    -   最后, 使用 ```<constrctor-arg>``` 元素为该方法传递方法参数

下面来看一个代码示例，首先先创建一个类 Car， 拥有构造函数，setter/getter 和 toString 方法，然后创建一个静态工厂类 StaticCarFactory， 如下所示：

```java
import java.util.Map;

/**
 * Author: PENG Zhengshuai
 * Date: 4/17/18
 * lovian.org
 */
public class StaticCarFactory {
    private static Map<String, Car> maps = new HashMap<String, Car>();

    static {
        maps.put("AUDI", new Car("Audi", "A6L", 50000));
        maps.put("BMW", new Car("BMW", "525L", 40000));
    }

    public static Car getCar(String name){
        return maps.get(name);
    }
}
```

然后我们新建一个配置文件 factory_beans.xml, 来配置 bean 实例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Here to config a Car instance, not a StaticCarFactory instance -->
    <bean id="audi" class="org.lovian.spring.bean.factory.StaticCarFactory" factory-method="getCar">
        <constructor-arg value="AUDI"/>
    </bean>
</beans>
```

注意，这里 ```class``` 属性中设置的 ```StaticCarFactory，``` 而不是 ```Car```， 但这个 bean 并```不是工厂方法的实例，而是 Car 的实例```，然后指定 ```factory-method```， 通过 ```constructor-arg``` 将 ```factory-method``` 所需要的参数传进去

然后我们创建一个 main 函数来测试

```java
package org.lovian.spring.demo;

import org.lovian.spring.bean.factory.Car;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/17/18
 * lovian.org
 */
public class FactoryDemo {
    public static void main(String[] args) {
        ApplicationContext acxt = new ClassPathXmlApplicationContext("config/factory_beans.xml");
        Car car = (Car)acxt.getBean("audi");
        System.out.println(car.toString());
    }
}
```

结果如下：

```
Car{brand='Audi', model='A6L', price='50000', maxSpeed='0.0'}
```

# III. 通过调用实例工厂方法创建 Bean

-   ```实例工厂方法```: 将对象的创建过程封装到另外一个对象实例的方法里. 当客户端需要请求对象时, 只需要简单的调用该实例方法而不需要关心对象的创建细节.
-   要声明通过实例工厂方法创建的 Bean
    -   首先创建实例工厂的 factory bean   
    -   在要创建的 bean 的 ```factory-bean``` 属性里指定拥有该工厂方法的 Bean
    -   在 ```factory-method``` 属性里指定该工厂方法的名称
    -   使用 ```construtor-arg``` 元素为工厂方法传递方法参数

下面来看实例， 首先创建一个 InstanceCarFactory 类：

```java
package org.lovian.spring.bean.factory;

import java.util.HashMap;
import java.util.Map;

/**
 * Author: PENG Zhengshuai
 * Date: 4/17/18
 * lovian.org
 */
public class InstanceCarFactory {
    private Map<String, Car> map;

    public InstanceCarFactory() {
        this.map = new HashMap<String, Car>();
        map.put("AUDI", new Car("Audi", "A6L", 50000));
        map.put("BMW", new Car("BMW", "525L", 40000));
    }

    public Car getCar(String name) {
        return this.map.get(name);
    }
}
```

然后再 factory_beans.xml 中配置 factory bean 和 car bean

```xml

    <bean id="carFactory" class="org.lovian.spring.bean.factory.InstanceCarFactory"/>

    <bean id="bmw"  factory-bean="carFactory" factory-method="getCar">
        <constructor-arg value="BMW"/>
    </bean>
```
执行 main 方法然后看结果

```
Car{brand='BMW', model='525L', price='40000', maxSpeed='0.0'}
```

可以看到，在配置了工厂方法以后，不需要声明 Car bean 的 class 属性，只需要设置好 ```factory-bean```, ```factory-method``` 和 ```factory-method``` 所需要的参数即可。也就是说，在有了工厂方法以后，就不需要去关注 car 类的所有细节，只需要知道工厂方法和其所需属性即可

# III. 通过 Spring Factory Bean 来创建 Bean

```FactoryBean``` 是 Spring 本身提供的一个接口，里面包含了三个方法：

-   ```getObject()```
-   ```getObjectType()```
-   ```isSingleton()```

在使用 Spring FactoryBean的时候，需要实现 FactoryBean 接口。

下面用示例说明，先创建一个 CarFactoryBean：

```java
package org.lovian.spring.bean.factory;

import org.springframework.beans.factory.FactoryBean;

/**
 * Author: PENG Zhengshuai
 * Date: 4/17/18
 * lovian.org
 */
public class CarFactoryBean implements FactoryBean<Car> {

    private String brand;
    private String model;
    private int price;

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public Car getObject() throws Exception {
        return new Car(brand, model, price);
    }

    public Class<?> getObjectType() {
        return Car.class;
    }

    public boolean isSingleton() {
        return true;
    }
}

```

然后在 xml 中配置这个 FactoryBean

```xml
<bean id="car" class="org.lovian.spring.bean.factory.CarFactoryBean">
        <property name="brand" value="AUDI"/>
        <property name="model" value="A6L"/>
        <property name="price" value="40000"/>
    </bean>
```

然后执行 main 方法，结果如下

```
Car{brand='AUDI', model='A6L', price='40000', maxSpeed='0.0'}
```
