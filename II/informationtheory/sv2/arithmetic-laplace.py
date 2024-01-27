from collections import Counter, namedtuple
import decimal
from decimal import Decimal

decimal.getcontext().prec = 1000

prob = namedtuple('Probability', 'p')
cumprob = namedtuple('ProbabilityRange', ['lo', 'hi'])


def laplace_probs(F, p_eos, characters):
    total = Decimal(sum(F.values()))
    seen = Decimal(0)
    probs = {}
    cumprobs = {}
    for char in characters:
        probs[char] = prob(F[char] / total * (1 - p_eos))
        p_lo = seen / total * Decimal(0.95)
        seen += F[char]
        p_hi = seen / total * Decimal(0.95)
        cumprobs[char] = cumprob(p_lo, p_hi)
    probs['#'] = p_eos
    cumprobs['#'] = cumprob(Decimal(0.95), Decimal(1.))
    return probs, cumprobs


def code(sequence: str,
         characters=('A', 'B', 'D', 'E', 'F'),
         p_eos: float = 0.05):
    p_eos = Decimal(p_eos)
    lo, hi = Decimal(0), Decimal(1)
    F = Counter(characters)

    for char in sequence:
        probs, cumprobs = laplace_probs(F, p_eos, characters)

        lo, hi = lo + (hi - lo) * cumprobs[char].lo, lo + (
            hi - lo) * cumprobs[char].hi

        F[char] += 1

    low, high = lo, hi

    i = Decimal(0.5)
    rep = ''
    while lo != 0:
        if lo <= i < hi:
            rep += '1'
            return low, high, rep
        elif i < lo and i < hi:
            lo -= i
            hi -= i
            rep += '1'
        else:
            rep += '0'
        i /= 2

    return low, high, rep


if __name__ == '__main__':
    lo, hi, rep = code('DEADBEEF#')
    print(f'{lo}\n{hi}\n{rep}')
