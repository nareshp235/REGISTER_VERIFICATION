# Register Verification Environment (reg_v.0)

## Overview

This project implements and verifies a simple memory-mapped register block using SystemVerilog.

The goal of this exercise is to understand:

* Memory Mapped Registers (MMIO)
* Read/Write (RW) register fields
* Read Only (RO) register fields
* Reserved register fields
* Register reset values
* Register read/write verification
* Hardware-to-Software status reporting

The project serves as a foundation for future enhancements such as:

* Multiple registers
* Interrupt registers
* DMA control/status registers
* Register scoreboards
* Register Abstraction Layer (RAL)

---

## Register Map

Base Address: `0x0000_1000`

| Bits  | Field    | Access | Reset  | Description     |
| ----- | -------- | ------ | ------ | --------------- |
| 31:16 | Reserved | RO     | 0x0000 | Reserved        |
| 15:8  | MODE     | RW     | 0x01   | Operating mode  |
| 7     | ENABLE   | RW     | 0      | Module enable   |
| 6:0   | STATUS   | RO     | 0x00   | Hardware status |

---

## Architecture

### Configuration Path

Software programs configuration registers through bus write operations.

Examples:

* MODE
* ENABLE

Flow:

CPU/Software → Register Block → Hardware

### Status Path

Hardware reports status through RO fields.

Examples:

* STATUS

Flow:

Hardware → Register Block → CPU/Software

---

## Project Structure

reg_v.0/

├── rtl/

│   └── reg_block.sv

├── tb/

│   └── tb_reg_block.sv

├── include/

│   └── reg_defines.svh

├── flist/

│   └── filelist.f

├── sim/

│   └── sim_vcs.sh

├── logs/

├── waves/

└── docs/

---

## Testcases Implemented

### Reset Verification

Verifies reset values:

* MODE = 0x01
* ENABLE = 0
* STATUS = 0

### RW Verification

Verifies:

* MODE field updates correctly
* ENABLE field updates correctly

### RO Verification

Verifies:

* STATUS field reflects hardware status
* Software writes cannot modify STATUS

### Reserved Bit Verification

Verifies:

* Reserved bits ignore writes
* Reserved bits read back as zero

---

## Running Simulation

```bash
cd sim
./sim_vcs.sh
```

Open waveform:

```bash
dve -vpd ../waves/reg_block.vpd &
```

---

## Key Learning Outcomes

This project demonstrates:

* Memory mapped register design
* Register read/write architecture
* Configuration vs Status registers
* Hardware/Software interface concepts
* Directed register verification
* Basic verification environment structure

---

## Future Roadmap

reg_v.0

* Single register block

reg_v.1

* Additional register tests
* Invalid address access
* Reset recovery

reg_v.2

* Multiple registers

reg_v.3

* DMA control and status registers

reg_v.4

* Interrupt support

reg_v.5

* Scoreboard and register model

reg_v.6

* Class-based verification

reg_v.7

* UVM-lite environment

reg_v.8

* Full RAL integration
