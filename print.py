#!/usr/bin/env python

for i in range(0, 256):
    print("8'b"+format(i, 'b').zfill(8)+":  y <= 8'b00000000;")
