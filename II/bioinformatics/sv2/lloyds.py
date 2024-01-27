import numpy as np


def lloyds(points, k):
    n, d = points.shape
    centres = points[np.random.choice(n, k, replace=False)]
    changed = True

    while changed:
        # broadcast
        distances = points.reshape((1, n, d))
        centres_br = centres.reshape((k, 1, d))

        # indices[i] is the index of the centre closest to the ith point
        indices = np.argmin(
            np.sum((distances - centres_br) ** 2, axis=2) ** 0.5, axis=0
        )

        # count[i] is num points s.t. the ith centre is the closest centre
        _, count = np.unique(indices, return_counts=True)

        # arr[i, j] = 1 iff centre i is the closest centre to the jth point
        arr = np.zeros((k, n))
        arr[indices, np.arange(n)] += 1

        # new_centres[i] is the mean of all points s.t.
        # the ith centre is the closest centre
        new_centres = (arr @ points) / count.reshape(k, 1)

        # check for convergence
        if np.allclose(centres, new_centres):
            changed = False

        centres = new_centres

    return centres


if __name__ == "__main__":
    np.random.seed(0)
    centres = np.array([[0, 0], [0, 5], [5, 0], [5, 5]])
    n_div_4 = 1000
    points = np.full((n_div_4, *centres.shape), centres).reshape(
        4 * n_div_4, centres.shape[1]
    ) + np.random.uniform(-2, 2, (4 * n_div_4, 2))
    lloyds(points, 4)
    # for each centre $\tilde x, \tilde y ~ N(\mu, 0.0316)$
    # [[ 5.01226398e+00 -2.55733633e-02]
    #  [-4.19110650e-02  4.96920291e+00]
    #  [-3.09700334e-02 -1.77992770e-04]
    #  [ 4.99306361e+00  4.98167004e+00]]
