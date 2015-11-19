#! /usr/bin/python
# -*- coding: utf-8 -*-

ININUM = 288 * 4


# def inputForFile()

def input_hex(name):
    # print("Input" + name)
    # rawData = raw_input()
    rawData = '00000000000000000000'
    data = ''.join([rawData[i-2:i] for i in range(len(rawData), 0, -2)])
    strNum = bin(int(data, 16))
    binNum = strNum[2:]
    Num = binNum.zfill(80)
    return Num


def initfunc():
    key = input_hex('Key')
    iv = input_hex('Iv')
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


def firstFunc(reg):
    t1 = reg[65] ^ reg[92]
    t2 = reg[161] ^ reg[176]
    t3 = reg[242] ^ reg[287]
    return t1, t2, t3


def secondFunc(reg, t1, t2, t3):
    t1 = t1 ^ reg[90] & reg[91] ^ reg[170]
    t2 = t2 ^ reg[174] & reg[175] ^ reg[263]
    t3 = t3 ^ reg[285] & reg[286] ^ reg[68]
    reg[1:] = reg[:287]
    reg[0] = t3
    reg[93] = t1
    reg[177] = t2
    return reg


def strToHex(strBin):
    intByte = int(strBin, 2)
    hexByte = hex(intByte)
    alph = hexByte[2]
    return alph


def bitToHex(reg):
    z = []
    strReg = ''.join(map(str, reg))
    byteReg = [strReg[i:i+4] for i in range(0, len(reg), 4)]
    for i in range(len(byteReg)):
        z.append(strToHex(byteReg[i]))
    strZ = ''.join(z)
    return strZ


if __name__ == "__main__":
    stream = 128
    z = []
    reg = initfunc()
    for i in range(stream + ININUM + 1):
        reg = shiftFunc(reg)
        # t1, t2, t3 = firstFunc(reg)
        # if i > ININUM:
        #     z.append(t1 ^ t2 ^ t3)
        # reg = secondFunc(reg, t1, t2, t3)
        strReg = ''.join(map(str, reg))
        print(strReg)
    # print(change(map(str, z)))
