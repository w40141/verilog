def fuga(moji):
    huff = 0b01000000
    moji_li = []
    moji_ord = ord(moji)
    for i in range(7):
        num = moji_ord ^ huff
        if num < 33 or 126 < num:
            break
        moji_tmp = chr(num)
        moji_li.append(moji_tmp)
        huff = huff >> 1
    return moji_li


# moji_li = ['p', 'q', 'r', 's', 't', 'u', 'v']
moji_li = [chr(x) for x in range(33, 127)]
for moji in moji_li:
    tmp = fuga(moji)
    if len(tmp) == 7:
        print(moji, fuga(moji))
