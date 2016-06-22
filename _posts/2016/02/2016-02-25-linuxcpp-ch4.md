---
layout: post
title:  "[LinuxCPP] ch4. 算法"
date:   2016-02-25
desc: "Linux C++ note ch4. 算法"
keywords: "Linux, C++, Algorithm"
categories: [Programming]
tags: [C++,Algorithm, Linux]
icon: fa-keyboard-o
---
# 算法

[TOC]

## I.算法的概念与特征

### 1.算法的基本概念
-    算法定义：解决问题的方法与步骤
-    设计算法的目的： 给出解决问题的逻辑描述， 根据算法描述进行实际编程

### 2.算法的基本特征

-    有穷性：步骤有限，算法在每种情况下都可以在有限步后终止
-    确定性：算法步骤的顺序和内容没有二义性
-    输入： 算法有零个或多个输入
-    输出： 算法至少要有一个输出（计算机内部发生了变化）
-    有效性： 时间有限，所有操作具有明确含义，并能在有限时间内完成

### 3.算法的正确性

算法的正确性，不是算法的特征，算法的正确性需要数学去证明

## II. 算法描述

### 1.伪代码
-    定义：混合自然语言与计算机语言， 数学语言的算法描述方法
-    优点：方便，容易表达设计者思想， 能够清楚的描述算法流程
-    缺点：不美观，算法复杂不容易理解
-    结构：
    -    顺序结构： ```执行某任务; 执行下一任务;```
    -    分支结构： if 结构， switch 结构
    -    循环结构：    for 循环， while 循环

### 2.流程图（程序框图）
-    定义：使用图形表示算法执行逻辑
-    优点：美观，算法表达清晰
-    缺点：绘制复杂，不易修改，占用过多篇幅
-    一般设算法设计完成后，写文档的时候用流程图

## III. 算法设计与实现

### 1.算法的设计
-    构造算法解决问题
-    按照自顶向下、逐步求精的方式进行：从顶层开始思考，然后在向细节进发
-    使用程序设计语言编程实现

### 2.典型示例

#### 素数判定问题
-    判断给定的某个自然数n (n > 2) 是否为素数
-    算法逻辑：
    -    输入： 大于2的正整数 n
    -    输出： 该数是否为素数， 若为素数返回true， 否则返回false。 （写输入输出可以基本确定算法原型）
    -    步骤1：设除数 i 为 2
    -    步骤2： 判断除数 i 是否为 n， 若为真返回 true， 否则继续
    -    步骤3： 判断 n % i 是否为 0, 若为 0 返回 false， 否则继续
    -    步骤4： 将除数 i 递增， 重复步骤2
-    实现1：

```cpp
bool IsPrime(unsigned int n)
{
    unsigned int i = 2;
    while(i < n)
    {
        if (n % i == 0)
            return false;
        i++;
    }
    return true;
}

```
-    实现2：（效率更高）

我们可以观察，如果一个数是合数，那么它一定会有两个因子，假设这两个因子是 p、q ，p 和 q的乘积是 n， 那么 p、q 一定一个大一个小，假设较小的那个是 p， 则 p <= q, 在这种情况下，p 一定是小于等于根号 n 的。这意味着， 如果这个数 n 是一个合数， 那么它一定有一个小于根号 n 的因子， 如果在 [2, sqrt(n)]之间都找不到它的任何一个因子， 那就不需要在寻    找了，n肯定是素数

```cpp
 bool IsPrime(unsigned int n)
{
    unsigned int i = 2;
    //sqrt(n), 是n的平方根， 在 <math.h> 或 <cmath> 头文件中
   //sqrt(n)结果是浮点数，需要cast转型
    while (i <= (unsigned int)sqrt(n))
    {
        if(n % i == 0)
            return false;
        i++;
    }

    return true;
}

```

在linux中，默认情况下，是不把数学库<math.h>装载进去的。 如果要装载它， 应该在链接的时候在 g++ 后面写上 "-lm": ```g++ -lm ```, 把数学库链接进去，才能够编译通过; 同时这里sqrt(n)会带来一个隐含的bug， 因为sqrt的结果是浮点数，就会存在误差， 比如sqrt(121), 理论结果应该是11.00000， 但是计算机有可能把它表示成11.00001或者是10.999999，这时候将结果转型的时候，有可能是11， 也有可能是10, 所以，程序的bug就出现了，有可能会判断出错。实现3将会解决这个问题， 并且将代码改进的比实现2更快

-    实现3

```cpp
bool IsPrime(unsigned int n)
{
    unsigned int i = 3;
    // 由于n 的平方根在参数n传进来的时候，就已经确定了
    // 所以就不用把开平方这个运算卸载while循环的判断中了
    // 由于浮点数的bug，所以这里在 sqrt 后 +1，多检查一次
    unsigned int t = (unsigned int)sqrt(n) + 1;

    if(n % 2 == 0)
        return false;
    while(i <= t)
    {
        if(n % i == 0)
            return false;
        i++;
    }

    return true;
}

```

