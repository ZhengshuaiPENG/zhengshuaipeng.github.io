---
layout: post
title:  "[LinuxCPP] ch6. 复合数据类型"
date:   2016-02-29
desc: "Linux C++ note ch6. 复合数据类型"
keywords: "Linux, C++, Algorithm"
categories: [Programming]
tags: [C++,Algorithm, Linux]
icon: fa-keyboard-o
---

# 复合数据类型

[TOC]

## I.字符

### 1.字符

#### 字符类型、字符文字与量

-    定义格式： 字符变量：```char ch;``` 字符常量：```const char cch = 'C';```
-    字符文字使用单引号对
-    实际存储时字符类型量存储字符的对应ASCII值
-    可以使用signed（缺省情况） 与 unsigned 修饰字符类型
-    正常情况下，ASCII码，用一个字节（8 bit： -128 ～127之间）来存储字符
-    Unicode 则使用两个字节(16 bit)来存储

#### 字符表示的等价性

下列四个是等价的

-    ```char a = 'A';```
-    ```char a = 65;``` ：十进制ascii
-    ```char a = 0101;``` ：八进制ascii
-    ```char a = 0x41;``` ： 十六进制ascii

### 2.ASCII码

跟整数一一映射， 要记住 0 的 ascii 码值是 48
-    控制字符、通信专用字符、可打印字符
-    回车于换行(不同的系统，文件交换需要处理换行)
    -    windows： ```\n\r```
    -    linux: ```\n```
    -    mac: ```\r```

### 3.字符量的数学运算

编写函数，判断某个字符是否为数字

```cpp

bool IsDigit(char c)
{
    if(c >= '0' && c <= '9')
        return true;
    else
        return false;
}

bool IsDigit(char c)
{
    if(c >= 48 && c <= 57)
        return true;
    else
        return false;
}

```

编写函数，将字符转换为大写字符

```cpp

char ToUpperCase(char c)
{
    if(c >= 'a' && c <= 'z')
        return c - 'a' + 'A';
    else
        return c;c
}

```



### 4.标准字符特征库

-    C 标准字符特征库： ctype.h/cctype
-    标准字符特征库常用函数
    -    ```bool isalnum(char c);``` : 判断字符 c 是不是英文字母和数字
    -    ```bool isalpha(char c);``` ：判断字符 c 是不是因为字符
    -    ```bool isdigit(char c);```
    -    ```bool islower(char c);```
    -    ```bool isspace(char c);```
    -    ```bool isupper(char c);```
    -    ```bool tolower(char c);```
    -    ```bool toupper(char c);```   

## II.数组

### 1.数组的意义与性质

#### 数组的定义

-    格式： ```元素类型 数组名称 [常数表达式]```
-    示例： ```int a[8]``` 定义包含8个整数元素的数组
-    常数表达式必须是常数和常量， 不允许为变量
    -    错误示例： ```int count 8; int c[count];``` 因为这里count是变量，但是如果 count 用 const 定义了，就是对的
    -    如果是 C 程序， 那么常量也不允许，只能使用常数
-    数组元素编号从 0 开始计数， 元素访问格式为 a[0]、 a[1]、 a[2]、....
-    不允许对数组整体进行赋值操作，只能使用循环逐一的复制元素
    -    错误示例： ```int a[8], b[8]; a = b;```
-    意义与性质
    -    将相同性质的数据元素组织成整体， 构成单一维度上的数据序列

### 2.数组的存储表示

-    内存中数组元素依次连续存放，中间没有空闲空间
-    数组的地址
    -    数组的基地址： 数组开始存储的物理位置
    -    数组首元素的基地址： 数组首个元素开始存储的物理地址，即起始元素的地址编号
    -    数组首元素的基地址在数值上总是与数组基地址相同
    -    ```&``` 操作符： ```&a``` 获得数组的基地址；```&a[0]```获得数组首元素的基地址， 实际上这两个数值是相同的
    -    注意： 当单独出现数组的名称 ```a```的时候，就意味着取这个数组的基地址， 也就是 ```&a``` 和 ```&a[0]```, 所以 & 大部分情况下可以不用写
    -    设数组基地址为 p， 并设每个元素的存储空间为 m， 则第 i 个元素的基地址为 p + mi



