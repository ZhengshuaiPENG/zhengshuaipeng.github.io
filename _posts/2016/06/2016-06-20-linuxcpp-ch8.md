---
layout: post
title:  "[LinuxCPP] ch8. 链表与程序抽象"
date:   2016-06-20
desc: "Linux C++ note ch8. 链表与程序抽象"
keywords: "Linux, C++, Algorithm"
categories: [Programming]
tags: [C++,Algorithm, Linux]
icon: fa-keyboard-o
---
#链表与程序抽象

[TOC]

## I. 数据抽象

### 1.数据抽象的目的与意义

#### 数据对象

数据对象有 VANT -- Value, Address， Name， Type
-    信息缺失： 在真实的程序中， 数据对象只会保留地址和值， 没有数据类型、数据解释及数据意义等信息
-    解决手段： ***抽象***
    -    数据的表示： 注释、 有意义的数据对象名称（在源代码级别， 保持数据对象的意义）
    -    数据的功能： 描述可以在数据上工作的操作集
    -    数据的 功能比表示更重要（重心在算法而不是数据结构上）

### 2.结构化数据类型的性质
-    类型： 细节由用户自定义， 语言仅提供定义手段
-    成员 ： 结构化数据类型的子数据对象
-    成员类型： 每个成员具有确切的类型
-    成员数目 ： 部分结构化数据类型可变， 部分固定
-    成员组织： 成员组织结构（线性结构或者非线性结构） 必须显式定义
-    操作集 ： 可以在数据上进行的操作集合

### 3.数据封装
-    数据封装： 将数据结构的细节隐藏起来
-    实现方式： 分别实现访问数据成员的存取函数
-    数据封装示例

```cpp
// dynamic array
struct DYNINTS{
    unsigned int capacity; // capacity of this array
    unsigned int count; // number of items in the runtime
    int * items; // array
    bool modified; // array changed or not
};

// getter
unsigned int DiGetCount(DYNINTS* a)
{
    if(!a){
        cout << "DiGetCount: Parameter illegal." << endl;
        exit(1);
    }
    return a->count;
}
```

实现数据的封装，就是对结构体里的数据成员，提供相应的存储函数。

### 4.信息隐藏

-    数据封装的问题： 只要将结构体类型定义在头文件中，库的使用者就可以看到该定义， 并按照成员格式直接访问， 而不调用存储函数; 但是封装应该是不允许直接访问数据结构的成员，而是应该通过存储函数去访问，但是这里并没有限制成员的直接访问
-    解决方法： 将结构体类型的具体细节定义在源文件中，所有针对该类型量的操作都只能通过函数接口来进行，从而隐藏实现细节 （就是藏起来所有的成员）
***数据封装和信息隐藏和在一起，才是编写抽象程序的关键***
-    信息隐藏示例

```cpp
/*头文件 “dynarray.h"*/
struct DYNINTS;
typdef struct DYNINTS * PDYNINTS;
/*源文件 ”dynarray.cpp"*/
struct DYNINTS{
    unsigned int capacity;
    unsigned int count;
    int * items;
    bool modified;
}
```

把定义写在源文件中，因为用户只能看见头文件，而源文件可以以编译好的二进制代码来提供，所以，用户是看不见数据结构是如何定义的，从而实现了信息隐藏的目的。 而为了保证用户可以正确的适用这个结构体，那么就应该在头文件中给出这个结构体的声明

### 5.数据结构设计

```cpp
/* "point.h" */
#include "stdbool.h"
struct POINT;
typedef struct POINT * PPOINT;

PPOINT PtCreate(int x, int y);
void PtDestroy(PPOINT point);
void PtGetValue(PPOINT point, int * x, int * y);
void PtSetValue(PPOINT point, int x, int y);
bool PtCompare(PPOINT point1, PPOINT point2);
char * PtTransformIntoString(PPOINT point);
void PtPrint(PPOINT point);
```