算法选择要保证正确性，同时要兼顾效率和可理解性， 有的时候，算法简单一些，牺牲一点效率也是可以的。

#### 最大公约数问题

求两个正整数的 x 与 y 的最大公约数
-    函数原型设计：返回值就是最大公约数
    ``` unsigned int gcd(unsigned int x, unsigned int y);```
-    实现1：（穷举法）

```cpp
unsigned int gcd(unsigned int x, unsigned int y)
{
    unsigned int t;
    t = x < y ? x : y;
    while(x % t != 0 || y % t != 0)
    {
        t--;
    }
    return t;
    //无论如何，最差情况是除到1, 总会结束的，但是数字越大，运算的次数就越多，效率差
}

```
-    实现2：欧式算法(辗转相除法)
    -    输入： 正整数 x 和 y
    -    输出： 最大公约数
    -    步骤1： x 整除以 y， 记余数为 r
    -    步骤2： 若 r 为 0, 则最大公约数即为 y， 算法结束
    -    步骤3： 否则将 y 作为新 x， 将 r 作为新 y， 重复上述步骤

```cpp
unsigned int gcd(unsigned int x, unsigned int y)
{
    unsigned int r;
    while(true)
    {
        r = x % y;
        if(r == 0)
            return y;
        x = y;
        y = r;
    }
}
```

算法的发现并不容易，应该好好学数学！！！！！！



## IV. 递归算法

### 1.递归问题的引入

-    递推公式： 数学上很常见，
    -    如： 阶乘函数： 1! = 1, n! = n * (n - 1)!
    -    如： 菲波那切函数：f(1) = f(2) = 1, f(n) = f(n-1) + f(n - 2)
    -    递推函数一定是分段函数， 具有初始表达式
    -    递推函数的计算逻辑： 逐步简化问题的规模

### 2.递归的工作步骤

-    递归过程：逐步分解问题，使其更简单， n -> (n-1) -> (n-2) -> ...
-    回归过程：根据简单情形组装最后的答案，最后由最简单的情况比如 n=1 或 n=2 的情况，来递归计算

#### 阶乘函数

-    使用循环实现

```cpp
unsigned int GetFactorial(unsigned int n)
{
    unsigned int result = 1, i = 0;
    while(++i <= n)
    {
        result *= i;
    }
    return result;
}

```

-    使用递归实现


```cpp
unsigned int GetFactorial(unsigned int n)
{
    unsigned int result;
    if(n == 1)
        result = 1;
    else
        result = n*GetFactorial(n-1);
    return result;
}

```

一个函数通过直接或者间接的手段，调用自身的动作就叫做递归，这样的函数就叫做递归函数



#### 菲波那切数列函数

-    使用循环实现

```cpp
unsigned int GetFibonacci(unsigned int n)
{
    unsigned int i, f1, f2, f3;
    if(n == 2 || n == 1)
        return 1;
    f2 = 1;
    f1 = 1;
    for(i = 3; i <= n; i++)
    {
        f3 = f1 + f2;
        f1 = f2;
        f2 = f3;
    }
    return f3;
}

```

-    使用递归实现

```cpp
unsigned int GetFibonacci(unsigned int n)
{
    if( n == 2 || n == 1)
        return 1;
    else
        return GetFibonacci(n-1) + GetFibonacci(n-2);
}

```

对于同一个问题，往往递归的方式实现，代码量更少



### 3.递归和循环的比较

-    循环使用显示的循环结构重复执行代码段， 递归使用重复的函数调用执行代码段
-    循环在满足其终止条件时终止执行，而递归则是在问题简化到最简单的情形时终止执行
-    循环的重复，是在当前迭代执行结束时进行，递归的重复则是在遇到对同名函数的调用时进行
-    循环和递归都可能隐藏程序错误，循环的条件测试可能永远为真， 递归则可能永远退化不到最简单情形
-    理论是，任何递归程度，都可以使用循环迭代方法解决
    -    递归函数的代码更短小精悍
    -    一旦掌握递归的思考方法，递归程序更容易理解

### 4.汉诺塔问题

-    问题： 把x轴上 1-n 个圆盘 移动到z轴上，每次只能移动一个圆盘且大圆盘不能压在小圆盘上
-    问题分析：
    -    Q1： 是否存在某种简单情形，问题很容易解决
    -    Q2： 是否可以将原始问题分解成性质相同但规模较小的子问题，且新问题的解答对原始问题有关键意义
    -    A1:  只有一个圆盘时是最简单的情形
    -    A2： 对于 n > 1, 考虑 n - 1 个圆盘， 如果能将 n - 1 个圆盘移动到某个塔座上，则可以移动第 n 个圆盘
-    策略： 首先将 n - 1 个圆盘移动到塔座 Y 上，然后将第 n 个圆盘移动到 z 上， 最后再将 n - 1 个圆盘从 Y 上移动到 Z 上
-    伪代码

```cpp
void MoveHanoi(unsigned int n, HANOI from, HANOI tmp, HANOI to)
{
    if(n == 1)
        将一个圆盘从 from 移动到 to
    else
    {
        将 n-1 个圆盘从 from 以 to 为中转移动到 tmp
        将圆盘 n 从 from 移动到 to
        将 n-1 个圆盘以 tmp 以 from 为中转移动到 to
    }
}

```

