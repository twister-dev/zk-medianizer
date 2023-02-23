function checkArray(x) {
    if (!Array.isArray(x)) throw new Error("Invalid input type, expected array!");
    x.map(v => {
        if (Array.isArray(v)) {
            checkArray(v);
        } else {
            if (typeof v !== "number") throw new Error("Invalid input type, Expected number!");
        }
    });
}

function getPermutationMatrix(y, x) {
    checkArray(y); checkArray(x);
    if (x.length !== y.length)
        throw new Error("Mismatched array lengths!");

    // y = Ax
    const found = {};
    const a = new Array(x.length);
    for (let i = 0; i < x.length; i++) {
        a[i] = (new Array(x.length)).fill(0);
        for (let j = 0; j < x.length; j++) {
            if (y[i] == x[j]) {
                if (!found[j]) {
                    a[i][j] = 1;
                    found[j] = true;
                    break;
                }
            }
        }
    }
    return a;
}

function matrixMultiplyVectorRow(a, x) {
    checkArray(a); checkArray(x);
    a.map(row => {
        if (row.length !== x.length) throw new Error("Mismatched array lengths!");
    })

    // b = Ax
    const b = new Array(x.length);
    a.map((row, i) => {
        b[i] = row.map((r, j) => r * x[j]).reduce((m, n) => m + n);
    });
    return b;
}

exports.getPermutationMatrix = getPermutationMatrix;
exports.matrixMultiplyVectorRow = matrixMultiplyVectorRow;

Object.assign(module.exports, {
    getPermutationMatrix,
    matrixMultiplyVectorRow,
});