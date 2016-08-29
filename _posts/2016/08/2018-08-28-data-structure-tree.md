---
layout: post
title:  "[Date Structure] 数据结构之树"
date:   2016-08-24
desc: "tree of data structure"
keywords: "java, data structure, tree"
categories: [Algorithm]
tags: [Algorithm, Data Structure]
icon: fa-keyboard-o
---

# 数值结构之树 Tree

## I. 树

### 1. 什么是树

树 ```Tree``` ：

-	是 n （n>=0) 个结点的有限集：
-	n = 0 时，称为空树
-	在任意一棵非空树中
	-	有且只有一个特定的根结点 ```Root```
	-	当 n > 1 时，其余结点可以分为 m (m > 0) 个互不相交的有限集 T1, T2, ..., Tn
	-	其中每一个集合本身又是一棵树，并成为根的子树 ```Sub Tree```

树的示意图如下：

![Tree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree1.png)

子树示意图：

![SubTree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree2.png)

注意：

-	n > 0 时，根结点是唯一的，不可能存在多个根结点
-	m > 0 时，子数的个数没有限制，但它们一定是互不相交的


### 2. 结点的分类

树的结点包含一个数据元素，及若干指向其子树的分支：

-	结点的度 ```Degree``` ： 结点拥有的子树数称为结点的度，即孩子个数
-	叶子结点 ```Leaf``` ： 度为 0 的结点称为叶子结点，也叫终端结点
-	分支结点： 度不为 0 的结点称为非终端节点或者分支结点
	-	除了根结点外，分支结点也成为内部结点
-	树的度是树内各节点度的最大值

![Degree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree3.png)


### 3. 结点的关系

-	```Parent```： 双亲结点
-	```Child``` ： 孩子结点
-	```Sibling```： 兄弟结点
-	结点的祖先是根到该结点所经分支上的所有结点
-	以某个结点为根的子树中的任一结点都称之为该点的子孙

结点关系示意图如下：

![TreeRelation]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree4.png)


### 4. 树的其他相关概念

-	结点的层次 ```level``` ：
	-	从根开始定义起，根为第一层，根的孩子为第二层
	-	数中结点最大层次称为树的深度 ```Depth```
-	```有序树```和```无序树``` ： 将树中结点的各子树看成从左至右是有次序的，不能互换的，则称该树为有序树，否则为无序树
-	森林 ```Forest``` 是 m (m >= 0) 棵互不相交的树的集合
	-	对树中每个结点而言，其子树的集合即为森林

### 5. 线性结构和树的区别

-	```线性结构```
	-	第一个数据元素： 无前驱
	-	最后一个数据元素： 无后继
	-	中间元素： 一个前驱一个后继
-	```树结构```
	-	根结点： 无双亲，唯一
	-	叶结点： 无孩子，可以多个
	-	中间结点： 一个双亲，多个孩子

## II. 树的实现

### 1. 树的抽象数据类型

```
ADT Tree
Data
	树是有一个根节点和若干颗子树构成;
	树中结点具有相同数据类型和层次关系
Operation
	InitTree(*T)				// 构造空树 T
	DestroyTree(*T)				// 销毁树 T
	CreateTree(*T)				// 按 definition 中给出树的定义来构造树
	ClearTree(*T)				// 若树 T 存在，则将树 T 清空为空树
	TreeEmpty(T)				// 若 T 为空树，则返回 true， 否则返回 false
	TreeDepth(T)				// 返回 T 的深度
	Root(T)						// 返回 T 的根结点
	Value(T, cur_e)				// cur_e 是树 T 中的一个结点，返回此结点的值
	Assign(T, cur_e, value)		// 给树 T 的结点 cur_e 赋值为 value
	Parent(T, cur_e)			// 若 cur_e 是树 T 的非根结点，则返回它的双亲， 否则返回空
	LeftChild(T, cur_e)			// 若 cur_e 是树 T 的非叶结点，则返回它的做孩子，否则返回空
	RightSibling(T, cur_e)		// 若 cur_e 有右兄弟，则返回它的右兄弟，否则返回空
	InsertChild(*T, *p, i, c)	// 其中 p指向树 T 的某个结点， i 为所指结点 p 的度加上 1, 非空树 c 与 T 不相交，操作结果为插入 c 为树 T 中 p 指结点的第 i 棵子树
	DeleteChild(*T, *p, i)		// p 指向树 T 的某个结点，i 为所指结点 p 的度，操作结果为删除 T 中 p 所指结点的第 i 棵子树
endADT
```

