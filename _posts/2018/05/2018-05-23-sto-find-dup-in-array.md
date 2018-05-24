---
layout: post
title:  "[Sword_To_Offer] Array - 数组中重复的数字"
date:   2018-05-23
desc: "Find duplicate numbers in an array"
keywords: "Algorithm, Sword_To_Offer, Array, Duplicated"
categories: [sword_to_offer]
---

# I. 问题描述

[OJ: NowCoder](https://www.nowcoder.com/practice/623a5ac0ea5b4e5f95552655361ae0a8?tpId=13&tqId=11203&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)


在一个长度为 n 的数组里的所有数字都在 0 到 n-1 的范围内。数组中某些数字是重复的，但不知道有几个数字是重复的，也不知道每个数字重复几次。请找出数组中任意一个重复的数字.
要求复杂度为 ```O(N) + O(1)```，也就是时间复杂度 O(N)，空间复杂度 O(1)

输入输出示例:

-   输入: 长度为 7 的数组 ```[2, 3, 1, 0, 2, 5]```
-   输出: 第一个重复的数字 2

# II.思路

数组长度为 0 到 n-1, 每一个数字的范围是 0-9, 由于时间复杂度要求为 O(N), 那么就不能使用排序算法再遍历.而空间复杂度要求为 O(1), 那么久不能另外维护一个同样大小的数据结构.所以我们可以采用 Hash 的方法,来给每一个元素做标记,这样最多只需要 [0-9] 10个元素的空间. 遍历数组, 如果出现了一个数字,那么就标记其存在.当发现某一个元素已经存在,那么就找到了这个重复的数字,返回即可. 对于时间复杂度来说, 也满足了 O(N) 的要求,因为最多只需要遍历一次数组.


# III. Java 实现

```java
import java.util.*;

public class Solution {
    // Parameters:
    //    numbers:     an array of integers
    //    length:      the length of array numbers
    //    duplication: (Output) the duplicated number in the array number,length of duplication array is 1,so using duplication[0] = ? in implementation;
    //                  Here duplication like pointor in C/C++, duplication[0] equal *duplication in C/C++
    //    这里要特别注意~返回任意重复的一个，赋值duplication[0]
    // Return value:       true if the input is valid, and there are some duplications in the array number
    //                     otherwise false
    public boolean duplicate(int numbers[],int length,int [] duplication) {
        if(numbers == null)
            return false;
        if(numbers.length != length || length < 2)
            return false;
        
        Set<Integer> exists = new HashSet<>();
        for(int i = 0; i < length; i++){
            int num = numbers[i];
            if(!exists.contains(num)){
                exists.add(num);
            }else{
                duplication[0] = num;
                return true;
            }
        }
        
        return false;
    }
}
```

# IV. 学习其他解题思路


## 1.使用 StringBuffer

将 int 数组转换为 StringBuffer 对象, 然后遍历每一个字符, 如果字符出现的 index 和最后一次出现的 index 不同,那么它就是重复的

```java
public class Solution {
    // Parameters:
    //    numbers:     an array of integers
    //    length:      the length of array numbers
    //    duplication: (Output) the duplicated number in the array number,length of duplication array is 1,so using duplication[0] = ? in implementation;
    //                  Here duplication like pointor in C/C++, duplication[0] equal *duplication in C/C++
    //    这里要特别注意~返回任意重复的一个，赋值duplication[0]
    // Return value:       true if the input is valid, and there are some duplications in the array number
    //                     otherwise false
    public boolean duplicate(int numbers[],int length,int [] duplication) {
    StringBuffer sb = new StringBuffer(); 
        for(int i = 0; i < length; i++){
                sb.append(numbers[i] + "");
            }
        for(int j = 0; j < length; j++){
            if(sb.indexOf(numbers[j]+"") != sb.lastIndexOf(numbers[j]+"")){
                duplication[0] = numbers[j];
                return true;
            }
        }
        return false;
    }
}
```

## II. 利用数组设置标记

这种数组元素在 [0, n-1] 范围内的问题，可以将值为 i 的元素放到第 i 个位置上。

以 (2, 3, 1, 0, 2, 5) 为例：

```text-html-basic
position-0 : (2,3,1,0,2,5) // 2 <-> 1
             (1,3,2,0,2,5) // 1 <-> 3
             (3,1,2,0,2,5) // 3 <-> 0
             (0,1,2,3,2,5) // already in position
position-1 : (0,1,2,3,2,5) // already in position
position-2 : (0,1,2,3,2,5) // already in position
position-3 : (0,1,2,3,2,5) // already in position
position-4 : (0,1,2,3,2,5) // nums[i] == nums[nums[i]], exit
```

遍历到位置 4 时，该位置上的数为 2，但是第 2 个位置上已经有一个 2 的值了，因此可以知道 2 重复。

```java
public boolean duplicate(int[] nums, int length, int[] duplication) {
    if (nums == null || length <= 0)
        return false;
    for (int i = 0; i < length; i++) {
        while (nums[i] != i) {
            if (nums[i] == nums[nums[i]]) {
                duplication[0] = nums[i];
                return true;
            }
            swap(nums, i, nums[i]);
        }
    }
    return false;
}

private void swap(int[] nums, int i, int j) {
    int t = nums[i]; nums[i] = nums[j]; nums[j] = t;
}
```