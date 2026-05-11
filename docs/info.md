# Clock Counter

## Description

This project is a simple clock counter. On every rising edge of the clock, a 32-bit counter increases by one. When reset is active, the counter returns to zero.

The lower 8 bits of the counter are connected to the dedicated output pins `uo_out`. This allows the output value to change over time as the clock runs.

## Block Diagram

```text
        clk ─────────────┐
                         ▼
                   ┌───────────┐
rst_n ────────────►│  32-bit   │
                   │ counter   │
                   └─────┬─────┘
                         │
                         ▼
                   counter[7:0]
                         │
                         ▼
                     uo_out[7:0]

ui_in[7:0]  ───── unused
uio_in[7:0] ───── unused
uio_out     ───── 0
uio_oe      ───── 0
