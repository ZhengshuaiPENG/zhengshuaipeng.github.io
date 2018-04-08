---
layout: post
title:  "[JAVA_Spring] Spring 中 Bean 的自动装配"
date:   2018-04-08
desc: "Spring Bean 配置"
keywords: "java, spring, Bean，Autowire"
categories: [java, web, spring]
---

# I. Bean 的装配与自动装配

在前一节[Spring 中 Bean 的配置](http://blog.lovian.org/java/web/spring/2018/04/07/java-spring-bean-configuration.html)中的例子，我们在 ```application_context.xml ```配置文件中，我们配置了许多 bean 对象，这些对象显然都是我们自己手动装配的（```wire```）。

比如在使用 ```p namespace``` 之后的 bean 写法如下：

```xml
<bean id="Rose" class="org.lovian.sping.bean.collections.Person" p:name="Rose" p:age="22" p:cars-ref="bba-cars"/>
```

我们显式的指明了，将 ```bba-cars``` 这个 bean 装配给了 ```Rose``` 这个 Person bean，那么什么是```自动装配（Autowire）```呢，就是说我这里不需要显示的写明，```bba-cars``` 这个bean是装配给```Rose```的，它去自己给我装配好，那么如果实现呢？

## 1.XML 配置里的 Bean 自动装配

-   Spring IOC 容器可以自动装配 Bean. 需要做的仅仅是在 ```<bean>``` 的 ```autowire``` 属性里```指定自动装配的模式```
    -   ```byType(根据类型自动装配)```: 若 IOC 容器中有多个与目标 Bean 类型一致的 Bean. 在这种情况下, Spring 将无法判定哪个 Bean 最合适该属性, 所以不能执行自动装配
    -   ```byName(根据名称自动装配)```: 必须将目标 Bean 的名称和属性名设置的完全相同
    - ```constructor(通过构造器自动装配)```: 当 Bean 中存在多个构造器时, 此种自动装配方式将会很复杂. 不推荐使用


## 2. XML 配置里的 Bean 自动装配的缺点

-   在 Bean 配置文件里设置 ```autowire``` 属性进行自动装配将会装配 Bean 的所有属性. 然而, 若只希望装配个别属性时, ```autowire``` 属性就不够灵活了. 
-   ```autowire``` 属性要么根据类型自动装配, 要么根据名称自动装配, 不能两者兼而有之.
-   一般情况下，在实际的项目中很少使用自动装配功能，因为和自动装配功能所带来的好处比起来，明确清晰的配置文档更有说服力一些


# II. Bean 自动装配实例

下面看个示例，我们新建三个类， Person， Address， Car

Address 类：
```java
package org.lovian.spring.autowire;

/**
 * Author: PENG Zhengshuai
 * Date: 4/8/18
 * lovian.org
 */
public class Address {
    private String city;
    private String street;

    public Address() {
    }

    public Address(String city, String street) {
        this.city = city;
        this.street = street;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    @Override
    public String toString() {
        return "Address{" +
                "city='" + city + '\'' +
                ", street='" + street + '\'' +
                '}';
    }
}
```

Car 类：

```java
package org.lovian.spring.autowire;

/**
 * Author: PENG Zhengshuai
 * Date: 4/8/18
 * lovian.org
 */
public class Car {
    private String brand;
    private int price;

    public Car() {
    }

    public Car(String brand, int price) {
        this.brand = brand;
        this.price = price;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Car{" +
                "brand='" + brand + '\'' +
                ", price=" + price +
                '}';
    }
}
```

Person 类：

```java
package org.lovian.spring.autowire;

/**
 * Author: PENG Zhengshuai
 * Date: 4/8/18
 * lovian.org
 */
public class Person {
    private String name;
    private Address address;
    private Car car;

    public Person() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", address=" + address +
                ", car=" + car +
                '}';
    }
}

```

然后新建一个 bean 的 configuration 文件,然后将 bean 的定义写好：

autowire_beans.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="address" class="org.lovian.spring.autowire.Address" p:city="Shanghai" p:street="lou shan guan road No.523"/>


    <bean id="car" class="org.lovian.spring.autowire.Car" p:brand="Audi A6L" p:price="480000" />


    <!--wire manually -->
    <bean id="lovian" class="org.lovian.spring.autowire.Person" p:name="lovain" p:address-ref="address" p:car-ref="car" />
    <!--autowire by name: bean id and field in Class must keep the same-->
    <bean id="sq" class="org.lovian.spring.autowire.Person" p:name="sq" autowire="byName"/>
    <!--autowire by type: the bean of one Type must be unique-->
    <bean id="zhshpeng" class="org.lovian.spring.autowire.Person" p:name="zhshpeng" autowire="byType"/>
</beans>
```

执行一下 main 方法：

```java
package org.lovian.spring.demo;

import org.lovian.spring.autowire.Person;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Author: PENG Zhengshuai
 * Date: 4/8/18
 * lovian.org
 */
public class AutoWireDemo {
    public static void main(String[] args) {
        ApplicationContext actx = new ClassPathXmlApplicationContext("config/autowire_beans.xml");
        Person lovain = (Person) actx.getBean("lovian");
        System.out.println(lovain.toString());

        Person sq = (Person) actx.getBean("sq");
        System.out.println(sq.toString());

        Person zhshpeng = (Person) actx.getBean("zhshpeng");
        System.out.println(zhshpeng.toString());
    }
}
```

结果如下所示：

```
Person{name='lovain', address=Address{city='Shanghai', street='lou shan guan road No.523'}, car=Car{brand='Audi A6L', price=480000}}
Person{name='sq', address=Address{city='Shanghai', street='lou shan guan road No.523'}, car=Car{brand='Audi A6L', price=480000}}
Person{name='zhshpeng', address=Address{city='Shanghai', street='lou shan guan road No.523'}, car=Car{brand='Audi A6L', price=480000}}
```

从结果我们可以看出，无论是手动装配还是自动装配，bean 都是装配成功的。

但是这里有几点要注意：

-   由 Autowire 属性 ```byName``` 自动装配的方式，是根据 bean 的名字（id）和当前 bean 的 setter 风格的属性名进行自动装配，也就是说，如果这个 bean 的名字和需要被装配的类的setter不一致无法装配成功的。如果我们把 ```address``` 这个 bean 的 id 改成 ```address2```, 是无法装配的
-   由 Autowire 属性 ```byType``` 自动装配的方式，是根据 bean 的Type，也就是Class来进行自动装配，一个 Class 只能有一个 bean 实例的定义，如果出现了两个 Address 的 bean 定义，是无法装配成功的