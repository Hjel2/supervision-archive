import scipy.optimize as opt
import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    plt.ylabel('$p_i$')
    plt.xlabel('$i$')
    n = 6
    for μ in (2, 3.5, 5):
        def f(x):
            r = x[0]
            lhs = n * r ** (n + 1) - (n + 1) * r ** n + 1
            rhs = μ * (1 - r ** n) * (1 - r)
            return abs(lhs - rhs)
        r = opt.fmin(
            f,
            [1/2]
        )[0]
        C = (1 - r) / (r * (1 - r ** n))
        i = np.arange(1, n + 1)
        pi = C * r ** i
        plt.plot(i, pi, label=f'$μ={μ}$')
    plt.legend()
    plt.savefig('plot.png')
