const chai = require("chai");
const path = require("path");
const { getPermutationMatrix } = require("../index.js");

const wasm_tester = require("circom_tester").wasm;

const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);

const assert = chai.assert;

describe("Median test", function () {
    this.timeout(100000000);

    it("should calculate the median of an unsorted array", async () => {
        const circuit = await wasm_tester(path.join(__dirname, "circuits", "median_test.circom"));

        const unsortedValues = Array.from({length: 69}, () => Math.floor(Math.random() * 77));
        const sortedValues = [...unsortedValues].sort((a, b) => a - b);
        const sortingKey = getPermutationMatrix(sortedValues, unsortedValues);

        const INPUT = {
            "unsortedValues": unsortedValues.map(v => v.toString()),
            "sortingKey": sortingKey.map((row) => row.map(v => v.toString()))
        }

        const witness = await circuit.calculateWitness(INPUT, true);

        assert(Fr.eq(Fr.e(witness[0]),Fr.e(1)));
        assert(Fr.eq(Fr.e(witness[1]),Fr.e(sortedValues[Math.floor(sortedValues.length/2)])));
    });
});