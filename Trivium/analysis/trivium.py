#! /usr/bin/python
# -*- coding: utf-8 -*-


cycle = 128
raw_key = ['06070809000000000000',
           '21134a33000000000000',
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
raw_iv = '4089d544000000000000'


def inputHex(rawData):
    bunkatu = [rawData[i:i+2] for i in range(0, len(rawData), 2)]
    bit = [bin(int(i, 16))[2:].zfill(8) for i in bunkatu]
    Num = ''.join([i[::-1] for i in bit]).zfill(80)
    return Num


def initfunc(key, iv):
    strReg = key + '0'*13 + iv + '0'*112 + '1'*3
    reg = [int(x) for x in list(strReg)]
    return reg


# for print Dout
def change(rawData, zero):
    revData = [str(x) for x in rawData]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    zNum = hex(int(''.join(strData), 2))[2:].zfill(zero)
    return zNum


# for print SET
def revChange(rawData, zero):
    revData = [str(x) for x in rawData[::-1]]
    strData = [''.join(revData[i:i+4]) for i in range(0, len(revData), 4)]
    zNum = hex(int(''.join(strData), 2))[2:].zfill(zero)
    return zNum


def triviumFunc(raw_key, raw_iv, cycle):
    z = []
    # inputfile = input('input inputfile name')
    # inputFile = 'RandomNum'
    # iv = inputHex(raw_iv)
    # with open(inputFile, "r") as fi:
    for key in raw_key:
        key = inputHex(key)
        iv = inputHex(raw_iv)
        reg = initfunc(key, iv)
        print(revChange(reg, 72))
        for i in range(cycle):
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
            print(revChange(reg, 72))
    return z


if __name__ == "__main__":
    TRIVIUM = triviumFunc(raw_key, raw_iv, cycle)
    # print(len(TRIVIUM))
    # print(TRIVIUM)
    # print(change(TRIVIUM, 32))
