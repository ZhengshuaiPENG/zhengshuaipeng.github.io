---
layout: post
title:  "[Sword_To_Offer] Array - 二维数组中的查找"
date:   2018-05-24
desc: "Find numbner in a two-dimension array"
keywords: "Algorithm, Sword_To_Offer, Array, Find, Two-Dimension"
categories: [sword_to_offer]
---

# I. 问题描述


在一个二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

```text-html-basic
Consider the following matrix:
[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]

Given target = 5, return true.
Given target = 20, return false.
```

[OJ: NowCoder](https://www.nowcoder.com/practice/abc3fe2ce8e146608e868a70efebf62e?tpId=13&tqId=11154&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

# II. 思路

```查找类的问题可以用二分的思想```, 要查找目标 target, 二分的思想就可以通过判断当前值 N 和target的大小, 所以最开始的时候要找到一个起始点 N

- ```target == N``` : found, return true
- ```target < N```: 找到下一个比 N 小的值,再跟 target 比较
- ```target > N```: 找到下一个比 N 大的值,再跟 target 比较

在一个二维矩阵 matrix 中, 每一行都递增, 每一列都递增, 那么要能够使得 N 可以找到下一个比 N 小的值并且可以找到下一个比 N 大的值, 那么起始点就应该从矩阵的右上角开始, 也就是这个 N,应该是 ```matrix[0][col.length-1]```, 它的左边都比它小,它的下边都比它大,这样就可以应用二分法的思想来解决了.左下角思路也是如此

时间复杂度为 O(M+N)
空间复杂度为 O(1)

# III. Java 实现

```java
public class Solution {
    public boolean Find(int target, int [][] array) {
        if(array == null || array.length == 0 || array[0].length == 0)
            return false;
        
        int rows = array.length;
        int cols = array[0].length;
        
        int r = 0;
        int c = cols -1;
        
        while(r < rows && c >= 0)
        if(target == array[r][c])
            return true;
        else if(target > array[r][c]){
            r++;
        }else{
            c--;
        }
        
        return false;
    }
}
```