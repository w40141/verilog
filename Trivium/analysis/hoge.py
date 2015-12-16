#! /usr/bin/python
# -*- coding: utf-8 -*-


import re
import time


TRIVIUM = []
DATA = []
raw_key = ['00000000000000000000',
           'ffffffffffffffffffff']
           # '06070809000000000000']
# raw_key = ['00000000000000000000']
           # '112a4370000000000000']
           # '21134a33000000000000',
           # '489db4b3000000000000',
           # '4ddfa569000000000000',
           # '5e019ed6000000000000',
           # '7bd23871000000000000',
           # '8c4effe0000000000000',
           # 'a23c0791000000000000',
           # 'ae505988000000000000',
           # 'b34fdadf000000000000',
           # 'd8b1e90d000000000000',
           # 'db108386000000000000',
           # 'df794c1f000000000000',
           # 'f25ceb0e000000000000',
           # 'f315f97c000000000000']
raw_iv = 'ffffffffffffffffffff'
# raw_iv = '00000000000000000000'
files = ['./1207data/00000000000000000000key.prn',
         './1207data/ffffffffffkey.prn']
# files = ['./1207data/ffffffffffkey.prn']
# files = ['./1204data/06070809key.prn',
#          './1204data/112a4370key.prn']
         # './1204data/21134a33key.prn',
         # './1204data/489db4b3key.prn',
         # './1204data/4ddfa569key.prn',
         # './1204data/5e019ed6key.prn',
         # './1204data/7bd23871key.prn',
         # './1204data/8c4effe0key.prn',
         # './1204data/a23c0791key.prn',
         # './1204data/ae505988key.prn',
         # './1204data/b34fdadfkey.prn',
         # './1204data/d8b1e90dkey.prn',
         # './1204data/db108386key.prn',
         # './1204data/df794c1fkey.prn',
         # './1204data/f25ceb0ekey.prn',
         # './1204data/f315f97ckey.prn']


def dataFunc(files, num):
    lines = []
    for fi in files:
        with open(fi, "r") as f:
            fl = f.readlines()
        for i in range(num+1):
            if i > 0:
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
    for key in raw_key:
        key = inputHex(key)
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


def checkList(li):
    # if :
        # pass


if __name__ == "__main__":
    start = time.time()
    scycle = 100
    ecycle = 250
    output = 'output.txt'
    for i in range(scycle, ecycle):
        print(i)
        TRIVIUM = triviumFunc(raw_key, raw_iv, i)
        liTri = makeList(TRIVIUM)
        print('finish Trivium')
        DATA = dataFunc(files, i)
        liDat = makeList(DATA)
        print('finish DATA')
        print(compare(liTri, liDat))
        # with open(output, 'a') as f:
        #     f.write(str(compare(liTri, liDat)) + '\n')
    elapsed_time = time.time() - start
    print("elapsed_time:{0}".format(elapsed_time) + "[sec]")
