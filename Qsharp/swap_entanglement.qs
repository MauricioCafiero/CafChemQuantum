namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Unit {
        // swaps entangled qubits
        // Args:
        //     None
        // Variables used:
        //     teleports_done: count of successful teleportations
        //     message: message qubit to send
        //     source: qubit form entangled pair that reverse entangles with message
        //     target: qubit to receive message qubit.

        mutable qubits_swapped = 0;
        mutable final_results = [0, 0, 0, 0];

        for i in 1..1..4096 {
            let (res1, res3) = swap_entanglement();

            if (not res1 and not res3) {
                set final_results w/=0 <- final_results[0]+1;
            } elif (not res1 and res3) {
                set final_results w/=1 <- final_results[1]+1;
            } elif (res1 and not res3) {
                set final_results w/= 2 <- final_results[2]+1;
            } elif (res1 and res3) {
                set final_results w/= 3 <- final_results[3]+1;
            }

            if res1 == res3 {
                set qubits_swapped += 1;
            }
        }

        Message($"Measured |00>: {final_results[0]}");
        Message($"Measured |01>: {final_results[1]}");
        Message($"Measured |10>: {final_results[2]}");
        Message($"Measured |11>: {final_results[3]}");
        Message($"Percent of succesful teleportation swaps: {qubits_swapped} out of 4096.");
    }

    operation swap_entanglement(): (Bool, Bool) {
        // swap entangled pairs 
        // 
        use (q1, q2, q3, q4) = (Qubit(), Qubit(), Qubit(), Qubit());

        // entangle first pair
        prep_entangled(q1, q2);

        // entangle second pair
        prep_entangled(q3, q4);
        
        // Bell measure on q2, q4 (one from each entangled pair)
        CNOT(q2, q4);
        H(q2);

        let q2_result = M(q2);
        let q4_result = M(q4);

        // final meaurement on q1, q3 based on measurements of q2, q4
        decode_qubit(q2_result, q4_result, q3);

        Adjoint prep_entangled(q1, q3);

        let q1_result = ResultAsBool(M(q1));
        let q3_result = ResultAsBool(M(q3));

        ResetAll([q1,q2,q3,q4]);

        return (q1_result, q3_result);
    }

    operation decode_qubit(q2_result: Result, q4_result: Result, q3: Qubit) : Unit {
        // depending on the measurements of q2 and q4, apply transformations
        // Args:
        //     q2_result
        //     q4_result

        if q2_result == Zero and q4_result == Zero {
            I(q3);
        } elif q2_result == Zero and q4_result == One {
            X(q3);
        } elif q2_result == One and q4_result == Zero {
            Z(q3);
        } elif q2_result == One and q4_result == One {
            Z(q3);
            X(q3);
        }
    }

    operation prep_entangled(q1: Qubit, q2: Qubit): Unit is Adj + Ctl {
        // entangle two qubits
        H(q1);
        CNOT(q1,q2);
    }

}