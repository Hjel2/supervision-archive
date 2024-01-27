def eulerian(V, E):
    """
    :param V: start node
    :type V: set[str]
    :param E: dictionary of edges e[u][v] = |{(u, v) | (u, v) is an edge}|
    :type E: dict[str, dict[str, int]]
    :return:
    """
    path = []
    def dfs(u):
        while E[u]:
            v = next(iter(E[u].keys()))
            E[u][v] -= 1
            if not E[u][v]:
                E[u].pop(v)
            dfs(v)
        path.append(u)

    dfs(next(iter(V)))

    return path
