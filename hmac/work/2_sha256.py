#!/usr/bin/env python3 # {{{
# -*- coding: utf-8 -*-
import sys
import binascii
import hashlib
import random
import math
import time


WORD = 8
LENGTH = 16
CHAIN = 256
BS4 = 128
BLOCKSIZE = 512
# }}}


class SHA256(): # {{{


    def __init__(self):
        self.value_IV = [0] * 8
        self.t1 = 0
        self.t2 = 0
        self.a = 0
        self.b = 0
        self.c = 0
        self.d = 0
        self.e = 0
        self.f = 0
        self.g = 0
        self.h = 0
        self.w = 0
        self.W = [0] * 64
        self.k = 0
        self.K = [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
                  0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
                  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
                  0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
                  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
                  0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
                  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
                  0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
                  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
                  0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
                  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
                  0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
                  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
                  0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
                  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
                  0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]
        self.value_IV = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xa54FF53A,
                         0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19]
        self.register = []
        self.set_reg = []


    def get_digest(self):
        reg = ''
        for i in self.value_IV:
            reg = reg + hex(i)[2:].zfill(8)
        return reg


    def rotation(self, block):
        self._W_schedule(block)
        self._input_digest()
        self.register = []
        for i in range(64):
            self._restore_reg()
            self._sha256_round(i)
        self.set_reg.append(self.register)
        self._update_digest()
        return self.value_IV


    def _sha256_round(self, count):
        self.k = self.K[count]
        self.w = self._next_w(count)
        self.t1 = self._T1(self.e, self.f, self.g, self.h, self.k, self.w)
        self.t2 = self._T2(self.a, self.b, self.c)
        tmp_d = self.d
        self.h = self.g
        self.g = self.f
        self.f = self.e
        self.e = (self.d + self.t1) &  0xffffffff
        self.d = self.c
        self.c = self.b
        self.b = self.a
        self.a = (self.t1 + self.t2) & 0xffffffff


    # sha_cal# {{{
    def _Ch(self, x, y, z):
        return (x & y) ^ (~x & z)


    def _Maj(self, x, y, z):
        return (x & y) ^ (x & z) ^ (y & z)

    def _sigma0(self, x):
        return (self._rotr32(x, 2) ^ self._rotr32(x, 13) ^ self._rotr32(x, 22))


    def _sigma1(self, x):
        return (self._rotr32(x, 6) ^ self._rotr32(x, 11) ^ self._rotr32(x, 25))


    def _delta0(self, x):
        return (self._rotr32(x, 7) ^ self._rotr32(x, 18) ^ self._shr32(x, 3))


    def _delta1(self, x):
        return (self._rotr32(x, 17) ^ self._rotr32(x, 19) ^ self._shr32(x, 10))


    def _T1(self, e, f, g, h, k, w):
        return (h + self._sigma1(e) + self._Ch(e, f, g) + k + w) & 0xffffffff


    def _T2(self, a, b, c):
        return (self._sigma0(a) + self._Maj(a, b, c)) & 0xffffffff


    def _rotr32(self, n, r):
        return ((n >> r) | (n << (32 - r))) & 0xffffffff


    def _shr32(self, n, r):
        return (n >> r)


    def _input_digest(self):
        self.a = self.value_IV[0]
        self.b = self.value_IV[1]
        self.c = self.value_IV[2]
        self.d = self.value_IV[3]
        self.e = self.value_IV[4]
        self.f = self.value_IV[5]
        self.g = self.value_IV[6]
        self.h = self.value_IV[7]


    def _update_digest(self):
        self.value_IV[0] = (self.value_IV[0] + self.a) & 0xffffffff
        self.value_IV[1] = (self.value_IV[1] + self.b) & 0xffffffff
        self.value_IV[2] = (self.value_IV[2] + self.c) & 0xffffffff
        self.value_IV[3] = (self.value_IV[3] + self.d) & 0xffffffff
        self.value_IV[4] = (self.value_IV[4] + self.e) & 0xffffffff
        self.value_IV[5] = (self.value_IV[5] + self.f) & 0xffffffff
        self.value_IV[6] = (self.value_IV[6] + self.g) & 0xffffffff
        self.value_IV[7] = (self.value_IV[7] + self.h) & 0xffffffff


    def _next_w(self, round):
        if (round < 16):
            return self.W[round]
        else:
            self.W[round] = (self._delta1(self.W[round - 2]) + \
                             self.W[round - 7] + \
                             self._delta0(self.W[round -15]) + \
                             self.W[round - 16]) & 0xffffffff
            return self.W[round]


    def _W_schedule(self, block):
        for i in range(16):
            self.W[i] = block[i]


    def _print_reg(self):
        print("0x%08x, 0x%08x, 0x%08x, 0x%08x 0x%08x, 0x%08x, 0x%08x, 0x%08x" %\
                (self.a, self.b, self.c, self.d, self.e, self.f, self.g, self.h))
        print("")


    def _restore_reg(self):
        bin_a = int2bin(self.a)
        bin_b = int2bin(self.b)
        bin_c = int2bin(self.c)
        bin_d = int2bin(self.d)
        bin_e = int2bin(self.e)
        bin_f = int2bin(self.f)
        bin_g = int2bin(self.g)
        bin_h = int2bin(self.h)
        reg = bin_a + bin_b + bin_c + bin_d + bin_e + bin_f + bin_g + bin_h
        list_reg = split_str2int(reg, 1)
        self.register.append(list_reg)
    # }}}
