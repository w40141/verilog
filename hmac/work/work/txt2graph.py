#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import os
import sys
import matplotlib


def input_file(fn):
    with open(fn, "r") as f:
        raw_data = f.read()
    data = int(raw_data.split('\n')[:-1])
    print(data)


def summary(t_li):
    t = np.array(t_li)
    summary_li = [np.max(t), np.min(t), np.mean(t), np.std(t)]
    return summary_li


def main():
    dir_path = './data/'
    file_li = os.listdir(dir_path)
    time_file_li = [ dir_path + f for f in file_li if f[5:9] == 'time' ]
    word_file_li = [ dir_path + f for f in file_li if f[5:9] == 'word' ]
    x = [ int(x[7:11]) for x in time_file_li ]
    for t_f in time_file_li:
        input_file(t_f)
    print(x)


if __name__=="__main__":
    sys.exit(main())


