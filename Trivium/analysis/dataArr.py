#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


if __name__ == "__main__":
    lines = []
    # openF = input("which file do you want to open: ")
    openF = '1124_trivium.prn'
    # writF = raw_input("which file do you want to write: ")
    # with open(openF, "r") as fo:
    # outputFile = input('input outputFile name: ')
    outputFile = 'arr.txt'
    with open(openF, "r") as f:
        for i in range(1024):
            fl = f.readline()
            if i != 0:
                liData = re.split(r"[\t\r\n]", fl)
                stData = ':'.join(liData[1:1026])
                with open(outputFile, 'a') as fh:
                    fh.write(stData + '\n')