# }}}


# SHA256 function{{{
def int2bin(num):
    num_bin = format(num, 'b')
    num_zero = num_bin.zfill(32)
    return num_zero


def word_split(m):
    vi = []
    for i in m:
        v = split_str2int(i, 8)
        vi.append(v)
    return vi


def split_str(s, n):
    v = [s[i:i+n] for i in range(0, len(s), n)]
    return v


# to split n word
def split_str2int(s, n):
    v = [int(s[i:i+n], 16) for i in range(0, len(s), n)]
    return v


def change_message_hex(message):
    m_init = str(binascii.hexlify(message.encode()))[2:-1]
    m_len = len(message) * 8
    return m_init, m_len


def change_message(m_init, m_len):
    m_len_hex = hex(m_len).replace('x', '').zfill(LENGTH)
    m_tmp = m_init + '80'
    if len(m_tmp + m_len_hex) > 128:
        m_pad_len = BS4 * 2 - LENGTH
    else:
        m_pad_len = BS4 - LENGTH
    m_pad = m_tmp.ljust(m_pad_len, '0') + m_len_hex
    return m_pad


def message_input(message):
    m_init, m_len = change_message_hex(message)
    m_pad = change_message(m_init, m_len)
    return m_pad


def make_kin_out(key, flag):
    pad = ['36', '5c']
    k_init, k_len = change_message_hex(key)
    if k_len <= BLOCKSIZE:
        k = k_init.ljust(BS4, '0')
    else:
        k_tmp = sha256_tests(key)
        k = k_tmp.ljust(BS4, '0')
    k_int = int(k, 16)
    pad_chr = pad[flag] * 64
    pad_int = int(pad_chr, 16)
    k_pad = k_int ^ pad_int
    k_hex = hex(k_pad)[2:]
    return k_hex


# flag: 0=>input, 1=>output
def key_message_input(key, flag, message):
    if flag:
        m_init = message
        m_len = 256
    else:
        m_init, m_len = change_message_hex(message)
    m_len = m_len + BLOCKSIZE
    k_pad = make_kin_out(key, flag)
    m_pad = change_message(m_init, m_len)
    k_m_pad= k_pad + m_pad
    return k_m_pad


def sha256_func(message):
    my_sha256 = SHA256();
    # m_pad = message_input(message)
    # print(m_pad)
    block = word_split(split_str(message, BS4))
    for b in block:
        IV = my_sha256.rotation(b)
    IV = my_sha256.get_digest()
    # return IV, my_sha256.register
    return IV, my_sha256.set_reg


def hmac_sha256_tests(message, key):
    kin_m = key_message_input(key, 0, message)
    h_n, reg_kin = sha256_func(kin_m)
    kout_m = key_message_input(key, 1, h_n)
    hmac, reg_kout = sha256_func(kout_m)
    reg = reg_kin + reg_kout
    return reg


def sha256_tests(message):
    m_pad = message_input(message)
    IV = sha256_func(m_pad)
    return IV
# }}}


# attack {{{
# {{{


