tmp_li_li = [[['Z927LTnZYCP2ErsX', 2548.6872367858887], ['3pScz84zf8Evvu0P', 985.4653098583221], ['2IEcbnsVMGLKD6YP', 443.04048705101013], ['y9gdbQUgajmW6wZM', 1378.8397479057312], ['xbPaQtXHpV0yHNzR', 983.4594790935516]], [['lphcQvErbELQ2LgK', 1615.9957780838013], ['Wlp3okv6nwbHZdnr', 1357.1910939216614], ['VVNjxrDnfCJa4hdn', 982.6591000556946], ['FcXYQ1fdyjN6HiuN', 1355.2133312225342], ['NZz7IyhFO8BAZVHj', 615.3865251541138]], [['TZ3QFd2krxbtq2w5', 411.76260709762573], ['aSvt0BUu4dcrvxnm', 293.6473779678345], ['enNy4Ut3eG7EJ2xZ', 614.2250049114227], ['41HGz1fjTj5Q7vo6', 971.8082139492035], ['mFDfYgpbPmROg9Vo', 981.3232390880585]], [['JVLx82BC4r8SB9b5', 888.0447242259979], ['TplkCFJoCSYSif1m', 328.6591181755066], ['8wL97ZOvlPwuL50X', 1385.7670509815216], ['362ALzs9twaou95l', 1377.836748123169], ['opHQsGVCXfmKbLqV', 992.8175098896027]], [['UKz9Yqoiuzu9pAxX', 1511.2904908657074], ['KSHikVZjffhDlVue', 2597.354999065399], ['S8q3ZJyyDeYwUUWw', 501.5152220726013], ['KOqi0YaGxz6iHRYE', 308.48197412490845], ['X7dwiO3fLh8da0AP', 1119.3314011096954]], [['zScBOX6G0Li5fQ4Y', 142.66195106506348], ['D1GGtGIb97DUqC4d', 1321.1168100833893], ['Zbv66dmfhMPnvbYX', 604.4033343791962], ['qX29O2Pliqts7eZ4', 971.1500120162964], ['9V9outX7Ti2yGXs1', 1383.2230558395386]], [['BW15wuW0vY21njOn', 415.25660514831543], ['EzGCOp2X51Eze6zj', 2249.9569821357727], ['SLQeLVJJImeHtPJZ', 795.2277460098267], ['pjo7TPx4tpskPquX', 143.53723311424255], ['WwphTV2Ziaf6fZf2', 316.4562659263611]], [['IDd5tPrTEuWLp7Mo', 2176.1843597888947], ['qjLYD4MtxrIeLnI7', 289.6417570114136], ['io5Wty5RB6fP1k9W', 4941.087045669556], ['fTYvr6wLaSe54Zyl', 966.0115330219269], ['JfrGZ9jw52mzK3AP', 1336.8038730621338]], [['frhVhZCkzLkWysaf', 1285.7524070739746], ['mvSwN1tRpywh1FVd', 973.5781960487366], ['fgrvm7CWoql83GjW', 976.4627668857574], ['k2bbclAtjmqnjNRk', 616.1792471408844], ['S1U3RAYZuWiGhoWA', 1193.5223841667175]], [['avQSFIAOyogkMrKk', 558.7757487297058], ['cC7agyML8wZra6DY', 957.9202210903168], ['HS35vHs2x8pxtHBR', 1363.8716449737549], ['xAQ5zJTevgJ1AXXp', 614.6036562919617], ['fZpb4BGYEttj2F3I', 1815.6366667747498]]]
t = []
for tmp_li in tmp_li_li:
    for tmp in tmp_li:
        t.append(tmp[1])
max_t = max(t)
min_t = min(t)
ave = sum(t)/len(t)
print(max_t)
print(min_t)
print(ave)

