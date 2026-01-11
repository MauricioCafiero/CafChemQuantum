namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        Message("Measuring effect of gates in Z basis: default qubit, no gate.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureDefaultQubit
        Sample(4096, PauliZ, I, false, MeasureQubit);

        Message("Measuring effect of X gate in Z basis: default qubit, X gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, X, false, MeasureQubit);

        Message("Measuring effect of Z gate in Z basis: default qubit, Z gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, Z, false, MeasureQubit);

        Message("Measuring effect of Y gate in Z basis: default qubit, Y gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, Y, false, MeasureQubit);

        Message("=============================================================================");

        Message("Measuring effect of gates in Z basis: superposition qubit, no gate.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureDefaultQubit
        Sample(4096, PauliZ, I, true, MeasureQubit);

        Message("Measuring effect of X gate in Z basis: superposition qubit, X gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, X, true, MeasureQubit);

        Message("Measuring effect of Z gate in Z basis: superposition qubit, Z gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, Z, true, MeasureQubit);

        Message("Measuring effect of Y gate in Z basis: superposition qubit, Y gate applied.");
        // call the sample operation, indicating measurement along the Z axis using the 
        // operation MeasureSuperpositionQubit
        Sample(4096, PauliZ, Y, true, MeasureQubit);
    }

    operation Sample(iterations: Int, basis: Pauli, g1: (Qubit => Unit), super_flag: Bool, op: ((Pauli, (Qubit => Unit), Bool) => Result)): Unit {
        // Performs a series of measurements
        // Args:
        //     iterations: how many trials to run
        //     basis: which basis to use for measurments
        //     g1: a gate to apply
        //     super_flag: whether or not to apply superposition
        //     op: an operation that measures and yields the result

        mutable running_total = 0; // how many in the |1> state

        for idx in 1..1..iterations{
            let result = op(basis, g1, super_flag);
            if result == One {
                running_total += 1
            }
            //set running_total += result == One ? 1 | 0; //use this for compactness
        }

        Message("Measurement Results:");
        Message($"|0> state: {iterations - running_total}.");
        Message($"|1> state: {running_total}.");
    }

    operation MeasureQubit(basis: Pauli, g1: (Qubit => Unit), super_flag: Bool) : Result {
        // accepts a measurement operator, allocates a qubit, 
        // applies Hadamard transformation if the flag is true,
        // performs the measurement, and returns the results
        // Args:
        //      basis: the measurement operator
        //     g1: a gate to apply
        //     super_flag: whether or not to apply superposition 
        // Returns:
        //      result: the result of the measurement

        use q1 = Qubit();
        if super_flag == true {
            H(q1);
        };
        g1(q1);
        let result = Measure([basis], [q1]);

        Reset(q1);
        return result;
    }
}