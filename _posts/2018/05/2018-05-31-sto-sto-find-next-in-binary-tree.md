---
layout: post
title:  "[Sword_To_Offer] BinaryTree-二叉树的下一个节点"
date:   2018-05-31
desc: "find next node in binary tree"
keywords: "Algorithm, Sword_To_Offer, binary tree, node"
categories: [sword_to_offer]
---

# I. 问题描述

给定一个二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针

二叉树定义如下:

```java
public class TreeLinkNode {
    int val;
    TreeLinkNode left = null;
    TreeLinkNode right = null;
    TreeLinkNode next = null;

    TreeLinkNode(int val) {
        this.val = val;
    }
}
```

[OJ: NowCoder](https://www.nowcoder.com/practice/9023a0c988684a53960365b889ceaf5e?tpId=13&tqId=11210&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

# II. 解题思路

二叉树的```中序遍历LDR```是左根右的顺序,那么给定一个节点, 找到下一个节点, 那么其实需要从中序遍历中找出下一个节点的情况, 一共有两种:

- 如果一个节点的右子树不为空，那么该节点的下一个节点是右子树的最左节点

![sto-find-next-node1](/assets/blog/2018/05/sto-find-next-node-1.png)

- 如果一个节点的右子树为空,那么就去找包含它的第一个左子树的父节点

![sto-find-next-node2](/assets/blog/2018/05/sto-find-next-node-2.png)

## III. Java 实现

```java
public TreeLinkNode GetNext(TreeLinkNode pNode) {
    if (pNode.right != null) {
        TreeLinkNode node = pNode.right;
        while (node.left != null)
            node = node.left;
        return node;
    } else {
        while (pNode.next != null) {
            TreeLinkNode parent = pNode.next;
            if (parent.left == pNode)
                return parent;
            pNode = pNode.next;
        }
    }
    return null;
}
```