```cpp
/* "point.cpp" */
#include "point.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
using namespace std;

static char *DuplicateString(const char *s);
struct POINT {
  int x, y;
};

PPOINT PtCreate(int x, int y) {
  PPOINT t = new POINT;
  t->x = x;
  t->y = y;
  return t;
}

void PtDestroy(PPOINT point) {
  if (point) {
    delete point;
  }
}

void PtGetValue(PPOINT point, int *x, int *y) {
  if (point) {
    if (x)
      *x = point->x;
    if (y)
      *y = point->y;
  }
}

bool PtCompare(PPOINT point1, PPOINT point2) {
  if (!point1 || !point2) {
    cout << "PtCompare: Parameter(s) illegal." << endl;
    exit(1);
  }
  return (point1->x == point2->x) && (point1->y == point2->y);
}

void PtPrint(PPOINT point) {
  if (point)
    printf("(%d,%d)", point->x, point->y);
  else
    printf("NULL");
}

char *PtTransformIntoString(PPOINT point){
  char buf[BUFSIZ];
  if(point){
    sprintf(buf, "(%d, %d)", point->x, point->y);
    return DuplicateString(buf);
  }
  else{
    return "NULL";
  }
}

char * DuplicateString(const char* s){
  unsigned int n = strlen(s);
  char* t = new char[n+1];
  for(int i = 0; i < n; i++){
    t[i] = s[i];
    t[n] = '\0';
  }
  return t;
}
```

## II. 链表

### 1.链表

-    链表的意义与性质
    -    存储顺序访问的数据对象集
    -    数据对象占用的存储空间总是动态分配的
-    链表的定义
    -    元素序列，每个元素与前后元素相链接
head ---> data | next ----> data | next ----> ... ----> tail
    -    结点： 链表中的元素 （Node）， 包括两个字段： 数据域 data 和链接域 next
    -    表头结点，表尾结点： 链表中的头尾结点
    -    头指针、尾指针： head 和 tail 就是这个链表的表头指针和表尾指针， 分别指向链表的表头结点和表尾结点

### 2.链表的数据结构

-    链表结点： 适用结构体类型表示
    至少包含两个域： 结点数据域与链接指针域

```cpp
struct NODE;
typedef struct NODE * PNODE;

struct NODE{
PPOINT data; // data filed of current node
PNODE next; // points to next node , tail is NULL
}

```

-    链表结构： 封装结点表示的细节

```cpp
struct LIST;
typedef struct LIST * PLIST;

struct LIST{
    unsigned int count; // the number of nodes
    PNODE head, tail; // head pointer, tail pointer
}

```

-    特别说明
    -    结点是动态分配内存的，所以结点在逻辑上连续，但是物理上地址空间不一定连续
    -    时刻注意维护链表的完整性： 一旦头指针head 失去链表表头地址， 整个链表就会丢失; 任一结点 next 域失去下一结点地址， 后续结点就会全部丢失
    -    单向链表、 双向链表（previous， next）、 循环链表（tail points to head）、双向循环链表



### 3.抽象链表接口

```cpp
/* list.h */
#include "point.h"

struct LIST;
typedef struct LIST * PLIST;

PLIST LICreate();

void LIDestroy(PLIST List);

void LIAppend(PLIST list, PPOINT point);

void LIInsert(PLIST list, PPOINT point, unsigned int pos);

void LIDelete(PLIST list, unsigned int pos);

void LIClear(PLIST list);

void LITraverse(PLIST list);

bool LISearch(PLIST list, PPOINT point);

unsigned int LIGetCount(PLIST list);

bool LIIsEmpty(PLIST list);
```

### 4.抽象链表实现

#### 链表的构造与销毁

```cpp
PLIST LICreate() {
  PLIST p = new LIST;
  p->count = 0;
  p->head = NULL;
  p->tail = NULL;
  return p;
}

```

-    Destroy 链表时， 先要清空链表
-    删除链表结构体

```cpp
void LIDestroy(PLIST list) {
  if (list) {
    LIClear(list);
    // destroy all the nodes before destroy list
    // otherwise you will lose all the nodes
    delete list;
  }
}

```

-    清空链表中的所有结点

```cpp
void LIClear(PLIST list) {
  if (!list) {
    cout << "LIClear: Parameter illegal." << endl;
    exit(1);
  }

  // destroy all the nodes one by one
  while (list->head) {
    PNODE t = list->head;
    list->head = t->next;
    PtDestroy(t->data);
    delete t;
    list->count--;
  }
  list->tail = NULL;
}
```

表头结点的删除 LIClear， 先设置临时指针 t， 使其指向链表头头结点， 将链表头结点设置为 t 的后继结点，即原始表头结点的下一结点，那么原头结点， 也就是现在的 t 结点，已经不存在于链表中了，那么我们可以销毁这个结点，在这个结点中，data区是一个指向 point 结构体的指针，我们得先销毁这个data指针，即删除原头结点 data 域所指向的目标数据对象， 然后删除 t 所指向的结点， 即原始表头结点。 然后递减链表的结点数目

#### 结点的追加

