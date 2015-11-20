#! /usr/bin/python
# -*- coding: utf-8 -*-

CYCLES = 100
INREGS = 288


def inputHex(rawData):
    data = ''.join([rawData[i-2:i] for i in range(len(rawData), 0, -2)])
    strNum = bin(int(data, 16))
    binNum = strNum[2:]
    Num = binNum.zfill(80)
    return Num


def initfunc(key, iv):
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = list(strReg)
    reg = map(int, reg)
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


if __name__ == "__main__":
    inReg = []
    tmp = ''
    print("input key")
    # raw_key = raw_input()
    raw_key = '11111111111111111111'
    key = inputHex(raw_key)
    print('input inputfile name')
    # inputFile = raw_input()
    inputFile = 'randomNum.txt'
    print('input outputfile name')
    outputFile = raw_input()
    signe = [['' for i in range(CYCLES)] for j in range(INREGS)]
    with open(inputFile, "r") as fi:
        fl = fi.readlines()
        for i in fl:
            iv = inputHex(i[:-1].replace(' ', ''))
            reg = initfunc(key, iv)
            for j in range(CYCLES):
                reg = shiftFunc(reg)
                strReg = ''.join(map(str, reg))
                inReg.append(strReg)
                with open(outputFile, 'a') as fh:
                    fh.write(strReg + '\n')
    for i in range(INREGS):
        for cyc in range(CYCLES):
            for j in range(len(fl)):
                signe[i][cyc] = signe[i][cyc] + inReg[cyc + CYCLES * j][i]
    print(signe)