def chack_chain(flow_data, chain):
    tmp = []
    for flow in flow_data:
        t = []
        for f in flow:
            t.append(chain[f])
        tmp.append(t)
    return tmp


def chain_end_remove(scanchain):
    for scan in scanchain:
        for s in scan:
            s.pop(-1)
    return scanchain


def random_message(m):
    li = []
    for i in range(m):
        word = ''
        for tmp in range(4):
            j = random.randint(0, 2)
            if j == 0:
                word += chr(random.randint(48, 57))
            elif j == 1:
                word += chr(random.randint(97, 122))
            else:
                word += chr(random.randint(65, 90))
        li.append(word)
    return li


def shuffle_li(num):
    li = [i for i in range(num)]
    random.shuffle(li)
    rand = li
    return rand


def convert_chain(reg_li, rand_li):
    scan_li_li = []
    for r in reg_li:
        scan_li = []
        for i in rand_li:
            if 0 <= i and i < len(r):
                scan_li.append(r[i])
            else:
                scan_li.append(random.randint(0, 1))
        scan_li_li.append(scan_li)
    return scan_li_li


def make_message(count):
    word_li = ['1', 'Q', 'a', 'y', 'u', 's', 'p']
    message = ['q' * 32]
    pad_q = ''
    for i in range(4):
        for word in word_li:
            pad_word = word.rjust(i+1, 'q')
            pad_word = pad_word.ljust(4, 'q')
            if word == '1':
                for j in range(count):
                    pad_q = 'qqqq' * j
                    message.append(pad_q + pad_word)
            else:
                message.append(pad_word)
    return message


def convert(reg_list):
    orig = []
    for reg_li in reg_list:
        scanchain = [[0 for i in reg_li] for j in reg_li[0]]
        for i, reg in enumerate(reg_li):
            for j, one_reg in enumerate(reg):
                scanchain[j][i] = int(one_reg)
        orig.append(scanchain)
    return orig


# }}}


# Analysis {{{
# first_step {{{
def compare_reg(reg_list):
    series = []
    for i, src_reg in enumerate(reg_list):
        for j, dst_reg in enumerate(reg_list):
            if src_reg[:-1] == dst_reg[1:]:
                series.append([i, j])
    return series


def find_series(series):
    fin_ser = []
    for ser in series:
        count = 0
        while count < len(series):
            if ser[-1] == series[count][0]:
                ser = ser + series[count]
                ser.remove(series[count][0])
                series.remove(series[count])
                count = 0
            elif ser[0] == series[count][-1]:
                ser = series[count] + ser
                ser.remove(series[count][-1])
                series.remove(series[count])
                count = 0
            else:
                count += 1
        fin_ser.append(ser)
    return fin_ser


def and_ser_li(set_ser):
    matched_list = []
    for i in set_ser:
        if len(matched_list) == 0:
            matched_list = i
        else:
            matched_list = [tag for tag in matched_list if tag in i]
    return matched_list


def first_step(reg):
    set_ser = []
    for i in reg:
        # print(i)
        set_ser.append(compare_reg(i))
    if len(set_ser) > 1:
        set_li = and_ser_li(set_ser)
    else:
        set_li = set_ser[0]
    if len(set_li) ==192:
        ser = find_series(set_li)
        return ser
    else:
        return 0
# }}}


# second_step {{{
def find_first_bit(register, flow_data):# {{{
    first_bit_li = []
    ae_bit_num = [x[0] for x in flow_data]
    for reg in register:
        first_bit = [reg[i] for i in ae_bit_num]
        first_bit_li.append(first_bit)
    return ae_bit_num, first_bit_li
# }}}


def make_diff_bit_stream(message_li):# {{{
    org = message_li[0]
    diff_bit_stream = []
    for scr in message_li:
        if org != scr:
            diff_bit = find_diff_bit(org, scr)
            diff_bit_stream.append(diff_bit)
    return diff_bit_stream


# make_diff_bit_stream
def find_diff_bit(org, scr):
    diff_bit = 0
    for i in range(len(scr)):
        if org[i] != scr[i]:
            diff_letter = i % 4
            diff_bit = math.log2(ord(org[i]) ^ ord(scr[i]))
            diff_bit = int(7 - diff_bit + diff_letter * 8)
            break
    return diff_bit
# }}}


