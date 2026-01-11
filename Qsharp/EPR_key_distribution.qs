namespace TestState {
    import Std.Random.DrawRandomBool;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    @EntryPoint()
    operation Main() : Unit {
        distribute_key(128, 0.0);
        distribute_key(128, 0.5);
        distribute_key(128, 1.0);
    }

    operation distribute_key(key_length: Int, prob_eavesdropping: Double) : Unit {
        // quantum key distribution done in rounds to keep quibit size small
        // Args:
        //      key_length: expected key length
        //      prob_eavesdropping: likelihood of an eavesdropper
        let qubit_size = 4*key_length;
        mutable sender_results = [false, size=0];
        mutable receiver_results = [false, size = 0];

        let sender_bases = generate_random_bits(qubit_size);
        let receiver_bases = generate_random_bits(qubit_size);

        for i in 0..qubit_size-1 {
           
            // Create entangled pair
            use (sender_q, receiver_q) = (Qubit(), Qubit());
            H(sender_q);
            CNOT(sender_q, receiver_q);

            // eavesdropping?
            eavesdrop(prob_eavesdropping, [receiver_q]);

            // Choose measurement randomly
            if (DrawRandomBool(0.5)) {
                set sender_results += [perform_measurement(sender_bases[i], sender_q)];
                set receiver_results += [perform_measurement(receiver_bases[i], receiver_q)];
            } else {
                set receiver_results += [perform_measurement(receiver_bases[i], receiver_q)];
                set sender_results += [perform_measurement(sender_bases[i], sender_q)];
            }
            ResetAll([sender_q, receiver_q]);
        } 
        let (sender_key, receiver_key) = compare_results(sender_bases, sender_results, receiver_bases, receiver_results);

        //check for eavesdropping and drop compromised qubits
        let (error_rate, trimmed_sender_key, trimmed_receiver_key) = 
                eavesdropping_test(sender_key, receiver_key);

        // check final results
        final_results(trimmed_sender_key, trimmed_receiver_key);
    }

    operation generate_random_bits(num_bits: Int) : Bool[] {
        // generate num_bits number of random bits, return as Booleans
        //Args:
        //      num_bits: number of bits to generate
        //Returns:
        //      new_bits: random bits

        mutable new_bits = [false, size = num_bits];

        for i in 0..num_bits-1 {
            let random_bit = DrawRandomBool(0.5);
            set new_bits w/= i <- random_bit;
        };
        return new_bits;
    }

    operation eavesdrop(prob_eavesdropping: Double, qubits: Qubit[]) : Unit {
        // Eavesdrop or not based on probability
        //Args:
        //  prob_eavesdropping: likelihood of eavesdropping
        //  qubits: message quibits

        for qubit in qubits {
            let should_eavesdrop = DrawRandomBool(prob_eavesdropping);
            if should_eavesdrop {
                let eavesdropping_basis = DrawRandomBool(0.5);
                if eavesdropping_basis{
                    Measure([PauliX],[qubit]);
                } else {
                    Measure([PauliZ], [qubit]);
                }
            }
        }
    }

    operation perform_measurement(current_basis: Bool, qubit: Qubit) : Bool {
        // measure qubits ccording to bases provided
        // 0 --> Z basis | 1 --> X basis
        //Args:
        //      current_basis: basis used for bit measurement
        //      qubit: qubit transmitted

       
        //if bases value if true, measure in X basis
        if current_basis {
            let result = Measure([PauliX], [qubit]);
            let decoded_bit = ResultAsBool(result);
            return decoded_bit;
        } else {
            let result = Measure([PauliZ], [qubit]);
            let decoded_bit = ResultAsBool(result);
            return decoded_bit;
        };  
    }

    function compare_results(sender_bases: Bool[], sender_values: Bool[], 
                            receiver_bases: Bool[], receiver_results: Bool[]) :
                            (Bool[], Bool[]) {
        //send and receiver compare bases
        //Args:
        //  sender bases
        //  sender_values: bit values for sender
        //  receiver_bases
        //  receiver_results: measurement results for receiver

        mutable sender_matching_bits = [false, size=0];
        mutable receiver_matching_bits = [false, size=0];

        for i in 0..Length(sender_bases)-1 {
            if sender_bases[i] == receiver_bases[i] {
                set sender_matching_bits += [sender_values[i]];
                set receiver_matching_bits += [receiver_results[i]];
            }
        }
        return (sender_matching_bits, receiver_matching_bits);
    }

    operation eavesdropping_test(total_sender_key: Bool[], total_receiver_key: Bool[]) :
                (Double, Bool[], Bool[]) {
        // Choose 50% of bits to check for eavesdropping
        //Args:
        //

        mutable trimmed_sender_key = [false, size=0];
        mutable trimmed_receiver_key = [false, size=0];
        mutable idx_eavesdropping = [0, size=0];

        for i in 0..Length(total_sender_key)-1 {
            let check_flag = DrawRandomBool(0.5);
            if check_flag {
                set idx_eavesdropping += [i];
            } else {
                set trimmed_sender_key += [total_sender_key[i]];
                set trimmed_receiver_key += [total_receiver_key[i]];
            }
        }
        mutable diffs = 0;
        for i in idx_eavesdropping {
            if total_sender_key[i] != total_receiver_key[i] {
                set diffs += 1;
            }
        }
        let error_rate = IntAsDouble(diffs)/IntAsDouble(Length(idx_eavesdropping));
        Message($"Found error rate in keys of {IntAsDouble(100)*error_rate}.");
        if error_rate > 0.05 {
            Message("Eavesdropper detected.");
        } else {
            Message("No eavesdropping detected.")
        }
        
        return (error_rate, trimmed_sender_key, trimmed_receiver_key);
    }

    function final_results(total_sender_key: Bool[], total_receiver_key: Bool[]) :
                            Unit {
        // check final keys
        //Args:
        //      total_sender_key
        //      total_receiver_key

        let int_sender_key = BoolArrayAsBigInt(total_sender_key);
        let int_receiver_key = BoolArrayAsBigInt(total_receiver_key);

        Message($"Sender   Key: {int_sender_key}.");
        Message($"Receiver Key: {int_receiver_key}");

        if int_sender_key == int_receiver_key {
            Message("Key distribution successful");
        } else {
            Message("Key distribution unsuccessful.");
        }
        Message("===================================================")
    }

}