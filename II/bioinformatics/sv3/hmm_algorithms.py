import numpy as np
from itertools import accumulate

# For simplicity, I ignore the vanishing probabilities problem


def forward(transition_matrix, input_probs, emission_probs, sequence):
    sequence_probs = [input_probs * emission_probs[:, sequence[0]]]
    for i in range(1, len(sequence)):
        probs = sequence_probs[-1]
        state_probs = probs @ transition_matrix
        sequence_probs.append(state_probs * emission_probs[:, sequence[i]])
    return [np.argmax(p) for p in sequence_probs]


def viterbi(transition_matrix, input_probs, emission_probs, sequence):
    sequence_probs = [input_probs + emission_probs[:, sequence[0]]]
    previous_most_likely = []

    for i in range(1, len(sequence)):
        probs = sequence_probs[-1]
        previous = np.argmax(probs * transition_matrix, axis=0)
        previous_most_likely.append(previous)
        state_probs = np.max(probs * transition_matrix, axis=0)
        sequence_probs.append(state_probs + emission_probs[:, sequence[i]])

    index = np.argmax(sequence_probs[-1])

    return list(
        reversed(
            list(
                accumulate(reversed(previous_most_likely),
                           lambda x, prev: prev[x],
                           initial=index))))


if __name__ == '__main__':
    transition_matrix = np.array([
        [0.2, 0.4, 0.4],
        [0.6, 0.1, 0.3],
        [0.8, 0.1, 0.1],
    ])

    initial_vector = np.array([0.3, 0.3, 0.4])

    emission_probs = np.array([
        [0.7, 0.1, 0.1, 0.1],
        [0.7, 0.1, 0.1, 0.1],
        [0.7, 0.1, 0.1, 0.1],
    ])

    forward(transition_matrix, initial_vector, emission_probs,
            [1, 1, 2, 0, 0, 2, 3, 2])