### 2. 树的存储结构

简单的顺序结构不能满足树的实现，所以要充分利用顺序结构和链式存储结构的特点，可以实现对树的存储结构的表示法：

-	```双亲表示法```
-	```孩子表示法```
-	```孩子兄弟表示法```

#### A. 双亲表示法

除了根结点， 其余的每个结点，它不一定有孩子，但是一定有且仅有一个双亲。

我们用一组连续空间存储树的结点，同时在每个结点中，附设一个指示器指示其双亲结点到链表中的位置：

-	数据域： data，存储数据元素
-	指针域： parent，存储该结点双亲在数组的下标
	-	约定根结点的 parent 为 -1

这样，所有的结点都存有其双亲的位置

-	优点：
	-	可以根据结点的 parent 指针很容易找到它的双亲结点，时间复杂度为 O(1)
	-	直到 parent 为 -1 的时候，表示找到了树结点的根
-	缺点：
	-	如果要直到结点的孩子是什么，需要遍历整个结构

#### B. 孩子表示法

树中的每个结点可能有多棵子树，可以使用多重链表， 即每个结点有多个指针域，其中每个指针指向一棵子树的根节点，我们把这种方法叫做多重链表的表示法。

```孩子表示法```的具体办法是： 把每个结点的孩子结点排列起来，以单链表作存储结构，则 n 个结点有 n 个孩子链表，如果是叶子结点则此单链表为空，然后 n 个头指针又组成一个线性表，采用顺序存储结构，存放进一个一维数组中。

如下图所示：

![treechild]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree5.png)

所以这种结构有两种结点：

-	表头数组的表头结点：
	-	数据域 ```data``` ：存储某个结点的数据信息
	-	头指针域 ```firstchild``` ： 存储该结点的孩子链表的头指针
-	孩子链表的孩子结点：
	-	数据域 ```child``` ：用来存储某个结点在表头数组中的下标
	-	指针域 ```next``` ：用来储存指向某个结点的下一个孩子结点的指针

这样的结构对于我们要查找某个结点的某个孩子，或者找某个结点的兄弟，只需要查找这个结点的孩子单链表即可，对于遍历整棵树，直接循环数组即可。

但是这样也有问题，如果我们要查找某个结点的双亲，则需要遍历整颗树，那么把孩子表示法和双亲表示法综合一下，如下所示：

![treechildimproved]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree6.png)

这种方法叫做```双亲孩子表示法```， 是对孩子表示法的改进


#### C. 孩子兄弟表示法

任意一棵树，它的结点的第一个孩子如果存在，就是唯一的，它的右兄弟如果存在也是唯一的，因此，我们可以设置两个指针，分别指向该结点的第一个孩子和此结点的右兄弟。

孩子兄弟表示法的结点结构：

-	数据域 ```data``` ：存储某个结点的数据信息
-	指针域：
	-	```firstchild``` ： 存储该结点的第一个孩子结点的存储地址
	-	```rightsib``` ： 存储该结点的有兄弟结点的存储地址

这种方法的结构示意图：

![treechildsib]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree7.png)


这种方法查找某个结点的孩子比较方便，只要通过 firstchild 找到结点的长子，然后再通过长子结点的 rightsib 找到它的二弟，接着一直找下去，就能找到具体的孩子结点。

实际上这种表示法，把一棵复杂的树变成了一个二叉树，把上图变型，就得到下图：

![treechildsib2]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree8.png)

那么就可以使用二叉树的特性来处理这棵树了


## III. 二叉树

### 1. 二叉树的定义

二叉树， ```Binary Tree``` ：