-    先new一个 point 的 目标结构体
-    动态构造一个新结点， 用 t 指向它， 有 data 域， 有 next 域
-    使 t 的 data 域 指向 point 参数指向的目标数据对象， next 域为 NULL
-    如果链表的 head 域为 NULL， 则说明当前链表中没有任何结点，将此结点作为链表唯一结点添加到链表中， 此时简单将链表的head域与tail域设为t即可
-    否则，则就把 t 挂在链表的表尾上去，将当前尾结点的 next 域设为 t， 即使其指向新结点
-    将链表的 tail 域设为 t， 即将心结点作为链表尾结点
-    递增链表结点数目

```cpp
void LIAppend(PLIST list, PPOINT point){
  PNODE t = new NODE;
  if(!list || !point){
    cout << "LIAppend: Parameter illegal." << endl;
    exit(1);
  }

  t->data = point;
  t->next = NULL;
  if(!list->head){
    list->head = t;
    list->tail = t;
  }else{
    list->tail->next = t;
    list->tail = t;
  }
  list->count++;
}

```

#### 结点的插入

将结点插入到链表的中间而不是追加在末尾
-    表头的插入
    -    动态构造一个新结点， 用 t 指向它
    -    使 t 的 data 域指向 point 指向的目标数据对象， next 域为 NULL
    -    将 t 的 next 域设为list 的 head 的值， 即使得原链表首结点链接到 t 所指向的结点之后
    -    修改链表的首结点指针， 使其指向新的结点
    -    递增链表的结点数目

***注意这里步骤不能变！！！*** 比如第三步和第四步，如果交换了顺序，那么实际上是构造了一个新的链表进行了替换，而且只包含了新构造的那个结点， 其他的结点都被弄丢了; 所以在操作链表的时候，不管是结点的插入还是删除，任何时候都要保持链表的链接关系不变

-    链表中间的插入
    -    动态构造一个新结点， 用 t 指向它
    -     使 t 的 data 域指向 point 指向的目标数据对象， next 域为 NULL
    -    从表头开始向后查找待插入位置的前一结点， 用 u 指向它， 那么u就是指向前一个结点的指针， 例如若插入位置为 1, 则用 u 指向 0 号结点
    -    将 t 的 next 域设为 u 的 next 值，即使得原链表中位置 pos 处的结点链接到 t 所指向的结点之后
    -    将 u 的 next 域设为 t， 即将 t 指向的结点链接到 u 指向的结点之后递增链表的结点数目

```cpp

void LIInsert(PLIST list, PPOINT point, unsigned int pos){
  if(!list || !point){
    cout << "LIInsert: Parameter illegal." << endl;
    exit(1);
  }

  if(pos < list->count){
    // insert into mid of list or the head of list
    // otherwise it's append
    PNODE t = new NODE;
    t->data = point;
    t->next = NULL;
    if(pos == 0){
      // insert into head
      t->next = list->head;
      list->head = t;
    }else{
      //insert into mid of list
      unsigned int i;
      PNODE u = list->head;
      for(i = 0; i < pos; ++i){
        // find the previous node of target position
        u = u -> next;
      }
      t->next = u->next;
      u->next = t;
    }
    list->count++;
  }else{
    // insert into end of list
    LIAppend(list, point);
  }
}
```

#### 结点的删除

-    找到待删除结点的前一个结点，用临时指针 u 保存待删除结点前一结点的地址
-    用 t 指针保存待删除结点的地址
-    把待删除的结点从链表中拿出来，将 t 的 next 域赋给 u 的next域，这保证 u 跳过 t 指向下一个结点
-    若 t 的 next 域不再指向其他结点（t 指向的结点本身就是链表尾结点）则将链表尾结点设为 u
-    释放 t 的 data 域指向的目标数据对象
-    释放 t 所指向的结点数据对象
-    递减链表的结点个数

```cpp
void LIDelete(PLIST list, unsigned int pos){
  if(!list){
    cout << "LIDelete: Parameter illegal." << endl;
    exit(1);
  }

  if(list->count == 0){
    // list is empty
    return;
  }

  if(pos == 0){
    // remove head node
    PNODE t = list->head;
    list->head = t->next;
    if(!t->next){
      // this is no node after head node
      list->tail = NULL;
    }

    PtDestroy(t->data);
    delete t;
    list->count--;

  }else if(pos < list->count){
    unsigned int i;
    PNODE u = list->head, t;
    for(i = 0; i < pos -1; ++i){
      u = u->next;
    }
    t = u->next;
    u->next = t->next;
    if(!t->next){
      list->tail = u;
    }
    PtDestroy(t->data);
    delete t;
    list->count--;
  }
}

```

