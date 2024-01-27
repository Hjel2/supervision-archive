import numpy as np
import matplotlib.pyplot as plt
from scipy import stats, integrate
import tqdm


def run(size, depth=10000):
    rng = np.random.default_rng()
    current = np.array(rng.random(size) <= 0.7, dtype=bool)
    ones = np.array(current, dtype=int)
    for i in range(depth - 1):
        rand = rng.random(size) <= 0.99
        current = rand & current | ~rand & np.array(rng.random(size) <= 0.7, dtype=bool)
        ones += current
    return ones


def coinflips(tries=100):
    size = 10000
    attempts = 10000
    ones = np.concatenate([run(attempts, size) for _ in tqdm.tqdm(range(tries))], dtype=np.dtype('int64'))
    np.ndarray.dump(np.array([np.count_nonzero(ones == i)  for i in range(size + 1)]) + np.load('ones.pkl', allow_pickle=True), 'ones.pkl')


def fullplot():
    ones = np.array(np.load('ones.pkl', allow_pickle=True), dtype=np.dtype('int64'))
    count = np.sum(ones)
    variance = 0
    expectation = 0
    for i in ones:
        variance += i ** 2
        expectation += i
    expectation /= count
    variance = variance / count - expectation ** 2
    print(f"{expectation=}, {variance=}")
    x = np.arange(10001)
    y = ones / count
    normal = stats.norm(7000, 413757 ** 0.5)
    yb = np.array([normal.pdf(r) for r in range(10001)])
    plt.plot(x, y, label='Experimental Probability')
    plt.plot(x, yb, label='$X \\sim N(7000, 413757$)')
    plt.ylabel('Probability')
    plt.xlabel('Number of Heads')
    plt.legend()
    plt.title('Experimental Probabilities')
    plt.tight_layout()
    plt.savefig('experimental_prob.png', dpi=400)
    plt.show()


def displayones():
    ones = np.load('ones.pkl', allow_pickle=True)
    sqsum = 0
    nsum = 0
    for i in range(10001):
        sqsum += int(ones[i]) * i ** 2
        nsum += int(ones[i]) * i
    sqsum /= np.sum(ones)
    nsum /= np.sum(ones)
    print(sqsum - nsum ** 2)
    plt.plot(np.arange(10001), ones / np.sum(ones))
    plt.show()


def inequalities():
    real = 1 - np.linspace(0, 1, 2)
    xs = np.linspace(0, 1, 10000)
    markovxs = xs[5000:]
    markov = 1 / (2 * markovxs)
    chebyshevxs = xs[7887:]
    chebyshev = 1 / (12 * (chebyshevxs - 0.5) ** 2)
    plt.plot([0, 1], real, label='Exact: $\mathbb{P}(|X| \geq a)$')
    plt.plot(markovxs, markov, label='Markov: $\\frac{1}{2a}$')
    print(chebyshev)
    plt.plot(chebyshevxs, chebyshev, label='Chebyshev: $\\frac{1}{12\left(a - \\frac{1}{2}\\right)^2}$')
    plt.xlabel('$a$')
    plt.ylabel('$\mathbb{P}(|X| \geq a)$')
    plt.title('Comparison of inequalities and the exact probability')
    plt.legend()
    plt.tight_layout()
    plt.savefig('inequalities.png', dpi=400)
    plt.show()


def normalbinom():
    binomial = stats.binom(10000, 0.7)
    xaxis = np.arange(10001)
    plt.plot(xaxis, binomial.pmf(xaxis), label='$X \\sim B(10000, 0.7)$')
    plt.ylabel('$\mathbb{P}(X = x)$')
    plt.xlabel('$x$')
    plt.title('Binomial Distribution')
    plt.tight_layout()
    plt.savefig('normabinomial.png', dpi=400)


def integrator(x):
    f = stats.gamma(a=40, scale=2)
    return integrate.quad(f.pdf, 0, x)


if __name__ == '__main__':
    inequalities()