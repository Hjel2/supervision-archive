class Node:

    def __init__(self, value, subtrie):
        super().__init__()
        self.value = value
        self.subtrie = subtrie

    def __getitem__(self, key):
        if key == '':
            return self.value
        for seq, rem in map(lambda i: (key[:i], key[i:]), range(len(key) + 1)):
            if seq in self.subtrie:
                return self.subtrie[seq][rem]

    def __setitem__(self, key, value):
        if key == '':
            self.value = value
        for seq, rem in map(lambda i: (key[:i], key[i:]), range(len(key))):
            if seq in self.subtrie:
                self.subtrie[seq][rem] = value

        newtrie = Node(
            value, {
                suffixkey[len(key):]: self.subtrie.pop(suffixkey)
                for suffixkey in list(
                    filter(
                        lambda x: len(x) != len(key) and x[:len(key)] == key,
                        self.subtrie))
            })

        self.subtrie[key] = newtrie

    def __repr__(self):
        return str(dict(self.subtrie))


class SuffixTrie(Node):

    def __init__(self):
        super().__init__(None, {})
        self.value_set = False

    def __getitem__(self, key):
        if key == '' and self.value_set is False:
            raise KeyError
        else:
            return super().__getitem__(key)

    def __setitem__(self, key, value):
        if key == '' and self.value_set is False:
            self.value_set = True
        else:
            super().__setitem__(key, value)
