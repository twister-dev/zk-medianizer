import numpy as np
from numba import jit

@jit(nopython=True)
def __get_permutation_matrix(x, y):
    # https://math.stackexchange.com/questions/4098438/finding-the-closest-permutation-matrix-given-two-vectors
    found_indices = set()
    permutation_matrix = np.zeros((x.size, x.size))
    for i in range(x.size):
        for j in range(x.size):
            if x[i] == y[j]:
                if j not in found_indices:
                    permutation_matrix[i, j] = 1
                    found_indices.add(j)
                    break
    return permutation_matrix

def get_permutation_matrix(x, y):
    if type(x) != np.ndarray or type(y) != np.ndarray:
        raise ValueError("get_permutation_matrix: Incorrect type! Expected numpy arrays.")
    if x.size != y.size:
        raise ValueError("get_permutation_matrix: Mismatched array lengths!")
    return __get_permutation_matrix_by_loop(x, y)
