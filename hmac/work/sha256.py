#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import binascii
import hashlib


WORD = 8
LENGTH = 16
M_LENGTH = 128



class SHA256():


    def __init__(self):# {{{
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
        self.W = [0] * 16
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
# }}}


# function {{{
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
            tmp_w = (self._delta1(self.W[14]) + self.W[9] + self._delta0(self.W[1]) + self.W[0]) & 0xffffffff
            for i in range(15):
                self.W[i] = self.W[(i+1)]
            self.W[15] = tmp_w
            return tmp_w


    def _W_schedule(self, block):
        for i in range(16):
            self.W[i] = block[i]


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


    # def _print_reg(self):
    #     print("0x%08x, 0x%08x, 0x%08x, 0x%08x 0x%08x, 0x%08x, 0x%08x, 0x%08x" %\
    #             (self.a, self.b, self.c, self.d, self.e, self.f, self.g, self.h))
    #     print("")

# }}}


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
        list_reg = split_str(reg, 1)
        self.register.append(list_reg)


def int2bin(num):
    num_bin = bin(num)
    num_bin = num_bin.replace('0b', '')
    num_zero = num_bin.zfill(32)
    return num_zero


def print_digest(digest):
    print("0x%08x, 0x%08x, 0x%08x, 0x%08x 0x%08x, 0x%08x, 0x%08x, 0x%08x" %\
          (digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7]))
    print("")


def compare_digests(digest, expected):
    if (digest != expected):
        print("Error:")
        print("Got:")
        print_digest(digest)
        print("Expected:")
        print_digest(expected)
    else:
        print("Test case ok.")


def sha256_tests():
    my_sha256 = SHA256();
    message = input('Input message > ')
    hash_origin = make_hash(message)
    block = word_split(message_input(message))
    # flag = hmac_mode()
    # my_sha256.get_H(flag)
    my_sha256.get_H(0)
    for i in block:
        my_sha256.rotation(i)
    my_hash = my_sha256.get_digest()
    scanchain = chain(my_sha256.register)
    print(scanchain)
    compare_digests(my_hash, hash_origin)
    print("")


# {{{
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


def chain(reg_list):
    scanchain = [[0 for i in range(len(reg_list))] for j in range(len(reg_list[0]))]
    for i, cyc_reg in enumerate(reg_list):
        for j, one_reg in enumerate(cyc_reg):
            scanchain[j][i] = one_reg
    return scanchain


# }}}

def main():
    print("---------------------------------")
    print("start")

    sha256_tests()


if __name__=="__main__":
    sys.exit(main())


