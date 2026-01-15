# Basics of Q#

Q# is a high-level language developed by Microsoft to interface with quantum computers. It gets compiled to *Quantum Intermediate Representation* (QIR) which is machine-agnostic. This can then be further interpreted on each machine.

The easiest way to work with Q# is to install the Microsoft Azure Quantum extension and QDK for VS Code. The QDK includes a virtual machine to run simulations of the code before running it on actual hardware. 

## Program structure / namespaces
You can start the program file (.qs extension) by definign a namespace for your work:
```
namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;
}
```
The rest of the code goes within the outer {}. This namespace contains several libraries:
- Intrinsic: contains basic operations such as gates and qubit reset functions.
- Canon: contains higher level functions like ApplyToEach, or Apply QFT.
- Measurement: contains measurement functions.
- Convert: contains functions like IntAsDouble, or ResuiltAsBool.

Loading too many libraries into one namespace may cause some overlap of function names.

## Functions, Operations and the EntryPoint 
A function in Q# is what you would expect. When a function performs operations on a qubit, it must be labelled as an *operation*. One function or operation in your code must be labelled with the ```@EntryPoint()``` decorator
```
namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        //This is the main function
    }
}
```

You can see the comments offset by ```//```. The ```: Unit``` after the fucntion declaration means that the function does not return any values (like Void in C). 

## Variable types
Q# has the usual types, as well as some types specific to quantum computing:
- Int
- Double
- String
- Bool

These variable types are declared in a function specification (see below) or with the ```let``` or ```mutable``` keywords. Q# will infer variable types whenever it is able. Arays are declared with [].
```
let system_length = 6;
mutable results = Bool[false, size=0];
```
The specific quantum related variable types include:
- Qubit: this defines a qubit. A qubit is created in the 0 state by default with the ```use``` keyword, and must be in the 0 state when the program ends. Qubits may be declared and reset as below:
```
use (q1, q2) = (Qubit(), Qubit());

ResetAll([q1, q2]);  // alternately use Reset(q1), etc...
```
- Result: this is a measurment result and can be Zero or One. You can generate a result in the computational (z) basis using the simple measurement operator: ```M```, or you can specify a measurement basis with ```Measure```:
```
use (q1, q2) = (Qubit(), Qubit());

// Put both into superposition
H(q1);
H(q2);

let q1_z_result = M(q1);
let q2_x_result = Measure([PauliX], [q2]);
```
In these cases q1_z_result would be 50% One and 50% Zero as it is in superposition. The q1_x_result would be 100% Zero since in the X basis, the superposition state *is* the basis state. The results are often turned into Booleans for analysis:
```
let q1Z_bool = ResultAsBool(q1_z_result);
let q2X_bool = ResultAsBool(q2_x_result);
```
In this conversion, 0 --> false and 1 --> true (for the computational basis), or $\ket{+}$ --> 0 --> false and $\ket{-}$ --> 1 --> true (for the X-basis).
- Pauli: in the above examle we intorduce the *Pauli* type. This type specifies a basis for measurement and can take on values: *PauliX, PauliY, and PauliZ* as seen above.

## Operations and functions
In order to demonstrate an operation, we will make a function that performs the measurements shown above:
```
operation test_measure(flip_flag: Bool): (Bool, Bool) {
        use (q1, q2) = (Qubit(), Qubit());
        H(q1);

        if flip_flag {
           X(q2);
        }
        H(q2);
        let q1_z_result = M(q1);
        let q2_x_result = Measure([PauliX], [q2]);

        let q1Z_bool = ResultAsBool(q1_z_result);
        let q2X_bool = ResultAsBool(q2_x_result);

        ResetAll([q1, q2]);
        
        return (q1Z_bool, q2X_bool);
    }
```

## Loops and conditionals
### Appending arrays
## Sample code
[Here](https://github.com/MauricioCafiero/CafChemQuantum/tree/main/Qsharp), you can find Q# Code for:
- Superposition
- Entanglement
- Entanglement swapping
- Teleportation
- BB84 Quantum Key Distribution
- B92 Quantum Key Distribution
- EPR Quantum Key Distribution
- Eigenvalue solving (quantum phase estimation)
