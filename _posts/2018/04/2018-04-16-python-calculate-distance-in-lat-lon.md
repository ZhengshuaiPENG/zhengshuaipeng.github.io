---
layout: post
title:  "[Python] 根据经纬度坐标计算两点间距离"
date:   2018-04-16
desc: "Use python to calculate distance between two points in lat/lon"
keywords: "Python, distance, latitude, longitude"
categories: [python]
---

# I. 根据经纬度坐标计算两点间距离

这是一个小的python脚本来计算两个已经纬度来计算两点之间的经纬度距离,距离输出单位为 ```米 m```

```python
#! python2
# -*- coding:utf-8 -*-
import sys
from math import sin, cos, sqrt, atan2, radians

def main(point_1_lat, point_1_lon, point_2_lat, point_2_lon, unit='m'):
    # approximate radius of earth in km
    R = 6373.0

    lat1 = radians(float(point_1_lat))
    lon1 = radians(float(point_1_lon))
    lat2 = radians(float(point_2_lat))
    lon2 = radians(float(point_2_lon))

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance = R * c * 1000
    print "Distance: " + str(distance) + "m"

if __name__ == '__main__':
    point_1_lat = sys.argv[1]
    print "Point 1 lat: " + str(point_1_lat)
    point_1_lon = sys.argv[2]
    print "Point 1 lon: " + str(point_1_lon)
    point_2_lat = sys.argv[3]
    print "Point 2 lat: " + str(point_2_lat)
    point_2_lon = sys.argv[4]
    print "Point 2 lon: " + str(point_2_lon)

    main(point_1_lat, point_1_lon, point_2_lat, point_2_lon)
```