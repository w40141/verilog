#!/usr/bin/python3
from random import randint
import sys

reg_li=[]

# constant{{{
# Key sizes supported
ksTable = {"SIZE_128": 16}

# Number of rounds related to key size
nrTable = {"SIZE_128": 18}

# Number of round keys related to key size
nrkTable = {"SIZE_128": 36}

# Number of rounds
nr = None

# Number of round keys effectively used
nrk = None

# Number of whitening keys
nwk = 4

# Round keys vector
rk = [None] * 2 * nrTable[max(nrTable)]

# Whitening keys
wk = [None] * 4

# First S-Box{{{
s0 = [0x57, 0x49, 0xd1, 0xc6, 0x2f, 0x33, 0x74, 0xfb,
      0x95, 0x6d, 0x82, 0xea, 0x0e, 0xb0, 0xa8, 0x1c,
      0x28, 0xd0, 0x4b, 0x92, 0x5c, 0xee, 0x85, 0xb1,
      0xc4, 0x0a, 0x76, 0x3d, 0x63, 0xf9, 0x17, 0xaf,
      0xbf, 0xa1, 0x19, 0x65, 0xf7, 0x7a, 0x32, 0x20,
      0x06, 0xce, 0xe4, 0x83, 0x9d, 0x5b, 0x4c, 0xd8,
      0x42, 0x5d, 0x2e, 0xe8, 0xd4, 0x9b, 0x0f, 0x13,
      0x3c, 0x89, 0x67, 0xc0, 0x71, 0xaa, 0xb6, 0xf5,
      0xa4, 0xbe, 0xfd, 0x8c, 0x12, 0x00, 0x97, 0xda,
      0x78, 0xe1, 0xcf, 0x6b, 0x39, 0x43, 0x55, 0x26,
      0x30, 0x98, 0xcc, 0xdd, 0xeb, 0x54, 0xb3, 0x8f,
      0x4e, 0x16, 0xfa, 0x22, 0xa5, 0x77, 0x09, 0x61,
      0xd6, 0x2a, 0x53, 0x37, 0x45, 0xc1, 0x6c, 0xae,
      0xef, 0x70, 0x08, 0x99, 0x8b, 0x1d, 0xf2, 0xb4,
      0xe9, 0xc7, 0x9f, 0x4a, 0x31, 0x25, 0xfe, 0x7c,
      0xd3, 0xa2, 0xbd, 0x56, 0x14, 0x88, 0x60, 0x0b,
      0xcd, 0xe2, 0x34, 0x50, 0x9e, 0xdc, 0x11, 0x05,
      0x2b, 0xb7, 0xa9, 0x48, 0xff, 0x66, 0x8a, 0x73,
      0x03, 0x75, 0x86, 0xf1, 0x6a, 0xa7, 0x40, 0xc2,
      0xb9, 0x2c, 0xdb, 0x1f, 0x58, 0x94, 0x3e, 0xed,
      0xfc, 0x1b, 0xa0, 0x04, 0xb8, 0x8d, 0xe6, 0x59,
      0x62, 0x93, 0x35, 0x7e, 0xca, 0x21, 0xdf, 0x47,
      0x15, 0xf3, 0xba, 0x7f, 0xa6, 0x69, 0xc8, 0x4d,
      0x87, 0x3b, 0x9c, 0x01, 0xe0, 0xde, 0x24, 0x52,
      0x7b, 0x0c, 0x68, 0x1e, 0x80, 0xb2, 0x5a, 0xe7,
      0xad, 0xd5, 0x23, 0xf4, 0x46, 0x3f, 0x91, 0xc9,
      0x6e, 0x84, 0x72, 0xbb, 0x0d, 0x18, 0xd9, 0x96,
      0xf0, 0x5f, 0x41, 0xac, 0x27, 0xc5, 0xe3, 0x3a,
      0x81, 0x6f, 0x07, 0xa3, 0x79, 0xf6, 0x2d, 0x38,
      0x1a, 0x44, 0x5e, 0xb5, 0xd2, 0xec, 0xcb, 0x90,
      0x9a, 0x36, 0xe5, 0x29, 0xc3, 0x4f, 0xab, 0x64,
      0x51, 0xf8, 0x10, 0xd7, 0xbc, 0x02, 0x7d, 0x8e]
