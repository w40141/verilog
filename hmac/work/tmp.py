def make_message(num):
    li = ['1', 'Q', 'a', 'y', 'u', 's', 'p']
    for i in range(4):
        q_pad = ''
        for word in li:
            pad_word = word.rjust(i+1, 'q')
            if word == '1':
                for j in range(num):
                    message_dic[word].append(q_pad + pad_word)
                    q_pad += 'q' * 4
            else:
                message_dic[word].append(pad_word)
        message_dic_li.append(message_dic)
    return message_dic_li

print(make_message(5))

