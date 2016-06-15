---
layout: post
title:  "[LinuxCPP] ch3. 函数"
date:   2016-02-24
desc: "Linux C++ note ch3. 函数"
keywords: "Linux, C++, Algorithm"
categories: [Programming]
tags: [C++,Algorithm, Linux]
icon: fa-keyboard-o
---
# 函数

[TOC]
## I. 函数的声明与调用

### 1.函数调用
-    主调（客户）函数与被调（服务器）函数
-    客户函数和被调函数会传递一些信息：函数调用时的参数与返回值
-    例一： ```Swap(a,b);```
    -    a, b 是传入的参数值， Swap函数把a， b 值互换， 所以没有返回值，返回值为空
-    例二： ```n = Add(a, b)```
    -    a, b 是传入的参数， 此函数会带回来一个结果 即 加法和，这里就会返回一个返回值

### 2.函数原型
-    函数的实现与调用格式说明： 作为函数接口， 一般出现在头文件中
-    格式： ```函数返回值类型 函数名称(形式参数列表)``` 
-    例一： ```int Add(int x, int y);```
-    例二： ```void Swap(int x, int y);```
-    例三： ```void Compute();```

## II. 函数定义

不仅可以使用标准库中的函数，还可以自己定义函数

### 1.函数实现
-    函数定义， 需要使用编程语言给出函数的执行步骤
-    函数返回值
    -    函数完成后带回来的结果
    -    主调函数可以使用
-    谓词函数
    -    返回bool类型值的函数
    -    表达某项任务是否完成或者某个条件是否满足



#### Add 函数

```cpp
//编写函数Add， 求两个整数的和
int Add(int x, int y)
{
    int t;
    t = x + y;
    return t;
}

```

#### Compare 函数

```cpp
// 编写函数Compare， 比较两个整型数据 x， y 的大小。
// 若 x 等于 y， 返回0
// 若 x 大于 y， 返回1
// 若 x 小于 y， 返回-1
int Compare(int x, int y)
{
    int t;
    if(x == y)
        t = 0;
    else if(x > y)
        t = 1;
    else
        t = -1;
    return t;

}

```

也可以用多条return语句，但是， 要注意在return语句后面的代码，往往不能够得到执行，除非这些return语句在不同的分支上

```cpp

int Compare(int x, int y)
{
    if(x == y)
        return 0;
    else if(x > y)
        return 1;
    else
        return -1;
}

```

#### Swap函数

```cpp
// 编写函数Swap， 互换两个整型数据的x、y值
void Swap(int x, int y)
{
    int t;
    t = x;
    x = y;
    y = t;
    return; //因为函数没有返回值， 只需写出return语句
}

```

思考不用临时变量，进行 两个量的互换



#### 谓词函数

```cpp
//编写函数IsLeap， 判断某个给定的年份是否为润年
bool IsLeap(int year)
{
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
}

```

谓词函数的作用一般拿来当作判断的条件表达式



### 2.函数重载
-    定义同名的但参数不完全相同的函数
-    示例
    -    ```int Max(int x, int y);```
    -    ```char Max(char x, char y);```
    -    ```bool Max(bool x, bool y);```

这样可以定义重名的函数，编译器编译的时候，会根据参数类型，自动匹配对应的函数



### 3.函数使用代码示例

```cpp
#include <iostream>
using namespace std;

int Add(int x, int y);
// 因为c/c++是一趟编译的语言
// 所以如果被调用的函数不写在调用函数之前
// 编译器是无法找到调用的函数
// 所以可以先写函数的声明， 或者写完整的函数
// 但是从维护代码的角度， 应该先写main函数
// main函数之前，只写函数的原型

int main(int argc, char const* argv[])
{
    int a, b, sum;
    cout << "This program is to calculate the sum of two integers\n";
    cout << "The first integer:";
    cin >> a;
    cout << "The second integer:";
    cin >> b
    sum = Add(a, b);
    cout << "The sum is " << sum << endl;
    return 0;

}

int Add(int x, int y){
    return x + y;
}

```

如果把程序组织成一个库的模式，则函数的组织方式，就不和main组织在一起了，函数的原型都会放在头文件里，而函数的实现则会放进源文件里。

## III. 函数调用规范

### 1.函数调用示例

