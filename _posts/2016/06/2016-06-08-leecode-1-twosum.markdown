---
layout: post
title:  "[LeetCode] 1. TwoSum"
date:   2016-06-08
desc: "LeetCode 1. TwoSum C++ solution"
keywords: "LeetCode, TwoSum, C++, Algorithm"
categories: [Algorithm]
tags: [C++,Algorithm, LeetCode, Array]
icon: fa-keyboard-o
---

## Q:1 Two sum
 Given an array of integers, return indices of the two numbers such that they add up to a specific target.
 You may assume that each input would have exactly one solution

 Example:
 Given nums = [2, 7, 11, 15], target = 9,
 Because nums[0] + nums[1] = 2 + 7 = 9;
 return [0, 1]

 The return format had been changed to zero-based indices. Please read the above updated description carefully.

## Answer
Just loop twice to find the indices of elements who has the same value, store the indices to a new vector ans.

## Code:

```cpp
#include <vector>
using namespace std;

class TwoSum{
    public:
        vector<int> twoSum(vector<int>& nums, int target){
            vector<int> ans(2);
            for (int i = 0; i < nums.size(); i++) {
                for (int j = i + 1; j < nums.size(); j++) {
                    if (nums[i] + nums[j] == target) {
                        ans[0] = i;
                        ans[1] = j;
                    }
                }
            }
            return ans;
        }
};

```
