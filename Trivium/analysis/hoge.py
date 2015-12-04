#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


TRIVIUM = []
DATA = []
cycle = 128
# raw_key = ['06070809000000000000',
raw_key = ['21134a33000000000000',
           '489db4b3000000000000',
           '5af119a4000000000000',
           '5e019ed6000000000000',
           '66c6f21f000000000000',
           '80000000000000000000',
           '8c4effe0000000000000',
           'a23c0791000000000000',
           'ad793e5a000000000000',
           'cb4ed2e2000000000000',
           'd8b1e90d000000000000',
           'db108386000000000000',
           'df794c1f000000000000',
           'f315f97c000000000000',
           'fba6dab3000000000000']
raw_iv = '00000000000000000000'
# files = ['./06070809000000000000key.prn',
files = ['./21134a33000000000000key.prn',
         './489db4b3000000000000key.prn',
         './5af119a4000000000000key.prn',
         './5e019ed6000000000000key.prn',
         './66c6f21f000000000000key.prn',
         './80000000000000000000key.prn',
         './8c4effe0000000000000key.prn',
         './a23c0791000000000000key.prn',
         './ad793e5a000000000000key.prn',
         './cb4ed2e2000000000000key.prn',
         './d8b1e90d000000000000key.prn',
         './db108386000000000000key.prn',
         './df794c1f000000000000key.prn',
         './f315f97c000000000000key.prn',
         './fba6dab3000000000000key.prn']


def dataFunc(files):
    lines = []
    for fi in files:
        with open(fi, "r") as f:
            fl = f.readlines()
        for i, data in enumerate(fl):
            if i != 0:
                liData = re.split(r"[\t\r\n]", data)
                liData[1] = int(liData[1])
                lines.append(liData[1:1026])
            # else:
            #     liData = re.split(r"[\t\r\n]", data)
            #     print(liData[538])
    return lines

# Trivium{{{
def inputHex(rawData):
    bunkatu = [rawData[i:i+2] for i in range(0, len(rawData), 2)]
    bit = [bin(int(i, 16))[2:].zfill(8) for i in bunkatu]
    num = ''.join([i[::-1] for i in bit]).zfill(80)
    return num


def initfunc(key, iv):
    # keyLen = input('length')
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = [int(x) for x in list(strReg)]
    return reg


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


def triviumFunc(raw_key, raw_iv, cycle):
    reReg = []
    # inputfile = input('input inputfile name')
    # inputFile = 'RandomNum'
    # with open(inputFile, "r") as fi:
    for key in raw_key:
        key = inputHex(key)
        iv = inputHex(raw_iv)
        # fl = fi.readline()
        # iv = inputHex(fl[:-1].replace(' ', ''))
        reg = initfunc(key, iv)
        for i in range(cycle):
            reReg.append([i] + [str(x) for x in shiftFunc(reg)])
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
    # ans = ['' for x in range(len(Tri))]
    for i, itemT in enumerate(Triv):
        print(i)
        for k, itemD in enumerate(Data):
            # print(itemD)
            if itemT == itemD:
                # if itemT[1] == itemD[1]:
                # ans[i] = ans[i] + str(k)
                print(str(i) + 'find: ' + str(k))
                # break
    # return ans


if __name__ == "__main__":
    TRIVIUM = triviumFunc(raw_key, raw_iv, cycle)
    # print(TRIVIUM)
    liTri = makeList(TRIVIUM)
    # print(liTri)
    print('finish Trivium')
    DATA = dataFunc(files)
    liDat = makeList(DATA)
    print('finish DATA')
    compare(liTri, liDat)
