---
layout: post
title:  "[LinuxCPP] ch2. 程序控制结构"
date:   2016-02-15
desc: "Linux C++ note ch2. 程序控制结构"
keywords: "Linux, C++, Algorithm"
categories: [Programming]
tags: [C++,Algorithm, Linux]
icon: fa-keyboard-o
---
# 程序控制结构

[TOC]


## I. 结构化程序设计基础

### 1.程序的控制结构（黑箱）

-    单入口单出口



### 2.三种基本控制结构

-    顺序结构
-    分支结构
-    循环结构
-    复杂控制结构可以由上述三种结构组合



### 3.顺序结构

-    由一组顺序执行的处理块组成，每个处理块可能包含一条或者一组语句，完成一项任务
-    顺序结构是最基本的算法结构： ```入口``` --> ``` 语句块A --> 语句块B ``` --> ```出口```
-    示例代码

```cpp

#include<iostream>
using namespace std;

int main(int argc, char const* argv[])
{
    cout << "This program will compare two numbers and return you back the maxmum" << endl;
    int a, b, max;
    cout << "Please input first number" << endl;
    cin >> a;
    cout << "Please input second number" << endl;
    cin >> b;

    max = a > b ? a : b; // 三元表达式
    cout << "The maxmum number is " << max << endl;

    return 0;
}

```

#### 三元表达式

-    ```condition ？ true code block ： false code block```
-    condition is true, exeucute true code block
-    condition is false, exeucute false code block



### 4.分支结构

-    分支结构（选择结构）含义：由某一个条件的判断结果，确定程序的流程，即选择哪一个程序分支中的处理块去执行
-    最基本的分支结构是二路分支结构



### 5.循环结构

-    循环结构定义：由某一条件的判断结果， 反复执行某一处理块的过程
-    最基本的循环结构是： 进入循环结构， 判断循环条件，若循环条件为真，则循环一次，然后再判断循环条件，当循环条件为假时，循环结束



## II. 布尔数据

一个值只有 true 或 false 时， 称之为bool 数据



### 1.枚举类型

-    声明： ```enum 枚举名 (元素名1, 元素名2, 元素名3, ..., 元素名n);```
-    如： ```enum MONTH(JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC);```
-    枚举类型声明中的元素为枚举文字， 不是变量
-    计算机处理枚举时，将枚举元素映射成整数， 地一个枚举元素（文字）映射成0,之后的元素则自动+1 ...一直到n-1
-    但是，在写代码的过程中， 不可以直接给枚举变量传一个整数，因为一个是int类型， 一个是enum类型， 类型不匹配
-    定义枚举类型变量 ```Month month;```
-    意义：将多个文字组织在一起，表达从属于特定类型的性质，取代魔数， 使代码易于理解



### 2.用户自定义数据类型

-    自定义类型的格式： ```typedef 原类型标识 新类型名``` 如```typedef int DWORD```
-    自定义类型的性质：
    -    新类型和元类型相同， 并为产生新类型，重新命名的自定义类使程序更易理解
    -    若整数可以用于表示两类不同数据对象，使用自定义类型可以区分它们
    -    自定义类型不是简单的类型替换，虽然它们确实等同（性质一样）



### 3.布尔类型

-    bool类型
    -    取值：false、true
    -    C语言没有这个类型，只在C++中有， C程序不能使用这三个关键字
-    bool量的定义
    -    定义： ```bool modified;```
    -    赋值： ```modified = true;```



### 4.关系表达式

-    关系操作符： 大于(>) 等于(==) 小于(<)  小于等于(<=) 大于等于(>=) 不等于(!=)
-    关系表达式： 关系操作符和两个操作数构成的表达式，运算结果为逻辑值：true or false
-    逻辑值（布尔值）： C/C++中， true：非0  false：0， C++建议用布尔值; 但是在linux中，由于大部分代码是早期C语言，就不可避免的要使用非0和0来表达真假



### 5.逻辑表达式

