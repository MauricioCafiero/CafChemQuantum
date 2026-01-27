# Qiskit - Python library for quantum computing by IBM

- [Install](#install)
- [Circuits and Gates](#circuits-and-gates)
- [Measurements and State functions](#measurements-and-state-functions)
- [Simulations](#simulations)
- [Draw Circuits](#draw-circuits)
- [Sample Code](#code)

## Install
To get the main tools needed for basic operation, first install:
```
pip install -q qiskit
pip install -q qiskit_aer
```
The second library contains the simulation (virtual machine) functions. 

Now import:
```
from qiskit import QuantumCircuit, ClassicalRegister, transpile #, execute
from qiskit_aer import Aer
from qiskit.visualization import plot_histogram, circuit, array_to_latex
from qiskit.circuit.library import MCMTGate, ZGate
from qiskit.quantum_info import Statevector
import matplotlib.pyplot as plt
import numpy as np
```

## Circuits and gates
**NOTE: Qiskit places qubits in reversed order, so $\ket{0}\ket{1}\ket{2}$ is represented in a Qiskit circuit as $\ket{2}\ket{1}\ket{0}$**

- Circuits are created with the QuantumCircuit class:
```
qc = QuantumCircuit(n, n)
```
This creates a circuit with *n* qubits and *n* bits.
- A gate can be added to a circuit as a method:
```
qc = QuantumCircuit(3,3)  

qc.h(0)          #applies the Hadamard gate to qubit 0
qc.cx(0,1)       #applies the controlled x gate to qubit 1 with 0 as the control

qc.z(2)          #applies the z gate to qubit 2

qc.rx(np.pi, 1)  #applies the rotation about the x gate to qubit 1 with an angle of pi
```
- A custom gate can be made with the MCMTGate class. For example, for a doubly controlled gate:
```
cont_z = MCMTGate(ZGate(), 2, 1)    #z gate with 2 control qubits and 1 target qubit
```
the custom gate can be applied to a circuit with *append*:
```
qc.append(cont_z, range(n))          # cont_z applied to n qubits in the circuit
```
- An entire circuit can be made into a gate and attached to another circuit with ```to_gate()```:
```
qc_total = QuantumCircuit(3,3)

qc_total.append(qc.to_gate(label='sub_gate'), range(n))
```

## Measurements and State functions

- A circuit can be measured with the *measure* method of a circuit:
```
qc.measure(3, 3)      # measure 3 qubits onto 3 classical bits
```
The measurement itself is just a part of a circuit and doesn't yield any information until the circuit is simulated.

- Another way of looking into the state of a circuit is to display the state function. This shows the weights of each basis state in the circuit.
```
s = Statevector.from_instruction(qc)
img = s.draw('latex', prefix=r'\ket{\psi} = ')
display(img)
```
This displays something like:
```math
\ket{\psi} = \frac{\sqrt{2}}{2} \ket{0} + \frac{\sqrt{2}}{2} \ket{1}
```
s is an array containing $2^n$ basis state coefficients.

## Simulations
- A simulator can be created with the *Aer* class:
```
simulator = Aer.get_backend('qasm_simulator')
```
if you have any custom gates or sub-circuits in your circuit, you should transpile the circuit before simulation:
```
qc_transpiled = transpile(qc_total, simulator)
```
- You can then run the simulation and get the counts for each state found:
```
job = simulator.run(qc_t, shots=shots)
counts = job.result().get_counts()
print(f'total counts: {counts}')
plot_histogram(counts)
```
- the *plot_histogram* method will make a plot for you.
<img width="437" height="337" alt="image" src="https://github.com/user-attachments/assets/15e84961-6aa6-46c0-817c-074d4df9ef7a" />

## Draw Circuits
Finally, you can visualize each circuit with the circuit's *draw* method:
```
qc_total.draw()
```
<img width="192" height="101" alt="image" src="https://github.com/user-attachments/assets/edc409fa-a6d4-40af-8e4c-fff834b48004" />

## Code

- See a Jupyter notebook with entanglement, teleportation, and Grover's search algorithm examples [here](https://github.com/MauricioCafiero/CafChemQuantum/blob/main/QC_Qiskit_CafChem.ipynb).
