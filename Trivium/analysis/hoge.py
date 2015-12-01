#! /usr/bin/python
# -*- coding: utf-8 -*-


import re
TRIVIUM = []
DATA = []


def inputHex(rawData):
    bunkatu = [rawData[i:i+2] for i in range(0, len(rawData), 2)]
    bit = [bin(int(i, 16))[2:].zfill(8) for i in bunkatu]
    num = ''.join([i[::-1] for i in bit]).zfill(80)
    return num


def initfunc(key, iv):
    # keyLen = input('length')
    keyLen = 16
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = [int(x) for x in list(strReg)]
    return keyLen, reg


def change(rawData, zero):
    revData = [str(x) for x in rawData[::-1]]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    zNum = hex(int(''.join(strData), 2))[2:-1].zfill(zero)
    return zNum


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
    with open(inputFile, "r") as fi:
        fl = fi.readline()
        iv = inputHex(fl[:-1].replace(' ', ''))
        keyLen, reg = initfunc(key, iv)
        CYCLES = int(1024 / keyLen)
        for win in range(keyLen):
            for i in range(CYCLES):
                # reReg.append([i] + [str(x) for x in reg])
                # print(reReg[i])
                # reg = shiftFunc(reg)
                reReg.append([i] + [str(x) for x in shiftFunc(reg)])
    return reReg


def dataFunc():
    lines = []
    # openF = input("which file do you want to open: ")
    openF = '1124_trivium.prn'
    with open(openF, "r") as f:
        for i in range(1025):
            fl = f.readline()
            if i != 0:
                liData = re.split(r"[\t\r\n]", fl)
                liData = [str(x) for x in liData]
                stData = liData[1:1026]
                stData[0] = int(stData[0])
                # print(stData)
                lines.append(stData)
    return lines


def makeList(liData):
    lenList = len(liData[0]) - 1
    signe = [['' for i in range(liData[-1][0] + 1)] for j in range(lenList)]
    for li in liData:
        tmp = li[1:]
        for i in range(len(tmp)):
            signe[i][li[0]] = signe[i][li[0]] + tmp[i]
    # print(signe)
    return signe


def compare(Tri, Data):
    # ans = ['' for x in range(len(Tri))]
    for i, itemT in enumerate(Tri):
        print(itemT[0])
        for k, itemD in enumerate(Data):
            # print(itemD)
            if itemT[0] == itemD[0]:
                # if itemT[1] == itemD[1]:
            #     ans[i] = ans[i] + str(k)
                print('find')
            #     break
    # return ans


if __name__ == "__main__":
    TRIVIUM = triviumFunc()
    # print(TRIVIUM)
    liTri = makeList(TRIVIUM)
    # print(liTri)
    print('finish Trivium')
    DATA = dataFunc()
    # print(DATA)
    liDat = makeList(DATA)
    # print(liDat)
    print('finish DATA')
    print(compare(liTri, liDat))
