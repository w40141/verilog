#! /usr/bin/python
# -*- coding: utf-8 -*-

a = 1
b = 1
c = 0
d = 1
e = 1
t1 = a ^ b & c ^ d ^ e
t2 = a ^ (b & c) ^ d ^ e
print(t1, t2)