### 3.数组元素的初始化

-    基本初始化格式
    -    定义格式： ```元素类型 数组名称[元素个数] = { 值1, 值2, 值3...}```
    -    示例一： ```int a[8] = {1, 2, 3, 4, 5, 6, 7, 8};```
    -    初始化前4个元素： ```int a[8] = { 1, 2, 3, 4, , , , };```
    -    初始化后4个元素： ```int a[8] = { , , , , 5, 6, 7, 8};```
-    初始化时省略元素个数表达式
    -    在全部元素均初始化时，可以不写元素个数， 使用 ```sizeof``` 操作符可以获得元素个数
    -    示例二： ```int a[] = {1, 2, 3, 4, 5, 6, 7, 8}; int num_of_elements = sizeof(a) / sizeof(a[0]);```
    -    ```sizeof(a)``` 用于获取数组存储空间的大小（以字节为单位）， ```sizeof(a[0])``` 获取数组首元素的存储空间大小
    -    数组的存储空间大小，除以数组首元素占用的存储空间大小，就得到了数组的长度

### 4.数组基本操作示例

编写程序，使用数组存储用户输入的5个整数， 并计算他们的和

```cpp

#include <iostream>
using namespace std;
int main()
{
    int i, a[5], result = 0;
    //用循环来给数组赋值，不能整体赋值
    for (i = 0; i < 5; i++)
    {
        cout << "Integer No. " << i +1 << ":";
        cin >> a[i];
    }

    for (i = 0; i < 5; i ++)
    {
        result += a[i];
    }
    cout << "The sum of elements of the array is " << result << endl;
    return 0;
}

```



### 5.数组与函数

-    数组元素作为函数实际参数

```cpp
int Add(int x, int y)
{
    return x + y;
}

int a[2] = {1, 2}, sum;
sum = Add(a[0], a[1]);
```

-    数组整体作为函数的形式参数
    -    基本格式： ```返回值类型 函数名称(元素类型 数组名称[], 元素个数类型 元素个数)```
    -    示例： ```void GenerateIntegers(int a[], unsigned int n);```
    -    特别说明： 作为函数的形式参数时， 数组名称后的中括号内不需要列写元素个数，必须使用单独的参数传递元素个数信息
-    代码示例

编写函数，随机生成 n 个位于 [lower, upper]区间的整数保存到数组中

```cpp
void GenerateIntegers(int a[], unsigned int n, int lower, int upper)
{
    unsigned int i;
    Randomize();
    for(i = 0; i < n; i++)
        a[i] = GenerateRandomNumber(lower, upper);
}

```
数组作为函数参数时有一个巨大的优势，就是能够把函数内部的修改带出去， 调用函数的那个实际的数组，就会被改变; 就是说，数组作为函数参数的时候，不仅仅是函数的输入集的一部分，同时也是函数输出集的一部分， 和普通的量作为函数参数的时候是不一样的。 同时，作为输入，不建议输入数组的长度，比如 int a[8], 则此函数不可复用， 因为在内部 for 循环，循环次数会写死为 8 次。 而且， 直接书写变量也不行， 比如 ```void GenerateIntegers(int a[n], int lower, int upper)```, 原因是数组的元素个数不能为变量， 只能为常数或者是常量， 所以这个是错误的。 因此，最好的解决办法，是像上述代码一样，用另一个变量 int n 来控制数组的元素个数

-    调用格式
    -    使用单独数组名称作为函数的实际参数， 传递数组基地址而不是数组元素值
    -    形式参数和实际参数实际上对应着同一片的存储区，即使用相同的存储区， 对数组形式参数值的改变会自动反应到实际参数中

```cpp
#define NUMBER_OF_ELEMENTS 8
const int lower_bound = 10;
const int upper_bound = 99;
int a[NUMBER_OF_ELEMENTS];
GenerateIntegers(a, NUMBER_OF_ELEMENTS, lower_bound, upper_bound);
//这个函数调用结束后，数组 a 里的值则会保存在函数中生成的随机整数

```

#### 代码示例

