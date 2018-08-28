---
layout: post
title:  "[Linux] Linux 中常用的命令"
date:   2018-08-28
desc: "Common commands in Linux"
keywords: "Linux, shell, command, compress, decompress"
categories: [linux]
---

# I. Monitoring Programs

## Peeking at the processes

```
$ ps

$ ps -ef 
// -e: show all processes
// -f: display a full format lsiting

$ ps -ef | grep $PID
```

## Real-time process monitoring

```
$ top
```

![top](/assets/blog/2018/08/top.png)

-   First Line: Shows the ```current time```, ```how long the system has been up```, ```the number of users logged in```, and the ```load average``` on the system
    -   The load average appears as three numbers: ```1-minutes```, ```5-minutes```, ```15-minutes```
-   Second Line: ```Tasks```, how many processes are running, sleeping, stopped, and zombie
-   Next Lines: Show CPU usages, status of system memory

## Stopping processes

```
$ kill 
```

-   ```kill -1 PID```: hangs up
-   ```kill -3 PID```: stops running
-   ```kill -9 PID```: unconditionally terminates


# II.Monitoring Disk Space

## df 

To see how much disk space is available on an individual device

```
$ df
$ df -h
```

## du

Shows the disk usage for a specific directory(by default is current directory)

```
$ du
$ du -sh
$ du -sh $FOLDER_NAME
$ du -ch // show total
```

# III. Processing Data Files

## Sort for data

use ```sort``` command

```
$ cat file1
one
two
three
four
five
$ sort file1
five
four
one
three
two
$
$ cat file2
1
2
100
45
3
10
145
75
$ sort file2
1
10
100
145
2
3
45
75
$
$ sort -n file2 // -n to sort numbers
1
2
3
10
45
75
100
145
```

## Searching for data

```grep [options] pattern [file]```

-   grep example

```
$ grep three file1
three
$ grep t file1
two
three
```

-   Reverse grep, output lines that don't match the pattern

```
$ grep -v t file1
one
four
five
```

-   Find the line number where matching patterns are found

```
$ grep -n t file1
2:two
3:three
```

-   Count of how many lines contain the matching pattern

```
$ grep -c t file1
2
```

-   Specify more than one mathing pattern

```
$ grep -e t -e f file1
two
three
four
five
```

-   Use regular expression

```
$ grep [tf] file1
two
three
four
five
```

## Compressing Data

## Archiving data