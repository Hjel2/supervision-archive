def middle_node(lo, hi, left, right, u, v, score):
    mid = (left + right) // 2

    # prefix
    prefix = [0]
    for i in range(lo, hi):
        prefix.append(prefix[-1] + score[u[i]]["_"])
    for i in range(left, mid):
        prefix_tmp = [prefix[0] + score[v[i]]["_"]]
        for j in range(lo, hi):
            prefix_tmp.append(
                max(
                    prefix[j - lo] + score[v[i]]["_"],
                    prefix[j - lo] + score[v[i]][v[j]],
                    prefix_tmp[-1] + score[u[j]]["_"],
                )
            )
        prefix = prefix_tmp

    # suffix
    suffix = [0 for _ in range(hi - lo + 1)]
    for i in range(hi - 1, lo - 1, -1):
        suffix[i - lo] = suffix[i - lo + 1] + score[u[i]]["_"]
    directions = ["↓" for _ in range(hi - lo + 1)]
    for i in range(right - 1, mid - 1, -1):
        suffix_tmp = [0 for _ in range(hi - lo + 1)]
        suffix_tmp[-1] = suffix[-1] + score[v[i]]["_"]
        for j in range(hi - 1, lo - 1, -1):
            suffix_tmp[j - lo] = max(
                suffix[j - lo + 1] + score[v[i]][u[j]],
                suffix[j - lo] + score[v[i]]["_"],
                suffix_tmp[j - lo + 1] + score[u[j]]["_"],
            )
            if i == mid:
                if suffix_tmp[j - lo] == suffix[j - lo + 1] + score[v[i]][u[j]]:
                    directions[j - lo] = "searrow"
                elif suffix_tmp[j - lo] == suffix[j - lo] + score[v[i]]["_"]:
                    directions[j - lo] = "to"
                elif suffix_tmp[j - lo] == suffix_tmp[j - lo + 1] + score[u[j]]["_"]:
                    directions[j - lo] = "darr"
                else:
                    assert False
        suffix = suffix_tmp

    m = max(range(hi - lo + 1), key=lambda x: prefix[x] + suffix[x])

    return (mid, m + lo), directions[m]  # middle node!


def linear_space_alignment(lo, hi, left, right, u, v, score):
    if hi == lo or hi == lo + 1:
        return [(x, lo) for x in range(left + 1, right)]
    node, edge = middle_node(lo, hi, left, right, u, v, score)
    (xmid, ymid) = node
    left_alignment = linear_space_alignment(lo, ymid, left, xmid, u, v, score)
    if edge in {"to", "searrow"}:
        xmid += 1
    if edge in {"darr", "searrow"}:
        ymid += 1
    right_alignment = linear_space_alignment(ymid, hi, xmid, right, u, v, score)

    return left_alignment + [node, (xmid, ymid)] + right_alignment


def reduced_storage_global_alignment(u, v, score):
    alignment = [(0, 0)]
    alignment.extend(linear_space_alignment(0, len(u), 0, len(v), u, v, score))
    return alignment
