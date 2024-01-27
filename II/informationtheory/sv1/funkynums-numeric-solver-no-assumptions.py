import scipy.optimize as opt
import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    plt.ylabel('$p_i$')
    plt.xlabel('$i$')
    n = 6
    for μ in (2, 3.5, 5):
        def f(x):
            p = np.exp(x)
            p /= np.sum(p)
            h = np.sum(p * -np.log(p))
            return h + (np.sum(p * np.arange(1, n + 1)) - μ) ** 2
        ps = opt.fmin(
            f,
            [0 for _ in range(n)]
        )
        i = np.arange(1, n + 1)
        print(i, ps)
        plt.plot(i, ps, label=f'$μ={μ}$')
    plt.legend()
    # plt.savefig('plot.png')
    plt.show()
