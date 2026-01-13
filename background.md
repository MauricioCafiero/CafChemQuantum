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
We will consider |0> as the default (or ground) state. They represent the quantum bits, or qubits, of the quantum computer. 

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
The $$\ket{+}$$ and $$\ket{-}$$ states form an alternate 2-level basis set to |0> and |1> and can be used as such. In a superposition state, the square of the coefficient of each basis function gives the probability that a measurement will find the qubit in that state:
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

### Controlled Gates
The CNOT gate

# Basics of Q#
## Program structure / namespaces
## Variable types
## Operations and functions
## Loops and conditionals
