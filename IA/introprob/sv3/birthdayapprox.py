import math

import numpy as np
import matplotlib.pyplot as plt
import scipy.stats


def collisions(size, iterations=1000, max=20):
    rng = np.random.default_rng()
    return np.array([size - len(set(rng.integers(0, max, size=size))) for i in range(iterations)])


def bdays():
    k = 90
    tries = 100000
    n = 20
    collides = collisions(k, iterations=tries, max=n)
    print(f"{np.mean(collides)=}, {np.var(collides)=}")
    expectation = k - n * (1 - pow(1 - 1 / n, k))
    print(f"{expectation=}")
    plt.show()


def nktest(k=20, dif=1000):
    xs = range(k, k + dif)
    ys = [1 - math.perm(n, k) / n ** k for n in xs]
    est = [1 - math.exp(- math.comb(k, 2) / n) for n in xs]
    plt.plot(xs, ys)
    plt.plot(xs, est)
    plt.ylim(0, 1)
    plt.show()


if __name__ == '__main__':
    nktest()
