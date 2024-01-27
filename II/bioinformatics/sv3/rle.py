from itertools import chain


def rle(sequence):
    """
    :param sequence: the string to encode
    :type sequence: str
    :return: a run length encoding of the sequence
    :rtype: str
    """

    rle_str = ''

    count = 1
    current = sequence[0]

    # "#" is a character not occurring in sequence
    for c in chain(sequence[1:], '#'):
        if c == current:
            count += 1
        else:
            rle_str += f'{count}{current}'
            count = 1
            current = c

    return rle_str


if __name__ == '__main__':
    # 1C1A2T1A1T1A1T1A1G1$
    rle('CATTATATAG$')

    # 1G1C3T1$2A1T2A
    rle(bwt('CATTATATAG$'))
