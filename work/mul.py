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

print(mult(1, 2048))
