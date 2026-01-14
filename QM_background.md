# Quantum Mechanics
## Basis states
Quantum computing is based on quantum 2-level systems. These can be spin states for nuclei (some quantum computers are NMR-based):
```math
\ket{\psi} = \ket{up}, \ket{down}
```
but the conventiom is to use bit notation of 1 and 0:
```math
\ket{\psi} = \ket{0}, \ket{1}
```
We will consider |0> as the default (or ground) state. They represent the quantum bits, or qubits, of the quantum computer. These are also called the **computational basis** or **z-basis**.

### Bloch sphere
It is useful to consider the basis states as vectors pointing to a point on the surface of a sphere. the |0> state points to the top (zero degree angle) and the |1> points to the bottom (180 degree angle). We refer to this sphere as the Bloch sphere.

## Superposition states
Before a system is measured, it can exist as a superposition of two states:
```math
\ket{\theta} = \frac{1}{\sqrt{2}} (\ket{0} + \ket{1})
```
or:
```math
\ket{\theta} = \frac{1}{\sqrt{2}} (\ket{0} - \ket{1})
```
These states occur frequently, and so are have their own symbols:
```math
\ket{+} = \frac{1}{\sqrt{2}} (\ket{0} + \ket{1})
```
```math
\ket{-} = \frac{1}{\sqrt{2}} (\ket{0} - \ket{1})
```
The $$\ket{+}$$ and $$\ket{-}$$ states form an alternate 2-level basis set to |0> and |1> and can be used as such. These are called the **x-basis**. In a superposition state, the square of the coefficient of each basis function gives the probability that a measurement will find the qubit in that state:
```math
a\ket{0} + b \ket{1},
```
```math
P(\ket{0}) = a^{2}
```
```math
P(\ket{1}) = b^{2}
```
## Unitary transformations / Gates
Unitary Transformations, or Gates, are operatios performed on qubit states. The most basic gate is the Hadamard gate, H, which puts the state into superposition:
```math
\textbf{H} \ket{0} = \frac{1}{\sqrt{2}} (\ket{0} + \ket{1}) = \ket{+}  
```
```math
\textbf{H} \ket{1} = \frac{1}{\sqrt{2}} (\ket{0} - \ket{1}) = \ket{-}  
```
The Hadamard gate is its own inverse and is self-adjoint. Further, we can say that the Hadamard gate transforms the z-basis into the x-basis.  

The Pauli X gate (names for the Pauli X operator) flips each qubit into the opposite state:
```math
\textbf{X} (a\ket{0} + b \ket{1}) = a\ket{1} + b \ket{0}
```
The Pauli Z gate 'flips' the phase of a state, that is, it changes the sign on the |1> state, but leaves the probabilities unchanged:
```math
\textbf{Z} (a\ket{0} + b \ket{1}) = a\ket{0} - b \ket{1}
```
The Pauli Y gate is like a combination the bit flip of the X gate and the phase flip of the Z gate:
The Pauli X gate (names for the Pauli X operator) flips each qubit into the opposite state:
```math
\textbf{Y} (a\ket{0} + b \ket{1}) = ai\ket{1} - bi \ket{0}
```
Finally, the identity gate leaves a state unchanged:
```math
\textbf{I} (a\ket{0} + b \ket{1}) = a\ket{0} + b \ket{1}
```
### Rotation Gates
When X gate takes a state from |0> to |1>, we can say that is a 180 degree rotation on the Bloch sphere. When the Hadamard gate takes a state from |0> to superposition, we can say that is a 90 degree rotation. Rotations about the x-axis on the Block sphere are particularly important. Rz is a generalization of the Z gate for any angle.
```math
R_{z}(\theta) \to R_{z}(\theta = \pi) = Z
```
Other important Z rotations include 45 degrees:
```math
R_{z}(\theta) \to R_{z}(\theta = \pi /2) = S
```
and 22.5 degrees:
```math
R_{z}(\theta) \to R_{z}(\theta = \pi /4) = T
```
Rotations around X and Y can be defined similarly.

## Multi qubit states
### Multi-qubit basis states
A two qubit state is shown as a product of one-qubit states:
```math
\psi = \ket{0}\ket{0} = \ket{00}
```
For n=two qubits, there are $2^n$ basis states:
```math
\ket{00} , \ket{01}, \ket{10}, \ket{11}
```
For n=three qubits, there are $2^n$ basis states:
```math
\ket{000} , \ket{001}, \ket{010}, \ket{100}, \ket{011}, \ket{101}, \ket{110}, \ket{111}
```
### Multi-qubit gates
If we have a two qubit system and want to perform X on the first qubit and Z on the second, we show this as:
```math
\textbf{U} = \textbf{X} \otimes \textbf{Z}
```
If we have a three qubit system and want to perform X on the first qubit, Z on the second, and nothing on the third, we show this as:
```math
\textbf{U} = \textbf{X} \otimes \textbf{Z} \otimes \textbf{I}
```