-    逻辑操作符： 与(&&) 或(||) 非(!)
-    逻辑表达式， 逻辑操作符和两个操作数构成的表达式， 运算结果为逻辑值： true or false
-    优先级顺序： （从高到低） ！、  <、  <=、  >、  >=、 (这四个同级， 先左后右) ==、  !=、(这两个同级） && ; ||(最低)



### 6.逻辑表达式求值

画逻辑关系图， 然后进行与并计算



## III. 分支结构

### 1.If分支结构

-    格式一： ```if(condition) {block}```
-    格式二： ```if(condition) {block1} else {block2}```
-    格式三： ```if(condition1) {block1} else if(condition2) {block2} else if(condition3) {block3} ... else{block n}```



```cpp

// print calendar
#include<iostream>
#include<iomanip>
// iomanip header to make table， 用来表格打印
// manip is manipulate, to indicate of format of output
// to use setw(width),设置宽度 来打印表格，在第width个位置打印

using namespace std;

typedef enum {SUN, MON, TUE, WED, THU, FRI, SAT} WEEKDAY;
// define a enum type WEEKDAY

int main(int argc, char const* argv[])
{
    int date;
    const WEEKDAY date_1 = FRI;
    WEEKDAY weekday;

    // input part
    cout << "The program gets a date (1-31), \n";
    cout << "and prints a calendar of 2006-12 (just the date). \n";
    cout << "The date: ";
    cin >> date;

    if(date > 31 || date < 1){
        // to check if the input is valid
        cout << "Date error! \n";
        return 1;
    }

    // calculation part
    weekday = (WEEKDAY)((date + (int)date_1 - 1) % 7);
    // 1st is Friday. (int) here to convert the enum to int for calculation

    //output part
    cout << "Calendar 2016-12\n";
    cout << "---------------------\n";
    cout << "Su  Mo  Tu  We  Th  Fr  Sa\n";
    cout << "---------------------\n";

    // make table
    // print the week info in right position
    if (weekday == SUN) {
        cout << setw(2) << date;
    } else if (weekday == MON) {
        cout << setw(6) << date;
    } else if (weekday == TUE) {
        cout << setw(10) << date;
    } else if (weekday == WED) {
        cout << setw(14) << date;
    } else if (weekday == THU) {
        cout << setw(18) << date;
    } else if (weekday == FRI) {
        cout << setw(22) << date;
    } else {
        cout << setw(26) << date;
    }
    cout << endl <<"----------------------\n";

    return 0;

}

```

### 2.Switch 分支结构

```cpp

switch(expression)
{
    case 常数表达式1： 语句1;
    case 常数表达式2： 语句2;
    case 常数表达式3： 语句3;
    ...
    case 常数表达式4： 语句4;
    default： 默认语句序列
}

```

-    switch 后面的表达式必须为 **int char enum***(可以和整数一一对应)
-    case 后面必须为常量表达式， 且各个case不能相同
-    若无default分支，且无case分支匹配，则不执行
-    case分支中语句可以有多条，不需要花括号
-    分支中要使用break语句，看下节
-    分支中可以嵌套



```cpp

// print calendar
#include <iostream>
#include <iomanip>

using namespace std;
typedef enum{SUN, MON, TUE, WED, THU, FRI, SAT} WEEKDAY;

int main(int argc, char const* argv[])
{
    int date;
    const WEEKDAY date_1 = FRI;
    WEEKDAY weekday;

    cout << "The program gets a date(1-31), and prints the Calendar\n";
    cout << "The date:\n";
    cin >> date;

    if (date > 31 || date < 1) {
        cout << "Date error!\n";
        return 1;
    }

    weekday = (WEEKDAY)((date + (int)date_1 -1) % 7);

    cout << "Calendar 2016-12\n";
    cout << "-----------------------------\n";
    cout << "SU  MO  TU  WE  TH  FR  SA\n";
    cout << "-----------------------------\n";
    switch (weekday) {
        case SUN:
            cout << setw(2) << date ;
            break;
        case MON:
            cout << setw(6) << date;
            break;
        case TUE:
            cout << setw(10) << date;
            break;
        case WED:
            cout << setw(14) << date;
            break;
        case THU:
            cout << setw(18) << date;
            break;
        case FRI:
            cout << setw(22) << date;
            break;
        case SAT:
            cout << setw(26) << date;
            break;
        default:
            ;
    }

    // 如果这里没有break，且date是3 即Sunday的话， 则会打印 7 个 date
    // 因为程序会执行所有switch中的语句块
    cout << endl << "---------------------------\n";
    return 0;

}

```

### 3.分支嵌套

如果有两个if 和一个else，如何配对？ 如果不用花括号括起来，则使用默认规则：

else将根据下列规则来默认配对最近的if
-    离它最近：距离最短（从后往前最近一个if）
-    同层次： 排除底层嵌套



## IV. break语句

switch 中， case 只能起到进入相对应语句的作用，而没有离开这个语句块的作用。 如果在case中不写break， 则程序会执行剩下swich中所有当前case内语句以后的所有的语句块。



## V. 循环结构

### 1.while 循环

-    格式： ```while(表达式）循环体```
-    循环执行流程： 先判断后执行： 表达式为真， 执行一遍循环体（一次迭代）， 返回重新计算表达式的值来确定是否继续执行循环体; 若表达式为假，则终止循环
-    为保证循环能终止，循环体内应有能改变表达式值的语句， 若没有此语句，则会发生无限循环
-    例外情况，满足某种条件时，使用 break 语句， 终止无限循环



```cpp

// calculate sum
#include <iostream>
using namespace std;
int main(int argc, char const* argv[])
{
    int n, sum = 0;
    cout << "The program gets some integers, and output their sum. \n";
    cout << "To stop, please input 0.\n";
    cout << "Please input an integer:";
    cin >> n;
    //先在循环体外取值， 循环提内部先累加，再读取下一个
    while (n != 0) {
        sum += n;
        cout << "The next integer:";
        cin >> n;
    }

    //或者可以这样， 使用哨兵，当用户输入满足情况，循环终止
    // 程序外部不赋值，程序内部先读取，再累加 
    //while (true) {
    //    cout << "The next integer: "
    //    cin >> n;
    //    if (n == 0) {
    //      break;
    //    }
    //    sum += n;
    //}
    // 此处 这个if语句就是个哨兵

    cout << "The sum is " << sum << endl;
    return 0;

}

```

### 2.for 循环

比while循环更方便，控制语句全在头部



#### 递增递减表达式（优先级非常高）

-    前缀递增递减
    -    格式：```++变量名称;``` ```--变量名称;```
    -    例一： 设 a 为 1, ```++a``` <==> ```a = a + 1```， a 的结果为2
    -    例二： 设 a 为 1, ```--a``` <==> ```a = a - 1```,  a 的结果为0 
    -    例三： 设 a 为 1， ```b = ++a * 3``` <==> ```a = a + 1; b = a * 3```, a 结果为2, b 为6
    -    计算： 先递增递减， 后参与运算



-    后缀递增递减
    -    格式： ```变量名称++;``` ```变量名称--;```
    -    计算： 先参与运算，再递增递减



#### for语句
-    格式： ```for(初始化表达式; 条件表达式; 步进表达式)```{循环体}
-    可以与while 互换， while 适用于不需要或很少需要初始化的场合，而for循环的循环控制写在头部，结构最清晰



```cpp

// 求 1-n 的平方和
#include <iostream>
using namespace std;

int main(int argc, char const* argv[])
{
    int n, sum = 1;
    cout << "This program gets a positive integer. \n";
    cout << "And prints the squared sum from 1 to number n\n";
    cout << "The number:";
    cin >> n;

    for (int i = 1; i < n + 1; i++) {
        sum = sum + i * i;
    }
    cout << "The result is " << sum << endl;
    return 0;

}

```



#### 循环嵌套

```cpp

//打印99乘法表
#include <iostream>
#include <iomanip>
using namespace std;

int main(int argc, char const* argv[])
{
    cout << "Nine by Nine Multiplication Table \n";
    cout << "-----------------------------------\n";

    // print the row of 1-9
    for (int i = 0; i < 9; i++) {
        cout << setw(4) << i + 1;
    }
    cout << endl;
    cout << "------------------------------------\n";

    for (int i = 1; i < 10; i++) {
        for (int j = 1; j < i + 1; j++) {
            cout << setw(4) << i*j;
        }
        cout << endl;
    }
    return 0;

}

// 一般二维表基本使用二重循环

```


