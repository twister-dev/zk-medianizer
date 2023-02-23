function getPermutationMatrix(y, x) {
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
    // b = Ax
    const b = new Array(x.length);
    a.map((row, i) => {
        b[i] = row.map((r, j) => r * x[j]).reduce((m, n) => m + n);
    });
    return b;
}

const x = [1, 7, 3, 3, 2, 8, 4, 0, 4, 6, 42, 343];
const y = [...x].sort((a, b) => a - b);

const a = getPermutationMatrix(y, x);
const b = matrixMultiplyVectorRow(a, x);

console.log("Unsorted:");
console.log(x);
console.log("Sorted:");
console.log(y);
console.log("Weighted:");
console.log(b);