def make_diff_bit_li(first_bit_li, diff_bit_stream):# {{{
    org = first_bit_li[0]
    scr_li = first_bit_li[1:]
    diff_bit_li = [[] for x in range(32)]
    # diff_bit_li = [-1 for x in range(32)]
    for i, scr in enumerate(scr_li):
        diff_bit = diff_bit_stream[i]
        tmp_li = compare_li(org, scr)
        diff_bit_li[diff_bit].append(tmp_li)
    return diff_bit_li


#make_diff_bit_li
def compare_li(org, scr):
    flag = 1
    count = 1
    diff_bit_li = []
    while flag:
        for i in range(len(org)):
            if org[i][count] != scr[i][count]:
                diff_bit_li.append(i)
                flag = 0
        count += 1
    return diff_bit_li
# }}}


def make_pair_li(diff_bit_li):# {{{
    # finished_li = [i for i in range(64)]
    finish_set = set([])
    pair_li = [0] * 32
    for i in range(4):
        other_set = set([])
        for j in range(1, 8):
            num = i * 8 + j
            target_li = diff_bit_li[num]
            determ_set, finish_set = make_determ_finish_set(target_li, finish_set)
            # print(determ_set)
            pair_li[num] = determ_set
            if pair_li[num-1] == 0:
                pair_li[num-1] = get_pair(pair_li, finish_set)
    return pair_li


#make_pair_diff
def make_determ_finish_set(target_li, finish_set):
    determ_set = set([])
    for tar in target_li:
        tar_set = set(tar)
        if len(determ_set) == 0:
            determ_set = tar_set ^ finish_set
            determ_set = tar_set & determ_set
        else:
            determ_set = tar_set & determ_set
        finish_set = tar_set | finish_set
    return determ_set, finish_set


def get_pair(pair_li, finish_set):
    other_set = set([])
    for target in pair_li:
        if target != 0:
            if len(other_set) == 0:
                other_set = target ^ finish_set
            else:
                other_set = target ^ other_set
    return other_set
# }}}


def check_len(target_li):# {{{
    for target in target_li:
        if len(target) != 2:
            return 0
    return 1
# }}}


def convert_li(pair_diff_li, ae_first_num):# {{{
    determin_li = [0] * 32
    for i, pair_set in enumerate(pair_diff_li):
        det = []
        pair_li = list(pair_set)
        for pair in pair_li:
            det.append(ae_first_num(pair))
        determin_li[i] = det
    return determin_li
# }}}


def second_step(signature_li, flow_data, message_li):
    ae_first_num,  first_bit_li = find_first_bit(signature_li, flow_data)
    diff_bit_stream = make_diff_bit_stream(message_li)
    diff_bit_li = make_diff_bit_li(first_bit_li, diff_bit_stream)
    pair_li = make_pair_li(diff_bit_li)
    print(pair_li)
    if check_len(pair_li):
        determin_li = convert_li(pair_li, ae_first_num)
        return determin_li
    else:
        return 0


# }}}


# third_step{{{
def find_flow(bit_num, flow_data):
    for f in flow_data:
        if bit_num == f[0]:
            break
    return f


def get_scan(i, scan):
    return scan[i]


def maj(a_li, b_li, c_li):
    maj = []
    for a, b, c in zip(a_li, b_li, c_li):
        maj.append((a & b) ^ (a & c) ^ (b & c))
    return maj


def sigma(s2_li, s13_li, s22_li):
    sigma_li = []
    for s2, s13, s22 in zip(s2_li, s13_li, s22_li):
        sigma_li.append(s2 ^ s13 ^ s22)
    return sigma_li


def t1(sigma_li, maj_li):
    t1_li = []
    for s, m in zip(sigma_li, maj_li):
        t1_li.append(s + m)
    return t1_li


