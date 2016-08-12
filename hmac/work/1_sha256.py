#!/usr/bin/env python3 # {{{
# -*- coding: utf-8 -*-
import sys
import binascii
import hashlib
import random


WORD = 8
LENGTH = 16
M_LENGTH = 128
CHAIN = 256
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
        self.register = []
        # self.left = 0
        # self.right = 0


    def get_IV(self, flag):
        if flag :
            message = imput('input H value > ')
            h = word_split(message_input(message))
            self.value_IV = h[0]
        else:
            self.value_IV = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xa54FF53A,
                             0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19]


    def rotation(self, block, count):
        self._W_schedule(block)
        self._input_digest()
        for i in range(count+1):
            self._restore_reg()
            # self._print_reg()
            self._sha256_round(i)
        self._update_digest()


    def _sha256_round(self, round):
        self.k = self.K[round]
        self.w = self._next_w(round)
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
        # self.left = self.e + self.t2 & 0xffffffff
        # self.right = self.a + tmp_d  & 0xffffffff


    def get_digest(self):
        return self.value_IV


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
            self.W[round] = (self._delta1(self.W[round - 2]) + self.W[round - 7] + self._delta0(self.W[round -15]) + self.W[round - 16]) & 0xffffffff
            return self.W[round]


    def _W_schedule(self, block):
        for i in range(16):
            self.W[i] = block[i]


    def _W_schedule_int(self, block):
        for i in range(16):
            self.W[i] = split_str2int(block[i])


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


def sha256_tests(message, flag, count):
    my_sha256 = SHA256();
    # hash_origin = make_hash(message)
    block = word_split(message_input(message))
    my_sha256.get_IV(flag)
    for i in block:
        my_sha256.rotation(i, count)
        my_sha256._W_schedule(i)
    return my_sha256.register, my_sha256.W
    # return my_sha256.register


# {{{


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


def int2bin(num):
    num_bin = format(num, 'b')
    num_zero = num_bin.zfill(32)
    return num_zero


def hmac_mode():
    flag = int(input('select hmac mode\n0 -> SHA256, else -> hmac :'))
    return flag


def make_hash(m):
    h = hashlib.sha256(m.encode()).hexdigest()
    list_h = split_str2int(h, 8)
    return list_h


def split_str(s, n):
    v = [s[i:i+n] for i in range(0, len(s), n)]
    return v


# to split n word
def split_str2int(s, n):
    v = [int(s[i:i+n], 16) for i in range(0, len(s), n)]
    return v


def make_message(num, ):
    # li = ['1', 'Q', 'a', 'y', 'u', 's', 'p']
    li = ['1']
    org = 'qqqq'
    src = ''
    dst = ''
    tmp = ''
    message = []
    for i in range(num):
        src += org
        for j in range(1):
        # for j in range(4):
            for k in li:
                dst = org[:j] + k + org[j+1:]
                message.append(src)
                message.append(tmp + dst)
        dst += org
        tmp += org
    return message