#### 结点的遍历

```cpp
void LITraverse(PLIST list){
  PNODE t = list->head;
  if(!list){
    cout << "LITraverse: Parameter illegal." << endl;
    exit(1);
  }

  while(t){
    cout << PtTransformIntoString(t->data) << "->";
    t = t -> next;
  }
  cout<<"NULL\n";
}

```

#### 结点的查找

```cpp
bool LISearch(PLIST list, PPOINT point){
  PNODE t = list->head;
  if(!list || !point){
    cout << "LISearch: Parameter illegal." << endl;
    exit(1);
  }

  while(t){
    if(PtCompare(t->data, point))
      return true;
    t = t->next;
  }

  return false;
}
```

### 5.链表小结

#### 链表的优点

-    插入和删除操作非常容易，不需要移动数据，只需要修改链表结点指针
-    与数组比较：数组插入和删除元素操作则需要移动数组元素，效率很低

#### 链表的缺点

-    只能顺序访问，要访问某个结点，必须从前向后查找到该结点，不能直接访问

#### 链表设计缺陷

-    链表要存储点的数据结构，就必须了解点库的接口; 如果要存储其他数据，就必须重新实现链表， 所以事实上是不抽象的
-    因为链表的实现要包含data数据的头文件（point.h）如果要存储还没有实现的数据结构（没有头文件），怎么办？
-    链表是一个容器， container， 那么它应该可以抽象成可以储存任何的数据的一个容器


## III. 函数指针

### 1.函数指针的目的与意义：抽象数据与抽象代码

-	数据与算法的对立统一， 通过函数指针将两者统一起来
-	函数的地址：
	-	函数入口位置， 将该数值作为数据保存起来，就可以通过特殊手段调用该函数;
	-	有函数入口，就能找到第一条指令，所以函数就能够执行下去直到return语句;
	-	由于地址是统一编码的，所以不管是数据，代码还是函数，他们的地址对计算机来说是无差别的，所以可以将函数的地址作为数值保存起来，这个就是函数指针，就可以通过这个指针指向那个函数的入口地址，然后通过指针的引领操作符来访问指针所指向的目标函数

```cpp
typedef void * ADT;
typdef const void * CADT;
// void * 是一个哑型指针，用来表达抽象的目标数据对象
// 由于指针不管指向哪一个数据类型，指针的数据地址存储空间是固定的
// 所以它可以表达指向任意类型的对象的数据的这样一个概念
// 所以它就可以代表任何类型的对象
// 所以哑型指针，就可以充当我们抽象数据类型的概念
```

-	要将链表所要存储的结点数据对象抽象成通用类型，不允许在链表库中出现与点结构数据相关的任何东西，即在之前的链表实现中，不能有对抽象点库任意的函数调用，也不能适用点库中定义的任意的类型
-	将原先链表实现中的 ```point*``` 代替成 ```void*```， 那么链表将不再保存指向一个点的结构体的一个指针，而是指向一个哑型的指针
-	注意 ADT 虽然指向一个哑型指针，但不是说指向无，而是指向一个未知的类型的目标数据对象，这样就实现了抽象编程

### 2.函数指针的定义

-	函数指针的定义格式：
	-	```数据类型 (* 函数指针数据对象名称) （形式参数列表）;```
	-	示例： char * （* as_string)(ADT object);
-	函数指针变量的赋值
	-	as_string 作为变量可以指向任何带有一个ADT类型的参数的返回值为 char * 类型的函数
	-	即变量 as_string 是一个指针，指向一个函数，这个函数带有一个 ADT 类型的参数， 函数的返回值为 char *
	-	如果没有第一个小括号对，那么这个就是一个函数原型的定义，而不是函数指针的定义，所以小括号不可省略
	-	函数指针变量可以像普通变量一样赋值： ```函数指针数据对象名称``` = ```函数名称```
	-	只要有函数，其带有一个 ADT 参数， 并且返回值为 char *， 都可以将这样一个函数的入口地址赋给 as_string 作为它的值

```cpp
// 有一个函数
char * DoTransfromObjectIntoString(ADT object)
{
	// 这里可以转型至 PPOINT
	return PtTransformIntoString((PPOINT)object);
}

// 完成函数指针的赋值，只需要函数名即可，这里是传入入口地址
as_string = DoTransfromObjectIntoString;
```

### 3.函数指针的使用

