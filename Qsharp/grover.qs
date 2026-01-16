namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Unit {
        // Grover's algorithm for searchh

        let bit_size = 4;

        for solution in 0..2^bit_size - 1 {
            let oracle = prep_oracle(solution);
            let result = grover(bit_size, oracle);

            Message($"Expected solution: {solution}.");
            Message($"Calculated result: {result}.  ");
        }
    }

    function prep_oracle(solution: Int) : ((Qubit[]) => Unit is Adj) {
        // return a partial of the oracle operation
        return Oracle(solution, _);
    }

    operation Oracle(solution: Int, qubits: Qubit[]) : Unit is Adj {
        // Applies X CZ Z on the qubits
        // Args:
        //      solution: the expected solution
        //      qubits

        let n = Length(qubits);

        within {
            let markers = IntAsBoolArray(solution, n);
            for i in 0..n-1 {
                if not markers[i] {
                    X(qubits[i]);
                }
            }
        } apply {
            Controlled Z(Most(qubits), Tail(qubits));
        }
    }

    operation diffusion(qubits: Qubit[]) : Unit is Adj {
        // applies HX CZ XH
        within {
            ApplyToEachA(H, qubits);
            ApplyToEachA(X, qubits);
        } apply {
            Controlled Z(Most(qubits), Tail(qubits));
        }
    }

    operation grover(n: Int, oracle: (Qubit[]) => Unit is Adj) : Int {
        // grover's algorithm
        // Args:
        //      n: defines size of problem space to search through
        //      oracle: Grover oracle to search
        // Returns:
        //      numer: solution

        let iters = Floor((PI() / 4.0) * Sqrt(IntAsDouble(2^n)));
        Message($"{iters}");
        use qubits = Qubit[n];
        ApplyToEach(H, qubits);

        for x in 1..iters {
            oracle(qubits);
            diffusion(qubits);
        }

        let register = Reversed(qubits);
        let number = MeasureInteger(register);

        //ResetAll(qubits);

        return number;
    }

}