---
layout: post
title:  "[Sword_To_Offer] LinkedList-从尾到头打印链表"
date:   2018-05-28
desc: "print linked list from tail to head"
keywords: "Algorithm, Sword_To_Offer, linked list, reverse"
categories: [sword_to_offer]
---

# I. 问题描述

输入链表的第一个节点, 从尾到头反过来打印每个节点的值.

```
Linked List:  [1] -> [2] -> [3] -> [4]
output:       [4] -> [3] -> [2] -> [1]
```
节点结构如下:

```java
public class ListNode {
    int val;
    ListNode next = null;

    ListNode(int val) {
        this.val = val;
     }
}
```


[OJ:NowCoder](https://www.nowcoder.com/practice/d0267f7f55b3412ba93bd35cfa8e8035?tpId=13&tqId=11156&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

# II.思路

使用```递归```的方式实现, 只要当前的ListNode 节点还有 next (也就是```listNode.next != null```), 那么就进行一次递归处理.而实际上递归的方式用的是堆栈结构

# III.代码实现

```java
public class Solution {
    ArrayList<Integer> arrayList=new ArrayList<Integer>();
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        if(listNode!=null){
            this.printListFromTailToHead(listNode.next);
            arrayList.add(listNode.val);
        }
        return arrayList;
    }
}  
```

# IV.其他思路

## 1. 借助堆栈后进先出实现

栈 Stack 的特性是后进先出, LIFO, 这么在循环遍历 ListNode 的时候, 将其加入栈中,当遍历到尾节点的时候,这时候栈取出的顺序就是从尾到头.

```java
import java.util.ArrayList;
import java.util.Stack;
public class Solution {
    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {
        Stack<Integer> stack=new Stack<Integer>();
        while(listNode!=null){
            stack.push(listNode.val);
            listNode=listNode.next;     
        }
        
        ArrayList<Integer> list=new ArrayList<Integer>();
        while(!stack.isEmpty()){
            list.add(stack.pop());
        }
        return list;
    }
}
```

## 2. 借助 Java 库函数 Collections.reverse()

这种方式其实就是遍历一遍ListNode, 将每个值从头到尾保存到 list 中, 然后利用 ```Collections.reverse()``` 函数直接对 list 进行翻转即可

```java
import java.util.ArrayList;
import java.util.Collections;
public class Solution {

    public ArrayList<Integer> printListFromTailToHead(ListNode listNode) {

        ArrayList<Integer> list = new ArrayList<Integer>();
         
        while(listNode != null){
            list.add(listNode.val);
            listNode = listNode.next;
        }
         
        Collections.reverse(list);
        return list;
    }
}
```