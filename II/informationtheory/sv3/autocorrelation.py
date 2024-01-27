from rich.traceback import install
install()
from tqdm import trange
from functools import cache
import numpy as np

if __name__ == '__main__':
    with open('autocorrelation.txt') as autocorrelation:
        ys = np.array([
            float(y) for y in autocorrelation.readline().strip("\n").split(",")
        ])

    ℓ_lo = 1
    ℓ_hi = len(ys)

    μ = np.mean(ys)
    Σ = np.cumsum(ys)

    ryys = []

    # ys -= μ
    # csm = np.cumsum(ys ** 2)
    n = ys.size

    for ℓ in trange(ℓ_lo, ℓ_hi):
        ryys.append(
            np.sum(ys[ℓ:] * ys[:-ℓ]) / (n - ℓ)
        )
        # ryys.append(np.sum(ys[ℓ:] * ys[:-ℓ]) / ((csm[-1] - csm[ℓ - 1]) * (csm[-ℓ])))
    ryys = np.array(ryys)

    import matplotlib.pyplot as plt
    plt.figure(figsize=(15, 3))
    plt.axhline(c='lightgrey', ls='--')
    plt.title('Autocorrelation')
    plt.xlabel('$\ell$')
    plt.ylabel('$R_{yy}(\ell)$')
    plt.xlim(left=ℓ_lo, right=ℓ_hi)
    plt.ylim(bottom=-1, top=1)
    x = 50
    norms = np.concatenate(
        list(
            ryys[i:len(ryys)-2*x+i].reshape(-1, 1) for i in range(2*x + 1)
        ),
        axis=1
    )
    μs = np.mean(norms, axis=1)
    σs = np.std(norms, axis=1)
    xs = np.arange(ℓ_lo + x, ℓ_hi - x)
    plt.fill_between(xs, μs - σs, μs + σs, alpha=0.2)
    plt.plot(xs, μs)
    plt.tight_layout()
    plt.savefig('autocorelation.pdf', format='pdf')

    print(np.argmax(ryys))
