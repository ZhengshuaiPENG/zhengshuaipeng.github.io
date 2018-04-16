i---
layout: post
title:  "[Linux] Linux find command"
date:   2018-04-16
desc: "find commands in Linux"
keywords: "Linux, shell, find"
categories: [linux]
---

# I.Find Command
Use find command to search files in ****nux like system.

```$ find [path...] [expression]```
-   path:
    -   ```.``` 表示当前目录
    -   ```/``` 表示路径根目录
-   expression: ```-options [-print -exec -ok...]```
    -   ```-options```: 指定 find 命令常用选项,比如```-name``` 是按照文件名来查找文件
    -   ```-print```: find 命令将匹配到的文件输出到标准输出
    -   ```-exec```:
        -   find 命令将匹配的文件执行该参数所给出的 shell 命令
        -   响应命令的形式为 ```command {  } \;```, 注意 ```{  }``` 和 ```\;```之间的空格

# II. Example

-   ```$find ./ -size 0 -exec rm {} \;``` 删除文件大小为0 的文件
-   ```find . -name "*.xml" -print``` 在当前目录寻找 xml 文件并打印
-   ```find path -type f -not -name "xxx" -delete``` 删除path目录中名字不是 xxx 的所有文件
-   ```find path -type d -empty -delete``` 删除path目录中所有空的文件夹