-    实现代码

```cpp
#include <iostream>
using namespace std;
typedef enum { X,
    Y,
    Z } HANOI;

void PrintWelcomeInfo();
unsigned int GetInteger();
void MoveHanoi(unsigned int n, HANOI from, HANOI tmp, HANOI to);
char ConvertHanoiToChar(HANOI x);
void MovePlate(unsigned int n, HANOI from, HANOI to);

int main(int argc, char const* argv[])
{
    unsigned int n;
    PrintWelcomeInfo();
    n = GetInteger();
    MoveHanoi(n, X, Y, Z);
    return 0;

}

void PrintWelcomeInfo()
{
    cout << "The program shows the moving process of Hanoi.\n";
    return;
}

unsigned int GetInteger()
{
    unsigned int t;
    cout << "Please input a integer:";
    cin >> t;
    return t;
}

char ConvertHanoiToChar(HANOI x)
{
    switch (x) {
    case X:
        return 'X';
    case Y:
        return 'X';
    case Z:
        return 'Z';
    default:
        return '\0';
    }
}

void MovePlate(unsigned int n, HANOI from, HANOI to)
{
    char fc, tc;
    fc = ConvertHanoiToChar(from);
    tc = ConvertHanoiToChar(to);
    cout << n << ":" << fc << "-->" << tc << endl;
}

void MoveHanoi(unsigned int n, HANOI from, HANOI tmp, HANOI to)
{
    if (n == 1)
        MovePlate(n, from, to);
    else {
        MoveHanoi(n - 1, from, to, tmp);
        MovePlate(n, from, to);
        MoveHanoi(n - 1, tmp, from, to);
    }
}

```

### 5.递归信任(递归一定会工作)

-    递归实现是否检查了最简单情形
    -    在尝试将问题分解成子问题前，首先应该检查问题是否足够简单
    -    在大多数情况下，递归函数以 if 开头
    -    如果程序不是这样， 仔细检查源程序
-    是否解决了最简单情形
    -    大量递归错误是由于没有正确解决最简单情形导致的
    -    最简单情形不能调用递归
-    递归分解是否使问题更简单
    -    只有分解出的子问题更简单， 递归才能正确工作，否则将形成无限递归，算法无法终止
-    问题简化过程是否能够确实回归到最简单情形，还是遗漏了某些情况
    -    如汉诺塔问题， 需要调用两次递归过程， 程序中如果遗漏了任意一个都会导致错误
-    子问题是否与原始问题完全一致
    -    如果递归过程改变了问题实质，则整个过程肯定会得到错误结果
-    使用递归信任时， 子问题的解是否正确组装为原始问题的解
    -    将子问题的解正确组装以形成原始问题的解，也是必不可少的步骤

## V. 容错

### 1.容错

-    容错的定义：允许错误的发生
-    错误的定义：
    -    普通错误或者特殊情况：忽略该错误不对程序运行结果产生影响
    -    用户输入错误： 通知用户错误性质， 提醒用户更正输入
    -    致命错误： 通知用户错误的性质，停止执行
-    典型容错手段：
    -    数据有效性检查
    -    程序流程的提前终止

```cpp
void GetUserInput()
{
    获取用户输入数据
    while(用户输入数据无效)
    {
        通知用户输入数据有误， 提醒用户重新输入数据
        重新获取用户输入数据
    }
}

void Input()
{
    GetInputData();
    while(!IsValid)
    {
        OutputErrorInfo();
        GetinputData();
    }
}

```

## VI. 算法复杂度

### 1.算法复杂度

-    引入算法复杂度的目的： 度量算法的效率与性能
-    时间复杂度（一般看时间的）和空间复杂度

### 2.大O表达式

-    算法效率与性能的近似表示（定性描述）
-    算法执行时间与问题规模的关系
-    表示原则：
    -    忽略所有对变化趋势影响较小的项， 例如多项式忽略高阶项之外的所有项
    -    忽略所有与问题规模无关的常数，例如多项式的系数

### 3.标准算法复杂度类型

-    O(1): 常数级， 表示算法执行时间与问题规模无关
-    O(log(n)): 对数级， 表示算法执行时间与问题规模的对数成正比
-    O(sqrt(n)): 平方根级， 表示算法执行时间与问题规模的平方根成正比
-    O(n): 线性级， 表示算法执行时间与问题规模成正比
-    O(n*log(n)): n*log(n) 级， 表示算法执行与问题规模的 n*log(n)成正比
-    O(n^2): 平方级，表示算法执行时间与问题规模的平方成正比

### 4.算法复杂度估计
一般估计算法复杂度很简单，就是数循环嵌套了多少次，一般来说，一次循环，是O(n)级别，嵌套两层循环， 是O(n^2)级别。但是如果两层循环的话，如果地一层循环循环到sqrt(n), 第二层循环也循环到 sqrt(n)， 则复杂度是O(n)级别






