import matplotlib.pyplot as plt
import numpy as np


def H_2(p):
    return -p * np.log2(p) - (1 - p) * np.log2(1 - p)


if __name__ == '__main__':
    ϵ = 1e-5
    f = np.linspace(ϵ, 1 - ϵ, 1000)
    p1_star = 1 / (1 - f) / (1 + 2**(H_2(f) / (1 - f)))
    BAC = H_2(p1_star * (1 - f)) - p1_star * H_2(f)

    BSC = 1 - H_2(f)

    plt.xlabel('$f$')
    plt.ylabel('$C$')
    plt.title('Capacity of Binary Channels as a function of error probability')
    plt.plot(f, BAC, label='$C_{BAC}$')
    plt.plot(f, BSC, label='$C_{BSC}$')
    plt.legend()
    plt.tight_layout()
    plt.savefig('bsc-bac-capacity.png')
    plt.show()
