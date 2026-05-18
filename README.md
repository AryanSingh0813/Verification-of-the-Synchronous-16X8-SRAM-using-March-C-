# Verification of the Synchronous 16X8 SRAM using March C-

## Overview
This project focuses on the functional verification of a **Synchronous 16x8 SRAM** using the **March C- memory testing algorithm**.  
The verification environment is developed in **SystemVerilog** to validate SRAM operations and detect memory faults through structured test sequences.

The project demonstrates:
- SRAM design verification
- Memory fault testing
- March algorithms
- Testbench architecture in SystemVerilog
- Waveform-based debugging and analysis

---

## Features
- Verification of synchronous SRAM read/write operations
- Implementation of the **March C- Algorithm**
- Detection of common memory faults
- Self-checking testbench
- Modular verification architecture
- Simulation waveform analysis

---

## SRAM Specifications

| Parameter | Value |
|-----------|-------|
| Memory Type | Synchronous SRAM |
| Depth | 16 Words |
| Width | 8 Bits |
| Clocked Operation | Yes |
| Language | Verilog/SystemVerilog |

---

## March C- Algorithm

The March C- algorithm is widely used for memory testing and fault detection.

### Sequence Used

1. Initialization Phase  
   `⇕(w0)`

2. Ascending Phase  
   `⇑(r0,w1)`  
   `⇑(r1,w0)`

3. Descending Phase  
   `⇓(r0,w1)`  
   `⇓(r1,w0)`

4. Final Read  
   `⇕(r0)`

Where:
- `w0` → write 0
- `w1` → write 1
- `r0` → read 0
- `r1` → read 1
- `⇑` → ascending address order
- `⇓` → descending address order
- `⇕` → any address order

---

## Faults Targeted

The verification environment helps identify:

- Stuck-at Faults (SAF)
- Transition Faults (TF)
- Address Decoder Faults
- Coupling Faults
- Read/Write Faults

---

## Project Structure

```bash
Verification-of-the-Synchronous-16X8-SRAM-using-March-C-/
│
├── rtl/
│   └── sram.v
│
├── tb/
│   └── sram_tb.sv
│
├── sim/
│   └── waveform.vcd
│
├── docs/
│   └── results.png
│
└── README.md
```

---

## Verification Flow

1. SRAM DUT instantiation
2. Clock and reset generation
3. Write operation verification
4. Read operation verification
5. March C- sequence execution
6. Output comparison and checking
7. Waveform analysis

---

## Tools Used

- Xilinx Vivado
- ModelSim / QuestaSim
- GTKWave

---

## Simulation

### Compile
```bash
vlog sram.v sram_tb.sv
```

### Run Simulation
```bash
vsim sram_tb
run -all
```

### View Waveform
```bash
gtkwave waveform.vcd
```

---

## Sample Waveform

Add your waveform screenshots here.

```markdown
<img width="1550" height="761" alt="image" src="https://github.com/user-attachments/assets/eb9a3256-2c21-470d-b2bb-a5f259afe96b" />

```

---

## Results
- Successfully verified synchronous SRAM functionality
- March C- algorithm executed successfully
- Correct read/write behavior observed
- Fault detection sequences validated through simulation

---

## Learning Outcomes
- Understanding of SRAM architecture
- Memory verification methodologies
- March test algorithms
- SystemVerilog-based verification
- Simulation and debugging techniques

---

## Future Improvements
- UVM-based verification environment
- Functional coverage implementation
- Assertion-based verification
- Fault injection testing
- Support for larger memory configurations

---
