# import {{{
import sys
import random
import time
LENGTH = 128
BLOCK = 32
# }}}


# {{{
# init {{{
def init_data(num):
    arg = sys.argv
    message_li = read_data(arg[1])
    # print('message_li')
    # print(message_li)
    data_li = read_data(arg[2])
    # print(data_li)
    # print('data_li')
    rand_li = make_rand_li(num)
    print(rand_li)
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
    # print('make_scan')
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
    p1p3 = find_tran(text_li_li, p1p3_li_li)
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
# }}}


# {{{
def find_key(data_li, p0p2, p1p3):
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
        key[i + 32] = p1p3[i + 64]
        key[i + 96] = p1p3[i]
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
    print(key)
    if key != '0xffeeddccbbaa99887766554433221100':
        sys.exit(1)
    elapsed_time = time.time() - start
    return elapsed_time
# }}}

# {{{
def attcks():
    ti_li = [attck(128 * (i + 1)) for i in range(20)]
    print(ti_li)
    return ti_li
# }}}

def main():
    print(attck(128))


if __name__ == "__main__":
    sys.exit(main())


