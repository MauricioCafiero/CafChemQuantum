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
