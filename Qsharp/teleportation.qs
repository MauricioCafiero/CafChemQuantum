namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation Main() : Unit {
        // performs quantum teleportation
        // Args:
        //     None
        // Variables used:
        //     teleports_done: count of successful teleportations
        //     message: message qubit to send
        //     source: qubit form entangled pair that reverse entangles with message
        //     target: qubit to receive message qubit.

        mutable teleports_done = 0;

        for i in 1..1..4096 {
            use (message, source, target) = (Qubit(), Qubit(), Qubit());
            //set arbitrary state a|0> + b|1>
            prep_initial_state(message);
            // execute teleportation circuit
            teleport(message, source, target);
            //transform target according to initial state
            Adjoint prep_initial_state(target);

            // measure target state and compare to message
            set teleports_done += M(target) == Zero ? 1 | 0;

            ResetAll([message, source, target]);
        }
        Message($"Percent of succesful teleportations: {teleports_done} out of 4096.");
    }

    operation prep_initial_state(q1: Qubit) : Unit is Adj + Ctl {
        Rx( 1.0 * PI() / 2.0, q1);
        Ry( 2.0 * PI() / 3.0, q1);
        Rz( 3.0 * PI() / 4.0, q1);
    }

    operation teleport(message: Qubit, source: Qubit, target: Qubit): Unit {
        //entangle pair for communication
        // Args:
        //     message: message qubit to send
        //     source: qubit form entangled pair that reverse entangles with message
        //     target: qubit to receive message qubit.
        H(source);
        CNOT(source, target);

        // reverse-entangle message and source qubit
        CNOT(message, source);
        H(message);

        // measure message and source
        let message_result = M(message) == Zero;
        let source_result = M(source) == Zero;

        decode_target(message_result, source_result, target);
    }

    operation decode_target(message_result: Bool, source_result: Bool, target: Qubit) : Unit {
        // depending on the measurements of message and source, apply transformations
        // Args:
        //     message_result: measurement of message qubit to send
        //     source_result: measurement of qubit form entangled 
        //                    pair that reverse entangles with message
        //     target: qubit to receive message qubit.

        if message_result and source_result {
            I(target);
        } elif message_result and not source_result {
            X(target);
        } elif not message_result and source_result {
            Z(target);
        } elif not message_result and not source_result {
            Z(target);
            X(target);
        }
    }
}