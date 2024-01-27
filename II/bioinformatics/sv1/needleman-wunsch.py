def needleman_wunsch(v: str, w: str, score: dict[tuple[str, str], float]) -> float:
    mem: list[list] = [[None for _ in range(len(w) + 1)] for _ in range(len(v) + 1)]

    mem[0][0] = 0

    for i in range(1, len(v) + 1):
        mem[i][0] = mem[i - 1][0] + score["_", v[i - 1]]

    for j in range(1, len(w) + 1):
        mem[0][j] = mem[0][j - 1] + score["_", w[j - 1]]

    for i in range(1, len(v) + 1):
        for j in range(1, len(w) + 1):
            mem[i][j] = max(
                mem[i - 1][j - 1] + score[v[i - 1], w[j - 1]],
                mem[i - 1][j] + score["_", w[j - 1]],
                mem[i][j - 1] + score["_", v[i - 1]],
            )

    return mem[-1][-1]


if __name__ == '__main__':
    print(
        needleman_wunsch(
            "CGTGAA",
            "GACTTAC",
            {
                ("_", "A"): -4,
                ("_", "T"): -4,
                ("_", "C"): -4,
                ("_", "G"): -4,
                ("_", "_"): -4,
                ("A", "A"): 5,
                ("A", "T"): -3,
                ("A", "C"): -3,
                ("A", "G"): -3,
                ("A", "_"): -4,
                ("T", "A"): -3,
                ("T", "T"): 5,
                ("T", "C"): -3,
                ("T", "G"): -3,
                ("T", "_"): -4,
                ("C", "A"): -3,
                ("C", "T"): -3,
                ("C", "C"): 5,
                ("C", "G"): -3,
                ("C", "_"): -4,
                ("G", "A"): -3,
                ("G", "T"): -3,
                ("G", "C"): -3,
                ("G", "G"): 5,
                ("G", "_"): -4,
            }
        )
    )