---
layout: post
title:  "[ELK Stack] ELK Stack 简介"
date:   2018-06-26
desc: "ELK Stack introduction"
keywords: "ELK, Elasticsearch, Logstash, Kibana"
categories: [elk]
---

# I. ELK

```ELK Stack(Elasticsearch, Logstash, Kibana)```, 是目前开源的分布式日志管理方案,也是最流行的实时数据分析方案之一.

-   ```Elasticsearch``` 是一个基于 Lucene 构建的开源, 分布式, RESTful 的搜索引擎,负责日志的存储,检索和分析
-   ```Logstash``` 用来传输和处理日志,事务或者其他数据
-   ```Kibana``` 是一个Web 前端,把 Elasticsearch 的数据分析并可视化

Elasticsearch 官网: [Elasticsearch Products](https://www.elastic.co/products)

Elasticsearch Docs: [Elasticsearch Docs](https://www.elastic.co/guide/en/elastic-stack/current/index.html)

# II. ELK 解决的问题

对于线上应用来说, 当应用出了问题之后, 开发人员就要上到服务器上去查看log日志,来找到出问题的地方从而解决问题. 对于单机,日志量小的情况下,这种方式还是很方便的.但是如果当应用是以集群的方式部署, 每一个服务器节点上都有日志的情况下,去人工查log则会非常的麻烦,而且不好定位到问题.

而 ELK 的出现就可以避免集群上日志查看,搜索,分析的麻烦.它可以实现每个节点上的日志收集, 日志搜索和日志分析的功能.

# III. ELK stack 架构图

![elk_stack](/assets/blog/2018/06/elk_stack.png) 

这张图是 ELK 的架构图, 图中说明了日志数据的流向, 下面进行详细说明.

从图中可以看出, 数据的来源主要分两种:

一种是通过 ```Beats(一种数据传输平台)``` 将集群上各个节点服务器上的数据,发送给 Logstash

另外一种则是通过```各种网络协议(TCP/UDP/HTTP)``` 将数据发送到目标 Logstash.

```Logstash``` 接收到数据之后, 对数据做一些```字段提取处理(Extract Fields)```或者```数据丰富处理(Enrich)```后, 将处理后的数据发送给 Elasticsearch (一般是以 Json 的格式)

```Elasticsearch``` 使用RESTful接口处理 JSON 请求. 实际上是基于 Lucene 的分布式搜索分析引擎,当数据从 Logstash 过来之后, Elasticsearch 会将数据写成```索引(Index)```进行集中存储.

```Kibana``` 则是前端交互界面, 它把 Elasticsearch 收集的数据进行可视化展示,并提供配置和管理 ELK 的界面


# IV. ELK 的安装

## 1. 下载地址

Elasticsearch 官方下载地址: [Elasticsearch Download](https://www.elastic.co/downloads/elasticsearch)

Logstash 官方下载地址:[Logstash Download](https://www.elastic.co/downloads/logstash)

Kibana 官方下载地址:[Kibana Download](https://www.elastic.co/downloads/kibana)

Beats 官方下载地址:[Beats Download](https://www.elastic.co/downloads/beats)


建议 ELK 都下载同一版本的zip/tar包以避免问题

这里只考虑 MacOS 和 Linux 环境, 我们再 ```/usr/local``` 目录下,建立一个目录

```
➜  ~ cd /usr/local
...
➜  sudo mkdir elk
```

然后将目录的所有者更改为当前用户和当前用户所在的用户组

```
➜  sudo chown -R user_name:group_name elk
➜  chmod -R 775 elk
➜  ll
total 0
drwxrwxr-x    2 zhshpeng  admin    64B Jun 26 17:35 elk
```
然后将 zip/tar 包都下载进这个目录里

## 2. JDK

需要在服务器环境中安装 JDK, 对于 ELK 6.0 版本及以上, JDK 要求是 1.8 版本.
所以需要将当前 ```$JAVA_HOME``` 设置为 jdk 1.8 的版本

```
➜  ~ java -version
java version "1.8.0_172"
Java(TM) SE Runtime Environment (build 1.8.0_172-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.172-b11, mixed mode)
```

## 3. 安装 Elk

用 wget 在 ```/usr/local/elk``` 目录中将系统版本对应的 elk 的软件包下载下来, 然后解压

```
unzip xxx.zip
tar -xvzf xxx.tar.gz
```

解压后可以为解压后的文件夹做使用 ```ln -s source target``` 来创建软连接

```
➜  elk ll
total 950528
lrwxr-xr-x   1 zhshpeng  admin    19B Jun 28 13:22 elasticsearch -> elasticsearch-6.3.0
drwxr-xr-x  11 zhshpeng  admin   352B Jun 11 23:44 elasticsearch-6.3.0
-rwxrwxr-x@  1 zhshpeng  admin    87M Jun 13 22:37 elasticsearch-6.3.0.zip
lrwxr-xr-x   1 zhshpeng  admin    26B Jun 28 13:23 kibana -> kibana-6.3.0-darwin-x86_64
drwxr-xr-x  16 zhshpeng  admin   512B Jun 12 08:02 kibana-6.3.0-darwin-x86_64
-rw-r--r--@  1 zhshpeng  admin   193M Jun 13 22:38 kibana-6.3.0-darwin-x86_64.tar.gz
lrwxr-xr-x   1 zhshpeng  admin    14B Jun 28 13:22 logstash -> logstash-6.3.0
drwxr-xr-x  17 zhshpeng  admin   544B Jun 28 13:21 logstash-6.3.0
-rwxrwxr-x@  1 zhshpeng  admin   147M Jun 13 22:39 logstash-6.3.0.zip
```


# V. ELK 启动测试

## 1. Elasticsearch

先进入到对应路径启动 Elasticsearch:

```
➜ pwd
/usr/local/elk/elasticsearch/bin
➜ ./elasticsearch &
```

然后可以发一个请求进行测试:

```
➜  ~ curl http://localhost:9200
{
  "name" : "zoEbdbq",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "3hYrr6ITQXmxfZL9oZILEw",
  "version" : {
    "number" : "6.3.0",
    "build_flavor" : "default",
    "build_type" : "zip",
    "build_hash" : "424e937",
    "build_date" : "2018-06-11T23:38:03.357887Z",
    "build_snapshot" : false,
    "lucene_version" : "7.3.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## 2. Logstash

对于 Logstash, 我们需要写一个conf文件```logstash.conf```用来指定要使用的插件以及每个插件的设置

下面是一个 ```logstash.conf``` 的示例
```
input { stdin { } }
output {
  elasticsearch { hosts => ["localhost:9200"] }
  stdout { codec => rubydebug }
}
```

我们进到 ```/usr/local/elk/logstash/config/ ``` 目录, 新建一个文件夹 custom, 然后按照示例将 ```logstash.conf``` 写进去

```
➜  pwd
/usr/local/elk/logstash/config
➜  mkdir custom
➜  cd custom
➜  vim logstash.conf
```

进入到对应路径启动 Logstash

```
➜   pwd
/usr/local/elk/logstash/bin
➜  ./logstash -f ../config/custom/logstash.conf &
```

## 3. Kibana

kibana 首先我们要指定 Elasticsearch URL, 从而将 Kibana 和 Elasticsearch 关联起来.这个配置文件位于 ```kibana/config/kibana.yml```, 首先对 kibana 原来的配置文件做备份.

```
➜  pwd
/usr/local/elk/kibana/config
➜  cp kibana.yml kibana.yml.origin
```

然后编辑 ```kibana.yml``` 文件将 28 行注释去掉, 指定
```
elasticsearch.url: "http://localhost:9200"
```
保存后启动 kibana

```
➜   pwd
/usr/local/elk/kibana/bin
➜   ./kibana &
```

然后浏览器打开 [http://localhost:5601/](http://localhost:5601/) 就可以访问 kibana 了