
import random
import numpy as np
from math import factorial, log, gamma, pi
from scipy import integrate, stats
import matplotlib.pyplot as plt


def test_geometric():
    rng = np.random.default_rng()
    size = 10000
    thetas = pi / 2 * (rng.random(size) - 1 / 3)
    x_0 = 38.32
    ys = x_0 * np.tan(thetas)
    print(f"{x_0 / pi * log(3)=}\n"
          f"{np.sum(ys)/size=}")


def f(x, alpha=3.1, beta=9.3, lambd=4.32):
    total = 1 / (alpha + x)
    term = 1
    for i in range(1, 100):
        term *= -1 * (beta + 1) * lambd / i
        total += term / (alpha + beta + x)
    return total * pow(beta, alpha) * pow(lambd, alpha + x) / (factorial(x) * gamma(alpha))


def test_posterior(n=10, alpha=1.5, beta=1.5):
    param = random.gammavariate(alpha, beta)
    sn = np.sum(np.random.poisson(lam=param, size=n))
    print(param, np.mean(stats.gamma.rvs(a=alpha + sn, scale=1/(beta + n), size=n)))


if __name__ == '__main__':
    test_posterior(n=10000)
