import numpy as np

def hash_fun(p,k,m):
    a = np.random.randint(1,p)
    b = np.random.randint(0,p)
    return ((a*k+b)%p)%m

def universalHash(source_list, p, m):
    # p = 65537
    # m = 4096
    # i = 0

    result_list = []

    split_len = int(np.log2(m))
    # print(split_len)
    for source in source_list:
        result1 = hash_fun(p, int(source[:int(len(source)/2)], 2), m)
        result2 = hash_fun(p, int(source[int(len(source)/2):], 2), m)
        print(f'x: {result1:0{split_len}b} {result1}  y: {result1:0{split_len}b} {result2}')
        result1 = result1 << 8
        result = result1 + result2
        result_list.append(result)

        # result_bit = f'{result:016b}'
        # x = result_bit[:split_len]
        # y = result_bit[split_len:]
        # print(f'x: {x} {int(x, 2)}  y: {y} {int(y,2)}')
        
        # print(result)

    return result_list