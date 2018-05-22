---
layout: post
title:  "[JAVA_Spring] Spring AOP 详解二之通知 Advice"
date:   2018-05-14
desc: "Spring AOP Explained in Details - Aadvice"
keywords: "java, spring, AOP， Advice"
categories: [spring]
---

在 [Spring AOP 详解一之 AspectJ 基于注解配置 AOP](http://blog.lovian.org/spring/2018/05/14/java-spring-aop-detail-annotation.html#tocAnchor-1-2) 一文中介绍了 Spring 中如何配置 AOP，并且在 ```LoggingAspect``` 的日志切面类中，实现了切面的定义，切点的定义。 方法 ```beforeMethod``` 就是一个```前置通知 Before Advice```。

# I. 通知 Advice

正如[AOP 术语](http://blog.lovian.org/spring/2018/05/07/java-spring-aop.html#tocAnchor-1-4) 中介绍的， ```通知定义了切面是什么以及何时使用```，所谓何时使用，就是说它应该应用在某个方法被调用之前？之后？之前之后都调用？还是只在抛出异常时的式和使用？

所以 Spring 切面有5种类型的通知：
-   ```前置通知（Before）```： 在目标方法被调用之前调用通知功能
-   ```后置通知（After）```：在目标方法完成之后调用通知，此时不关心方法的输出是什么
-   ```返回通知（After-returning）```：在目标方法完成后调用通知
-   ```异常通知（After-throwing）```：在目标方法抛出异常后调用通知
-   ```环绕通知（Around）```：通知包裹了被通知的方法，在被通知的方法调用之前和调用之后执行自定义的行为


# II. AspectJ 注解定义通知

在 ```LoggingAspect``` 中， 我们在 ```beforeMethod``` 上使用了 ```@Before```， 这个注解是用来定义前置通知方法。

| Annotation | Advice |
| ---------- | ------ |
| @After     | The advice method is called after the advised method returns or throws an exception. |
| @AfterReturning | The advice method is called after the advised method returns. |
| @AfterThrowing | The advice method is called after the advised method throws an exception. |
| @Around | The advice method wraps the advised method. |
| @Before | The advice method is called before the advised method is called. |

# III. 代码实例

场景说明：我们需要一场音乐会 Concert,音乐会由多个表演 Performance 组成。 这个音乐会有小提琴表演和钢琴表演，也有可能有其他表演，观众 Audience 则根据表演给出相应的反应。

分析如下： Audience 根据表演给出相应的反应，那么，这些反应对每一个 Performance 来说应该是一致的，所以 Audience 在这里就可以抽象成一个切面。而 Performance 则是我们的目标 Target，Performance 中的方法即切点，Audience 切面中定义不同的通知来切入到 Target 中的切点。

首先先定义一个 Performance 接口：

```java
package org.lovian.spring.concert;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */
public interface Performance {
    void perform();
}
```

可以看到 Performance 接口中定义了 perform() 方法，那么这个 perform() 方法就应该是我们所说的切点了。

然后定义切面 Audience 类：

```java
package org.lovian.spring.concert;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */

@Aspect
public class Audience {
    private Log logger = LogFactory.getLog(Audience.class);

    // define a named point cut, name is the methodName
    @Pointcut("execution(* org.lovian.spring.concert.Performance.perform(..))")
    public void performance() {
        // its method body should be empty
    }

    //before performance
    //@Before("execution(* org.lovian.spring.concert.Performance.perform(..))")
    @Before("performance()")
    public void silenceCellPhones() {
        logger.info("Silencing cell phones");
    }

    //before performance
    //@Before("execution(* org.lovian.spring.concert.Performance.perform(..))")
    @Before("performance()")
    public void takeSeats() {
        logger.info("Taking seats");
    }

    //after performance
    //@AfterReturning("execution(* org.lovian.spring.concert.Performance.perform(..))")
    @AfterReturning("performance()")
    public void applause() {
        logger.info("CLAP CLAP CLAP");
    }

    //after bad performance
    //@AfterThrowing("execution(* org.lovian.spring.concert.Performance.perform(..))")
    @AfterThrowing("performance()")
    public void demandRefund() {
        logger.info("Demanding a refund");
    }
}
```

类似上个例子中出现的 beforeMethod 一样， 在 Audience 中定义各种通知， 这里一共由四个通知， 包括了 ```@Before```， ```@AfterReturning``` 和 ```@AfterThrowing```，也就是前置通知，返回通知，和异常通知

切点则由切点表达式来匹配，那么由于我们定义的切点只有一个 ```perform()```, 所以在每一个通知上都定义一个一样的切点表达式，那么就造成了代码的冗余，所以我们通过 ```@Pointcut``` 注解来定义一个切点的位置，那么通过 ```@Pointcut```定义的切点表达式就可以被其他的通知进行调用。就比如 ```Audience.performance()``` 一样，它的方法体就应该为空，指向了我们定义的切点。那么其他的注解就可以使用 ```performance()``` 去代替一般的切点表达式了。

那么我们定义两个 Performance 接口的实现类：
一个是不会抛出异常的（指的是 RuntimeException)

```java
package org.lovian.spring.concert;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */

@Component
public class PianoPerformance implements Performance {
    private Log logger = LogFactory.getLog(PianoPerformance.class);

    @Override
    public void perform(){
        logger.info("Perform piano...");
    }
}
```

然后定一个另一个会抛出异常的（RuntimeException）

```java
package org.lovian.spring.concert;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Component;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */

@Component
public class ViolinPerformance implements Performance {
    private Log logger = LogFactory.getLog(ViolinPerformance.class);

    @Override
    public void perform() {
        logger.info("Bad violin performance");
        throw new RuntimeException("performance interrupted");
    }
}
```

为什么这里要使用 ```RuntimeException```？因为运行期的异常可以不需要 try-catch 去显式的处理，而一般的编译期异常，需要去显式的处理掉。所以对于代理对象来说，你如果显式的把异常处理掉了，那么我的通知也没必要切入进去了。

现在有了 Target和切面类了，我们要配置 Spring Configuration，这里采用的方式是 JavaConfig 的方式：

```java
package org.lovian.spring.concert;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */

@Configuration
@EnableAspectJAutoProxy
@ComponentScan(basePackages = "org.lovian.spring.concert")
public class ConcertConfig {

    @Bean
    public Audience audience(){
        return new Audience();
    }
}
```

在 ```ConcertConfig``` 类中，开启了指定包下的组件扫描和启用 AspectJ 的自动代理。然后在其中定义切面类的实例 bean。```ConcertConfig``` 同样也可以通过 xml file 来定义。

然后定义 Concert 类，来测试我们的功能

```java
package org.lovian.spring.concert;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = ConcertConfig.class)
public class Concert {
    @Autowired
    private Performance pianoPerformance;

    @Autowired
    private Performance violinPerformance;

    @Test
    public void testGoodPerformance(){
        pianoPerformance.perform();
    }

    @Test
    public void testBadPerformance(){
        violinPerformance.perform();
    }
}
```
执行 ```testGoodPerformance()``` 得到结果如下：

```
INFO: Refreshing org.springframework.context.support.GenericApplicationContext@28d25987: startup date [Tue May 22 22:28:01 CST 2018]; root of context hierarchy
May 22, 2018 10:28:01 PM org.lovian.spring.concert.Audience silenceCellPhones
INFO: Silencing cell phones
May 22, 2018 10:28:01 PM org.lovian.spring.concert.Audience takeSeats
INFO: Taking seats
May 22, 2018 10:28:01 PM org.lovian.spring.concert.PianoPerformance perform
INFO: Perform piano...
May 22, 2018 10:28:01 PM org.lovian.spring.concert.Audience applause
INFO: CLAP CLAP CLAP
```

可以看出执行顺序是 ```Silencing cell phones --> Taking seats --> Perform piano... --> CLAP CLAP CLAP```

接着我们测试 ```testBadPerformance()```， 结果如下：

```
INFO: Refreshing org.springframework.context.support.GenericApplicationContext@28d25987: startup date [Tue May 22 22:32:59 CST 2018]; root of context hierarchy
May 22, 2018 10:33:00 PM org.lovian.spring.concert.Audience silenceCellPhones
INFO: Silencing cell phones
May 22, 2018 10:33:00 PM org.lovian.spring.concert.Audience takeSeats
INFO: Taking seats
May 22, 2018 10:33:00 PM org.lovian.spring.concert.ViolinPerformance perform
INFO: Bad violin performance
May 22, 2018 10:33:00 PM org.lovian.spring.concert.Audience demandRefund
INFO: Demanding a refund

java.lang.RuntimeException: performance interrupted

	at org.lovian.spring.concert.ViolinPerformance.perform(ViolinPerformance.java:20)
...
Process finished with exit code 255
```

这里看到执行顺序是 ```Silencing cell phones --> Taking seats --> Bad violin performance --> Demanding a refund```，并且 Exception 被打印了出来， UnitTest 同时也 fail了。那么我们应该猜到了这个 ```@AfterThrowing``` 并没有catch这个exception，但是在这个 exception 发生后执行了 ```demandRefund``` 方法。

下面我们将 Audience 的通知设置为```环绕通知 @Around```，然后我们再执行看区别：

```java
package org.lovian.spring.concert;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;

/**
 * Author: PENG Zhengshuai
 * Date: 5/17/18
 * lovian.org
 */

@Aspect
public class Audience {
    private Log logger = LogFactory.getLog(Audience.class);

    // define a named point cut, name is the methodName
    @Pointcut("execution(* org.lovian.spring.concert.Performance.perform(..))")
    public void performance() {
        // its method body should be empty
    }

    @Around("performance()")
    public void watchPerformance(ProceedingJoinPoint joinPoint){
        try{
            logger.info("Silencing cell phones");
            logger.info("Taking seats");
            joinPoint.proceed();
            logger.info("CLAP CLAP CLAP");
        }catch (Throwable e){
            logger.info("Demanding a refund");
        }
    }
}
```

在环绕通知中，我们将需要处理的通知，分别对应的放到对应的位置，要注意的是这里 ```Throwable 是被 catch 住的```。那么我们来执行测试 ```testBadPerformance()```，得到结果如下：

```
INFO: Refreshing org.springframework.context.support.GenericApplicationContext@28d25987: startup date [Tue May 22 22:40:59 CST 2018]; root of context hierarchy
May 22, 2018 10:40:59 PM org.lovian.spring.concert.Audience watchPerformance
INFO: Silencing cell phones
May 22, 2018 10:40:59 PM org.lovian.spring.concert.Audience watchPerformance
INFO: Taking seats
May 22, 2018 10:40:59 PM org.lovian.spring.concert.ViolinPerformance perform
INFO: Bad violin performance
May 22, 2018 10:40:59 PM org.lovian.spring.concert.Audience watchPerformance
INFO: Demanding a refund

Process finished with exit code 0
```

可以看出，不仅 UnitTest 测试也过了，并且 Exception 并没有被打印出来，那么说明在环绕通知中 ```Exception 实际上是被处理```了的。


总结：这个例子很好的应用了 Spring IOC 和 AOP 的思想， 并且将通知进行了说明。