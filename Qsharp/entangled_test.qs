namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        // Requests a series of measurements
        // Args:
        //     None
        // Variables used:
        //     iterations: how many trials to run
        //     basis: which basis to use for measurments
        //     initial_state: indicates which inital state basis to use: |00>, |01>, |10>, or |11>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.

        Message("Creating |00>, entangling, and measuring final states.");
        SampleBellState(4096, PauliZ, [false, false]);

        Message("Creating |01>, entangling, and measuring final states.");
        SampleBellState(4096, PauliZ, [false, true]);

        Message("Creating |10>, entangling, and measuring final states.");
        SampleBellState(4096, PauliZ, [true, false]);

        Message("Creating |11>, entangling, and measuring final states.");
        SampleBellState(4096, PauliZ, [true, true]);
    }

    operation SampleBellState(iterations: Int, basis: Pauli, initial_state: Bool[]): Unit {
        // Performs a series of measurements
        // Args:
        //     iterations: how many trials to run
        //     basis: which basis to use for measurments
        //     initial_state: indicates which inital state basis to use: |00>, |01>, |10>, or |11>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.
        mutable running_total = [0,0,0,0];

        for idx in 1..1..iterations{
            mutable result_list = make_test_bell_state(basis, initial_state);
            if result_list[0] and result_list[1] {
                set running_total w/= 0 <- running_total[0]+1;
            } elif (not result_list[0] and not result_list[1]) {
                set running_total w/= 3 <- running_total[3]+1;
            } elif (result_list[0] and not result_list[1]) {
                set running_total w/= 1 <- running_total[1]+1;
            } elif (not result_list[0] and result_list[1]) {
                set running_total w/= 2 <- running_total[2]+1;
            }
        }

        Message($"|00> state: {running_total[0]}.");
        Message($"|01> state: {running_total[1]}.");
        Message($"|10> state: {running_total[2]}.");
        Message($"|11> state: {running_total[3]}.");
    }

    operation make_test_bell_state(basis: Pauli, initial_state: Bool[]): Bool[] {
        // Allocates two qubits, places them in the requested initial state, then 
        // entangles them using H(q1) -> CNOT(q1, q2). Finally performs a measurements in the 
        // requested basis.
        // Args:
        //     basis: which basis to use for measurments
        //     initial_state: indicates which inital state basis to use: |00>, |01>, |10>, or |11>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.
        // Returns:
        //     final_state: boolean array with true -> 0, false -> 1.
        mutable final_state = [true, true];

        use (q1, q2) = (Qubit(), Qubit());
        if initial_state[0] {
            X(q1);
        };
        if initial_state[1] {
            X(q2)
        };
        H(q1);
        CNOT(q1, q2);

        let result1 = Measure([basis], [q1]);
        let result2 = Measure([basis], [q2]);

        if result1 == One {
            set final_state w/= 0 <- false;
        }
        if result2 == One {
            set final_state w/= 1 <- false;
        }

        ResetAll([q1, q2]);

        return final_state

    }
}