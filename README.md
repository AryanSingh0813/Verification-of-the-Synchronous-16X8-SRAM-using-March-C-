# Verification of the Synchronous 16×8 SRAM using March C+

## Overview

This project implements **functional verification** of a **Synchronous 16×8 SRAM** using an extended **March C+ memory testing algorithm**. The verification environment is built in **Verilog/SystemVerilog** to validate SRAM read/write operations and detect common memory faults through a structured, address-ordered test sequence.

The project demonstrates:
- Synchronous SRAM design and behaviour
- Structured memory fault testing via March algorithms
- Task-based, modular testbench architecture in SystemVerilog
- Waveform-based simulation and debugging

---

## SRAM Specifications

| Parameter        | Value              |
|------------------|--------------------|
| Memory Type      | Synchronous SRAM   |
| Depth            | 16 Words           |
| Width            | 8 Bits             |
| Address Bus      | 4 bits (`[3:0]`)   |
| Data Bus         | 8 bits (`[7:0]`)   |
| Clocked Operation| Yes (rising edge)  |
| Chip Enable      | Active High (`ce`) |
| Write Enable     | Active High (`wr`) |
| Language         | Verilog / SystemVerilog |

---

## Design Under Test — `sram16_8.v`

The SRAM is a simple synchronous model:

- All operations are registered on the **rising edge of `clk`**
- `ce` (chip enable) must be asserted for any operation
- When `wr = 1` → **write** `din` to `mem[addr]`
- When `wr = 0` → **read** `mem[addr]` to `dout`
- Memory is initialised to `0x00` on power-up

```verilog
always @(posedge clk) begin
    if (ce) begin
        if (wr) mem[addr] <= din;
        else    dout <= mem[addr];
    end
end
```

---

## March C+ Algorithm

The testbench implements an **extended March C+** sequence. Unlike the standard March C−, this variant includes an extra ascending pass with interleaved read/write/read operations, providing stronger coverage for transition faults and coupling faults.

### Sequence Implemented

| Step | Direction  | Operations      | Task in TB           |
|------|-----------|-----------------|----------------------|
| M0   | ⇕ (any)   | `w0`            | `w0()`               |
| M1   | ⇑ (asc)   | `r0, w1, r1`    | `r0_w1_r1_asc()`     |
| M2   | ⇓ (desc)  | `r1, w0, r0`    | `r1_w0_r0_desc()`    |
| M3   | ⇓ (desc)  | `r0, w1, r1`    | `r0_w1_r1_desc()`    |
| M4   | ⇑ (asc)   | `r1, w0, r0`    | `r1_w0_r0_asc()`     |

**Legend:**

| Symbol | Meaning              |
|--------|----------------------|
| `w0`   | Write `0x00`         |
| `w1`   | Write `0x01`         |
| `r0`   | Read, expect `0x00`  |
| `r1`   | Read, expect `0x01`  |
| `⇑`    | Ascending address    |
| `⇓`    | Descending address   |
| `⇕`    | Any address order    |

---

## Faults Targeted

| Fault Type              | Description                                             |
|-------------------------|---------------------------------------------------------|
| Stuck-at Fault (SAF)    | Cell permanently stuck at `0` or `1`                    |
| Transition Fault (TF)   | Cell fails to transition from `0→1` or `1→0`            |
| Address Decoder Fault   | Wrong cell accessed for a given address                 |
| Coupling Fault (CF)     | Write to one cell corrupts another                      |
| Read/Write Disturb Fault| Read or write operation disturbs neighbouring cells     |

---

## Project Structure

```
Verification-of-the-Synchronous-16X8-SRAM-using-March-C+/
│
├── rtl/
│   └── sram_16x8.v          # SRAM Design Under Test
│
├── tb/
│   └── march_c_plus_tb.v    # March C+ Testbench
│
├── sim/
│   └── waveform.vcd         # Simulation waveform dump
│
├── docs/
│   └── results.png          # Waveform screenshot
│
└── README.md
```

