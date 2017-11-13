# import {{{
import sys
import random
import time
import multiprocessing as mp
LENGTH = 128
BLOCK = 32
# }}}


# {{{
# init {{{
def init_data(num):
    arg = sys.argv
    message_li = read_data(arg[1])
    data_li = read_data(arg[2])
    rand_li = make_rand_li(num)
    # rand_li = [i for i in range(LENGTH)]
    data_li = make_scan_li(data_li, rand_li)
    m_li_li = make_message(message_li)
    return m_li_li, data_li


def make_message(message_li):
    rand_li = [i for i in range(LENGTH)]
    m_li_li = make_scan_li(message_li, rand_li)
    return trans_li(m_li_li)


def make_dataset(data_li):
    p0p2_li_li = make_data(data_li, 13)
    p1p3_li_li = make_data(data_li, 14)
    return p0p2_li_li, p1p3_li_li


# {{{
def read_data(arg):# {{{
    li = []
    readfile = arg
    with open(readfile, 'r') as f:
        for row in f:
            li.append(int(row.strip()))
    return li
# }}}


def make_rand_li(num):# {{{
    rand_li = [i for i in range(num)]
    random.shuffle(rand_li)
    return rand_li
# }}}


def make_data(data_li, num):
    txt_li = extract_data(data_li, num)
    return trans_li(txt_li)


def extract_data(data_li, num):
    return [data_li[i] for i in range(num, len(data_li), BLOCK)]


def make_scan_li(data_li, rand_li):# {{{
    scan_li_li = [make_scan(data, rand_li) for data in data_li]
    return scan_li_li
# }}}


def trans_li(reg_li):
    return list(map(list, zip(*reg_li)))


def make_scan(data, rand_li):
    org_li = split_str(int2bin(data))
    return convert_rand_chain(org_li, rand_li)


def int2bin(num):# {{{
    return format(num, 'b').zfill(LENGTH)


def split_str(string):
    return [int(string[i:i + 1]) for i in range(0, len(string), 1)]
# }}}


def convert_rand_chain(reg_li, rand_li):# {{{
    scan_li = []
    for i in rand_li:
        if i < len(reg_li):
            tmp = reg_li[i]
        else:
            tmp = random.randint(0, 1)
        scan_li.append(tmp)
    return scan_li
# }}}
# }}}
# }}}


# first_step {{{
def first_step(text_li_li, p0p2_li_li, p1p3_li_li):
    p0p2 = find_tran(text_li_li, p0p2_li_li)
    p1p2xor_li_li = xor_lili(text_li_li[32:64], text_li_li[64:96])
    p0p3xor_li_li = xor_lili(text_li_li[0:32], text_li_li[96:128])
    xordata_li_li = xor_lili(p0p2_li_li, p1p3_li_li)
    p1 = find_tran(p1p2xor_li_li, xordata_li_li)
    p3 = find_tran(p0p3xor_li_li, xordata_li_li)
    p1p3 = p1 + p3
    return p0p2, p1p3


# find_tran {{{
def find_tran(org_li, scr_li):
    ans_li = [[] for i in range(LENGTH)]
    for org_c, org in enumerate(org_li):
        for scr_c, scr in enumerate(scr_li):
            if org == scr:
                ans_li[org_c].append(scr_c)
    return ans_li
# }}}


def xor_li(org_li, scr_li):
    return [ org ^ scr for (org, scr) in zip(org_li, scr_li) ]


def xor_lili(org_lili, scr_lili):
    return [ xor_li(org_li, scr_li) for (org_li, scr_li) in zip(org_lili, scr_lili) ]


# }}}


def find_key(data_li, p0p2, p1p3):# {{{
    key_num = [0 for i in range(128)]
    key_num = find_p0p2(key_num, p0p2)
    key_num = find_p1p3(key_num, p1p3)
    key_li = [data_li[k[0]] for k in key_num]
    key_li.reverse()
    key = 0
    for i in range(len(key_li)):
        key += (1 << i) * key_li[i]
    key_hex = hex(key)
    return key_hex


# {{{
def find_p0p2(key, p0p2):
    for i in range(int(LENGTH/4)):
        key[i] = p0p2[i]
        key[i + 64] = p0p2[i + 64]
    return key


def find_p1p3(key, p1p3):
    for i in range(int(LENGTH/4)):
        key[i + 32] = p1p3[i]
        key[i + 96] = p1p3[i + 128]
    return key
# }}}
# }}}


# }}}


def attck(scan_length):# {{{
    m_li_li, data_li = init_data(scan_length)
    start = time.time()
    p0p2_li_li, p1p3_li_li = make_dataset(data_li)
    p0p2, p1p3 = first_step(m_li_li, p0p2_li_li, p1p3_li_li)
    key = find_key(data_li[0], p0p2, p1p3)
    if key != '0xffeeddccbbaa99887766554433221100':
        sys.exit(1)
    elapsed_time = time.time() - start
    return elapsed_time
# }}}


def make_ave(time_li_li):
    li = [[time_li_li[i][j] for i in range(len(time_li_li))] for j in range(len(time_li_li[0]))]
    print(li)
    return [sum(l) /len(l) for l in li]


def attcks():
    ti_li = [ attck(128 * (i + 1)) for i in range(20) ]
    print(ti_li)
    return ti_li


def main():
    # print(attck(1000))
    num = 50
    time_li_li = [attcks() for i in range(num)]
    # pool = mp.Pool(num)
    # time_li_li = pool.map(attcks, range(num))
    # pool.close()
    print(make_ave(time_li_li))


if __name__=="__main__":
    sys.exit(main())


