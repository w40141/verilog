#! /usr/bin/python
# -*- coding: utf-8 -*-


import re
Trivium = []
DATA = []


def inputHex(rawData):
    data = ''.join([rawData[i-2:i] for i in range(len(rawData), 0, -2)])
    strNum = bin(int(data, 16))
    binNum = strNum[2:]
    Num = binNum.zfill(80)
    return Num


def initfunc(key, iv):
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = list(strReg)
    reg = [int(x) for x in reg]
    return reg


def shiftFunc(reg):
    t1 = reg[65] ^ reg[92] ^ reg[90] & reg[91] ^ reg[170]
    t2 = reg[161] ^ reg[176] ^ reg[174] & reg[175] ^ reg[263]
    t3 = reg[242] ^ reg[287] ^ reg[285] & reg[286] ^ reg[68]
    reg[1:] = reg[:287]
    reg[0] = t3
    reg[93] = t1
    reg[177] = t2
    return reg


def triviumFunc():
    reReg = []
    raw_key = '00010203040506070809'
    key = inputHex(raw_key)
    # inputFile = input('input inputfile name')
    inputFile = 'RandomNum'
    # outputFile = input('input outputfile name: ')
    # outputFile = 'tri.txt'
    # keyLen = input('length')
    keyLen = 16
    CYCLES = int(1024 / keyLen)
    window = 0
    with open(inputFile, "r") as fi:
        for i in range(keyLen):
            fl = fi.readline()
            # count = 0
            window = 0
            iv = inputHex(fl[:-1].replace(' ', ''))
            reg = initfunc(key, iv)
            for j in range(CYCLES):
                reg = shiftFunc(reg)
                strReg = [str(x) for x in reg]
                lisReg = [window]
                lisReg = lisReg + strReg
                # lisReg = [str(x) for x in lisReg]
                reReg.append(lisReg)
                window += 1
    return reReg


def dataFunc():
    lines = []
    # openF = input("which file do you want to open: ")
    openF = '1124_trivium.prn'
    # outputFile = input('input outputFile name: ')
    # outputFile = 'arr.txt'
    with open(openF, "r") as f:
        for i in range(1024):
            fl = f.readline()
            if i != 0:
                liData = re.split(r"[\t\r\n]", fl)
                liData = [str(x) for x in liData]
                stData = liData[1:1026]
                stData[0] = int(stData[0])
                lines.append(stData)
    return lines


def makeList(data):
    length = len(data)
    signe = [['' for i in range(data[-1][0] + 1)] for j in range(length)]
    for i in data:
        print(i[0])
        for j in range(length):
            signe[i[0]][j] = signe[i[0]][j] + i[j]


if __name__ == "__main__":
    Trivium = triviumFunc()
    print(len(Trivium[0]))
    print('finish Trivium')
    DATA = dataFunc()
    print('finish DATA')
    # makeList(Trivium)
