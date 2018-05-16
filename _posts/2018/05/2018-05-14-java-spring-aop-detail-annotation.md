---
layout: post
title:  "[JAVA_Spring] Spring AOP 详解一之 AspectJ 基于注解配置 AOP"
date:   2018-05-14
desc: "Spring AOP Explained in Details - AspectJ based on Annotation"
keywords: "java, spring, AOP， AspectJ"
categories: [spring]
---

# I. AspectJ简介

AspectJ 是 Java 社区中最完整最流行的 AOP 框架。在Spring中可以使用基于 AspectJ 注解或者时基于 XML 配置的 AOP

如何在 Spring 中```启用 AspectJ 注解```的支持？
-   要在 Spring 应用中使用 AspectJ 注解, 必须在 ```classpath``` 下包含 AspectJ 类库: ```aopalliance.jar、aspectj.weaver.jar 和 spring-aspects.jar```
-   ```将 aop Schema 添加到 <beans> 根元素中```
-   要在 Spring IOC 容器中启用 AspectJ 注解支持, 只要在 Bean 配置文件中定义一个空的 XML 元素 ```<aop:aspectj-autoproxy>```
-   当 Spring IOC 容器侦测到 Bean 配置文件中的 ```<aop:aspectj-autoproxy>``` 元素时, 会自动为与 AspectJ 切面匹配的 Bean 创建代理.


# II. AspectJ 基于注解配置 AOP

那么我们现在通过一个实例去使用Spring 和 AspectJ。

需求是实现一个简单的计算器，实现加减乘除的接口，并在接口使用前后，通过 log 打印出方法名，参数，和结果。


新建一个项目，并通过 maven 将所需要的 Spring 相关依赖，AspectJ 依赖和 Junit 依赖引进。 pom.xml 中相关依赖如下：

```xml
<dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-beans</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-expression</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aspects</artifactId>
            <version>5.0.5.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.aspectj</groupId>
            <artifactId>aspectjweaver</artifactId>
            <version>1.8.13</version>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>RELEASE</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
    </dependencies>
```

既然要实现一个计算器，那么我们先定义好这个计算器的接口：

```java
package org.lovian.spring.aop;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */
public interface ArithmeticCalculator {

    int add(int i, int j);

    int sub(int i, int j);

    int mul(int i, int j);

    int div(int i, int j);
}
```

然后给出一个计算器的具体实现：

```java
package org.lovian.spring.aop.impl;

import org.lovian.spring.aop.ArithmeticCalculator;
import org.springframework.stereotype.Component;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */

@Component
public class ArithmeticCalculatorImpl implements ArithmeticCalculator {

    @Override
    public int add(int i, int j) {
        return i + j;
    }

    @Override
    public int sub(int i, int j) {
        return i - j;
    }

    @Override
    public int mul(int i, int j) {
        return i * j;
    }

    @Override
    public int div(int i, int j) {
        if (j == 0)
            throw new ArithmeticException("j can't be 0 when j is a divisor");
        return i / j;
    }
}
```

在这个实现中，通过 ```@Component``` 标签注解将 ```ArithmeticCalculatorImpl``` 标记为一个 Spring 组件， 让 IOC 容器去管理其所对应的 bean。一般情况下，当这个类被实例化后，就可以调用对象的方法执行加减乘除的运算。

考虑使用 AOP 的方式给这个计算器加日志，首先先创建一个日志的切面类：

```java
package org.lovian.spring.aop.aspect;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */

@Aspect
@Component
public class LoggingAspect {
    private Log logger = LogFactory.getLog(LoggingAspect.class);

    @Before("execution(* org.lovian.spring.aop.impl.*.*(int, int))")
    public void beforeMethod(JoinPoint joinPoint){
        Signature signature = joinPoint.getSignature();
        String methodName = signature.getName();

        Object[] args = joinPoint.getArgs();

        logger.info("Method " + methodName + " begins with args: " + Arrays.asList(args));
    }
}
```

在 ```LoggingAspect``` 中， 同样的使用 Spring 的 ```@Component``` 注解将其标记为组件，并使用 AspectJ 的```@Aspect``` 将其标记为切面。

```beforeMethod``` 方法，就是一个前置通知，这个通知将会被插入到连接点（```ArithmeticCalculatorImpl``` 的四个方法）之前执行。

那么在 ```beforeMethod``` 方法上定义的 ```@Before``` 注解中，就定义了切点。注解中是 ```切点表达式```，用来指定匹配的类或者是方法，也就是说，被匹配到的类或者方法，就是所谓的切点，通知将在这个切点的位置进行执行。

## 1.编写切点

### a. AspectJ 切点表达式
在 ```@Before``` 注解中，我们使用了切点表达式来定义切点，下面详细的解释一下切点表达式

```execution(* org.lovian.spring.aop.impl.*.*(int, int))```

-   ```execution``` 表示在方法执行时触发
-   第一个 ```*``` 表示返回任意类型，当然也可以标记为具体的类型
-   接着是一个表达式来表示类和方法，```*``` 可以指代包下任意类或者类中任意方法，也可以具体指定类或者方法
-   括号中则可以表明方法的参数类型，或者可以使用 ```(..)``` 来代替任意参数类型


