---
layout: post
title:  "Numeral System And Conversion"
date:   2016-07-04
desc: "Introduction of numeral system and conversion of numeral system"
keywords: "numeral system, decimal, octonary, hexadecimal, binary"
categories: [Programming]
tags: [Numeral System]
icon: fa-keyboard-o
---

# I. Numeral System

## 1. 十进制 Decimal

-	base: 10
-	0 , 1, 2, 3, 4, 5, 6, 7, 8, 9

## 2. 二进制 Binary

-	base: 2
-	0, 1
-	begin with ```0b```

## 3. 八进制 Octonary

-	base: 8
-	0, 1, 2, 3, 4, 5, 6, 7
-	begin with ```0```

## 4. 十六进制 Hexadecimal

-	base: 16
-	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F
-	begin with ```0x```

# II. Conversion between numeral system

## 1. Binary To Decimal

convert binary 0b1001 to decimal;

```
0b1001 = 1 * 2^3 + 0 * 2^2 + 0 * 2^1 + 1 * 2^0
     = 8 + 0 + 0 + 1
     = 9
```

## 2. Decimal to Binary

convert decimal 20 to binary

### Method 1

Use divsion and remainder

```
binary: divide by 2  -- remainder
20 / 2 = 10  -- 0
10 / 2 = 5   -- 0
5  / 2 = 2   -- 1
2  / 2 = 1   -- 0
1  / 2 = 0   -- 1
So binary = 0b10100
```

### Method 2: 8421 code

| 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 | 1/0 |
|--|--|--|--|--|--|--|--|
|128/0|64/0|32/0|16/0|8/0|4/0|2/0|1/0|

```
20 = 1* 16 + 0 * 8 + 1 * 4 + 0 * 2 + 0 * 1
   = 10100
binary: 0b10100
```

## 3. Octonary to Decimal

convert octonary 01001 to decimal

```
01001 = 1 * 8^3 + 0 * 8^2 + 0 * 8^1 + 1 * 8^0
     = 512 + 0 + 0 + 1
     = 513
```

## 4. Decimal to Octonary

The same as decimal to binary, convert decimal 52 to octonary

```
52 / 8 = 6  -- 4
6 / 8  = 0  -- 6
octonary: 064
```

## 5. Hexadecimal to Decimal

convert hexadecimal 0x1001 to decimal

```
0x1001 = 1 * 16^3 + 0 * 16^2 + 0 * 16^1 + 1 * 16^0
     = 4096 + 0 + 0 + 1
     = 4097
```

# 6 Decimal to Hexadecimal

The same as decimal to binary, convert 52 to hexadecimal

```
52 / 16 = 3 -- 4
3 / 16  = 0 -- 3
hexadecimal: 0x34
```