# }}}

# Second S-Box{{{
s1 = [0x6c, 0xda, 0xc3, 0xe9, 0x4e, 0x9d, 0x0a, 0x3d,
      0xb8, 0x36, 0xb4, 0x38, 0x13, 0x34, 0x0c, 0xd9,
      0xbf, 0x74, 0x94, 0x8f, 0xb7, 0x9c, 0xe5, 0xdc,
      0x9e, 0x07, 0x49, 0x4f, 0x98, 0x2c, 0xb0, 0x93,
      0x12, 0xeb, 0xcd, 0xb3, 0x92, 0xe7, 0x41, 0x60,
      0xe3, 0x21, 0x27, 0x3b, 0xe6, 0x19, 0xd2, 0x0e,
      0x91, 0x11, 0xc7, 0x3f, 0x2a, 0x8e, 0xa1, 0xbc,
      0x2b, 0xc8, 0xc5, 0x0f, 0x5b, 0xf3, 0x87, 0x8b,
      0xfb, 0xf5, 0xde, 0x20, 0xc6, 0xa7, 0x84, 0xce,
      0xd8, 0x65, 0x51, 0xc9, 0xa4, 0xef, 0x43, 0x53,
      0x25, 0x5d, 0x9b, 0x31, 0xe8, 0x3e, 0x0d, 0xd7,
      0x80, 0xff, 0x69, 0x8a, 0xba, 0x0b, 0x73, 0x5c,
      0x6e, 0x54, 0x15, 0x62, 0xf6, 0x35, 0x30, 0x52,
      0xa3, 0x16, 0xd3, 0x28, 0x32, 0xfa, 0xaa, 0x5e,
      0xcf, 0xea, 0xed, 0x78, 0x33, 0x58, 0x09, 0x7b,
      0x63, 0xc0, 0xc1, 0x46, 0x1e, 0xdf, 0xa9, 0x99,
      0x55, 0x04, 0xc4, 0x86, 0x39, 0x77, 0x82, 0xec,
      0x40, 0x18, 0x90, 0x97, 0x59, 0xdd, 0x83, 0x1f,
      0x9a, 0x37, 0x06, 0x24, 0x64, 0x7c, 0xa5, 0x56,
      0x48, 0x08, 0x85, 0xd0, 0x61, 0x26, 0xca, 0x6f,
      0x7e, 0x6a, 0xb6, 0x71, 0xa0, 0x70, 0x05, 0xd1,
      0x45, 0x8c, 0x23, 0x1c, 0xf0, 0xee, 0x89, 0xad,
      0x7a, 0x4b, 0xc2, 0x2f, 0xdb, 0x5a, 0x4d, 0x76,
      0x67, 0x17, 0x2d, 0xf4, 0xcb, 0xb1, 0x4a, 0xa8,
      0xb5, 0x22, 0x47, 0x3a, 0xd5, 0x10, 0x4c, 0x72,
      0xcc, 0x00, 0xf9, 0xe0, 0xfd, 0xe2, 0xfe, 0xae,
      0xf8, 0x5f, 0xab, 0xf1, 0x1b, 0x42, 0x81, 0xd6,
      0xbe, 0x44, 0x29, 0xa6, 0x57, 0xb9, 0xaf, 0xf2,
      0xd4, 0x75, 0x66, 0xbb, 0x68, 0x9f, 0x50, 0x02,
      0x01, 0x3c, 0x7f, 0x8d, 0x1a, 0x88, 0xbd, 0xac,
      0xf7, 0xe4, 0x79, 0x96, 0xa2, 0xfc, 0x6d, 0xb2,
      0x6b, 0x03, 0xe1, 0x2e, 0x7d, 0x14, 0x95, 0x1d]
