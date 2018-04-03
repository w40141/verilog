#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import os
import sys
import matplotlib.pyplot as plt


def file2data(fn):
    with open(fn, "r") as f:
        raw_data = f.readlines()
    # data = [float(d[:-2]) for d in raw_data]
    data = [float(d) for d in raw_data]
    return data


def make_summary(t_li):
    t = np.array(t_li)
    n_max = np.max(t)
    print(n_max)
    n_min = np.min(t)
    n_ave = np.mean(t)
    n_std = np.std(t, ddof=1)
    n_med = np.median(t)
    s_li = [n_max, n_min, n_ave, n_std, n_med]
    return s_li


def file2summary(dir_path, file_li, mode):
    mode_file_li = [dir_path + f for f in file_li if f[5:9] == mode]
    x = [int(x[7:11]) for x in mode_file_li]
    summary_li = [make_summary(file2data(fn)) for fn in mode_file_li]
    return x, summary_li


def make_plot(x, summary_li, mode):
    s_max = [s[0] for s in summary_li]
    s_min = [s[1] for s in summary_li]
    s_ave = [s[2] for s in summary_li]
    s_std = [s[3] for s in summary_li]
    s_med = [s[4] for s in summary_li]
    if mode == 'time':
        yl = "CPU time to restore $\it{K_{in}}$ and $\it{K_{out}}$ [s]"
    elif mode == 'word':
        yl = "Messages to input to the HMAC-SHA-256 circuit"
    plt.plot(x, s_max, 'r+', label="Max")
    plt.plot(x, s_ave, 'b.', label="Average")
    plt.plot(x, s_med, 'y*', label="Median")
    plt.plot(x, s_min, 'mv', label="Min")
    plt.errorbar(x, s_ave, yerr=s_std, fmt='b.', ecolor='g', capsize=3.0)
    plt.xlabel("Bit length of the scan data [bits]")
    plt.ylabel(yl)
    plt.legend(bbox_to_anchor=(0.5, -0.2), loc='center', borderaxespad=0, ncol=4)
    plt.subplots_adjust(bottom=0.2)
    plt.show()


def main():
    dir_path = './data/'
    file_li = os.listdir(dir_path)
    time_x, time_summary_li = file2summary(dir_path, file_li, 'time')
    make_plot(time_x, time_summary_li, 'time')
    word_x, word_summary_li = file2summary(dir_path, file_li, 'word')
    make_plot(word_x, word_summary_li, 'word')


if __name__ == "__main__":
    sys.exit(main())
