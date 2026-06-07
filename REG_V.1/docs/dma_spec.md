# DMA Core Specification

## Overview

The DMA core is a simplified hardware engine used for learning and verification purposes.

The core models:

* Transfer start
* Transfer execution
* Transfer completion
* Transfer error

---

## Inputs

### ENABLE

Type: Control

Source: Register Block

Description:

Starts DMA operation.

---

### MODE

Width: 8 bits

Source: Register Block

Description:

Selects DMA operating mode.

---

## Outputs

### STATUS[0]

BUSY

Indicates DMA is currently executing.

---

### STATUS[1]

DONE

Indicates DMA completed successfully.

---

### STATUS[2]

ERROR

Indicates DMA completed with failure.

---

## State Machine

States:

IDLE

BUSY

DONE

ERROR

---

## Reset Behavior

After reset:

BUSY  = 0

DONE  = 0

ERROR = 0

State = IDLE

---

## Normal Mode

Condition:

MODE = 0x00

ENABLE = 1

Behavior:

IDLE
↓
BUSY
↓
5 Clock Cycles
↓
DONE

Final Status:

0000010

---

## Error Mode

Condition:

MODE = 0xFF

ENABLE = 1

Behavior:

IDLE
↓
BUSY
↓
5 Clock Cycles
↓
ERROR

Final Status:

0000100

---

## Timing Model

Transfer duration:

5 clock cycles

This fixed latency is used only for learning and verification.
