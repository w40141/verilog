#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


if __name__ == "__main__":
    lines = []
    # print("which file do you want to open?")
    # openF = raw_input()
    # print("which file do you want to write?")
    # writF = raw_input()
    # with open(openF, "r") as fo:
    outputFile = input('input outputFile name: ')
    with open('1124_trivium.prn', "r") as f:
        for i in range(1024):
            fl = f.readline()
            if i != 0:
                liData = re.split(r"[\t\r\n]", fl)
                stData = ':'.join(liData[1:1026])
                with open(outputFile, 'a') as fh:
                    fh.write(stData + '\n')
            # data.split(' ')
            # print(data[:1024])
            # lines.append(data[1:1026])
        # print(lines)
        # for i in fl:
        #     lines.append(i[:-1].replace(' ', ''))
        #     print(lines)

    # with open(writF, 'a') as fi:
    #     fi.write('' + '\n')
    # print("Finish")
