from bisect import bisect_left, bisect_right


if __name__ == '__main__':
    sequence = ...
    suffix_array = [...]
    prefix = ...
    bisect_left(suffix_array, prefix, key=lambda x: ...)
    bisect_right(suffix_array, prefix, key=lambda x: ...)