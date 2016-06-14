#! /usr/bin/env python

def init():
    """initial"""
    num = input('input number: ')
    int_num = int(num)
    bin_num = bin(int_num)
    print(num)
    print(int_num)
    print(bin_num)


if __name__ == '__main__':
    init()
