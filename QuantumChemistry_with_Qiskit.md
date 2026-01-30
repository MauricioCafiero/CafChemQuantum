# Quantum Chemistry with Quantum Computing (using Qiskit)

## Hamiltonians
The familiar Hartree-Fock (HF) Hamiltonian can be written as:
```math
\hat{H} = \sum_{i=1}^{n}{\hat{h}_i} + \sum_{i>j}^{n} \frac{1}{r_{ij}} + E_{NN}
```
where *n* is the number of electrons. In the second quantization formalism, we can convert this to:
```math
\hat{H} = \sum_{i,j}^{m}{h_{ij} \hat{a}_i^{+}\hat{a}_j} + \frac{1}{2} \sum_{i,j,k,l}^{m}  g_{i,j,k,l} \hat{a}_i^{+} \hat{a}_j^{+} \hat{a}_k \hat{a}_l + E_{NN}
```
where *m* is the number of orbitals,  $\hat{a}^{+}$ is a *creation operator* that puts an electron in an orbital, $\hat{a}$ is an *annihilation operator*
that removes an electron from an orbital, and $h_{ij}$ and $g_{i,j,k,l}$ are one-electron hamiltonian and coulomb/exchange integrals over the orbitals.

## Fermion to qubit operators
In the quantum computing formalism, the orbitals are described by quibts, so the operators acting on them hve to be *qubit operators*. In general, the qubit operators are:
```math

\sigma^+ = \frac{1}{2} (\textbf{X} - i \textbf{Y})   \hspace{2cm}   \text{Creation} 
```
```math

\sigma^- = \frac{1}{2} (\textbf{X} + i \textbf{Y})  \hspace{2cm}   \text{Annihiliation} 
```
```math

\sigma^+ \sigma^- = \frac{1}{2} (\textbf{I} - \textbf{Z})   \hspace{2cm}   \text{make particle} 
```
```math

\sigma^- \sigma^+ = \frac{1}{2} (\textbf{I} + \textbf{Z})   \hspace{2cm}   \text{remove particle} 
```
where **X** and **Y** are the unitary gates described earlier. There are sevral ways to map fermionic operators to qubit operators. Two mappings for systems with a one-to-one electron to qubit mapping are *Jordan-Wigner* and *Bravyi-Kitaev*. There is also the *Parity* mapping. Consider an example of the Jordan-Wigner mapping. For orbital 1 (numbered 0), the creation operator would be the same as above:
```math

\hat{a}^+_{0} = \frac{1}{2} (\textbf{X} - i \textbf{Y}) 
```
For orbital 2 (numbered 1), it would be:
```math

\hat{a}^+_{1} = \frac{1}{2} (\textbf{X} - i \textbf{Y}) \textbf(Z)
```
For orbital 3 (numbered 2), it would be:
```math

\hat{a}^+_{2} = \frac{1}{2} (\textbf{X} - i \textbf{Y}) \textbf(Z) \textbf(Z)
```
and so on. Other mappings would create slightly different results.

## Coupled Cluster Ansatz
In coupled cluster theory, the wave function takes the form:
```math
\ket{\psi_{CC}(\theta)} = e^{\hat{T}(\theta) - \hat{T}^{+}(\theta)} \ket{\psi_{Ref}(\phi)}
```
where the reference wave function is a set of qubits with variational rotation angle parameters:
```math
\ket{\psi_{Ref}(\phi)} = \textbf{U}(\phi) \ket{0...n}
```
where $U(\phi)$ is a unitary operator with rotational angle parameters $\phi$, such as a combination of RX, RY and RZ gates.

If we consider Unitary Coupled Cluster with Single and Double excitations, the **T** operator is made up of:
```math
\hat{T}_{1}(\theta) = \sum_{i; m} \theta_{i}^{m} \hat{a}_m^{+}\hat{a}_i
```
```math
\hat{T}_{2}(\theta) = \frac{1}{2} \sum_{i,j; m,n} \theta_{i,j}^{m,n} \hat{a}_n^{+}\hat{a}_m^{+} \hat{a}_j \hat{a}_i
```

where *i* runs over occupied orbitals and *m* runs over unoccupied orbitals, and $\theta$ are the variational parameters. 

$\ket{\psi_{CC}(\theta)}$ is then mapped into qubit operators using one of the mappings above.


## Variational Quantum Eigensolver

To solve this on a quantum computer, the following steps are followed:
- The wavefunction qubits and gates (circuit) are set up on the quantum computer.
- The energy is calculated on the quantum computer by starting with a random set of parameters, applying the
circuit representing the energy expectation value (in essence, $\bra{\psi} \hat{H} \ket{\psi}$) and performing a simulation to find
the integrals.
- The energy is calculated on the classical computer, and the parameters optimization steps are performed.
- Repeat until convergence.

A practical example can be found in the [sample code](https://github.com/MauricioCafiero/CafChemQuantum/blob/main/Qiskit_Chemistry_CafChem.ipynb)
