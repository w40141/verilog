#!/usr/bin/env python3 # {{{
# -*- coding: utf-8 -*-
import sys
import binascii
import hashlib


WORD = 8
LENGTH = 16
M_LENGTH = 128
# }}}


class SHA256(): # {{{


    def __init__(self):
        self.value_H = [0] * 8
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


    def get_H(self, flag):
        if flag :
            message = imput('input H value > ')
            h = word_split(message_input(message))
            self.value_H = h[0]
        else:
            self.value_H = [0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xa54FF53A,
                            0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19]


    def rotation(self, block):
        self._W_schedule(block)
        self._input_digest()
        for i in range(64):
            self._restore_reg()
            self._sha256_round(i)
        self._update_digest()


    def get_digest(self):
        return self.value_H


    def _input_digest(self):
        self.a = self.value_H[0]
        self.b = self.value_H[1]
        self.c = self.value_H[2]
        self.d = self.value_H[3]
        self.e = self.value_H[4]
        self.f = self.value_H[5]
        self.g = self.value_H[6]
        self.h = self.value_H[7]


    def _update_digest(self):
        self.value_H[0] = (self.value_H[0] + self.a) & 0xffffffff
        self.value_H[1] = (self.value_H[1] + self.b) & 0xffffffff
        self.value_H[2] = (self.value_H[2] + self.c) & 0xffffffff
        self.value_H[3] = (self.value_H[3] + self.d) & 0xffffffff
        self.value_H[4] = (self.value_H[4] + self.e) & 0xffffffff
        self.value_H[5] = (self.value_H[5] + self.f) & 0xffffffff
        self.value_H[6] = (self.value_H[6] + self.g) & 0xffffffff
        self.value_H[7] = (self.value_H[7] + self.h) & 0xffffffff


    def _sha256_round(self, round):
        self.k = self.K[round]
        self.w = self._next_w(round)
        self.t1 = self._T1(self.e, self.f, self.g, self.h, self.k, self.w)
        self.t2 = self._T2(self.a, self.b, self.c)
        self.h = self.g
        self.g = self.f
        self.f = self.e
        self.e = (self.d + self.t1) &  0xffffffff
        self.d = self.c
        self.c = self.b
        self.b = self.a
        self.a = (self.t1 + self.t2) & 0xffffffff


    def _next_w(self, round):
        if (round < 16):
            return self.W[round]
        else:
            self.W[round] = (self._delta1(self.W[round - 2]) + self.W[round - 7] + self._delta0(self.W[round -15]) + self.W[round - 16]) & 0xffffffff
            # tmp_w = (self._delta1(self.W[14]) + self.W[9] + self._delta0(self.W[1]) + self.W[0]) & 0xffffffff
            # for i in range(15):
            #     self.W[i] = self.W[(i+1)]
            # self.W[15] = tmp_w
            # return tmp_w
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
        # rand = [252,   4, 126, 176,  46,  59, 130,  14,  53, 185,   1,  34, 118,  62, 154, 234,
        #         129, 156,  88,  93, 163,  22,  24, 222, 146, 110, 125, 253,  75,  85,  32,  54,
        #         202, 109, 105, 169,  56,  20, 228, 181,  10, 178,  77, 115,  50,  86, 104,  19,
        #          31,  99, 183, 108,  15,  87, 133,  76,  42, 255, 205, 136,  38, 237, 188, 128,
        #          26, 159, 193, 170, 142, 151, 248,  47,  37, 132,  11, 239,  58,  97, 198, 218,
        #         226,  79, 209, 141,  57, 114, 184, 137, 192, 186,  48, 171, 149, 208,  21, 138,
        #         179, 172,  33, 119,  67, 206,  65, 161, 160, 175, 107, 245, 112, 155, 168, 232,
        #         167,  80, 116,  68, 123, 211, 180, 147, 247, 225,  17, 135,  96, 224, 134,  74,
        #          91,  16,  44, 194,  45,  63,  23, 220,  90,  36, 203, 233,  39, 241, 152, 148,
        #          89,   6,  83, 221, 182,   9,  95, 231, 243, 254, 199, 195,  98, 196, 127, 177,
        #          43,  49,  13,   8, 143, 164,   2, 157,  40, 250, 144, 223,  12, 215, 235, 227,
        #          27,  28, 240,  29, 244, 197, 242, 162, 187, 201,  52, 111,  41,  82, 212, 124,
        #         117,  71,  35, 100,  70, 158,  72, 191, 113, 229, 238,  60, 189,  18, 120, 103,
        #         102, 166,   3,  64,  55, 174,   7, 216,  51,  84,  92, 140, 236, 122,  61,  81,
        #           0, 121, 249, 204, 200, 213, 173,  66, 131,  73,  30,  69, 217,  94, 106, 214,
        #         165, 210, 246, 145, 153, 230, 219, 251, 150, 101, 190, 139, 207,  78,   5,  25]
        # tmp_reg = [list_reg[x] for x in rand]
        # self.register.append(tmp_reg)


