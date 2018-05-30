---
layout: post
title:  "[Sword_To_Offer] BinaryTree-重建二叉树"
date:   2018-05-30
desc: "reconstruct binary tree"
keywords: "Algorithm, Sword_To_Offer, binary tree, traverse"
categories: [sword_to_offer]
---


# I. 问题描述

根据二叉树的前序遍历和中序遍历的结果，重建出该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

```
preorder = [3,9,20,15,7]
inorder =  [9,3,15,20,7]
```
![sto-rebuild-binary-tree](/assets/blog/2018/05/sto-rebuild-binary-tree.png)


其中二叉树节点的定义为:

```java
// Definition for binary tree
 public class TreeNode {
     int val;
     TreeNode left;
     TreeNode right;
     TreeNode(int x) { val = x; }
}
```


[OJ: NowCoder](https://www.nowcoder.com/practice/8a19cbe657394eeaac2f6ea9b0f6fcf6?tpId=13&tqId=11157&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

关于二叉树的数据结构,可以参考 [[Date Structure] 数据结构之树](https://blog.lovian.org/data_structure/2016/08/24/data-structure-tree.html#tocAnchor-1-1-3)

# II. 思路

二叉树遍历一般来说有三种方式:

-   ```前序遍历 preorder```: DLR 根左右
-   ```中序遍历 inorder```: LDR 左根右
-   ```后序遍历 postorder```: LRD 左右根

二叉树有以下的遍历性质:

-   已知```前序遍历```序列和```中序遍历```序列，可以```唯一确定```一个二叉树
-   已知```后序遍历```序列和```中序遍历```序列，可以```唯一确定```一个二叉树
-   已知```前序遍历```序列和```后续序遍历```序列，```不能确定```一个二叉树


由于二叉树的特性, ```前序遍历的第一个值,肯定就是 root 节点```.由于题目假设二叉树的数字没有重复, 那么肯定能够根据这个 root 节点的值来找到root节点在中序遍历中的位置.从而根据中序遍历的特性, ```root 节点可以把中序遍历序列分为左子树和右子树```, 那么 root 节点的左子节点就是左子树的 root 节点, 而 root 节点的右子节点,就是右子树的 root 节点, 然后就可以```递归```的将树还原出来


# III. Java 实现

```java
/**
 * Definition for binary tree
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
public class Solution {
    public TreeNode reConstructBinaryTree(int [] pre,int [] in) {
        TreeNode root=reConstructBinaryTree(pre,0,pre.length-1,in,0,in.length-1);
        return root;
    }
    
    private TreeNode reConstructBinaryTree(int [] pre,int startPre,int endPre,int [] in,int startIn,int endIn) {
         
        if(startPre>endPre||startIn>endIn)
            return null;
        TreeNode root=new TreeNode(pre[startPre]);
         
        for(int i=startIn;i<=endIn;i++){
            if(in[i]==pre[startPre]){
                root.left=reConstructBinaryTree(pre,startPre+1,startPre+i-startIn,in,startIn,i-1);
                root.right=reConstructBinaryTree(pre,i-startIn+startPre+1,endPre,in,i+1,endIn);
                break;
            }
        }  
        return root;
    }
}
```