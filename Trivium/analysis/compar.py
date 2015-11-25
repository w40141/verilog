#! /usr/bin/python
# -*- coding: utf-8 -*-

CYCLES = 100
INREGS = 288


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
