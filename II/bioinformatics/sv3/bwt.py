import typer


def bwt(sequence):
    """
    :param sequence: the sequence to transform; terminated by '#'
    :type sequence: str
    :return: burrels wheeler transformation of the input
    :rtype: str
    """
    # sorted rotation matrix
    matrix = sorted(
        (sequence[i:] + sequence[:i] for i in range(len(sequence))),
        key=lambda x: "".join(x))
    # n.b. sorted is stable

    # last column
    return ''.join((s[-1] for s in matrix))


def invert(sequence):
    """
    :param sequence: burrels wheeler transformed sequence
    :type sequence: str
    :return: original sequence
    :rtype: str
    """
    # indices of first occurrence for each character in the last column
    last_indices = {base: sequence.index(base) for base in set(sequence)}

    # first column
    firstcol = ''.join(sorted(sequence))

    # indices of first occurrence for each character in the first column
    first_indices = {base: firstcol.index(base) for base in set(sequence)}

    # reversed accumulator of genomes
    genome = ['$']
    index = 0
    for _ in range(len(sequence) - 1):
        genome.append(sequence[index])
        count = sequence[:index].count(sequence[index])
        index = first_indices[sequence[index]] + count

    return ''.join(reversed(genome))


def main(seq:str = 'CATTATATAG$'):
    # GCTTT$AATAA
    seq = bwt(seq)
    print(seq)

    # CATTATATAG$
    invert(seq)


if __name__ == '__main__':
    typer.run(main)

