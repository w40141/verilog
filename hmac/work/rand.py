import random


# def make_message():
#     message_number = 8
#     li = ['A', 'Q', 'a', 'y', 'u', 's', 'p']
#     org = 'qqqq'
#     src = ''
#     dst = ''
#     tmp = ''
#     message = []
#     for i in range(message_number):
#         src += org
#         for j in range(4):
#             for k in li:
#                 dst = org[:j] + k + org[j+1:]
#                 message.append(src)
#                 message.append(tmp + dst)
#         dst += org
#         tmp += org
#     return message


def shuffle_li(num):
    li = [i for i in range(num)]
    random.shuffle(li)
    rand_li = li
    return rand_li


def convert_chain(reg_li, rand_li):
    scan_li = []
    for i in rand_li:
        if 0 <= i and i < len(reg_li):
            scan_li.append(reg_li[i])
        else:
            scan_li.append(random.randint(0, 1))
    return scan_li


reg_li = [x for x in range(32)]
print(reg_li)
rand_li = shuffle_li(64)
print(rand_li)
chain = convert_chain(reg_li, rand_li)
print(chain)


# m = make_message()
# for i in m:
#     print(i)
