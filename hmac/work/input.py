#! /usr/bin/env python


import binascii
import struct


def split_str(s, n):
    v = [s[i:i+n] for i in range(0, len(s), n)]
    return v


def append_length(message):
    m_len = len(message)
    print(message)
    n_hex = hex(m_len - 1).replace('x', '').zfill(16)
    print(n_hex)
    message_append_length = zero_padded(message) + n_hex
    return message_append_length


def zero_padded(message):
    message_tmp = message.replace("'", '80')
    m_len = len(message_tmp)
    if m_len <= 60:
        message_padded = message_tmp.ljust(60 - m_len, '0')
        print(message_padded + ',')
    else:
        m_len_tmp = m_len // 64
        print(m_len_tmp)
        message_padded = message_tmp.ljust(64 * m_len_tmp + 60, '0')
    return message_padded


def i_padding_message():
    m=[[]]
    message = input('Input message> ')
    message_init = str(binascii.hexlify(message.encode()))[2:]
    print(message_init)
    print(append_length(message_init))
    # message_str = str(message_int)
    # m_len_hex = hex(m_len).replace('x', '').zfill(16)
    # print(message_str + m_len_hex)
    # le = len(hex_message)
    # counter = le / LENGTH
    # for i in range(0, counter+1):
    # padding_message = [hex_message[i:i+4] for i in range(0, le, 4)]
    # return padding_message


print(i_padding_message())