-	是 n  (n >= 0) 个结点的有限集合
-	该集合为空时，称为空二叉树
-	由一个根节点和两棵互不相交的，分别称为根节点的左子树和右子树的二叉树组成

一个典型的二叉树如下所示：

![binarytree1]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree9.png)

### 2. 二叉树的特点

-	```每个结点最多有两棵子树```，所以二叉树中不存在度大于 2 的结点
-	左子树和右子树是有顺序的，顺序不能任意颠倒
-	即使树中的某个结点只有一棵子树，也要区分它是左子树还是右子树

二叉树具有五种形态：

-	空二叉树
-	只有一个根结点
-	根结点只有左子树
-	根结点只有右子树
-	根结点既有左子树又有右子树

### 3. 特殊二叉树

-	```斜树```：
	-	所有的结点都只有左子树的二叉树叫左斜树
	-	所有结点都是只有右子树的二叉树叫右斜树
	-	每一层只有一个结点，结点的个数与二叉树的深度相同
	-	线性表结构，可以理解为一种极其特殊的表现形式
-	```满二叉树```：
	-	在一棵二叉树，如果所有分支结点都存在左子树和右子树，并且所有叶子都在同一层，这样的二叉树称为满二叉树
	-	叶子只能出现在最下一层，出现在其他层就不可能达到平衡
	-	非叶子结点的度，一定是 2
	-	在同样深度的二叉树中，满二叉树的结点个数最多，叶子树最多

![fullbinarytree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree10.png)

-	```完全二叉树```：
	-	对一棵具有 n 个结点的二叉树按层次编号，如果编号为 i (1 <= i <= n) 的结点与同样深度的满二叉树中编号为 i 的结点在二叉树中位置完全相同，则这棵二叉树称为完全二叉树
	-	一个满二叉树一定是一颗完全二叉树，但是一个完全二叉树不一定是一个满二叉树
	-	叶子结点只能出现在最下两层
	-	最下层的叶子一定集中在左部连续位置
	-	倒数二层，若有叶子结点，一定都在右部的连续位置
	-	如果结点度为 1, 那么该结点只有左孩子，即不存在只有右子树的情况
	-	同样结点数的二叉树，完全二叉树深度最小

![complbinarytree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree11.png)

完全二叉树的所有结点与同样深度的满二叉树，它们按```层序编号```相同的结点，是一一对应的，如下图所示：

![complbinarytree2]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree12.png)

树1, 因为 5 结点没有左子树，却有右子树，按照层序编号，第 10 个编号就空档了; 同理，树 2 的 6, 7 编号也空档了; 树 3 由于 5 编号下没有子树造成第 10 和第 11 位置空档，所以这三个树都不是完全二叉树，说明了，```如果二叉树的编号出现了空档，那么就不是完全二叉树```

### 4. 二叉树的性质

-	性质1：
	-	在二叉树的```第 i 层```上，至多有 ```2^(i-1)``` 个结点
-	性质2：
	-	```深度为 k``` 的二叉树，至多有 ```2^k - 1``` 个结点
-	性质3：
	-	对任意一棵二叉树 T， 如果其叶子结点数为 A， 度为 2 的结点数为 B，度为 1 的结点数为 C
	-	A = B + 1
	-	总结点数 n = A + B + C
-	性质4：
	-	具有 n 个结点的完全二叉树深度为 ```[log(n) + 1]```, 其中log以 2 为底， 结果是取整
-	性质5：
	-	如果对一颗有 n 个结点的完全二叉树，其深度为 ```[log(n) + 1]``` 的结点按层序编号（从第一层到第 [log(n)+1] 层，每层从左到右），对任一结点 i （1 <= i <= n), 则有：
		-	如果 i = 1, 则结点 i 是二叉树的根，无双亲
		-	如果 i > 1, 则其```双亲```是结点 ```[i/2]```
		-	如果 2i > n, 则结点 i 无左孩子，即叶子结点; 否则其```左孩子```是结点 ```2i```
		-	如果 2i + 1 > n, 则结点 i 无右孩子;否则其```右孩子```结点是 ```2i+1```


