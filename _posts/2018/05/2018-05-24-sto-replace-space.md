---
layout: post
title:  "[Sword_To_Offer] Array - 替换空格"
date:   2018-05-25
desc: "Replace "
keywords: "Algorithm, Sword_To_Offer, Array, Find, Two-Dimension"
categories: [sword_to_offer]
---

# I. 问题描述

请实现一个函数，将一个字符串中的空格替换成 ```%20```。例如，当字符串为 ```We Are Happy```. 则经过替换之后的字符串为 ```We%20Are%20Happy```

[OJ: NowCoder](https://www.nowcoder.com/practice/4060ac7e3e404ad1a894ef3e17650423?tpId=13&tqId=11155&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)



# II. 思路

对每一个空格, 占位长度为 1, 而一个 ```%20```, 占位长度为 3. 也就是说, 有 N 个空格, 那么替换后的字符串长度应该就是 ```old_length + 2*N```, 所以思路就是把原有的字符串扩展到有被替换的长度, 然后由后往前, 逐个替换位置上应该出现的字符. 

比如 ```A B```, 那么扩展长度后就应该是 ```A B  ```, 然后首先先将 B 移动到最后一个位置 ```A   B```, 之后把三个空格,替换为 ```%20```, 就变成了 ```A%20B```

# III. JAVA 实现

```java
public class Solution {
    public String replaceSpace(StringBuffer str) {
        int oldLen = str.length();
        
        // 先扩展原有字符串的长度
    	for(int i = 0; i < oldLen; i ++){
            if(str.charAt(i) == ' '){
                str.append("  ");
            }
        }
        
        int oldIdx = oldLen - 1;
        int newIdx = str.length() - 1;
        
        // 替换每一个位置的字符,由后致前
        while(oldIdx >= 0 && newIdx > oldIdx){
            char c = str.charAt(oldIdx--);
            if(c == ' '){
                // 逆序替换空格
                str.setCharAt(newIdx--, '0');
                str.setCharAt(newIdx--, '2');
                str.setCharAt(newIdx--, '%');
            }else{
                // 替换正常字符
                str.setCharAt(newIdx--, c);
            }
        }
        
        return str.toString();
    }
}
```