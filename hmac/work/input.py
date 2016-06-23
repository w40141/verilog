#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import binascii
import hashlib


WORD = 8
LENGTH = 16
M_LENGTH = 128


def chain(reg_list):
    scanchain = [[0 for i in range(list)] for j in range(list[0])]
    for i, cyc_reg in enumerate(reg_list):
        for j, one_reg in enumerate(cyc_reg):
            scanchain[i][j] = one_reg
    return scanchain


def conpare_reg(reg_list):
    for i in :
        pass


def int2bin(num):
    num_bin = bin(num)
    num_bin = num.replace('0b', '')
    num_zero = num_bin.zfill(32)


# hogehogehoge -> [ho, ge, ho, ge, ho, ge]
def split_str(s, n):
    v = [s[i:i+n] for i in range(0, len(s), n)]
    return v


def split_str2int(s, n):
    v = [int(s[i:i+n], 16) for i in range(0, len(s), n)]
    return v


# message -> message000000LENGTH
def append_length(m):
    m_len = (len(m) - 1) * 4
    n_hex = hex(m_len).replace('x', '').zfill(LENGTH)
    m_append_length = zero_padded(m) + n_hex
    return m_append_length


# message -> message000000
def zero_padded(m):
    m_tmp = m.replace("'", '80')
    count = (len(m_tmp) // M_LENGTH+ 1)
    m_len = M_LENGTH * count - LENGTH
    m_padded = m_tmp.ljust(m_len, '0')
    return m_padded


# message input -> [message000000LENGTH, message000000LENGTH]
def message_input():
    m = input('Input message> ')
    m_init = str(binascii.hexlify(m.encode()))[2:]
    print(m_init)
    m_padded = append_length(m_init)
    print(m_padded)
    m_list = split_str(m_padded, M_LENGTH)
    print(m_list)
    return m_list


# message -> [4byte_stream, 4byte_stream]
def word_split(m):
    vi = []
    for i in m:
        v = split_str2int(i, 8)
        vi.append(v)
    return vi


def make_hash(m):
    h = hashlib.sha256(m.encode()).hexdigest()
    list_h = split_str2int(h, 8)
    print(list_h)


print(word_split(message_input()))
make_hash(input('m'))