def cal_digit(reg_li, bit_num, group_li, flow_data, scan, carry_dic):
    a_group = group_li[bit_num]
    for i in range(2):
        a_bit = a_group[i]
        a_bit_flow = find_flow(a_bit, flow_data)
        dic_abcd = make_abcd(scan, a_bit_flow)
        e_bit = a_group[1-i]
        e_li = get_scan(e_bit, scan)
        ad_li, ad_carry_li = cal_add(dic_abcd['a'], dic_abcd['d'], carry_dic['ad'])
        maj_li = maj(dic_abcd['a'], dic_abcd['b'], dic_abcd['c'])
        dic_si = make_si(bit_num, group_li)
        for s2_bit in dic_si['s2']:
            s2_li = get_scan(s2_bit, scan)
            for s13_bit in dic_si['s13']:
                s13_li = get_scan(s13_bit, scan)
                for s22_bit in dic_si['s22']:
                    s22_li = get_scan(s22_bit, scan)
                    sigma_li = sigma(s2_li, s13_li, s22_li)
                    t1_li = t1(sigma_li, maj_li)
                    et_li, et_carry_li = cal_add(e_li, t1_li, carry_dic['et'])
                    if ad_li == et_li:
                        carry_dic['ad'] = ad_carry_li
                        carry_dic['et'] = et_carry_li
                        reg_li[bit_num] = a_bit
                        reg_li[bit_num - 2] = s2_bit
                        reg_li[bit_num - 13] = s13_bit
                        reg_li[bit_num - 22] = s22_bit
    return reg_li, carry_dic


def make_abcd(scan, flow_data):
    a = get_scan(flow_data[0], scan)
    b = get_scan(flow_data[1], scan)
    c = get_scan(flow_data[2], scan)
    d = get_scan(flow_data[3], scan)
    dic_abcd = {'a': a, 'b': b, 'c': c, 'd': d}
    return dic_abcd


def get_s(num, i, group_li):
    return group_li[num - i]


def make_si(bit_num, group_li):
    s2_group = get_s(bit_num, 2, group_li)
    s13_group = get_s(bit_num, 13, group_li)
    s22_group = get_s(bit_num, 22, group_li)
    dic_si = {'s2': s2_group, 's13': s13_group, 's22': s22_group}
    return dic_si


def cal_add(one_li, two_li, carry):
    add_li = []
    carry_li = []
    for one, two, c in zip(one_li[1:], two_li[:-1], carry):
        cal = one + two + c
        add_li.append(cal & 1)
        carry_li.append((cal & 6) >> 1)
    return add_li, carry_li


def third_step(scan, group_li, flow_data):
    reg_li = [0] * 32
    ad_carry_li = [0] * 63
    et_carry_li = [0] * 63
    carry_dic = {'ad':ad_carry_li, 'et':et_carry_li}
    for i in range(len(group_li)-1, -1, -1):
        reg_li, carry_dic = cal_digit(reg_li, i, group_li, flow_data, scan, carry_dic)
    return reg_li
# }}}


def analysis(register, message, chain):
    scanchain = convert(register)
    # print('convert register data finished')
    flow_data = first_step(scanchain)
    print(flow_data)
    determin_li = second_step(scanchain, flow_data, message)
    print(determin_li)
    # for i in range(64, 0, -1):
    #     flow_data = first_step(scanchain)
    #     if flow_data == 0:
    #         print(i+1)
    #         break
    #     scanchain = chain_end_remove(scanchain)
    # print('first step finished')
    # print(chack_chain(flow_data, chain))
    # group_bit = second_step(register, flow_data, bin_w)
    # print('second step finished')
    # # print(group_bit)
    # reg_li = third_step(scanchain[0], group_bit, flow_data)
    # print(reg_li)
    # print('third step finished')
    # return determin_li
# }}}
# }}}


def main():
    # tmp = [1, 2, 4, 8, 16]
    tmp = [1]
    ans = []
    key = 'abc'
    m = 'abc'
    reg = hmac_sha256_tests(m, key)
    chain = [i for i in range(256)]
    new_reg = convert_chain(reg, chain)
    f = analysis(reg, m, chain)
    # スキャンチェイン長# {{{
    # for c in tmp:
    #     # メッセージ個数
    #     for i in range(1, 8):
    #         message = make_message(i)
    #         data_len = c * CHAIN
    #         w = [0] * len(message)
    #         chain = shuffle_li(data_len)
    #         print('Analysis start')
    #         # サイクル数
    #         count = 15
    #         register = []
    #         for j, m in enumerate(message):
    #             reg, w[j] = sha256_tests(m, flag, count)
    #             # new_reg = convert_chain(reg, chain)
    #             new_reg = reg
    #             register.append(new_reg)
    #         f = analysis(register, message, chain)
    #         print(f)
    # print(ans)
# }}}


if __name__=="__main__":
    sys.exit(main())


