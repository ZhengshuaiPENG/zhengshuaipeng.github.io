---
layout: post
title:  "[JAVA_Spring] Spring 使用 Java Config 自动装配 Bean"
date:   2018-04-22
desc: "Spring autowired bean by java config"
keywords: "java, spring, Bean， annotation, java config， autowired"
categories: [java, spring]
---

# I. Spring Bean 的装配机制

在之前的章节里面我们讲过 Spring 的```装配机制```：

-   在 XML 中进行显式配置
-   通过 Annotation 在 Java 中进行隐式的 bean 发现机制和自动装配

Spring 提供了几种方式既可以单独使用，也可以配合着使用。即便如此，还是```尽可能的使用自动装配的机制```，显式的配置越少越好。

但是某些时候，比如模块有很多人开发，或者开发之后的源码由别人维护，配置 Bean 的时候，显式的配置则会更方便维护人员。那么除了 XML 的方式，我们还可以```通过使用类型安全并且比 XML 更为强大的 JavaConfig```来显式的配置 Bean。除非需要使用 XML 中的 namespace 并且 JavaConfig之中没有同样的实现的时候，就可以选择 XML 方式


# II. Spring 自动化装配 Bean

之前的章节， [Spring XML AutoWired](http://blog.lovian.org/java/spring/2018/04/08/java-spring-bean-autowired.html) 和 [Spring Annotation](http://blog.lovian.org/java/spring/2018/04/18/java-spring-annotations.html) 也介绍过如何使用注解和组件扫描来以及XML的方式实现自动化装配, 其实Spring是从两个角度来实现的自动化装配的：

-   ```组件扫描(component scanning)```: Spring 自动发现应用上下文所创建的 bean
-   ```自动装配(autowiring)```： Spring 自动满足 bean 之间的依赖

那我们尽量使用组件扫描和自动装配来使得显式配置降低到最少， 下面通过一个实例来演示

# III. 代码实例

我们来实现一个需求，创建一个 CD 播放器，播放器可以播放一张 CD，使用 Spring 来自动把 CD 装配给 CD 播放器。

我们先建立 CD 的概念，创建一个 CD 的接口，代码如下：

```java
package org.lovian.spring.soundsystem;

/**
 * Author: PENG Zhengshuai
 * Date: 4/27/18
 * lovian.org
 */


public interface CompactDisc {
    void play();
}
```

在这个接口中，定义了一个 CD 播放器能够对一个 CD 所能进行的操作，然后我们创建一个 CD 的实现类，比如周杰伦的范特西，代码如下：

```java
package org.lovian.spring.soundsystem;

import org.springframework.stereotype.Component;

/**
 * Author: PENG Zhengshuai
 * Date: 4/27/18
 * lovian.org
 */

@Component
public class JayCompactDisc implements CompactDisc {

    private String title = "Fantasy";
    private String artist = "Jay Chou";

    public void play() {
        System.out.println("Playing " + title + " by " + artist);
    }
}
```

在 ```JayCompactDisc``` 里面，我们定义了两个成员变量，调用 ```play()``` 方法时，会将这两个变量打印出来; 同时给这个类标注 ```@Component``` 注解，这个注解表明该类会作为一个组件类，并且告诉 Spring 在 IOC 容器中要去创建这个类的 bean 实例。

在 [Spring Annotation](http://blog.lovian.org/java/spring/2018/04/18/java-spring-annotations.html) 中我们讲到，由于组件扫描默认是不启用的，如果要使用组件扫描的功能，则需要在 XML 中配置 ```component-scan```：

```xml
<context:component-scan base-package="org.lovian.spring.soundsystem">
```

在这里，我们还另一种 ```JavaConfig``` 的配置方式来配置组件扫描：

```java
package org.lovian.spring.soundsystem;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Author: PENG Zhengshuai
 * Date: 4/27/18
 * lovian.org
 */

@Configuration
@ComponentScan
public class CDPlayerConfig {
}
```
```CDPlayerConfig``` 类通过代码的方式，完成了类似 XML 定义的装配规则。```@Configuration``` 注解表明了这个类是一个配置类，而 ```@ComponentScan``` 注解则告诉 Spring 要启用组件扫描。

如果没有其他配置的话， Spring 会默认会扫描和标注了```@ComponentScan``` 的配置类相同的包。在这里 ```CDPlayerConfig``` 位于包 ```org.lovian.spring.soundsystem``` 中，那么 Spring 则会扫描这个包以及其子包，查找所有被标注 ```@Component``` 注解的类，并为其创建 bean。

```@ComponentScan```也可以指定扫描的包，通过使用 ```basePackages``` 属性（注意是复数），可以指定多个包，用 ```,```分隔， 比如：

```java
@ComponentScan(basePackages="org.lovian.spring.soundsystem", "org.lovian.spring.videos")
```

接下来我们创建一个 Test 类来测试一下结果

```java
package org.lovian.spring.soundsystem;


import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * Author: PENG Zhengshuai
 * Date: 4/27/18
 * lovian.org
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes=CDPlayerConfig.class)
public class CDPlayerTest {

    @Autowired
    private CompactDisc cd;

    @Test
    public void assertCdBean(){
        Assert.assertNotNull(cd);
        Assert.assertEquals(JayCompactDisc.class, cd.getClass());
    }
}
```

这个类使用了 ```org.junit``` 库和 ```spring-test``` 模块，我们需要在 ```pom.xml``` 或者 classpath 中加入依赖，maven 依赖如下：

```xml
<dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-test</artifactId>
        <version>5.0.5.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>RELEASE</version>
</dependency>
```

在 ```CDPlayerTest``` 类中， ```@RunWith``` 是 Junit 组件的标注，```SpringJUnit4ClassRunner``` 则是告诉 Junit，在测试开始的时候，调用这个类来```自动创建 Spring 的 ApplicationContext```。 ```@ContextConfiguration``` 注解则指明了要在哪个配置类中来加载配置。我们将 ```CompactDisc``` 使用 ```@Autowired``` 注解注入到这个 Test 类中，然后运行测试，测试通过。