-	通过函数指针调用函数
	-	函数指针被赋值后，即指向实际函数的入口地址
	-	通过函数指针可以直接调用它所指向的函数
	-	调用示例

```cpp
char * returned_value;
PPOINT pt = PtCreate(10, 20);
as_string = DoTransfromObjectIntoString;

// 这里可以认为 as_string 就是 DoTransfromObjectIntoString
returned_value = as_string((ADT)pt);
```

	-	要区分函数指针调用和函数直接调用，适用下述格式调用函数：

```cpp
returned_value = (*as_string)((ADT)pt);
//第一个小括号对不可省略，因为 *as_string 会返回字符串的 0 号字符
//将字符赋值给一个字符串，赋值不兼容，编译器不通过
```

####.设计程序

-	设计程序，随机生成8个 10-99 之间的整数，调用 stdlib 库的 qsort 对其进行排序
-	qsort 函数原型(quick sort)

```cpp
void qsort(void * base, unsigned int number_of_elements, unsigned int size_of_elements，
			int(*compare)(const void *, const void *));
//第一个参数： 需要排序的数组的基地址
//第二个参数： 数组中包含的元素的个数
//第三个参数： 每一个元素所占用的存储空间的大小，以字节为单位
//第四个参数： 函数指针，用于比较两个对象的大小关系
```

-	调用 qsort 时，需要按照下述的格式实现自己的比较函数：```int(*compare)(const void *, const void *);```
-	compare 函数参数不是传入两个对象，而是传入两个对象的指针，因为在 compare 这个函数里，不允许通过指针修改目标对的值
-	比较函数示例： ```int MyCompareFunc(const void * e1, const void * e2);```
-	比较函数必须返回正负值（一般为正负1）或0, 规则按照题目要求自定义

```cpp
// main.pp
#include <cstdlib>
#include <iostream>
using namespace std;

#include "arrmanip.h"
// In order to operate Array

#define NUMBER_OF_ELEMENTS 8

int DoCompareObject(const void *e1, const void *e2);

int main() {
  int a[NUMBER_OF_ELEMENTS];
  GenerateIntegers(a, NUMBER_OF_ELEMENTS);
  cout << "Array generated at random as follows"
       << "\n";
  PrintIntegers(a, NUMBER_OF_ELEMENTS);
  qsort(a, NUMBER_OF_ELEMENTS, sizeof(int), DoCompareObject);
  cout << "After sorted: "
       << "\n";
  PrintIntegers(a, NUMBER_OF_ELEMENTS);
  return 0;
}

int DoCompareObject(const void *e1, const void *e2) {
  return CompareInteger(*(const int *)e1, *(const int *)e2);
}
```

```cpp
// arrmanip.h
// header file of arrmanip
void GenerateIntegers(int a[], unsigned int n);

void PrintIntegers(int a[], unsigned int n);

int CompareInteger(int x, int y);

```

```cpp
// arrmainp.cpp
#include "arrmanip.h"
#include "zyrandom.h"
#include <iomanip>
#include <iostream>

static const unsigned int lower_bound = 10;
static const unsigned int upper_bound = 99;

void GenerateIntegers(int a[], unsigned int n) {
  unsigned int i;
  Randomize();
  for (i = 0; i < n; ++i) {
    a[i] = GenerateRandomNumber(lower_bound, upper_bound);
  }
}

int CompareInteger(int x, int y) {
  if (x > y)
    return 1;
  else if (x == y)
    return 0;
  else
    return -1;
}

void PrintIntegers(int a[], unsigned int n) {
  unsigned int i;
  for (i = 0; i < n; i++) {
    std::cout << std::setw(3) << a[i];
  }
  std::cout << std::endl;
}

```

#### 函数指针的赋值
-	同类型函数指针可以赋值，不同类型则不能赋值
-	如何确定函数指针类型是否相同： 函数参数与返回值不完全相同

#### 函数指针类型
-	用于区分不同类型的函数指针
-	定义： ```typedef int(* COMPARE_OBJECT)(const void * e1, const void * e2);```
-	前面添加 typedef 关键字，保证 COMPARE_OBJECT 为函数指针类型，而不是函数指针变量
-	注意表示类型时，这里 COMPARE_OBJECT全大写，表示变量时，这里全小写
-	可以像普通类型一样使用函数指针类型定义变量： ```COMPARE_OBJECT compare = DoCompareObject;```

#### qsort 函数简明写法
```void qsort(void * base, unsigned int number_of_elements, unsigned int size_of_elements, COMPARE_OBJECT compare);```
