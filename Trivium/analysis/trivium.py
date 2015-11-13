#! /usr/bin/python
# -*- coding: utf-8 -*-


def input_hex(name):
    print("Input" + name)
    # rawData = raw_input()
    rawData = 'ffffffffffffffffffff'
    data = ''.join([rawData[i-2:i] for i in range(len(rawData), 0, -2)])
    strNum = bin(int(data, 16))
    binNum = strNum[2:]
    Num = binNum.zfill(80)
    return Num


if __name__ == "__main__":
    key = input_hex('Key')
    iv = input_hex('Iv')
    # print("how long")
    # stream = int(input())
    iniNum = 1124
    z = []
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = list(strReg)
    # for i in range(stream + iniNum):
    for i in range(10000):
        t1 = int(reg[65]) ^ int(reg[92])
        t2 = int(reg[161]) ^ int(reg[176])
        t3 = int(reg[242]) ^ int(reg[287])
        if i >= iniNum:
            z.append(t1 ^ t2 ^ t3)
        t1 = t1 ^ int(reg[90]) & int(reg[91]) ^ int(reg[170])
        t2 = t2 ^ int(reg[174]) & int(reg[175]) ^ int(reg[263])
        t3 = t3 ^ int(reg[285]) & int(reg[286]) ^ int(reg[68])
        reg[1:] = reg[:287]
        reg[0] = str(t3)
        reg[93] = str(t1)
        reg[177] = str(t2)
