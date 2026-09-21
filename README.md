# Synchronous FIFO

A Verilog design of a synchronous First-In-First-Out (FIFO) buffer. The FIFO uses one clock for both write and read sides. The design stores 8-bit data. The design has 16 storage locations.

## Repository Contents

| File | Purpose |
|---|---|
| `fifo_rtl.v` | RTL source code for the synchronous FIFO module |
| `fifo_tb.v` | Testbench that drives and checks the FIFO |
| `README.md` | This file |

## Module: `fifo_rtl`

### Ports

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 bit | Clock signal |
| `reset` | Input | 1 bit | Synchronous reset, active high |
| `write_en` | Input | 1 bit | Write enable |
| `read_en` | Input | 1 bit | Read enable |
| `write_data` | Input | 8 bits | Data to write into the FIFO |
| `read_data` | Output | 8 bits | Data read from the FIFO |
| `full` | Output | 1 bit | Goes high when the FIFO is full |
| `empty` | Output | 1 bit | Goes high when the FIFO is empty |

### Internal Structure

- **Memory array:** 16 locations, each 8 bits wide (`memory[0:15]`).
- **Write pointer:** 4-bit register. It marks the next location to write.
- **Read pointer:** 4-bit register. It marks the next location to read.
- **Counter:** 5-bit register. It tracks the number of stored words. The `empty` flag goes high when the counter is 0. The `full` flag goes high when the counter reaches 15.

### Operation

On each rising clock edge:

1. If `reset` is high, the write pointer, read pointer, counter, and `read_data` all clear to 0.
2. If `reset` is low:
   - If `read_en` is high and the FIFO is not empty, the module reads the word at the read pointer and moves the read pointer forward.
   - If `write_en` is high and the FIFO is not full, the module writes `write_data` into the location at the write pointer and moves the write pointer forward.
   - The counter updates based on which of the read and write operations took place in that cycle.

The design supports a read and a write in the same clock cycle. When both occur together, the counter value does not change.

## Testbench: `fifo_tb`

The testbench instantiates `fifo_rtl` as the unit under test and creates a clock with a 10 ns period. The test sequence checks the following:

1. Reset behavior
2. Basic write operations
3. Basic read operations, with a check against expected values
4. The `empty` flag after all data is read
5. A blocked read while the FIFO is empty
6. Filling the FIFO to 16 words and checking the `full` flag
7. A blocked write while the FIFO is full
8. Pointer wrap-around after reads free up space and new writes take place
9. A simultaneous read and write

The testbench prints `PASS` or `FAIL` messages to the simulator console for each check, and a completion message at the end of the run.

## Running the Simulation

Use any Verilog simulator that accepts these two files. For example, with Icarus Verilog:

```bash
iverilog -o fifo_sim fifo_rtl.v fifo_tb.v
vvp fifo_sim
```

View the results in the console output, or add `$dumpfile` and `$dumpvars` calls to the testbench to view waveforms in a tool such as GTKWave.

## Notes

- The FIFO depth is fixed at 16 words in this version. Change the memory array size, and the width of the pointers and counter, to use a different depth.
- The data width is fixed at 8 bits. Change the width of `write_data`, `read_data`, and the memory array to use a different width.
