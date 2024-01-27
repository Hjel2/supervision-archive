def hamiltonian(V, E):
    """
    :param V: start node
    :type V: set[str]
    :param E: dictionary of edges E[u] = {v | (u, v) is an edge}
    :type E: dict[str, set[str]]
    :return:
    """
    cycle = [V.pop()]

    def dfs():
        if not V:
            return True
        for v in V.copy():
            if v in E[cycle[-1]]:
                V.remove(v)
                cycle.append(v)
                if dfs():
                    return True
                else:
                    V.add(v)
                    return False

    dfs()

    return cycle