# }}}

m0 = [0x01, 0x02, 0x04, 0x06, 0x02, 0x01, 0x06, 0x04,
      0x04, 0x06, 0x01, 0x02, 0x06, 0x04, 0x02, 0x01]

m1 = [0x01, 0x08, 0x02, 0x0a, 0x08, 0x01, 0x0a, 0x02,
      0x02, 0x0a, 0x01, 0x08, 0x0a, 0x02, 0x08, 0x01]

# constant for key{{{
con128 = [0xf56b7aeb, 0x994a8a42, 0x96a4bd75, 0xfa854521,
          0x735b768a, 0x1f7abac4, 0xd5bc3b45, 0xb99d5d62,
          0x52d73592, 0x3ef636e5, 0xc57a1ac9, 0xa95b9b72,
          0x5ab42554, 0x369555ed, 0x1553ba9a, 0x7972b2a2,
          0xe6b85d4d, 0x8a995951, 0x4b550696, 0x2774b4fc,
          0xc9bb034b, 0xa59a5a7e, 0x88cc81a5, 0xe4ed2d3f,
          0x7c6f68e2, 0x104e8ecb, 0xd2263471, 0xbe07c765,
          0x511a3208, 0x3d3bfbe6, 0x1084b134, 0x7ca565a7,
          0x304bf0aa, 0x5c6aaa87, 0xf4347855, 0x9815d543,
          0x4213141a, 0x2e32f2f5, 0xcd180a0d, 0xa139f97a,
          0x5e852d36, 0x32a464e9, 0xc353169b, 0xaf72b274,
          0x8db88b4d, 0xe199593a, 0x7ed56d96, 0x12f434c9,
          0xd37b36cb, 0xbf5a9a64, 0x85ac9b65, 0xe98d4d32,
          0x7adf6582, 0x16fe3ecd, 0xd17e32c1, 0xbd5f9f66,
          0x50b63150, 0x3c9757e7, 0x1052b098, 0x7c73b3a7]
# }}}
# }}}

# divide word{{{
def int2bin(num):
    return format(num, 'b').zfill(128)


def _8To32(x32):
    """Convert a 4-byte list to a 32-bit integer"""
    return (((((x32[0] << 8) + x32[1]) << 8) + x32[2]) << 8) + x32[3]    


def _32To8(x32):
    """Convert a 32-bit integer to a 4-byte list"""
    return [(x32 >> 8 * i) & 0xff for i in reversed(range(4))]


def _32To128(x32):
    """Convert a 32-bit 4-element list to a 128-bit integer"""
    return (((((x32[0] << 32) + x32[1]) << 32) + x32[2]) << 32) + x32[3]


def _128To32(x128):
    """Convert a 128-bit integer to a 32-bit 4-element list"""
    return [(x128 >> 32 * i) & 0xffffffff for i in reversed(range(4))]
# }}}

# mult{{{
def mult(p1, p2):
    """Multiply two polynomials in GF(2^8)
       (the irreducible polynomial used in this
       field is x^8 + x^4 + x^3 + x^2 + 1)"""
    p = 0
    while p2:
        if p2 & 0b1:
            p ^= p1
        p1 <<= 1
        if p1 & 0x100:
            p1 ^= 0b11101
        p2 >>= 1
    return p & 0xff


def memoize(f):
    """Memoization function"""
    memo = {}
    def helper(x):
        if x not in memo:
            memo[x] = f(x)
        return memo[x]
    return helper


# Auxiliary one-parameter functions defined for memoization
# (to speed up multiplication in GF(2^8))
@memoize
def x2(y):
    """Multiply by 2 in GF(2^8)"""
    return mult(2, y)


@memoize
def x4(y):
    """Multiply by 4 in GF(2^8)"""
    return mult(4, y)


@memoize
def x6(y):
    """Multiply by 6 in GF(2^8)"""
    return mult(6, y)


@memoize
def x8(y):
    """Multiply by 8 in GF(2^8)"""
    return mult(8, y)


