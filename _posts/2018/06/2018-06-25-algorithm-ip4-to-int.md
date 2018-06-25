---
layout: post
title:  "[String] Convert IPV4 address to 32 bit int"
date:   2018-06-25
desc: "String, convert ipv4 address to 32 bit integer"
keywords: "IP, String, Java, Algorithm"
categories: [algorithm]
---

# I. Question

Convert a IPV4 address String to a 32 bit integer.
-   Input: ```172.168.5.1```
-   Output: ```2896692481```

The output should be a 32 bit integer, with ```172``` as the highest order 8bit, ```168``` as the second highest order 8 bit, ```5``` as the second lowerest order 8 bit, and ```1``` as the lowerest order 8 bit.

Requirements:

1. You can only iterate the String once.
2. You should handle the whitespace correctly:
    -   The space between a digit and a dot is valid input: ```172[space].[space]168.5.1``` is a valid input
    -   The space between to digits is not a valid input: ```17[space]2.168.5.1``` is not a valid input

# II. Solution

In java, ```Integer.MAX_VALUE = 2^31 - 1 = 2147483647```, so here the output ```2896692481``` is out of the range of the max_value of integer, so we should consider to use ```Long``` or ```BigInt``` to process it.

Also we need to consider the bounder detection, to check the input is or is not a validate IPV4 address, we can use REGEX here.

Considering there may be the white space inside a input, we need to format the input String, use ```trim()``` operation.

Then split ip address to four ip segment, from begin to end, we use Bitshift operation.

But the requirements said that we can only iterate the String once, so the trim() operation should be done just before BitShift operation.

# III. Java Implementation

Java Implementation:

```java
package org.lovian.utils;

import java.math.BigInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;

/**
 * @author: PENG Zhengshuai
 * @Date: 2018/6/25
 * @Description:
 */
public class IpUtils {
    private static final String IPV4_PATTERN = "^(\\s)*(\\d){1,3}(\\s)*\\.(\\s)*(\\d){1,3}(\\s)*\\.(\\s)*(\\d){1,3}(\\s)*\\.(\\s)*(\\d){1,3}(\\s)*$";

    public static BigInteger ipv4To32BitInt(String ipAddr) {
        if (!validateIpAddress(ipAddr))
            throw new IllegalArgumentException("Ip Address is not validated: " + ipAddr);

        return BigInteger.valueOf(ipv4ToLong(ipAddr));
    }

    private static boolean validateIpAddress(String ipAddr) {
        if (StringUtils.isBlank(ipAddr))
            return false;
        Pattern pattern = Pattern.compile(IPV4_PATTERN);
        Matcher matcher = pattern.matcher(ipAddr);
        return matcher.matches();
    }

    private static long ipv4ToLong(String ipAddr) {
        long result = 0;

        String[] ipSegmentArray = StringUtils.split(ipAddr, "\\.");

        for (int i = ipSegmentArray.length; i > 0; i--) {
            long ipSegment = formatIpSegment(ipSegmentArray[ipSegmentArray.length - i]);
            long shiftedIpSegment = ipSegment << ((i - 1) * 8);
            //Use Bitwise OR to add each shifted segment to result
            result |= shiftedIpSegment;
        }

        return result;
    }

    private static long formatIpSegment(String ipSegment) {
        long formattedIpSegment =  Long.parseLong(ipSegment.trim());
        
        if(formattedIpSegment< 0 || formattedIpSegment > 255)
            throw new IllegalArgumentException("Ip Address Segment Is Out Of Range: " + ipSegment);
        
        return formattedIpSegment;
    }
}
```

Junit Tests:

```java
package org.lovian.utils;

import java.math.BigInteger;

import org.junit.Assert;
import org.junit.Test;

/**
 * @author: PENG Zhengshuai
 * @Date: 2018/6/25
 * @Description:
 */
public class IpUtilsTest {
    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddrBlank() {
        IpUtils.ipv4To32BitInt("");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddrNull() {
        IpUtils.ipv4To32BitInt(null);
    }

    @Test
    public void testIpv4ToInt() {
        // normal case
        Assert.assertEquals(BigInteger.valueOf(2896692481L), IpUtils.ipv4To32BitInt("172.168.5.1"));
    }

    @Test
    public void testIpv4AddrWithSpaceToInt() {
        Assert.assertEquals(BigInteger.valueOf(2896692481L), IpUtils.ipv4To32BitInt("172 . 168 .5 . 1"));
        Assert.assertEquals(BigInteger.valueOf(2896692481L), IpUtils.ipv4To32BitInt(" 172.168.5.1 "));
        Assert.assertEquals(BigInteger.valueOf(2896692481L), IpUtils.ipv4To32BitInt(" 172 .168 .5 . 1 "));
        Assert.assertEquals(BigInteger.valueOf(2896692481L), IpUtils.ipv4To32BitInt("   172 . 168 .5 . 1  "));
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddrWithInvalidateSpace() {
        IpUtils.ipv4To32BitInt("17 2.168.5.1");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddrInvalidate0(){
        IpUtils.ipv4To32BitInt("256.23.4.1");
    }
    
    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddrInvalidate1() {
        IpUtils.ipv4To32BitInt(".1.23.4.1");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddInvalidate2() {
        IpUtils.ipv4To32BitInt(".23.4.1");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddInvalidate3() {
        IpUtils.ipv4To32BitInt("a.b.c.d");
    }

    @Test(expected = IllegalArgumentException.class)
    public void testIpv4AddInvalidate4() {
        IpUtils.ipv4To32BitInt("a.b.1.2");
    }
}
```