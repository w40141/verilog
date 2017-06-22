#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from collections import defaultdict
import collections
import sys
import random


# {{{
# data {{{
data_li = [0xffeeddccbbaa99887766554433221100, 
           0xf3921db07766554484ecb876ffeeddcc, 
           0x5e2a4bb384ecb876d634cd6df3921db0, 
           0x0e6ca8bfd634cd6d40f5b2765e2a4bb3, 
           0x0836437b40f5b2765129d33b0e6ca8bf, 
           0x07a7d8445129d33b2ee879d20836437b, 
           0x1f7e10852ee879d2a144729807a7d844, 
           0x480d7065a1447298ba0460751f7e1085, 
           0xf2679d3dba0460753806497a480d7065, 
           0x7652e3763806497aa557c677f2679d3d, 
           0xd50b1670a557c67714005a7f7652e376, 
           0x8f89a61b14005a7f93e65627d50b1670, 
           0x9db9d0f393e65627da0d027e8f89a61b, 
           0x00010203fbebdbcb08090a0bb7a79787, 
           0xaf91ea5808090a0b1c56b7f700010203, 
           0xfd15e1b81c56b7f782dee144af91ea58, 
           0xc4896f2982dee1444ecf4244fd15e1b8, 
           0x376c6fd24ecf42444b49b022c4896f29, 
           0x673fc8b94b49b0227a88be0e376c6fd2, 
           0x12d017bc7a88be0e3345dcfb673fc8b9, 
           0x1459a5073345dcfbb8ec058b12d017bc, 
           0xbfd8dde7b8ec058b81b859501459a507, 
           0x5e3a559581b8595079019cb3bfd8dde7, 
           0xbba357c779019cb3066ca42f5e3a5595, 
           0x5196dce1066ca42f145d5524bba357c7, 
           0xf9d97f1d145d55242bde6fe75196dce1, 
           0x1e29190c2bde6fe74da8e442f9d97f1d, 
           0x817ca7e44da8e4423de824901e29190c, 
           0x367c28af3de82490f4ebe9f7817ca7e4, 
           0x64664dd0f4ebe9f74065c77b367c28af, 
           0xde2bf2fd4065c77bf129855564664dd0]


key_li = [0xffeeddccbbaa99887766554433221100, 
          0xf3921db07766554484ecb876ffeeddcc, 
          0x5e2a4bb384ecb876d634cd6df3921db0, 
          0x0e6ca8bfd634cd6d40f5b2765e2a4bb3, 
          0x0836437b40f5b2765129d33b0e6ca8bf, 
          0x07a7d8445129d33b2ee879d20836437b, 
          0x1f7e10852ee879d2a144729807a7d844, 
          0x480d7065a1447298ba0460751f7e1085, 
          0xf2679d3dba0460753806497a480d7065, 
          0x7652e3763806497aa557c677f2679d3d, 
          0xd50b1670a557c67714005a7f7652e376, 
          0x8f89a61b14005a7f93e65627d50b1670]


enc_li = [0x00010203fbebdbcb08090a0bb7a79787, 
          0xaf91ea5808090a0b1c56b7f700010203, 
          0xfd15e1b81c56b7f782dee144af91ea58, 
          0xc4896f2982dee1444ecf4244fd15e1b8, 
          0x376c6fd24ecf42444b49b022c4896f29, 
          0x673fc8b94b49b0227a88be0e376c6fd2, 
          0x12d017bc7a88be0e3345dcfb673fc8b9, 
          0x1459a5073345dcfbb8ec058b12d017bc, 
          0xbfd8dde7b8ec058b81b859501459a507, 
          0x5e3a559581b8595079019cb3bfd8dde7, 
          0xbba357c779019cb3066ca42f5e3a5595, 
          0x5196dce1066ca42f145d5524bba357c7, 
          0xf9d97f1d145d55242bde6fe75196dce1, 
          0x1e29190c2bde6fe74da8e442f9d97f1d, 
          0x817ca7e44da8e4423de824901e29190c, 
          0x367c28af3de82490f4ebe9f7817ca7e4, 
          0x64664dd0f4ebe9f74065c77b367c28af, 
          0xde2bf2fd4065c77bf129855564664dd0]
# }}}


# misc {{{
def int2bin(num):
    return format(num, 'b').zfill(128)


def split_str(string):
    return [int(string[i:i + 1]) for i in range(0, len(string), 1)]


def trans_li(reg_li):
    return list(map(list, zip(*reg_li)))


def make_rand_li(num):
    rand_li = [i for i in range(num)]
    random.shuffle(rand_li)
    return rand_li
# }}}


# add noise bit to scan chain{{{
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


def init_data():
    li = make_data()
    data_li_li = make_li(li)
    tran_dic = defaultdict(int)
    # rand_li = make_rand_li(512)
    rand_li = [i for i in range(128)]
    return data_li_li, tran_dic, rand_li


def make_data():
    li = []
    readfile = './data.txt'
    with open(readfile, 'r') as f:
        for row in f:
            li.append(int(row.strip()))
    return li


def make_li(d_li):
    n = 31
    l = int(len(d_li)/31)
    li = [ [] for i in range(l) ]
    for i in range(l):
        li[i] = d_li[n * i:n * (i + 1)]
    return li


def transpose(data_li, rand_li):
    scan_li = []
    for data in data_li:
        org_li = split_str(int2bin(data))
        scan_li.append(convert_rand_chain(org_li, rand_li))
    return trans_li(scan_li)


def find_tran(t_scan_li, tran_dic):
    for i in range(0, len(t_scan_li[0]), 5):
        series_li = compare_li(t_scan_li, i, 10)
        if len(series_li) >= 64:
            tmp_li = list(map(str, series_li))
            for t in tmp_li:
                tran_dic[t] += 1
    return tran_dic


def first_step(data_li_li, rand_li, tran_dic):
    li = []
    for data_li in data_li_li:
        t_scan_li = transpose(data_li, rand_li)
        tran_dic = find_tran(t_scan_li, tran_dic)
    for k, v in sorted(tran_dic.items()):
        if v >= 100:
            # li.append(k)
            li.append(list(map(int,k[0][1:-1].split(','))))
    return li


def second_step():
    return 0


def main():
    data_li_li, tran_dic, rand_li = init_data()
    li = first_step(data_li_li, rand_li, tran_dic)
    print(li)
    print(len(li))
    a = second_step()


if __name__=="__main__":
    sys.exit(main())

