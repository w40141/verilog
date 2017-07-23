#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from collections import defaultdict
import random
import sys
import time


# init {{{
def init_data(n, arg):
    li = make_data(arg)
    data_li_li = make_li(li)
    # rand_li = make_rand_li(n)
    rand_li = [i for i in range(128)]
    return data_li_li, rand_li


def make_data(arg):
    li = []
    # readfile = './data.txt'
    readfile = arg
    with open(readfile, 'r') as f:
        for row in f:
            li.append(int(row.strip()))
    return li


def make_li(d_li):
    n = 32
    l = int(len(d_li)/n)
    li = [d_li[n * i:n * (i + 1)] for i in range(l) ]
    return li


def make_rand_li(num):
    rand_li = [i for i in range(num)]
    random.shuffle(rand_li)
    return rand_li
# }}}


# make_scan {{{
def make_scan(data_li_li, rand_li):
    scan_li_li = []
    for data_li in data_li_li:
        scan_li = []
        for data in data_li:
            org_li = split_str(int2bin(data))
            scan_li.append(convert_rand_chain(org_li, rand_li))
        scan_li_li.append(scan_li)
    return scan_li_li


def int2bin(num):
    return format(num, 'b').zfill(128)


def split_str(string):
    return [int(string[i:i + 1]) for i in range(0, len(string), 1)]


def convert_rand_chain(reg_li, rand_li):
    scan_li = []
    for i in rand_li:
        if i < len(reg_li):
            tmp = reg_li[i]
        else:
            tmp = random.randint(0, 1)
        scan_li.append(tmp)
    return scan_li
# }}}


# first_step {{{
def first_step(scan_li_li):
    tran_dic = defaultdict(int)
    li = []
    for scan_li in scan_li_li:
        t_scan_li = trans_li(scan_li)
        tran_dic = find_tran(t_scan_li, tran_dic)
    print(tran_dic)
    for k, v in sorted(tran_dic.items()):
        if v >= 100:
            li.append(list(map(int,k[1:-1].split(','))))
    return li


def trans_li(reg_li):
    return list(map(list, zip(*reg_li)))


# find_tran {{{
def find_tran(t_scan_li, tran_dic):
    for i in range(0, len(t_scan_li[0]), 1):
        series_li = compare_li(t_scan_li, i, 12)
        if len(series_li) >= 64:
            tmp_li = list(map(str, series_li))
            for t in tmp_li:
                tran_dic[t] += 1
    return tran_dic


# compare_li {{{
def compare_li(reg_li, s, n):
    series_li = []
    e = s + n
    for i, src_reg in enumerate(reg_li):
        for j, dst_reg in enumerate(reg_li):
            if i != j:
                if src_reg[s:e] == dst_reg[s + 1:e + 1]:
                    series_li.append([i, j])
    return series_li
# }}}
# }}}
# }}}


# second_step {{{
def second_step(scan_li_li, first_li):
    extrac_li = extraction(scan_li_li)
    org_li = find_flag(extrac_li, first_li)
    key = make_key(scan_li_li, org_li)
    return key


# make_key {{{
def make_key(scan_li_li, org_li):
    tmp = [scan_li_li[0][0][i] for i in org_li]
    key_bin = ''.join(map(str, tmp))
    return format(int(key_bin, 2), 'x').zfill(32)
# }}}


def extraction(scan_li_li):
    return [i[13] for i in scan_li_li]


# find_flag {{{
def find_flag(extrac_li, first_li):
    org_li = [0 for i in range(128)]
    for i, reg in enumerate(extrac_li):
        for j in first_li:
            if reg[j[0]] == 1:
                if i < 32 :
                    org_li[i] = j[0]
                    org_li[i + 96] = j[1]
                else:
                    org_li[i + 32] = j[0] 
                    org_li[i] = j[1]
    return org_li
# }}}
# }}}


def main(n, arg):
    data_li_li, rand_li = init_data(n, arg)
    scan_li_li = make_scan(data_li_li, rand_li)
    first_li = first_step(scan_li_li)
    print(first_li)
    key = second_step(scan_li_li, first_li)
    print(key)


if __name__=="__main__":
    argvs = sys.argv
    n = 128
    count = 5
    main(n, argvs[1])
    # f = open('time_s.txt', 'w')
    # for i in range(1, 11, 1):
    #     a_time = 0
    #     m = n * i
    #     print(m)
    #     for i in range(count):
    #         start = time.time()
    #         main(m, argvs[1])
    #         elapsed_time = time.time() - start
    #         print("elapsed_time:{0}".format(elapsed_time) + "[sec]")
    #         a_time += elapsed_time
    #     a_time = a_time/count
    #     print("a_time:{0}".format(a_time) + "[sec]")
    #     f.write("{0}".format(a_time) + "[sec]\n")
    # f.flush()
    # f.close()



