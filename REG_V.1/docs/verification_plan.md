# Verification Plan

## Objective

Verify correct interaction between:

* Software
* Register Block
* DMA Core

---

# Feature 1

Reset Verification

## Checkpoints

Verify:

MODE = 0x01

ENABLE = 0

STATUS = 0

Expected Result:

PASS

---

# Feature 2

Register Programming

## Checkpoints

Write MODE

Read MODE

Write ENABLE

Read ENABLE

Expected Result:

PASS

---

# Feature 3

Normal DMA Operation

## Configuration

MODE = 0x00

ENABLE = 1

## Checkpoints

DMA enters BUSY state.

DMA exits BUSY state.

DMA sets DONE.

DMA clears BUSY.

Expected Result:

DONE = 1

ERROR = 0

---

# Feature 4

Error DMA Operation

## Configuration

MODE = 0xFF

ENABLE = 1

## Checkpoints

DMA enters BUSY state.

DMA exits BUSY state.

DMA sets ERROR.

DMA clears BUSY.

Expected Result:

ERROR = 1

DONE = 0

---

# Feature 5

RO Status Verification

## Checkpoints

Software attempts to write STATUS bits.

Verify STATUS remains hardware controlled.

Expected Result:

PASS

---

# Feature 6

Reserved Bit Verification

## Checkpoints

Write all ones.

Verify reserved bits remain zero.

Expected Result:

PASS

---

# Success Criteria

All testcases pass.

No protocol violations.

No register access violations.

Status behavior matches DMA specification.

Waveforms confirm expected operation.
