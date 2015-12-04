#! /usr/bin/python
# -*- coding: utf-8 -*-


import re


if __name__ == "__main__":
    outputFile = 'saseboData.txt'
    files = ['./06070809000000000000key.prn',
             './21134a33000000000000key.prn',
             './489db4b3000000000000key.prn',
             './5af119a4000000000000key.prn',
             './5e019ed6000000000000key.prn',
             './66c6f21f000000000000key.prn',
             './80000000000000000000key.prn',
             './8c4effe0000000000000key.prn',
             './a23c0791000000000000key.prn',
             './ad793e5a000000000000key.prn',
             './cb4ed2e2000000000000key.prn',
             './d8b1e90d000000000000key.prn',
             './db108386000000000000key.prn',
             './df794c1f000000000000key.prn',
             './f315f97c000000000000key.prn',
             './fba6dab3000000000000key.prn']
    for fi in files:
        print(fi)
        with open(fi, "r") as f:
            fl = f.readlines()
        for i, data in enumerate(fl):
            with open(outputFile, 'a') as fh:
                if i != 0:
                    liData = re.split(r"[\t\r\n]", data)
                    fh.write(str(liData[1:1026]) + '\n')
