# Basics of Q#

Q# is a high-level language developed by Microsoft to interface with quantum computers. It gets compiled to *Quantum Intermediate Representation* (QIR) which is machine-agnostic. This can then be further interpreted on each machine.

The easiest way to work with Q# is to install the Microsoft Azure Quantum extension and QDK for VS Code. The QDK includes a virtual machine to run simulations of the code before running it on actual hardware. 

- [Program structure](#program-structure-and-namespaces)
- [EntryPoint](#the-entrypoint)
- [Variable types](#variable-types)
- [Functions and Operations](#operations-and-functions)
- [Loops and conditionals](#loops-and-conditionals)
- [Running the code](#running-the-code)
- [Sample Code](#sample-code)

## Program structure and namespaces
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

## The EntryPoint 
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
- Operation declaration: ```test_measure(flip_flag: Bool): (Bool, Bool)``` shows the incoming variables (flip_flag) and specifies that the return value will be a tuple of Bools.
- Conditional: this will be further explained below, but it is a standard if statement.
- Return: The return statement send back the values to the function call.

If this did not operate on qubits, we could have declared it as a function rather than an operation. 

## Loops and conditionals
The code above used a conditional statement. Conditionals in Q# include the standard: ```if, elif```, and ```else``` key words. Each of these much be followed by a block that is executed or not based on the evaluated conditional. 

In order to demonstrate the for loop, we will create a calling function for the operation above:
```
@EntryPoint()
operation Main() : Unit {
    //This is the main function
    mutable z_0 = 0;
    mutable z_1 = 0;
    mutable x_0 = 0;
    mutable x_1 = 0;

    for i in 0..1000 {
        let (q1Z, q1X) = test_measure(false);
        if q1Z {
            set z_1 += 1;
        } elif q1Z == false {
            set z_0 += 1;
        }
        if q1X {
            set x_1 += 1;
        } elif q1X == false {
            set x_0 += 1;
        }
    }

    Message($"q1_Z  0: {z_0}, 1: {z_1}");
    Message($"q1_X  0: {x_0}, 1: {x_1}");
}
```
- mutable variables: at the top, four variables are declared as mutable. They must be declared this way if their values can change. They are all assigned an initial value of 0. A mutable array could be declared as: ```mutable z_results = [0, size=0]```, and we will see an example below.
- The ```for``` loop uses a range variable to set the number of repetitions. A range is declared by ```start_idx..end_idx```. Alternately, a step size can be included: ```start_idx..step_size..end_idx```. The loop stats at 0 and goes all the way to the end_idx, so most often you will want to set the ending range as end_idx-1. A {} block encloses everything to be executed in the loop.
- ```Message```: this code demonstrates the Message function. To print a static string, it can be called by: ```Message("Hello world!")``` but to include variables in the message, the first " is preceded by a $ and the variables is enclosed in {} as above.
- This code demonstrates the ```elif``` statement.

We could also use mutable arrays in this operation:
```
 @EntryPoint()
operation Main() : Unit {
    //This is the main function
    mutable z_results = [0, size=2];
    mutable x_results = [0, size=2];

    for i in 0..1000 {
        let (q1Z, q1X) = test_measure(false);
        if q1Z {
            set z_results w/= 1 <- z_results[1] + 1;
        } elif q1Z == false {
            set z_results w/= 0 <- z_results[0] + 1 ;
        }
        if q1X {
            set x_results w/= 1 <- x_results[1] + 1;
        } elif q1X == false {
            set x_results w/= 0 <- x_results[0] + 1;
        }
    }

    Message($"q1_Z  0: {z_results[0]}, 1: {z_results[1]}");
    Message($"q1_X  0: {x_results[0]}, 1: {x_results[1]}");
}
```
- The array ```z_results``` is declared as mutable with all 0's to start and a size of 2.
- In the loop, the array values are modified
  * the ```set``` keyword is used to change the value
  * ```w/= idx <- value``` means to put ```value``` into the array at the location ```idx```.
  * In this case we are augmenting the previous value by one and putting it in the array. 

## Running the code
The whole code can be run from the command line in VS Code using the QDK virtual machine. 
```
namespace TestState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Convert;

    @EntryPoint()
    operation Main() : Unit {
        //This is the main function
        mutable z_results = [0, size=2];
        mutable x_results = [0, size=2];

        for i in 0..1000 {
            let (q1Z, q1X) = test_measure(false);
            if q1Z {
                set z_results w/= 1 <- z_results[1] + 1;
            } elif q1Z == false {
                set z_results w/= 0 <- z_results[0] + 1 ;
            }
            if q1X {
                set x_results w/= 1 <- x_results[1] + 1;
            } elif q1X == false {
                set x_results w/= 0 <- x_results[0] + 1;
            }
        }

        Message($"q1_Z  0: {z_results[0]}, 1: {z_results[1]}");
        Message($"q1_X  0: {x_results[0]}, 1: {x_results[1]}");
    }
        

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
}
```
It produces the following output:
```
q1_Z  0: 503, 1: 498

q1_X  0: 1001, 1: 0
```

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
- Grover's algorithm for searching
