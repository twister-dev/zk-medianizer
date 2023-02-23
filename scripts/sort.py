import time
import numpy as np
from numba import jit

def timethis(func):
    def inner_timethis(*args, **kwargs):
        before = time.perf_counter()
        result = func(*args, **kwargs)
        after = time.perf_counter()
        print(f"{func.__name__} time taken: {after-before: 6.6}s")
        return result
    return inner_timethis

@jit(nopython=True)
def get_permutation_matrix_by_loop(x, y):
    # https://math.stackexchange.com/questions/4098438/finding-the-closest-permutation-matrix-given-two-vectors
    found_indices = set()
    a = np.zeros((x.size, y.size))
    for i in range(x.size):
        for j in range(x.size):
            if x[i] == y[j]:
                if j not in found_indices:
                    a[i, j] = 1
                    found_indices.add(j)
                    break
    return a

@timethis
def get_matrix(x, y):
    if type(x) != np.ndarray or type(y) != np.ndarray:
        raise ValueError("get_permutation_matrix: Incorrect type! Expected numpy arrays.")
    if x.size != y.size:
        raise ValueError("get_permutation_matrix: Mismatched array lengths!")
    return get_permutation_matrix_by_loop(x, y)

x = np.random.randint(low=0, high=2**32-1, size=10001)
y = np.sort(x)

sorting_key = get_matrix(y, x)
b = np.matmul(sorting_key, x)

print(np.median(x))
print(y[y.size//2])
print(np.all(b==y))