### 5. 二叉树的顺序存储结构


二叉树的存储结构就是用```一维数组```存储二叉树中的```结点```，并且结点的存储位置，也就是数组的下标，要能体现结点之间的逻辑关系。

下图是```完全二叉树```的顺序存储

![fullbinarytreestruc]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree13.png)

因为完全二叉树定义的严格，可以顺序结构可以表现出二叉树的结构，但是如果二叉树不是完全二叉树，比如斜树，用这种存储则非常浪费空间，如下图：

![singlebinarytreestruc]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree14.png)

所以，顺序存储结构一般只适用于完全二叉树

### 6. 二叉链表

二叉树的每个结点最多有两个孩子，那么，用链式结构存储，设置一个数据域和两个指针域：

-	数据域： data
-	指针域：
	-	leftchild： 指向左孩子
	-	rightchild： 指向右孩子

结构示意图如下：

![linkedbinarytree]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree15.png)

### 7. 二叉树的遍历

二叉树的遍历 ```traversing binary tree``` 是指从根结点出发，按照某种次序依次访问二叉树中所有结点，使得每个结点被访问一次且仅被访问一次。

二叉树的遍历次序不同于线性结构，最多就是从头到尾，循环，双向等简单的遍历方式。树的结点之间不存在唯一的前驱和后继关系，在访问一个结点的之后，下一个被访问的结点面临着不同的选择，是左孩子还是右孩子。

#### A. 前序遍历

前序遍历：```DLR 根左右```

-	如果是空二叉树，则空操作返回
-	否则：
	-	访问根结点
	-	前序遍历左子树
	-	前序遍历右子树

![dlr]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree16.png)

访问次序： ABDGHCEIF

算法如下：

```
// 二叉树前序遍历算法
void PreOrderTraverse(BiTree T)
{
	if(T==NULL)
		return;
	printf("%c", T->data);				// 访问根结点
	PreOrderTraverse(T->leftChild);		// 前序遍历左子树
	PreOrderTraverse(T->rightChild);	// 前序遍历右子树
}
```

#### B. 中序遍历

中序遍历： ```LDR 左根右```

-	如果是空二叉树，则空操作返回
-	否则：
	-	从根结点开始（不是访问根结点）
	-	中序遍历左子树
	-	访问根结点
	-	中序遍历右子树

![ldr]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree17.png)

访问次序： GDHBAEICF

算法如下：

```
// 二叉树中序遍历算法
void InOrderTraverse(BiTree T)
{
	if(T==NULL)
		return;
	InOrderTraverse(T->leftChild);		// 中序遍历左子树
	printf("%c", T->data);				// 访问根结点
	InOrderTraverse(T->rightChild);		// 中序遍历右子树
}
```


#### C. 后续遍历

后序遍历： ```LRD 左右根```

-	如果是空二叉树，则空操作返回
-	否则：
	-	后序遍历左子树
	-	后序遍历右子树
	-	访问根结点

![lrd]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree18.png)

访问次序： GHDBIEFCA

算法如下：

```
// 二叉树后序遍历算法
void PostOrderTraverse(BiTree T)
{
	if(T==NULL)
		return;
	PostOrderTraverse(T->leftChild);	// 后续遍历左子树
	PostOrderTraverse(T->rightChild);	// 后序遍历右子树
	printf("%c", T->data);				// 访问根结点
}
```

#### D. 层序遍历

层序遍历

-	如果是空二叉树，则空操作返回
-	否则：
	-	从树的第一层，根结点开始访问
	-	从上而下逐层遍历
	-	同一层中，按照从左到右的顺序逐个访问

![leveltraverse]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree19.png)

遍历次序： ABCDEFGHI


#### E. 二叉树遍历性质

-	已知```前序遍历```序列和```中序遍历```序列，可以```唯一确定```一个二叉树
-	已知```后序遍历```序列和```中序遍历```序列，可以```唯一确定```一个二叉树
-	已知```前序遍历```序列和```后续序遍历```序列，```不能确定```一个二叉树


### 8. 线索二叉树

线索二叉树 ```Threaded Binary Tree```：

