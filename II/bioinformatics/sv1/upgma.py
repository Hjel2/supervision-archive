from itertools import combinations


def upgma(distances):
    # number of elements in the groups
    sizes = {k: 1 for k in distances.keys()}
    # ages of the nodes
    ages = {k: 0 for k in distances.keys()}
    while len(distances) > 1:
        # find the least D_{i,j}
        i, j = min(
            combinations(distances.keys(), 2), key=lambda x: distances[x[0]][x[1]]
        )
        dij = distances[i][j]

        # remove rows and columns i, j
        dist_i = distances.pop(i)
        dist_j = distances.pop(j)
        for dist in distances.values():
            dist.pop(i)
            dist.pop(j)

        # create the new node m
        m = f"({i}, {j})"
        sizes[m] = sizes[i] + sizes[j]
        ages[m] = dij / 2
        dist_m = {
            k: (sizes[i] * dist_i[k] + sizes[j] * dist_j[k]) / (sizes[i] + sizes[j])
            for k in distances.keys()
        }
        for k in distances.keys():
            distances[k][m] = dist_m[k]
        distances[m] = dist_m

    return next(iter(distances)), ages
