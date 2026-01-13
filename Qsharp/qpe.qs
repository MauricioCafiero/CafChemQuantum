namespace TestState {
    import Std.Random.DrawRandomBool;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    @EntryPoint()
    operation Main() : Unit {
        // uses qpe to find the eigenvalue of the operator / oracle
        //
        use eigenfunction = Qubit();

        // should give 0.5, as Z is a 90 degree rotation on the bloch sphere
        test_qpe(prep_oracle(Z), prep_eigenfunction(eigenfunction), 0.5);

        // should give 0.25, as S is a 45 degree rotation on the bloch sphere
        test_qpe(prep_oracle(S), prep_eigenfunction(eigenfunction), 0.25);

        // should give 0.125, as T is a 22.5 degree rotation on the bloch sphere
        test_qpe(prep_oracle(S), prep_eigenfunction(eigenfunction), 0.125);
    }

    operation test_qpe(oracle: (Int, Qubit[]) => Unit is Adj + Ctl, ef: Qubit,
                       expected_ev: Double) : Unit {
        // apply qpe
        //Args:
        //      oracle: Operator to find eigenvalues of
        //      ef: qubit / eigenfunction
        //      expected_ev: expected eigenvalue

        let calc_phase = qpe(ef, oracle, 3);

        Message($"Expected Phase:   {expected_ev}.");
        Message($"Calculated Phase: {calc_phase}.");
    }

    operation prep_eigenfunction(ef: Qubit): Qubit {
        // flips the state of the eigenfunction
        // Args:
        //      ef: eigenfunction / qubit to flip
        // Returns:
        //      ef: transformed ef

        X(ef);
        return ef;
    }

    operation U_op(op: (Qubit) => Unit is Adj + Ctl, power: Int, qubits: Qubit[]) :
                Unit is Adj +  Ctl {
        // Applies the Unitary operation
        // Args:
        //      op: operation to apply
        //      power: how many times to apply
        //      qubits: uses the forst qubit to apply the operation
        for _ in 1..power {
            op(qubits[0]);
        };
    }

    function prep_oracle(op: (Qubit) => Unit is Adj + Ctl) : 
                    ((Int, Qubit[]) => Unit is Adj + Ctl) {
        // applies a partial on U_op: supplies the operation, 
        // but not the power or qubit array
        //Args:
        //      op: operation to apply
        //Returns:
        //      U_op: oracle partial

        return U_op(op, _, _);
    }

    operation qpe(ef: Qubit, oracle: ((Int, Qubit[]) => Unit is Adj + Ctl),
                       precision: Int) : Double {
        // acts on the qubit with the oracle operator, power times
        // Args:
        //      ef: qubit/ eignefunction
        //      oracle: operator ^ power 
        //      precision
        //Returns:
        //      phase: eigenvalue

        use qubits =  Qubit[precision];  
        let register = Reversed(qubits);

        ApplyToEach(H, qubits);

        for i in 0..precision-1 {
            Controlled oracle([qubits[i]], (2^i, [ef]));
        }

        Adjoint ApplyQFT(register);

        let phase = IntAsDouble(MeasureInteger(register)) / IntAsDouble(2^precision);

        ResetAll(qubits);
        Reset(ef);

        return phase;
    }
}