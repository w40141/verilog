import random

num = 10
li = [x for x in range(2**10)]
random.shuffle(li)
num_li = li[:128]
bin_li = [bin(x)[2:].zfill(num) for x in num_li]
mes_li = ['' for _ in range(10)]
for b in bin_li:
    for i in range(10):
        mes_li[i] += b[i]
print(mes_li)