-    编写程序，随机生成 8 个 10-99 之间的整数保存到数组中，然后将这些程序颠倒过来。
-    写一个数组操作库： arrmanip.h 

```cpp
// arrmanip.h
// header file of arrmanip
void GenerateIntegers(int a[], unsigned int n, int low, int high);
void SwapIntegers(int a[], unsigned int i, unsigned int j);
void ReverseIntegers(int a[], unsigned int n);
void PrintIntegers(int a[], unsigned int n);

```

```cpp
// arrmanip.cpp
#include <iostream>
#include <iomanip>
#include "zyrandom.h"
#include "arrmanip.h"
using namespace std;
void GenerateIntegers(int a[], unsigned int n, int low, int high)
{
    Randomize();
    for (unsigned int i = 0; i < n; i++) {
        a[i] = GenerateRandomNumber(low, high);
    }
}

void SwapIntegers(int a[], unsigned int i, unsigned int j)
{
    int tmp;
    tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;
}

void ReverseIntegers(int a[], unsigned int n)
{
    for (unsigned int i = 0; i < n / 2; i++) {
        SwapIntegers(a, i, n - i - 1);
    }
}

void PrintIntegers(int a[], unsigned int n)
{
    for (unsigned int i = 0; i < n; i++) {
        cout << setw(3) << a[i];
    }
    cout << endl;
}
```

```cpp
//test.cpp
#include <iostream>
#include "arrmanip.h"
using namespace std;

#define NUMBER_OF_ELEMENTS 8
const int lower = 10;
const int upper = 99;

int main(int argc, char const* argv[])
{
    int a[NUMBER_OF_ELEMENTS];
    GenerateIntegers(a, NUMBER_OF_ELEMENTS, lower, upper);
    cout << "Array generated as follows: \n";
    PrintIntegers(a, NUMBER_OF_ELEMENTS);
    ReverseIntegers(a, NUMBER_OF_ELEMENTS);
    cout << "After all elements of the array reversed: \n";
    PrintIntegers(a, NUMBER_OF_ELEMENTS);
    return 0;
}
```
ps: 在用g++ 编译的时候，需要链接上头文件的实现：
```$ g++ -Wall test.cpp arrmanip.cpp zyrandom.h```

### 6.多维数组

#### 多维数组的定义
-    格式：```元素类型 数组名称[常数表达式1][常数表达式2]...```
-    示例一：```int a[2][2];```: 2×2 个整数元素的二维数组
-    示例二：```int b[2][3][4];```: 2×3×4 个整数元素的三维数组

#### 多维数组的初始化

-    与一维数组类似： ```int a[2][3] = {1, 2, 3, 4, 5, 6};```
-    单独初始化每一维： ```int a[2][3] = {[1, 2, 3], [4, 5, 6]};``` 建议以这种方法写. (这里中括号应该是花括号，但是jeykell的markdown 会把两个花括号括一起算错，所以这里用中括号代替)

#### 多维数组的存储布局

同单维数组，先行后列顺序存放： a[1][1]: a[0][0] -> a[0][1] -> a[1][0] -> a[1][1]

一般来说， 两维数组，需要两重for循环来计算，有时候甚至需要三重for循环  

## III.结构体

与数组不同，数组里所有的元素性质必须是相同的，但是结构体里，所有的元素性质可以相同，也可以不同

### 1.结构体的意义和性质

#### 结构体的意义
-    与数组的最大差别： 不同类型数据对象构成的集合
-    也可以为相同类型的但具体意义或解释不同的数据对象集合

#### 结构体的定义： 注意类型后面定义的分号

```
struct 结构体名称
{
    成员类型1 成员名称1;
    成员类型2 成员名称2;
    ...
    成员类型n 成员名称n;
};

// 注意最后有个分号

```

#### 结构体定义示例

```cpp
// 日期结构体
struct DATE
{
    int year;
    int month;
    int day;
};

```

```cpp

// 复数结构体
struct COMPLEX
{
    double real;
    double imag;
};

```

#### 结构体类型的声明

-    在C++中，可以仅仅只引入结构体类型的名称， 而没有给出具体定义， 其具体定义在其他头文件中或本文件后续的位置
-    ```struct COMPLEX;``` ： 注意在这里就直接以分号结尾，这是一个结构体的声明，而不是定义，因为没有花括号对及其语句块