### Controlled Gates
A controlled gate is a multi-qubit gate where an action on one qubit depends on, or is controlled by, another qubit. The **control** qubit is unchanged by the gate, but, if it is in state 1, then the gate will be applied to the **target** qubit. If it is in state 0, the gate will not be applied to the target. We can write a controlled gate as $\textbf{CU}$ and show how it works on a two-qubit sytem below (first qubit is the control, second is the target):
```math
\textbf{CU} \ket{00} = \ket{00}
```
```math
\textbf{CU} \ket{01} = \ket{01}
```
```math
\textbf{CU} \ket{10} =  \ket{1} \otimes \textbf{U} \ket{0}
```
```math
\textbf{CU} \ket{11} =  \ket{1} \otimes \textbf{U} \ket{1}
```
### The CNOT gate
The CNOT gate is one of the most important in quantum computing, as it creates an entangled state of two qubits. It is a controlled gate **CU** where **U = NOT**. The operation **NOT** (the XOR function) returns the 0 state for the second qubit when the cubits match, and returns the 1 state for the second qubit when they don't match: 
```math
\textbf{CNOT} \ket{00} = \ket{00}
```
```math
\textbf{CNOT} \ket{01} = \ket{01}
```
```math
\textbf{CNOT} \ket{10} =  \ket{11}
```
```math
\textbf{CNOT} \ket{11} =  \ket{10}
```
In the x-basis this looks like:
```math
\textbf{CNOT} \ket{++} = \ket{++}
```
```math
\textbf{CNOT} \ket{+-} = \ket{--}
```
```math
\textbf{CNOT} \ket{-+} =  \ket{-+}
```
```math
\textbf{CNOT} \ket{--} =  \ket{+-}
```
The **CNOT gate is its own inverse and self-adjoint.

### The SWAP gate
**SWAP** switches the states for two qubits. In the two-qubit basis, the only states affected are thus |01> and |10>:
```math
\psi = a \ket{00} +b \ket{01} +c \ket{10} +d \ket{11}
```
```math
\textbf{SWAP} \psi = a \ket{00} +b \ket{10} +c \ket{01} +d \ket{11}
```
### The CZ gate
The **CZ** gate is a controlled gate that applies **Z** to the second qubit if the first is in the 1 state. It thus only affects one basis state, |11>:
```math
\textbf{CZ} \psi = a \ket{00} +b \ket{10} +c \ket{01} - d \ket{11}
```
### The Toffoli / CCNOT gate
This is a three qubit gate that is a doubly controlled gate that applies CNOT to the target is the *two* controls are in the 1 state. It thus only affects the |110> and |111> states:
```math
\psi = a \ket{000} +b \ket{001} +c \ket{010} +d \ket{100} +e \ket{011} +f \ket{101} +g \ket{110} +h \ket{111}
```
```math
\textbf{CCNOT} \psi = a \ket{000} +b \ket{001} +c \ket{010} +d \ket{100} +e \ket{011} +f \ket{101} +g \ket{111} +h \ket{110}
```

## Entanglement

### Two qubits
Two qubits can be placed into an entangled state with the application of the Hadamard gate on the first qubit, and then the CNOT gate on both, with the first qubit acting as the control. The resulting states are known as the *Bell states*:
```math
\textbf{CNOT} ( \textbf{H} \otimes \textbf{I}) \ket{00} = \frac{1}{\sqrt{2}} (\ket{00} + \ket{11})  = \ket{\Theta^{+}}
```
```math
\textbf{CNOT} ( \textbf{H} \otimes \textbf{I}) \ket{01} = \frac{1}{\sqrt{2}} (\ket{01} + \ket{10}) =  \ket{\Psi^{+}}
```
```math
\textbf{CNOT} ( \textbf{H} \otimes \textbf{I}) \ket{10} = \frac{1}{\sqrt{2}} (\ket{00} - \ket{11}) =  \ket{\Theta^{-}}
```
```math
\textbf{CNOT} ( \textbf{H} \otimes \textbf{I}) \ket{11} = \frac{1}{\sqrt{2}} (\ket{01} - \ket{10}) =  \ket{\Psi^{-}}
```
The Bell states serve as an alternate basis for the two qubit system.

### Three qubits
Enatngled states for three qubit can be created by applying a second **CNOT** gate to a Bell state:
```math
\textbf{U} = (\textbf{I} \otimes \textbf{CNOT}) (\textbf{CNOT} \otimes \textbf{I}) ( \textbf{H} \otimes \textbf{I} \otimes \textbf{I})
```
The resulting states can be called GHZ states:
```math
\textbf{U} \ket{000}  = \frac{1}{\sqrt{2}} (\ket{000} + \ket{111}) =  \ket{GHZ}
```

## Teleportation

## Measurements
Measurements can be carried out in different bases, and will thus have different results. For a two qubit system, measuring in the z, or computational basis means that the state:


