#! /usr/bin/python
# -*- coding: utf-8 -*-


def inputHex(rawData):
    bunkatu = [rawData[i:i+2] for i in range(0, len(rawData), 2)]
    bit = [bin(int(i, 16))[2:].zfill(8) for i in bunkatu]
    Num = ''.join([i[::-1] for i in bit]).zfill(80)
    return Num


def initfunc(key, iv):
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = [int(x) for x in list(strReg)]
    return reg


def change(rawData, zero):
    revData = [str(x) for x in rawData[::-1]]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    zNum = hex(int(''.join(strData), 2))[2:-1].zfill(zero)
    return zNum


def triviumFunc():
    z = []
    raw_key = '00010203040506070809'
    key = inputHex(raw_key)
    inputFile = 'RandomNum'
    CYCLES = 288 * 4 + 128
    with open(inputFile, "r") as fi:
        fl = fi.readline()
        iv = inputHex(fl[:-1].replace(' ', ''))
        reg = initfunc(key, iv)
        for i in range(CYCLES):
            # print(change(reg, 72))
            t1 = reg[65] ^ reg[92]
            t2 = reg[161] ^ reg[176]
            t3 = reg[242] ^ reg[287]
            if i >= 288 * 4:
                t = t1 ^ t2 ^t3
                z.append(t)
                # print(t)
            t1 = t1 ^ reg[90] & reg[91] ^ reg[170]
            t2 = t2 ^ reg[174] & reg[175] ^ reg[263]
            t3 = t3 ^ reg[285] & reg[286] ^ reg[68]
            reg[1:] = reg[:287]
            reg[0] = t3
            reg[93] = t1
            reg[177] = t2
    return z


if __name__ == "__main__":
    TRIVIUM = triviumFunc()
    print(len(TRIVIUM))
    print(TRIVIUM)
    print(change(TRIVIUM, 32))
