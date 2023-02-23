pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib-matrix/circuits/matMul.circom";

template HashChain(n) {
    signal input values[n];
    signal output hash;

    component hashers[n];

    // hash = poseidon(poseidon(poseidon(0, values[0]), values[1]),values[2])...
    for (var i = 0; i < n; i++) {
        hashers[i] = Poseidon(2);
        hashers[i].inputs[0] <== i == 0 ? 0 : hashers[i-1].out;
        hashers[i].inputs[1] <== values[i];
    }

    hash <== hashers[n-1].out;
}

template MedianOptimal(n) {
    // public
    signal input unsortedValuesHash;
    signal output medianValue;

    // private
    signal input unsortedValues[n];
    signal input sortingKey[n][n];

    // verify unsorted data against hash
    component hashChain = HashChain(n);
    for (var i = 0; i < n; i++) {
        hashChain.values[i] <== unsortedValues[i];
    }
    hashChain.hash === unsortedValuesHash;

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
    component isSorted[n - 1];
    for (var i = 0; i < n - 1; i++) {
        isSorted[i] = LessEqThan(252);
        isSorted[i].in[0] <== m.out[i][0];
        isSorted[i].in[1] <== m.out[i+1][0];
        isSorted[i].out === 1;
    }

    // median value is the center value in the sorted array
    medianValue <== m.out[n\2][0];
}
