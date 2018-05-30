---
layout: post
title:  "[Sword_To_Offer] BinaryTree-重建二叉树"
date:   2018-05-28
desc: "rebuild binary tree"
keywords: "Algorithm, Sword_To_Offer, binary tree"
categories: [sword_to_offer]
---

# I. 问题描述

根据二叉树的前序遍历和中序遍历的结果，重建出该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

```
preorder = [3,9,20,15,7]
inorder =  [9,3,15,20,7]
```
![sto-rebuild-binary-tree](/assets/blog/2018/05/sto-rebuild-binary-tree.png)

[OJ: NowCoder](https://www.nowcoder.com/practice/8a19cbe657394eeaac2f6ea9b0f6fcf6?tpId=13&tqId=11157&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

关于树的数据结构,可以参考 [[Date Structure] 数据结构之树](https://blog.lovian.org/data_structure/2016/08/24/data-structure-tree.html)

# II. 思路