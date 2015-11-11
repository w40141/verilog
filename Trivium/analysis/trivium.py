#! /usr/bin/python
# -*- coding: utf-8 -*-

import struct


if __name__ == "__main__":
    print("Input Key")
    rawKey = int(input())
    print("Input IV")
    rawIv = int(input())
    print("how long")
    count = int(input())
    num = 1124
    print(str(rawIv)[2])
