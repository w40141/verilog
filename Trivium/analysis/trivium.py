#! /usr/bin/python
# -*- coding: utf-8 -*-


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


if __name__ == "__main__":
    # inReg = []
    # tmp = ''
    # strReg = []
    # raw_key = input('input key')
    raw_key = '00010203040506070809'
    key = inputHex(raw_key)
    # inputFile = input('input inputfile name')
    inputFile = 'test.txt'
    outputFile = input('input outputfile name: ')
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
                lisReg = [window]
                lisReg = lisReg + reg
                strReg = ':'.join(map(str, lisReg))
                window += 1
                # count += 1
                with open(outputFile, 'a') as fh:
                    fh.write(strReg + '\n')