@memoize
def x10(y):
    """Multiply by 10 in GF(2^8)"""
    return mult(10, y)
# }}}

# function0{{{
def f0(rk, x32):
    """F0 function"""
    t8 = _32To8(rk ^ x32)
    t8 = [s0[t8[0]], s1[t8[1]], s0[t8[2]], s1[t8[3]]]
    return _8To32(multm0(t8))


def multm0(t32):
    """Multiply the matrix m0 by a 4-element transposed vector in GF(2^8)"""
    return [   t32[0]  ^ x2(t32[1]) ^ x4(t32[2]) ^ x6(t32[3]),
            x2(t32[0]) ^    t32[1]  ^ x6(t32[2]) ^ x4(t32[3]),
            x4(t32[0]) ^ x6(t32[1]) ^    t32[2]  ^ x2(t32[3]),
            x6(t32[0]) ^ x4(t32[1]) ^ x2(t32[2]) ^    t32[3]]    
# }}}

# function1{{{
def f1(rk, x32):
    """F1 function"""
    t8 = _32To8(rk ^ x32)
    t8 = s1[t8[0]], s0[t8[1]], s1[t8[2]], s0[t8[3]]
    return _8To32(multm1(t8))


def multm1(t32):
    """Multiply the matrix m1 by a 4-element transposed vector in GF(2^8)"""
    return [    t32[0]  ^  x8(t32[1]) ^  x2(t32[2]) ^ x10(t32[3]),
             x8(t32[0]) ^     t32[1]  ^ x10(t32[2]) ^  x2(t32[3]),
             x2(t32[0]) ^ x10(t32[1]) ^     t32[2]  ^  x8(t32[3]),
            x10(t32[0]) ^ x2(t32[1])  ^  x8(t32[2]) ^     t32[3]]      
# }}}

# sigma {{{
def sigma(x128):
    """The double-swap function sigma (used in key scheduling)"""
    return [(x128[0] << 7) & 0xffffff80  | (x128[1] >> 25),
            (x128[1] << 7) & 0xffffff80  | (x128[3] & 0x7f),
            (x128[0] & 0xfe000000)       | (x128[2] >> 7),
            (x128[2] << 25) & 0xfe000000 | (x128[3] >> 7)]
# }}}

# setKey {{{
def setKey(key, keySize):
    """Generate round/whitening keys from the given key"""
    global nr, nrk
    nr = nrTable[keySize]
    nrk = nrkTable[keySize]
    k32 = _128To32(key)
    for i in range(len(con128) - nrk):
        rk[i] = con128[i]
    l = gfn4(k32, 12)
    for i in range(nwk):
        wk[i] = k32[i]
    for i in range(0, nrk, 4):
        t32 = [r ^ s for r, s in zip(l, con128[i + 24:i + 28])]
        l = sigma(l)
        if i & 0b100:
            rk[i:i + 4] = [r ^ s for r, s in zip(t32, wk)]
        else:
            rk[i:i + 4] = t32
# }}}

# run_reg {{{
def run_reg(key, keySize, p32):
    """Generate round/whitening keys from the given key"""
    global nr, nrk
    nr = nrTable[keySize]
    nrk = nrkTable[keySize]
    k32 = _128To32(key)
    for i in range(len(con128) - nrk):
        rk[i] = con128[i]
    l = gfn4(k32, 12)
    for i in range(nwk):
        wk[i] = k32[i]
    p32[1] ^= wk[0]
    p32[3] ^= wk[1]
    for i in range(0, nrk, 4):
        t32 = [r ^ s for r, s in zip(l, con128[i + 24:i + 28])]
        l = sigma(l)
        rk[i:i + 4] = t32
        for j in range(i, i + 4, 2):
            p128 = _32To128(p32)
            reg_li.append(p128)
            print(hex(p128))
            p32[1] ^= f0(rk[j], p32[0])
            p32[3] ^= f1(rk[j + 1], p32[2])
            p32 = p32[1:] + p32[:1]
            if i & 32:
                1+1
            elif i & 0b100:
                p32[1] ^= wk[j % 4 + 1]
                p32[3] ^= wk[(j + 1) % 4 -1]
            else:
                p32[1] ^= wk[j % 4]
                p32[3] ^= wk[(j + 1) % 4]
    p32 = p32[3:] + p32[:3]
    p32[1] ^= wk[2]
    p32[3] ^= wk[3]
    p128 = _32To128(p32)
    reg_li.append(p128)
    # print(hex(p128))
    return p32