这样，通过一个切点表达式，我们就定义了一个切点，也就是通知所要执行的位置。例子中就指明了，所有匹配到 ```org.lovian.spring.aop.impl``` 包下的任意类中的任意返回值类型，参数类型是两个 int 类型的方法，就是我们的所要定义切点。
当切点定义的方法被执行的时候，我们定义的这个前置通知 ```beforeMethod``` 方法也会被执行

### b. AspectJ指示器

AspectJ 的指示器其实是切点表达式的一部分， ```execution``` 就是其中一个指示器。不同的地方式 ```execution``` 是用来实际执行匹配的，而其它的指示器都是用来限制匹配的。

下面列出主要的指示器

| AspectJ designator | Description |
| ------------------ | ----------- |
| args()             | Limits join-point matches to the execution of methods whose arguments are instances of the given types|
| @args()            | Limits join-point matches to the execution of methods whose arguments are annotated with the given annotation types |
| execution()        | Matches join points that are method executions |
| this()             | Limits join-point matches to those where the bean reference of the AOP proxy is of a given type |
| target()           | Limits join-point matches to those where the target object is of a given type |
| @target()          | Limits matching to join points where the class of the executing object has an annotation of the given type |
| within()           | Limits matching to join points within certain types |
| @within()          | Limits matching to join points within types that have the given annotation (the execution of methods declared in types with the given annotation when using Spring AOP) |
| @annotation        | Limits join-point matches to those where the subject of the join point has the given annotation|

这些指示器是可以通过逻辑操作符来连接起来，使得切点必须匹配所有的指示器：

-   ```&&```, ```and``` : 与 （在 xml 中使用 and 代替 &&）
-   ```||```, ```or``` : 或
-   ```!```, ```not``` :  非

比如：

```execution(* org.lovian.spring.aop.impl.ArithmeticCalculatorImpl.*(int, int)) && within（org.lovian.spring.aop.impl.*)```

这个切点表达式就设置的切点仅匹配```org.lovian.spring.aop.impl```包，和 ArithmeticCalculator 下参数是两个int 类型的方法


继续回到刚才的例子，切面和连接点已经被定义好了，在 ```beforeMethod``` 方法中，可以通过 ```Joinpoint``` 对象，来拿到连接点的信息，比如方法名，方法参数等。

接下来可以通过两种方式来配置注解，一种是 JavaConfig方式，一种是 XML 的方式

## 2. 通过 Java Config 方式配置注解来使用 AspectJ

下面就要通过 Java Config 的方式来配置 IOC 容器的组件扫描

```java
package org.lovian.spring.aop.configuration;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */

@EnableAspectJAutoProxy
@Configuration
@ComponentScan(basePackages="org.lovian.spring.aop")
public class CalculatorConfiguration {

}
```

-   ```@Configuration``` 注解定义了 ```CalculatorConfiguration``` 类是一个配置类;
-   ```@ComponentScan``` 则指定了组件自动扫描的范围;
-   ```@EnableAspectJAutoProxy``` 注解则指定了启用 AspectJ 自动代理，将会为被织入的类自动创建代理对象

然后我们实现一个测试类来测试：

```java
package org.lovian.spring.aop;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.lovian.spring.aop.configuration.CalculatorConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=CalculatorConfiguration.class)
public class CalculatorApp {
    private Log logger = LogFactory.getLog(CalculatorApp.class);

    @Autowired
    private ArithmeticCalculator calculator;

    @Test
    public void testAdd(){
        int result = calculator.add(1,2);
        logger.info("result: " + result);
    }
}
```

执行 testAdd() 方法，打印出的结果应该包含下面两行：

```
INFO: Method add begins with args: [1, 2]
INFO: result: 3
```

实际上打印result的结果应该由后置通知来实现，这个将会在后面的文章中讲述通知的时候以另外一个例子说明

## 2. 通过 xml 方式配置注解来使用 AspectJ

上面使用了 JavaConfig 的方式启用的组件自动扫描和 AspectJ 自动代理，那么还可以通过 xml 的方式来达到相同的目的。

首先我们在 ```src/main/resources/``` 下新建一个 xml 配置文件 ```config/aop_calculator_config.xml```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd">
    <!-- 组件扫描 -->
    <context:component-scan base-package="org.lovian.spring.aop"/>

    <!-- 启用 AspectJ 自动代理 -->
    <aop:aspectj-autoproxy/>

</beans>
```

然后修改测试类如下：

```java
package org.lovian.spring.aop;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Author: PENG Zhengshuai
 * Date: 5/14/18
 * lovian.org
 */

@RunWith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(classes=CalculatorConfiguration.class)
@ContextConfiguration({"classpath:config/aop_calculator_config.xml"})
public class CalculatorApp {
    private Log logger = LogFactory.getLog(CalculatorApp.class);

    @Autowired
    private ArithmeticCalculator calculator;

    @Test
    public void testAdd(){
        int result = calculator.add(1,2);
        logger.info("result: " + result);
    }
}
```

同样可以得到上面的结果。

和使用 JavaConfig 的方式唯一不同的一点就是，一个是配置类的方式定义了组件扫描和启用 AspectJ，而这个是在 XML 配置文件中指明