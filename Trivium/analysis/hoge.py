#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


if __name__ == "__main__":
    lines = []
    print("which file do you want to open?")
    # openF = raw_input()
    # print("which file do you want to write?")
    # writF = raw_input()
    # with open(openF, "r") as fo:
    with open('1124_trivium.prn', "r") as f:
        fl = f.readlines()
        for i in fl:
            data = re.split(r"[\t\r\n]", i)
            # data = i.replace('\t', ' ')
            # data.split(' ')
            # print(data[:1024])
            lines.append(data[1:1026])
        print(lines)
        # for i in fl:
        #     lines.append(i[:-1].replace(' ', ''))
        #     print(lines)

    # with open(writF, 'a') as fi:
    #     fi.write('' + '\n')
    # print("Finish")
