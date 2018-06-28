---
layout: post
title:  "[ELK Stack] ELK Stack Trouble Shooting"
date:   2018-06-28
desc: "ELK Stack trouble shooting"
keywords: "ELK, Elasticsearch, Logstash, Kibana, trouble shooting"
categories: [elk]
---

# Trouble Shooting

## 1. Elasticsearch 不允许 root 权限运行

在 Linux 环境 Elasticsearch 不允许以 root 的权限来运行
解决方案: 创建用户组,把当前用户加入到用户组中,然后更改 elk 程序的所有者

```
# groupadd devusers
# gpsswd -a current_user devusers 
# chown -R current_user:devusers /usr/local/elk
```

## 2. vm.max_map_count 不低于 262144

Elasticsearch 默认要求 ```vm.max_map_count``` 不低于 ```262144```.
其中 ```vm.max_map_count``` 是系统内核参数, 表示虚拟内存的大小.

错误提示

```
max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

解决方案:

1. 临时设置 ```vm.max_map_count```, 系统重启后会恢复默认值

```
sysctl -w vm.max_map_count=262144
```

2. 永久性设置 ```vm.max_map_count```, 在 ```/etc/sysctl.conf``` 中修改参数

```
echo "vm.max_map_count=262144" > /etc/sysctl.conf
sysctl -p
```

## 3. nofile 不低于 65536

Elasticsearch 进程要求可以打开的最大文件数不低于 ```65536```, ```nofile``` 表示系统中,进程允许打开的最大文件数

错误提示:

```
max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
```

在 ```/etc/security/limits.conf``` 文件中修改 ```nofile``` 参数

```
echo "* soft nofile 65536" > /etc/security/limits.conf
echo "* hard nofile 131072" > /etc/security/limits.conf
```

## 4. nproc 不低于 2048

Elasticsearch 要求最大的线程数不低于 2048, ```nproc``` 表示最大线程数

错误提示:

```
max number of threads [1024] for user [user] is too low, increase to at least [2048]
```

解决方案: 在 ```/etc/security/limits.conf``` 中修改 ```nproc``` 参数

```
echo "* soft nproc 2048" > /etc/security/limits.conf
echo "* hard nproc 4096" > /etc/security/limits.conf
```

## 5. Kibana No Default Index Pattern Warning

访问 Kibana 页面后出现如下错误信息

```
Warning No default index pattern. You must select or create one to continue.
...
Unable to fetch mapping. Do you have indices matching the pattern?
```

说明 logstash 还没有将数据传输到 Elasticsearch. 如果正常有日志输出, 那么就需要去检查 logstash 和 Elasticsearch 之间的通信了.