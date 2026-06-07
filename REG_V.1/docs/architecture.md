# Architecture Specification

## Overview

reg_v.1 introduces a DMA hardware block connected to the register block.

The objective is to demonstrate a complete hardware/software interaction path.

---

## High-Level Architecture

Software
↓
Register Block
↓
DMA Core
↓
Status Signals
↓
Register Block
↓
Software

---

## Module Hierarchy

tb_reg_top

└── reg_top

```
├── reg_block

└── dma_core
```

---

## Register Block Responsibilities

The register block provides:

* Software-visible registers
* Register storage
* Register read logic
* Register write logic
* Hardware status visibility

### Outputs to Hardware

MODE

ENABLE

### Inputs from Hardware

STATUS

---

## DMA Core Responsibilities

The DMA core provides:

* Transfer execution
* Transfer state tracking
* Status generation

The DMA core consumes:

* MODE
* ENABLE

The DMA core generates:

* BUSY
* DONE
* ERROR

---

## Configuration Path

Software
↓
Bus Write
↓
MODE / ENABLE
↓
DMA Core

---

## Status Path

DMA Core
↓
STATUS
↓
Register Block
↓
Software Read

---

## Design Goal

Demonstrate a realistic peripheral architecture where:

Software configures hardware.

Hardware performs work.

Hardware reports status.

Software observes status.
