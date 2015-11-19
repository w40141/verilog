#! /usr/bin/python
# -*- coding: utf-8 -*-


lines = []
with open("text.txt", "r") as f:
    fl = f.readlines()
    print(fl)
    for i in fl:
        lines.append(i[:-1].replace(' ', ''))
    print(lines)

if __name__ == "__main__":
    print("how many number do you want?")
    count = int(input())
    print("which file do you want to write?")
    name = raw_input()
    for i in range(count):
        word = ''
        for j in range(10):
            num = '%x' % random.randint(0, 255)
            word = word + num.zfill(2) + ' '
        with open(name, 'a') as fh:
            fh.write(word[0:-1] + '\n')
    print("Finish write " + str(count) + " lines to " + name + ".")
with open(name, 'a') as fh:
    fh.write(word[0:-1] + '\n')
