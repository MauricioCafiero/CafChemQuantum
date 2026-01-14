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
let system_length = 6
mutable results = Bool[false, size=0]
```
The specific quantum related variable types include:
- Qubit: this defines a qubit. A qubit is created in the 0 state by default with the ```use``` keyword, and must be in the 0 state when the program ends. Qubits may be declared and reset as below:
```
use (q1, q2) = (Qubit(), Qubit())

ResetAll([q1, q2])  // alternately use Reset(q1), etc...
```
- Result: this is a measurment result and can be 0 or 1. You can generate a result using the simple measurement operator: ```M```, or you can specify a measurement basis with ```Measure```.

## Operations and functions
## Loops and conditionals
### Appending arrays
