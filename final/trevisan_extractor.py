import numpy as np
from galois import GF

def inttobit(x):
    if x>0:
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

    for j in range(int(c) + 1):
        alp.append((i & (mask << (j*int(np.log2(t))))) >> j*np.log2(t))


def trsExtractor(seed, source, n, alpha, epsilon):
    r = 2*np.e

    k = alpha*n
    m = int(np.floor*((k-4*np.log2(1/epsilon)-6)/r))

    t_req = int(2*np.ceil(np.log2(n)+2*np.log2(2/epsilon)))
    t = int(2**(np.ceil(np.log2(t_req))))
    d = t**2

if __name__ == '__main__':
    print(inttobit(2))
    # trsExtractor()