def tmp_encrypt(key, keySize, ptext):
    t32 = _128To32(ptext)
    c = run_reg(key, keySize, t32)
    # print(c)
    return _32To128(c)


# }}}

# decrypt{{{
def decrypt(ctext):
    """Decrypt a block"""
    t32 = _128To32(ctext)
    t32[1] ^= wk[2]
    t32[3] ^= wk[3]
    t32 = gfn4i(t32, nr)
    t32[1] ^= wk[0]
    t32[3] ^= wk[1]
    return _32To128(t32)


def gfn4i(x32, n):
    """4-branch Generalized Feistel Network inverse function"""
    t32 = x32[:]
    for i in reversed(range(0, n << 1, 2)):
        t32[1] ^= f0(rk[i], t32[0])
        t32[3] ^= f1(rk[i + 1], t32[2])
        t32 = t32[3:] + t32[:3]
    return t32[1:] + t32[:1]
# }}}


def gfn4(x32, n):
    """4-branch Generalized Feistel Network function"""
    t32 = x32[:]
    p128 = _32To128(t32)
    reg_li.append(p128)
    # print(hex(p128))
    for i in range(0, n << 1, 2):
        t32[1] ^= f0(rk[i], t32[0])
        t32[3] ^= f1(rk[i + 1], t32[2])
        t32 = t32[1:] + t32[:1]
        p128 = _32To128(t32)
        # print(hex(p128))
        reg_li.append(p128)
    t32 = t32[3:] + t32[:3]
    return t32


# encrypt {{{
def encrypt(ptext):
    """Encrypt a block"""
    t32 = _128To32(ptext)
    t32[1] ^= wk[0]
    t32[3] ^= wk[1]
    t32 = gfn4(t32, nr)
    t32[1] ^= wk[2]
    t32[3] ^= wk[3]
    p128 = _32To128(t32)
    l = p128
    # l = '0x' + format(p128, 'x').zfill(32)
    # print('0x' + format(p128, 'x').zfill(32))
    # print(hex(p128))
    return _32To128(t32)
# }}}


def checkTestVector(key, keySize, plaintext):
    ctext = tmp_encrypt(key, keySize, plaintext)
    # print('-----')
    # reg_li.append(plaintext)
    # setKey(key, keySize)
    # ctext = encrypt(plaintext)
    reg_li[-1] = ctext
    return ctext


def make_message():
    message = ''
    chars = 'abcdef0123456789'
    l = len(chars)
    for i in range(32):
        m = randint(0, l - 1)
        message += chars[m]
    return int(message, 16)


if __name__ == "__main__":
    argvs = sys.argv
    ptext = 0x000102030405060708090a0b0c0d0e0f
    test =  0xffffffffffffffffffffffffffffffff
    key1 = 0xffeeddccbbaa99887766554433221100
    # txt_li = [make_message() for i in range(128)]
    txt_li = [test >> i for i in range(128)]
    f = open(argvs[1], 'w')
    for txt in txt_li:
        f.write(str(txt) + '\n')
        # f.write(hex(reg) + '\n')
    f.flush()
    f.close()
    for txt in txt_li:
        # txt = make_message()
        ctext = checkTestVector(key1, "SIZE_128", txt)
        # test = test >> 1
    f = open(argvs[2], 'w')
    for reg in reg_li:
        f.write(str(reg) + '\n')
        # f.write(hex(reg) + '\n')
    f.flush()
    f.close()
    sys.exit()


