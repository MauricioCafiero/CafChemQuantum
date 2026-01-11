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
        //     initial_state: indicates which inital state basis to use: |000>, |001>,
        //                    |010>, |100>, |011>, |101>, |110> or |111>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.

        Message("Creating |000>, entangling, and measuring final states.");
        SampleState(4096, PauliZ, [false, false, false]);

        Message("Creating |111>, entangling, and measuring final states.");
        SampleState(4096, PauliZ, [true, true, true]);

    }

    operation SampleState(iterations: Int, basis: Pauli, initial_state: Bool[]): Unit {
        // Performs a series of measurements
        // Args:
        //     iterations: how many trials to run
        //     basis: which basis to use for measurments
        //     initial_state: indicates which inital state basis to use: |000>, |001>,
        //                    |010>, |100>, |011>, |101>, |110> or |111>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.
        mutable running_total = [0,0,0,0,0,0,0,0];

        for idx in 1..1..iterations{
            mutable result_list = make_test_3q_state(basis, initial_state);
            if (result_list[0] and result_list[1] and result_list[2]) {
                set running_total w/= 0 <- running_total[0]+1;
            } elif (not result_list[0] and not result_list[1] and not result_list[2]) {
                set running_total w/= 7 <- running_total[7]+1;
            } elif (result_list[0] and result_list[1] and not result_list[2]) {
                set running_total w/= 1 <- running_total[1]+1;
            } elif (result_list[0] and not result_list[1] and result_list[2]) {
                set running_total w/= 2 <- running_total[2]+1;
            } elif (not result_list[0] and result_list[1] and result_list[2]) {
                set running_total w/= 3 <- running_total[3]+1;
            } elif (result_list[0] and not result_list[1] and not result_list[2]) {
                set running_total w/= 4 <- running_total[4]+1;
            } elif (not result_list[0] and result_list[1] and not result_list[2]) {
                set running_total w/= 5 <- running_total[5]+1;
            } elif (not result_list[0] and not result_list[1] and result_list[2]) {
                set running_total w/= 6 <- running_total[6]+1;
            }
        }

        Message($"|000> state: {running_total[0]}.");
        Message($"|001> state: {running_total[1]}.");
        Message($"|010> state: {running_total[2]}.");
        Message($"|100> state: {running_total[3]}.");
        Message($"|011> state: {running_total[4]}.");
        Message($"|101> state: {running_total[5]}.");
        Message($"|110> state: {running_total[6]}.");
        Message($"|111> state: {running_total[7]}.");
    }

    operation make_test_3q_state(basis: Pauli, initial_state: Bool[]): Bool[] {
        // Allocates three qubits, places them in the requested initial state, then 
        // entangles them using H(q1) -> CNOT(q1, q2) -> CNOT(q2,q3). 
        // Finally performs a measurements in the requested basis.
        // Args:
        //     basis: which basis to use for measurments
        //     initial_state: indicates which inital state basis to use: |000>, |001>,
        //                    |010>, |100>, |011>, |101>, |110> or |111>.
        //                    false -> 0, true -> 1 indicates whether to flip the initial state with PauliX.
        // Returns:
        //     final_state: boolean array with true -> 0, false -> 1.

        use qs = Qubit[3];
        for q_idx in 0..1..2 {
            if initial_state[q_idx] {
                X(qs[q_idx]);
            };
        };

        H(qs[0]);
        CNOT(qs[0], qs[1]);
        CNOT(qs[1],qs[2]);

        let final_state = [
            Measure([basis], [qs[0]]) == Zero,
            Measure([basis], [qs[1]]) == Zero,
            Measure([basis], [qs[2]]) == Zero
        ];
        
        ResetAll(qs);

        return final_state

    }
}