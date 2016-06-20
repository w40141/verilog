#! /usr/bin/env python


import binascii


WORD = 8
LENGTH = 16
M_LENGTH = 128


def split_str(s, n):
    v = [s[i:i+n] for i in range(0, len(s), n)]
    return v


def append_length(m):
    m_len = (len(m) - 1) * 4
    n_hex = hex(m_len).replace('x', '').zfill(LENGTH)
    m_append_length = zero_padded(m) + n_hex
    return m_append_length


def zero_padded(m):
    m_tmp = m.replace("'", '80')
    count = (len(m_tmp) // M_LENGTH+ 1)
    m_len = M_LENGTH * count - LENGTH
    m_padded = m_tmp.ljust(m_len, '0')
    return m_padded


def bit_stream(m):
    m = '0x' + m
    m_hex = hex(int(m, 16))
    m_bin = bin(hex)
    bit = m_bin.replace('0b', '').zfill(32)
    return bit


def i_padding_message():
    m=[[]]
    m = input('Input message> ')
    m_init = str(binascii.hexlify(m.encode()))[2:]
    m_padded = append_length(m_init)
    m_list = split_str(m_padded, M_LENGTH)
    return m_list


def word_split(m):
    vi = []
    print(m)
    print(len(m))
    for i in m:
        v = split_str(i, 8)
        vi.append(v)
    return vi


print(word_split(i_padding_message()))