-	```线索```： 指向前驱和后继的指针叫做线索
-	加上线索的二叉链表就是```线索链表```
-	相应的二叉树就叫做线索二叉树

如图所示：

![ThreadBinaryTree1]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree20.png)

我们将这棵二叉树进行中序遍历之后，将所有的空指针域中的 rightchild 改为指向它的后继结点，如果结点不存在后继则设置成 NULL。那么我们就可以通过指针去得到某些结点的后继结点

![ThreadBinaryTree2]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree21.png)

然后我们就可以将所有空指针域的 leftchild 改为指向它的前继结点，如果结点不存在前继则设置成 NULL。

所以线索二叉树，等于是把一棵二叉树转变成了一个双向链表，这样对我们的插入删除结点、查找某个结点都带来了方便。所以我们```对二叉树以某种次序遍历使其变成线索二叉树的过程称作是线索化```。 所以通过线索化，就把上面的树，变成了下面的双向链表：

![ThreadBinaryTree3]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree22.png)

虽然我们把一个二叉树变成了双向链表，但是我们并不知道某个结点的 leftChild 是指向它的左孩子还是指向前驱结点，rightchild 同理。所以我们需要再给每个结点增加两个```标志域 ltag 和 rtag```，用于存放布尔型变量，所以结点结构就变成下面这样：

-	数据域： ```data```
-	指针域：
	-	左孩子指针：```leftchild```， 用于存放左孩子或者前驱结点指针
	-	右孩子指针： ```rightchild```， 用于存放右孩子或者后继结点指针
-	标志域：
	-	```ltag```：
		-	ltag 为 0, 该结点指向左孩子
		-	ltag 为 1, 该结点指向前驱结点
	-	```rtag```：
		-	rtag 为 0, 该结点指向右孩子
		-	rtag 为 1, 该结点指向后继结点

所以二叉链表就变成了下面的样子：

![ThreadBinaryTree4]( https://zhengshuaipeng.github.io/static/img/blog/2016/08/tree23.png)

```线索化的实质``` 就是将二叉链表中的空指针改为指向前驱或者后继的线索; ```线索化的过程``` 就是在遍历二叉树的过程中修改空指针的过程

线索化代码实现：

```
//中序遍历进行中序线索化
BiTree pre; // 全局变量，始终指向刚刚访问过的结点
void InThreading(BiTree p)
{
	if(p)
	{
		InThreading(p->leftChild);		// 递归左子树线索化
		if(!p->leftchild)				// 没有左孩子
		{
			p->lTag = Thread;			// 前驱线索
			p->leftchild = pre;			// 左孩子指针指向前驱
		}
		if(!pre->rchild)				// 前驱没有右孩子
		{
			pre->rTag = Thread;			// 后继线索
			pre->rightChild = p;		// 前驱的后孩子指针指向后继（当前结点 p）
		}
		pre = p;						// 保持 pre 指向 p 的前驱
		InThreading(p->rigthChild);		// 递归右子树线索化
	}
}
```

遍历线索二叉树代码实现：

```
// T  指向头结点
// 头结点左链 leftChild 指向根结点
// 头结点右链 rightChild 指向中序遍历的最后一个结点
//	中序遍历二叉线索链表表示的二叉树 T
Status InOrderTraverse_Thr(BiTree T)
{
	BiTree p;
	p = T->leftChild;		// p 指向根结点
	while(p != T)			// 空树或遍历结束的时候， p == T
	{
		while(p->lTag==Link)	// 当 lTag == 0 时循环到中序序列的第一个结点
			p = p->leftChild;
		printf("%c", p->data);	// 打印第一个结点
		while(p->rTag==Thread && p->rightChild != T)
		{
			p = p->rightChild;
			printf("c", p->data);
		}
		p = p->rightChild;		// p 进至其右子树根
	}
	return OK;
}
```

所以如果用的二叉树需要经常遍历或者查找结点的时候，需要某种遍历序列的前驱和后继，那么采用线索二叉链表的存储结构就是非常不错的选择


## III. 树、森林和二叉树的转换