```cpp
//编写程序，将用户输出的两个整数相加，要求尽可能使用函数将程序中的操作独立出来
#include <iostream>
using namespace std;
void Welcome();
int GetInteger(int idx);
int Add(int x, int y);
int main()
{
    int a, b, sum;
    // 程序的最初，应该给出程序的功能性的简单说明
    Welcome();
    a = GetInteger(1);
    b = GetInteger(2);
    sum = Add(a, b);
    cout << "The sum is " << sum << "." << endl;
    return 0;

}

void Welcome()
{
    cout << " The program gets two integers, and prints their sum." << endl;
}

int GetInteger(int idx)
{
    int t;
    cout << " No. " << idx << ":";
    cin >> t;
    return t;
}

int Add(int x, int y)
{
    int t;
    t = x + y;
    return t;
}

```

### 2.参数传递机制

#### 值传递机制
-    形式参数在函数调用时，才分配存储空间，并接受实际参数的值， 若没有调用，形式参数是没有存储空间的
-    形式参数，可以是复杂的表达式， 无论表达式多复杂，编译器都会在函数调用前，完成表达式的计算
-    形式参数和实际参数可以同名，也可以不同名
-    参数很多时， 实际参数值逐一赋值，它们必须保持数目、类型、顺序的一致
-    值的复制过程（实际参数向形式参数赋值）是（一次性）单向不可逆的，函数内部对形式参数值的修改不会反映到实际参数中去。
-    函数参数一般为函数输入集（函数从外部接收的信息的集合）的一部分，函数输出集（函数向外部输出的集合）一般使用返回值表示，只有使用特殊的手段才可以将函数参数作为函数输出集的一部分



##### 代码说明

```cpp
//编写程序，将用户输出的两个整数互换（错误示例）
#include <iostream>
using namespace std;
void Welcome();
int GetInteger(int idx);
void Swap(int x, int y);
int main()
{
    int a, b;
    Welcome();
    a = GetInteger(1);
    b = GetInteger(2);
    cout << "a: " << a << "b: " << b << endl;
    Swap(a, b);
    cout << "a: " << a << "b: " << b << endl;
    //这里我们会发现，a和b的值并没有发生改变
    //原因是，a和b将值传递到Swap（int x， int y）之后， x 和 y发生的变化跟 a 和 b是没有任何关系的
    //执行Swap（）函数的时候，Swap（）函数的栈框架，已经覆盖了main（）的函数栈框架
    // 后续可以使用指针和引用来解决
    return 0;

}

void Welcome()
{
    cout << " The program gets two integers, and swap them." << endl;
}

int GetInteger(int idx)
{
    int t;
    cout << " No. " << idx << ":";
    cin >> t;
    return t;
}

void Swap(int x, int y)
{
    int t;
    t = x;
    x = y;
    y = t;
    return;
}

```
不过我们可以使用全局变量来改变上面的代码，使上面的代码可以正确运行

```cpp

//编写程序，使用全局变量 将用户输出的两个整数互换（正确示例）

#include <iostream>
using namespace std;
int a， b;
//在这里定义的变量是全局变量，即从这里开始，到代码结束，所有的地方都可以使用的变量
// 也就是说，下面所有的函数包括main函数，都可以使用 a, b
// 因为这两个量被所有函数共享，所以Swap()连参数都不用传
// 所以Swap函数的形式参数列表就空了
// 但是Swap函数的实现也要全部换成 a 和 b

void Welcome();
int GetInteger(int idx);
void Swap();
int main()
{
    Welcome();
    a = GetInteger(1);
    b = GetInteger(2);
    cout << "a: " << a << "b: " << b << endl;
    Swap();
    cout << "a: " << a << "b: " << b << endl;
    //这里我们会发现，a和b的值并没有发生改变
    //原因是，a和b将值传递到Swap（int x， int y）之后， x 和 y发生的变化跟 a 和 b是没有任何关系的
    //执行Swap（）函数的时候，Swap（）函数的栈框架，已经覆盖了main（）的函数栈框架
    // 后续可以使用指针和引用来解决
    return 0;

}

void Welcome()
{
    cout << " The program gets two integers, and swap them." << endl;
}

int GetInteger(int idx)
{
    int t;
    cout << " No. " << idx << ":";
    cin >> t;
    return t;

}

void Swap()
{
    int t;
    t = a;
    a = b;
    b = t;
    return;
}

```

虽然问题解决了，但是处理办法并不好，所以不推荐如此处理

#### 引用传递

在指针和引用部分讨论

### 3.函数调用栈框架

画图表示函数的栈框架












