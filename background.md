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
The $$\ket{+}$$ and $$\ket{-}$$ states form an alternate 2-level basis set to |0> and |1> and can be used as such.

## Unitary transformations / Gates
Unitary Transformations, or Gates, are operatios performed on qubit states. The most basic gate is the Hadamard gate, H, which flips the state:
```math
\textbf{H} \ket{0} = \ket{1}
```

# Basics of Q#
## Program structure / namespaces
## Variable types
## Operations and functions
## Loops and conditionals
