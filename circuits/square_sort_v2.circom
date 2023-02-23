pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib-matrix/circuits/matMul.circom";
include "./matDeterminant.circom";

template SquareSortV2(n) {
    /*
        inputs
    */
    // raw values to be sorted
    signal input unsortedValues[n];

    // determinant of permutation matrix
    signal input determinantOfA;

    // permutation matrix
    signal input permutationMatrixA[n][n];

    /*
        outputs
    */
    // sorted values will be assigned from the result of the matrix multiplication
    signal output sortedValues[n];

    /*
        constraints generation
    */
    // instantiate matDeterminant component
    component determinant = matDeterminant(n);
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
            // constraint: elements in permutation matrix are binary
            permutationMatrixA[i][j] * (1 - permutationMatrixA[i][j]) === 0;

            // feed matDeterminant component inputs
            determinant.in[i][j] <== permutationMatrixA[i][j];
        }
    }

    // constraint: the provided value for determinantOfA is the determinant of permutationMatrixA
    determinant.out === determinantOfA;

    // constraint: the value of the determinant is either 1 or -1
    (determinantOfA + 1) * (determinantOfA - 1) === 0;

    // instantiate matMul component
    component m = matMul(n, n, 1);
    for (var i = 0; i < n; i++) {
        // feed matMul vector inputs
        m.b[i][0] <== unsortedValues[i];
        for (var j = 0; j < n; j++) {
            // feed matMul matrix inputs
            m.a[i][j] <== permutationMatrixA[i][j];
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

    // assign the sorted values to the template's output
    for (var i = 0; i < n; i++) {
        sortedValues[i] <== m.out[i][0];
    }
}