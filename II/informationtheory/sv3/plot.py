import matplotlib.pyplot as plt
import numpy as np

if __name__ == '__main__':
    ϵ = 1e-5
    f = np.linspace(ϵ, 1 - ϵ, 1000)
    H_2f = -f * np.log2(f) - (1 - f) * np.log2(1 - f)
    p_star = 1 / (1 - f) / (1 + 2**(H_2f / (1 - f)))
    plt.xlabel('$f$')
    plt.ylabel('$p_1^\\star$')
    plt.title('Optimal input distribution for BAC')
    plt.tight_layout()
    plt.axhline(1 / np.e, linestyle='dashed')
    ticks = [0.38, 0.4, 0.42, 0.44, 0.46, 0.48, 0.50]
    plt.yticks(ticks + [1 / np.e], [
        str(tick) + '0' if len(str(tick)) == 3 else str(tick) for tick in ticks
    ] + ['$e^{-1}$'])
    plt.plot(f, p_star)
    plt.savefig('bac-plot.png')
    plt.show()
