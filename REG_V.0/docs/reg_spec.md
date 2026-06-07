# Register Specification

## CTRL_REG

Address: `0x0000_1000`

### Register Layout

31                     16 15          8 7      6        0
+-----------------------+--------------+--------+---------+
|       Reserved        |     MODE     |ENABLE  | STATUS  |
+-----------------------+--------------+--------+---------+

---

## MODE

Bits: `[15:8]`

Access: RW

Reset: `0x01`

Description:

Controls operating mode of the hardware block.

Software may read or write this field.

---

## ENABLE

Bit: `[7]`

Access: RW

Reset: `0`

Description:

Enables or disables the hardware block.

Values:

* 0 = Disabled
* 1 = Enabled

Software may read or write this field.

---

## STATUS

Bits: `[6:0]`

Access: RO

Reset: `0x00`

Description:

Reports hardware status information.

This field is driven by hardware and exposed to software through the register interface.

Software may read this field but cannot modify it.

---

## Reserved

Bits: `[31:16]`

Access: RO

Reset: `0x0000`

Description:

Reserved for future use.

Requirements:

* Ignore software writes
* Read back as zero

---

## Read Behaviour

Reading address `0x0000_1000` returns:

* MODE
* ENABLE
* STATUS

combined into a single 32-bit register value.

---

## Write Behaviour

Writing address `0x0000_1000` updates:

* MODE
* ENABLE

Writing does not affect:

* STATUS
* Reserved fields

---

## Hardware Interface

Input:

```systemverilog
input logic [6:0] hw_status;
```

The STATUS field directly reflects the value of `hw_status`.

Hardware drives `hw_status`.

Software observes STATUS through register reads.
