#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


TRIVIUM = []
DATA = []
# raw_key = input('input key\n')
raw_key = '199e1b8344c2ad75c5af'
# raw_iv  = input('input iv\n')
raw_iv  = '0783977b8cf6cb7c4cc3'
name = input('input name\n')
files   = '../../../../Dropbox/share/' + name


def dataFunc(files, num):
    lines = []
    with open(files, "r") as f:
        fl = f.readlines()
    for i in range(num+1):
        if 0 < i:
            liData = re.split(r"[\t\r\n]", fl[i])
            liData[1] = int(liData[1])
            lines.append(liData[1:1026])
    return lines


# Trivium{{{
def inputHex(rawData):
    bunkatu = [rawData[i:i+2] for i in range(0, len(rawData), 2)]
    bit = [bin(int(i, 16))[2:].zfill(8) for i in bunkatu]
    num = ''.join([i[::-1] for i in bit]).zfill(80)
    return num


def initfunc(key, iv):
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = [int(x) for x in list(strReg)]
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


# for print Dout
def change(rawData, zero):
    revData = [str(x) for x in rawData]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    zNum = hex(int(''.join(strData), 2))[2:].zfill(zero)
    return zNum


# for print SET
def revChange(rawData):
    revData = [str(x) for x in rawData[::-1]]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    liHex = [hex(int(i, 2)) for i in strData]
    zNum = ''.join([i[2] for i in liHex])
    return zNum


def triviumFunc(raw_key, raw_iv, cycle):
    reReg = []
    key = inputHex(raw_key)
    tmp = '00000000000000000000'
    tmp = inputHex(tmp)
    reg = initfunc(key, tmp)
    reReg.append([0] + [str(x) for x in reg])
    iv = inputHex(raw_iv)
    reg = initfunc(key, iv)
    for i in range(1, cycle):
        reReg.append([i] + [str(x) for x in reg])
        reg = shiftFunc(reg)
    return reReg


# }}}


def makeList(liData):
    lenList = len(liData[0]) - 1
    signe = [['' for i in range(liData[-1][0] + 1)] for j in range(lenList)]
    for li in liData:
        tmp = li[1:]
        for i in range(len(tmp)):
            signe[i][li[0]] = signe[i][li[0]] + tmp[i]
    return signe


def compare(Triv, Data):
    ans = [[] for x in range(len(Triv))]
    for i in range(len(Triv)):
        for k in range(len(Data)):
            if Triv[i] == Data[k]:
                ans[i].append(str(k))
    return ans


if __name__ == "__main__":
    begin = 100
    end = 300
    for i in range(begin, end):
        print(i)
        TRIVIUM = triviumFunc(raw_key, raw_iv, i)
        # print(TRIVIUM)
        liTri = makeList(TRIVIUM)
        DATA = dataFunc(files, i)
        # print(DATA)
        liDat = makeList(DATA)
        # print(liDat)
        print(compare(liTri, liDat))
