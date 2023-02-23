pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib-matrix/circuits/matMul.circom";

template SquareSort(n) {
    // public
    signal input unsortedValues[n];
    signal output sortedValues[n];

    // private
    signal input sortingKey[n][n];

    // verify sorting key is binary and composed only of unit vectors
    for (var i = 0; i < n; i++) {
        var sortingSum = 0;
        for (var j = 0; j < n; j++) {
            sortingKey[i][j] * (1 - sortingKey[i][j]) === 0;
            sortingSum += sortingKey[i][j];
        }
        sortingSum === 1;
    }

    // verify sorted data is a permutation of the unsorted data
    component m = matMul(n, n, 1);
    for (var i = 0; i < n; i++) {
        m.b[i][0] <== unsortedValues[i];
        for (var j = 0; j < n; j++) {
            m.a[i][j] <== sortingKey[i][j];
        }
    }

    // verify permutated array is sorted
    component isSorted[n - 1];
    for (var i = 0; i < n - 1; i++) {
        isSorted[i] = LessEqThan(252);
        isSorted[i].in[0] <== m.out[i][0];
        isSorted[i].in[1] <== m.out[i+1][0];
        isSorted[i].out === 1;
    }

    // return the sorted values
    for (var i = 0; i < n; i++) {
        sortedValues[i] <== m.out[i][0];
    }
}