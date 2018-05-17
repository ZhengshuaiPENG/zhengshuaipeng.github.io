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