import numpy as np
from galois import GF

def inttobit(x):
    if x > 0:
        return [x//2**k % 2 for k in range(int(np.floor(np.log2(x))+1))]
    if x==0:
        return [0]
    
def bittoint(x):
    a=0
    for i in range(len(x)):
        a=a+x[i]*2**i
    return a

def weakDesign(i, m, t, t_req):
    GF_t = GF(t)

    alp = []
    S = []
    c = np.ceil(np.log2(m)/np.log2(t_req)-1)
    mask = (1 << int(np.log2(t))) - 1

    alp_int = []
    for j in range(int(c) + 1):
        alp_int = (i & (mask << (j*int(np.log2(t))))) >> j*int(np.log2(t))
        alp.append(GF_t(alp_int))

    for a in range(int(t_req)):
        b = GF_t(0)
        S_a = 0
        int_a = a
        a = GF_t(a)
        for k in range(int(c) + 1):
            b = b + alp[k]*a**k
        
        S_a = int(S_a ^ b)
        S_a = S_a ^ (int_a<<int(np.log2(t)))
        S.append(S_a)

    return S

def oneBitExtractor(seed, source, error):
    n = len(source)
    l = int(np.ceil(np.log2(n) + 2*np.log2(2/error)))
    
    GF_2l = GF(2**l)
    s = int(np.ceil(n/l))
    
    for i in range(n, s*l):
        source = source + '0'
    
    c = []
    for i in range(s):
        c.append(source[i*l:(i+1)*l])
    seed_list = int(seed[:l], 2)
    alpha = GF_2l(seed_list)

    for i in range(s):
        c[i] = GF_2l(int(c[i], 2))
    
    r = GF_2l(0)
    for i in range(1, s+1):
        print(f'c: {c[i-1]}, a: {alpha**(i-1)}')
        r = GF_2l(r + c[i-1]*alpha**(i-1))
        print(r)
        print()

    return 0


def trsExtractor(seed, source, n, alpha, epsilon):
    r = 2*np.e

    k = alpha*n
    m = int(np.floor((k-4*np.log2(1/epsilon)-6)/r))

    t_req = int(2*np.ceil(np.log2(n)+2*np.log2(2/epsilon)))
    t = int(2**(np.ceil(np.log2(t_req))))
    d = t**2

    seed = seed[:d]
    source = source[:n]
    
    rho = np.zeros(m)

    for i in range(1): # m
        S = weakDesign(i, m, t, t_req)
        b = np.zeros(t_req)

        for j in range(t_req):
            b[j] = np.int64(seed[S[j]])
        b = ''.join(b.astype(np.int64).astype(str))
        rho[i] = oneBitExtractor(b, source, epsilon)

    return rho
        
if __name__ == '__main__':
    input_length = 1000
    alpha = 0.4
    epsilon = 0.001

    seed = open('./seed.txt', 'r').read()
    source = open('./source.txt', 'r').read()

    trsExtractor(seed, source, input_length, alpha, epsilon)
    # weakDesign(727,727,128,72)
    # trsExtractor()