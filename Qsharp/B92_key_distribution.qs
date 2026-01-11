namespace TestState {
    import Std.Random.DrawRandomBool;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;

    @EntryPoint()
    operation Main() : Unit {
        distribute_key(32, 16, 0.0);
        distribute_key(32, 16, 0.5);
        distribute_key(32, 16, 1.0);
    }

    operation distribute_key(num_trips: Int, trip_size: Int, prob_eavesdropping: Double) : Unit {
        // quantum key distribution done in rounds to keep quibit size small
        // Args:
        //      num_trips: number of rounds to do
        //      trip_size: number of bits ot process per round
        //      prob_eavesdropping: likelihood of an eavesdropper

        mutable total_sender_key = [false, size=0];
        mutable total_receiver_key = [false, size = 0];

        for trip in 0..num_trips-1 {
            use qubits = Qubit[trip_size];

            // Choose sender key bits
            let sender_values = generate_random_bits(trip_size);

            // sender encode values
            encode_qubits(sender_values, qubits);

            // eavesdropping?
            eavesdrop(prob_eavesdropping, qubits);

            // Choose receiver measurement bases randomly
            let receiver_bases = generate_random_bits(trip_size);

            // receiver decodes bits according to random bases
            let receiver_results = decode_qubits(receiver_bases, qubits);

            // compare sender and receiver bases, discard differences
            let (sender_trip_result, receiver_trip_result) 
                = compare_results(sender_values, receiver_bases, receiver_results);

            // add curent trip values to total
            set total_sender_key += sender_trip_result;
            set total_receiver_key += receiver_trip_result;

            ResetAll(qubits);
        } 
        //check for eavesdropping and drop compromised qubits
        let (error_rate, trimmed_sender_key, trimmed_receiver_key) = 
                eavesdropping_test(total_sender_key, total_receiver_key);

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

    operation encode_qubits(bit_values: Bool[], qubits: Qubit[]) : Unit {
        // Encode qubits ccording to bases provided
        //Args:
        //      bit_values: bits to use in key (flip or not)
        //      qubits: qubits for transmission

        for i in 0..Length(qubits)-1 {
             //if bases value if true, encode in X basis by H gate
            let current_value = bit_values[i];
            if current_value {
                H(qubits[i]);
            };
        };
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

    operation decode_qubits(bases: Bool[], qubits: Qubit[]) : Bool[] {
        // Decode qubits ccording to bases provided
        //Args:
        //      bases: bases used for bit measurement
        //      qubits: qubits transmitted

        mutable decoded_bits = [false, size = 0];

        for i in 0..Length(qubits)-1 {
            //if bases value if true, measure in X basis
            if bases[i] {
                let result = Measure([PauliX], [qubits[i]]);
                set decoded_bits += [ResultAsBool(result)];
            } else {
                let result = Measure([PauliZ], [qubits[i]]);
                set decoded_bits += [ResultAsBool(result)];
            };  
        };
        return decoded_bits;
    }

    function compare_results(sender_values: Bool[], 
                            receiver_bases: Bool[], receiver_results: Bool[]) :
                            (Bool[], Bool[]) {
        //send and receiver compare bases
        //Args:
        //  sender_values: bit values for sender
        //  receiver_bases
        //  receiver_results: measurement results for receiver

        mutable sender_matching_bits = [false, size=0];
        mutable receiver_matching_bits = [false, size=0];

        for i in 0..Length(sender_values)-1 {
            if receiver_results[i] {
                set sender_matching_bits += [sender_values[i]];
                set receiver_matching_bits += [not receiver_bases[i]];
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
            Message("Key disctribution succesful");
        } else {
            Message("Key distribution unsuccessful.");
        }
        Message("===================================================")
    }

}