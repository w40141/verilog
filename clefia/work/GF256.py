import numpy as np


class GF256:

    zero = 0x11D
    # x^8+x^4+x^3+x^2+1==0

    def __init__(self, n):
        self.n = n

    def print(self):
        print("0x%02x" % self.n)

    def add(self, node):
        if isinstance(node, int):
            node = GF256(node)
        r = GF256(self.n)
        r.n ^= node.n
        return r

    def shift(self):
        r = GF256(self.n)
        r.n <<= 1
        if r.n > 0xFF:
            r.n ^= GF256.zero
        return r

    def mul(self, node):
        GF256.init()
        if self.n == 0:
            return GF256(0)
        if node.n == 0:
            return GF256(0)
        exponent_0 = GF256.v2e_table[self.n]
        exponent_1 = GF256.v2e_table[node.n]
        exponent_mul = exponent_0 + exponent_1
        if exponent_mul >= 255:
            exponent_mul -= 255
        r = GF256(GF256.e2v_table[exponent_mul])
        return r

    def inv(self):
        GF256.init()
        if self.n == 0:
            return GF256(0)  # error
        exponent_0 = GF256.v2e_table[self.n]
        exponent_1 = 255 - exponent_0
        r = GF256(GF256.e2v_table[exponent_1])
        return r

    @classmethod
    def init(cls):
        if hasattr(cls, 'v2e_table'):
            return
        cls.v2e_table = np.zeros(256, dtype='uint16')
        cls.e2v_table = np.zeros(256, dtype='uint8')
        node = GF256(1)
        for i in range(255):
            # print("(%d,%d)" % (i,node.n))
            cls.e2v_table[i] = node.n
            cls.v2e_table[node.n] = i
            node = node.shift()


if __name__ == "__main__":
    a = GF256(0xA0).inv()
    a.print()
    b = GF256(0x00).mul(a)
    b.print()
    c = GF256(0x5D).mul(a)
    c.print()
    d = GF256(0xAD).mul(a)
    d.print()
    e = GF256(0xA0).mul(a)
    e.print()
    f = GF256(0xF0).mul(a)
    f.print()
    g = GF256(0x70).mul(a)
    g.print()