def message_input(m):
    m_init = str(binascii.hexlify(m.encode()))[2:]
    m_len = (len(m_init) - 1) * 4
    n_hex = hex(m_len).replace('x', '').zfill(LENGTH)
    m_tmp = m_init.replace("'", '80')
    count = (len(m_tmp) // M_LENGTH+ 1)
    m_len = M_LENGTH * count - LENGTH
    m_padded = m_tmp.ljust(m_len, '0')
    m_fin = m_padded + n_hex
    m_list = split_str(m_fin, M_LENGTH)
    return m_list


def word_split(m):
    vi = []
    for i in m:
        v = split_str2int(i, 8)
        vi.append(v)
    return vi


def convert(reg_list):
    orig = []
    for reg_li in reg_list:
        scanchain = [[0 for i in reg_li] for j in reg_li[0]]
        for i, cyc_reg in enumerate(reg_li):
            for j, one_reg in enumerate(cyc_reg):
                scanchain[j][i] = int(one_reg)
        orig.append(scanchain)
    return orig

# }}}


# first_step {{{
# def compare_reg(reg_list):
#     series = []
#     for i, src_reg in enumerate(reg_list):
#         count = 0
#         for j, dst_reg in enumerate(reg_list):
#             if count < 2:
#                 if src_reg[:-1] == dst_reg[1:]:
#                     series.append([i, j])
#                     count += 1
#             else:
#                 break
#     return series


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


def reg_compare(reg_li):
    if len(reg_li) == 0:
        flag = 1
    else:
        org = reg_li[0]
        flag = 0
        for reg in reg_li:
            if org != reg:
                flag = 1
    return flag


# def first_step(reg):
#     set_ser = []
#     for i in reg:
#         series = compare_reg(i)
#         if len(series) ==192:
#             ser = find_series(series)
#             set_ser.append(ser)
#         flag = reg_compare(set_ser)
#     if flag:
#         return 0
#     else:
#         return set_ser[0]


def and_ser_li(set_ser):
    matched_list = []
    for i in set_ser:
        if len(matched_list) == 0:
            matched_list = i
            # print('init')
        else:
            matched_list = [tag for tag in matched_list if tag in i]
            # print('and_ser_li')
        # print(matched_list)
    return matched_list


def first_step(reg):
    # print(reg)
    set_ser = []
    for i in reg:
        set_ser.append(compare_reg(i))
        # print('i')
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
def extract_first_bit(register, flow_data):
    first_bit_stream = []
    stream_first = [x[0] for x in flow_data]
    stream_first.sort()
    for reg in register:
        tmp = [[cyc[i] for i in stream_first] for cyc in reg]
        first_bit_stream.append(tmp)
    return first_bit_stream, stream_first


def com_list(orig_li, dst_li, stream_first):
    diff_bit = []
    for i, num in enumerate(stream_first):
        if orig_li[i] != dst_li[i]:
            diff_bit.append(num)
    return diff_bit


def com_double_list(orig_reg, dst_reg, stream_first):
    diff_bit_class = []
    for i in range(len(orig_reg)):
        com = com_list(orig_reg[i], dst_reg[i], stream_first)
        if len(com) != 0:
            break
    return com


def hamming(num_li0, num_li1):
    for i in range(len(num_li0)):
        xor = format(num_li0[i] ^ num_li1[i], 'b')
        if xor != '0':
            xor = xor.zfill(32)
            for j, letter in enumerate(xor):
                if letter == '1':
                    num = j
            break
    return num


def find_reverse_bit(first_bit_stream, stream_first, bin_w):
    diff_bit_class = [[j] for j in range(32)]
    for i in range(0, len(first_bit_stream), 2):
        origan = first_bit_stream[i]
        destin = first_bit_stream[i+1]
        num_hamming = hamming(bin_w[i], bin_w[i+1])
        tmp = com_double_list(origan, destin, stream_first)
        diff_bit_class[num_hamming].append(tmp)
    return diff_bit_class


def second_step(register, flow_data, bin_w):
    first_bit_stream, stream_first = extract_first_bit(register, flow_data)
    diff_bit = find_reverse_bit(first_bit_stream, stream_first, bin_w)
    g_bit = group(diff_bit)
    g_bit_li = set2list(g_bit)
    return g_bit_li


def find_bit(diff_li, already_bit):
    candidate_bit = set()
    a_bit = already_bit
    for d_li in diff_li:
        d_set = set(d_li)
        if len(candidate_bit) == 0:
            candidate_bit = d_set
        else:
            candidate_bit = candidate_bit & d_set
        a_bit = a_bit | d_set
    return candidate_bit, a_bit


def find_else_bit(already_bit, group_bit):
    else_bit = already_bit
    for g_bit in group_bit:
        if type(g_bit) == set:
            else_bit -= g_bit
    return else_bit


def group(diff_li):
    already_bit = set()
    group_bit = ['0' for i in diff_li]
    for diff in diff_li:
        number = diff[0]
        d_li = diff[1:]
        if number % 8 != 0:
            cnd_bit, already_bit = find_bit(d_li, already_bit)
            group_bit[number] = cnd_bit
            if (number + 1) % 8 == 0:
                group_bit[number - 7] = find_else_bit(already_bit, group_bit)
    return group_bit


def set2list(group_bit):
    group = []
    for i in group_bit:
        tmp = list(i)
        group.append(tmp)
    # group.reverse()
    return group


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


def analysis(register, bin_w, chain):
    scanchain = convert(register)
    # print('convert register data finished')
    flow_data = first_step(scanchain)
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
    return flow_data


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


def main():
    # tmp = [1, 2, 4, 8, 16]
    tmp = [1]
    ans = []
    flag = 0
    # スキャンチェイン長
    for c in tmp:
        # メッセージ個数
        for m in range(1, 3):
            print('message, ' + str(m))
            data_len = c * CHAIN
            print(data_len)
            # lines = make_message(1)
            lines = random_message(m)
            w = [0] * len(lines)
            chain = shuffle_li(data_len)
            # message = 'abc'
            # reg = sha256_tests(message, flag)
            # register.append(reg)
            print('Analysis start')
            # for count in range(13,  25):
            # サイクル数
            for count in range(15, 17):
                #
                register = []
                # print('count' + str(count))
                for i, message in enumerate(lines):
                    reg, w[i] = sha256_tests(message, flag, count)
                    new_reg = convert_chain(reg, chain)
                    register.append(new_reg)
                print(lines)
                f = analysis(register, w, chain)
                if f !=0:
                    print(m, data_len, count)
                    ans.append([m, data_len, count])
                    break
    print(ans)


if __name__=="__main__":
    sys.exit(main())