# }}}


def sha256_tests(message, flag):
    my_sha256 = SHA256();
    hash_origin = make_hash(message)
    block = word_split(message_input(message))
    my_sha256.get_H(flag)
    for i in block:
        my_sha256.rotation(i)
        my_sha256._W_schedule(i)
    # return my_sha256.register, block[0]
    return my_sha256.register, my_sha256.W


# {{{


def int2bin(num):
    # num_bin = bin(num)
    # num_bin = num_bin.replace('0b', '')
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


def split_str2int(s, n):
    v = [int(s[i:i+n], 16) for i in range(0, len(s), n)]
    return v


def make_message():
    li = ['1', 'Q', 'a', 'y', 'u', 's', 'p']
    org = 'qqqq'
    message = []
    for i in li:
        src = ''
        dst = ''
        for j in range(4):
            src = org
            dst = org[:j] + i + org[j+1:]
            for k in range(8):
                message.append(src)
                message.append(dst)
                src = org + src
                dst = org + dst
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


def compare_reg(reg_list):
    num = [i for i in range(len(reg_list))]
    series = []
    for i, src_reg in enumerate(reg_list):
        for j, dst_reg in enumerate(reg_list):
            if src_reg[:-1] == dst_reg[1:]:
                series.append([i, j])
    return series

# orig
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
            count += 1
        fin_ser.append(ser)
    return fin_ser


#orig
def first_step(reg):
    set_ser = []
    for i in reg:
        series = compare_reg(i)
        ser = find_series(series)
        set_ser.append(ser)
    return set_ser[0]


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
    group.reverse()
    return group


# }}}


def find_flow(flow_data, g):
    for f in flow_data:
        if g == f[0]:
            group_flow = f
            break
    return group_flow


def sigma(s6, s13, s25):
    sig = []
    for i, j, k in s6, s13, s25:
        sig.append(i ^ j ^ k)
    return sig


def ch(e, f, g):
    ch = []
    for i, j, k in e, f, g:
        ch.append((i & j) ^ (~i & g))
    return ch


def cal_next_e(d_li, h_li, ch_li, sigma_li, kw_li, carry_li):
    next_e = [0 for i in range(len(h_li))]
    for i in range(len(h_li)):
        tmp = d_li[i] + h_li[i] + sigma_li[i] + ch_li[i] + kw_li[i] + carry_li[i]
        next_e[i] = tmp & 1
        carry[i] = tmp & 2
    return next_e, carry


def com_e(next_e, e):
    if next_e[:-1] == e[1:]:
        flag = 1
    return flag


def cal(scan, group_li, flow_data, kw_li, carry, reg_li):
    next_e = [0] * 64
    for i in range(len(group_li)):
        flow = find_flow(flow_data, group_li[i])
        d_li = scan[group_li[i-1]]
        e_li = scan[flow[0]]
        f_li = scan[flow[1]]
        g_li = scan[flow[2]]
        h_li = scan[flow[3]]
        ch_li = ch(e_li, f_li, g_li)
        s6_li = g_bit[(6 + i) % 32]
        s11_li = g_bit[(11 + i) % 32]
        s25_li = g_bit[(25 + i) % 32]
        for s6 in s6_li:
            s6_data = scan[s6]
            for s11 in s11_li:
                s11_data = scan[s11]
                for s25 in s25_li:
                    s25_data = scan[s25]
                    sigma_li = sigma(s6_data, s11_data, s25_data)
                    next_e_li, c_li = cal_e1(d_li, h_li, scan, flow, sigma_li, kw_li, carry)
                    flag = com_e(next_e, )
                    if flag:

    return t1


def kw(k_li, w_li):
    kw=[]
    for k, w in zip(k_li, w_li):
        tmp = (k + w) & 0xffffffff
        kw.append(split_str2(int2bin(tmp), 1))
    return kw


def third_step(scan, g_bit, flow_data, bin_w):
    # K value{{{
    K = [0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
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
    # }}}

    kw_li = kw(k, bin_w)
    carry = [0] * 64

    # g_bit(32) -> group(2)
    for group in g_bit:
        tmp = cal()
        # flow([1, 2, 3, 4])


def analysis(register, bin_w):
    print('Analysis start')
    scanchain = convert(register)
    print('convert register data finished')
    flow_data = first_step(scanchain)
    print('first step finished')
    group_bit = second_step(register, flow_data, bin_w)
    print('second step finished')
    # print(group_bit)
    third_step(scanchain[0], group_bit, flow_data, bin_w)
    print('third step finished')


def main():
    lines = make_message()
    register = []
    bin_w = [0] * len(lines)
    flag = 0
    for i, message in enumerate(lines):
        reg, bin_w[i] = sha256_tests(message, flag)
        print(bin_w[i])
        register.append(reg)
    analysis(register, bin_w)


if __name__=="__main__":
    sys.exit(main())