#### 具体示例

如何表示学生信息？其成员如下：
-    整数类型的学号 i
-    字符串类型的姓名 name
-    性别（单独定义枚举类型） gender
-    年龄 age
-    字符串类型的地址 addr

```cpp
enum GENDER{FEMALE, MALE};
struct STUDENT
{
    int id;
    STRING name;
    GENDER gender;
    int age;
    STRING addr;

}

// 在这里我们假设已经有了字符串类型的定义

```

### 2.结构体的存储表示

-    按照成员定义的顺序存放： 各个成员的存储空间一般连续（不像数组是紧密排放的，结构体不强求紧密排放，一般连续即可，中间可能会出现空洞）
-    特殊情况：
    -    因为不同硬件和编译器的原因， 不同类型的成员可能会按照字（两个字节) 或双字（四个字节）对齐后排放
    -    使用 ```sizeof```来获得结构体类型量占用空间的大小（以字节为单位），下述两种使用方式均可：```sizeof date;``` 或 ```sizeof(date);```

### 3.结构体数据对象的访问

#### 结构体类型的变量与常量
-    按照普通格式定义
-    示例一： ```DATE date;```
-    示例二： ```STUDENT zhang_san;```
-    示例三： ```STUDENT student[8];```

#### 结构体类型的变量的初始化
-    示例： ```DATE date = {2008, 8, 8};```

#### 结构体量的赋值

-    与数组不同，数组是不可以直接赋值的，而结构体量可以直接赋值， 拷贝过程为逐成员意义复制
-    示例： ```DATE new_date; new_date = date;``` 两个结构体的类型必须一致

#### 结构体数据对象的访问

##### 结构体量成员的访问

-    使用点号操作符 ```.``` 解析结构体量的某个特定的成员
-    示例一：

```cpp
DATE date;
date.year = 2008;
date.month = 8;
date.day = 8;

```

##### 嵌套结构体成员的访问

-    可以连续使用点号进行逐层解析
-    示例二：

```cpp
struct FRIEND{
    int id;
    STRING name;
    DATE birthday;
};

FRIEND friend;
friend.birthday.year =1998;
```

##### 复杂结构体成员的访问

-    严格按照语法规范进行
-    示例三：

```cpp

FRIEND friends[4];
// 成员为数组
friends[0].birthday.year = 1988;

```

### 4.结构体与函数

编写一函数，使用结构体来存储日期，并返回该日在该年的第几天信息，具体天数从 1 开始计数， 例如 2016年 1 月 20 日返回 20, 2 月 1 日返回 32

```cpp
// a function which can count the number of the date of the year
struct DATE {
    int year;
    int month;
    int day;
};

bool IsLeap(int year);

unsigned int GetDateCount(DATE date)
{
    static unsigned int days_of_months[13] = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    
    unsigned int i, date_id = 0;
    for (i = 1; i < date.month; i++) {
        date_id += days_of_months[i];
    }
    date_id += date.day;

    if (date.month > 2 && IsLeap(date.year)) {
        date_id++;
    }

    return date_id;
}

// IsLeap() 用来判断是不是润年
bool IsLeap(int year)
{
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
}
```

由于数组不能整体赋值，所以数组不能作为函数的返回值; 但是结构体可以整体赋值，可以结构体可以作为函数的返回值。

计算机屏幕上的点使用二维坐标描述， 编写函数，随机生成一个屏幕上的点， 设计算机的屏幕分辨率为 1920×1200, 屏幕坐标总是从 0 开始技术

```cpp
struct POINT
{
    int x;
    int y;
};

const int orignal_point_x = 0;
const int orignal_point_y = 0;
const int num_of_pixels_x = 1920;
const int num_of_pixels_y = 1200;

POINT GeneratePoint()
{
    POINT t;
    t.x = GenerateRandomNumber(orignal_point_x, num_of_pixels_x - 1);
    t.y = GenerateRandomNumber(orignal_point_y, num_of_pixels_y -1);{{1, 2, 3}}
    return t;

}
```


