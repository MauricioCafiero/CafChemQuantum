# Cirq - Python library for quantum computing by Google

- [Install](#install)
- [Circuits and Gates](#circuits-and-gates)
- [Measurements and State functions](#measurements-and-state-functions)
- [Simulations](#simulations)
- [Draw Circuits](#draw-circuits)
- [Sample Code](#code)

## Install
To get the main tools needed for basic operation, first install:
```
pip install -q cirq
```
The second library contains the simulation (virtual machine) functions. 

Now import:
```
import cirq
import matplotlib.pyplot as plt
import numpy as np
```

## Circuits and gates

- Circuits are created with the Circuit class:
```
qc = cirq.Circuit()
```
- Qubits are created with several classes, but we will use LineQubit:
```
qubits = cirq.LineQubit.range(3)
```
- A gate can be added to a circuit by appending:
```
qc.append(cirq.X(qubits[0]))                   # applies the X gate

qc.append(cirq.H(qubits[0]))                   #applies the Hadamard gate to qubit 0
qc.append(cirq.CNOT(qubits[0], qubits[1]))     #applies the controlled x gate to qubit 1 with 0 as the control

qc.append(cirq.Z(qubits[2]))                   #applies the z gate to qubit 2

rz_gate = cirq.rx(np.pi)
qc.append(rz_gate(qubits[1]))                  #applies the rotation about the z gate to qubit 1 with an angle of pi
```
- A custom controlled gate can be made with the ControlledGate class. For example, for a doubly controlled gate:
```
multi_cz = cirq.ControlledGate(sub_gate=cirq.Z,
                      num_controls=len(qubits) - 1)    #z gate with 2 control qubits and 1 target qubit
```
the custom gate can be applied to a circuit with *append*:
```
qc.append(multi_cz(*qubits))                     # cont_z applied to n qubits in the circuit
```

## Measurements and State functions

- A circuit can be measured by appending the *measure* method to a circuit:
```
qc.append(cirq.measure(*qubits, key='result'))      # measure 3 qubits and called it 'results'
```
The measurement itself is just a part of a circuit and doesn't yield any information until the circuit is simulated.

- Another way of looking into the state of a circuit is to display the state function. This shows the weights of each basis state in the circuit.
```
result = simulator.simulate(qc)
print(f'state: {result}')
```
This displays something like:
```math
output vector: (0.354+0.612j)\ket{0} + (0.612-0.354j) \ket{1} 
```
A list of the basis state coefficients can be created with:
```
coeffs = result.final_state_vector
```
coeffs is an array containing $2^n$ basis state coefficients.

## Simulations
- A simulator can be created with the *Simulator* class:
```
simulator = cirq.Simulator()
```
- You can then run the simulation and get the counts for each state found:
```
result = self.simulator.run(qc, repetitions=1000)
counts = result.histogram(key='result')
```
- Use MatPlotLib to make a plot.
```
from matplotlib import pyplot as plt
plt.bar(counts.keys(), counts.values())
plt.show()
```
<img width="437" height="337" alt="image" src="https://github.com/user-attachments/assets/15e84961-6aa6-46c0-817c-074d4df9ef7a" />

## Draw Circuits
Finally, you can visualize each circuit with the python print method:
```
print(qc)
```
<img width="192" height="101" alt="image" src="https://github.com/user-attachments/assets/edc409fa-a6d4-40af-8e4c-fff834b48004" />

## Code

- See a Jupyter notebook with entanglement, teleportation, and Grover's search algorithm examples [here](https://github.com/MauricioCafiero/CafChemQuantum/blob/main/QC_Cirq_CafChem.ipynb).