---

## Testbench Architecture — `march_c_plus_tb.v`

The testbench is **task-based** and **modular**. Each March element is encapsulated in its own Verilog task, called sequentially from a single `initial` block.

```
initial
  └── ce = 1 (chip enable)
       ├── w0()                 → M0: initialise all cells to 0
       ├── r0_w1_r1_asc()       → M1: ascending read-0, write-1, read-1
       ├── r1_w0_r0_desc()      → M2: descending read-1, write-0, read-0
       ├── r0_w1_r1_desc()      → M3: descending read-0, write-1, read-1
       └── r1_w0_r0_asc()       → M4: ascending read-1, write-0, read-0
```

### Clock & Enable

```verilog
initial clk = 0;
always  #5 clk <= ~clk;   // 10 ns period → 100 MHz

initial begin
    ce = 0;
    #5 @(posedge clk) ce = 1;   // Enable after first rising edge
    ...
end
```

---

## Verification Flow

```
1. Instantiate DUT (sram16_8)
2. Generate clock (100 MHz) and assert chip enable
3. M0 — Write 0x00 to all 16 addresses (ascending)
4. M1 — Read 0 → Write 1 → Read 1  (ascending)
5. M2 — Read 1 → Write 0 → Read 0  (descending)
6. M3 — Read 0 → Write 1 → Read 1  (descending)
7. M4 — Read 1 → Write 0 → Read 0  (ascending)
8. Observe $display output and waveforms for pass/fail
```

---

## Simulation

### Prerequisites

- ModelSim / QuestaSim  **or**  Xilinx Vivado Simulator
- GTKWave (for waveform viewing)

### Compile

```bash
vlog rtl/sram_16x8.v tb/march_c_plus_tb.v
```

### Run Simulation

```bash
vsim tb
run -all
```

### View Waveform

```bash
gtkwave sim/waveform.vcd
```

To dump a VCD from the testbench, add the following inside the `initial` block:

```verilog
initial begin
    $dumpfile("sim/waveform.vcd");
    $dumpvars(0, tb);
end
```

---

## Sample Console Output

```
=================w0===================
wr = 1, addr = 0, din = 0
wr = 1, addr = 1, din = 0
...
write0 completed
=================r0_w1_r1_asc===================
wr = 0, addr = 0, dout = 0
...
read0 completed
wr = 1, addr = 0, din = 1
...
write1 completed
wr = 0, addr = 0, dout = 1
...
read1 completed
=================r1_w0_r0_desc===================
...
```

---

## Sample Waveform

![Simulation Waveform]()

> Signals to observe: `clk`, `ce`, `wr`, `addr[3:0]`, `din[7:0]`, `dout[7:0]`

---

## Results

- All 16 memory locations initialised correctly in M0
- Ascending and descending read/write sequences executed without errors
- `dout` matches the expected value at every read operation
- No stuck-at or transition faults detected in the fault-free SRAM model
- March C+ sequence completed successfully

---

## Tools Used

| Tool              | Purpose                     |
|-------------------|-----------------------------|
| Xilinx Vivado     | Synthesis and simulation     |
| ModelSim/QuestaSim| RTL simulation               |
| GTKWave           | Waveform analysis            |

---

## Learning Outcomes

- Synchronous SRAM architecture and timing
- March algorithm theory and practical implementation
- Task-based testbench structuring in SystemVerilog
- Address-ordered memory traversal (ascending / descending)
- Simulation, waveform analysis, and debug techniques

---

## Future Improvements

- Add self-checking assertions to automatically flag read mismatches
- UVM-based layered verification environment
- Functional coverage groups for each March element
- Fault injection to validate fault detection capability
- Parameterised testbench to support larger memory configurations (e.g., 256×8, 1K×8)
- Formal verification with property checking

---

## License

This project is open-source and available under the [MIT License](LICENSE).
