def landin(f, n):
    global r
    r = lambda n: 0
    recur = lambda n: r(n)
    r = lambda n: f(recur, n)
    return recur(n)

print(landin((lambda f, v: 1 if v == 1 else v * f(v - 1)), 4))
