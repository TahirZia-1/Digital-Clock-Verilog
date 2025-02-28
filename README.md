# Digital Clock FPGA Implementation
## The source files (Design and Testbench) are in "DigitalClock.srcs" folder
## A general NEXYS 4 DDR xdc file is also added

## Overview
This repository contains a Verilog implementation of a 24-hour digital clock designed for FPGA platforms. The design displays hours, minutes, and seconds on a 7-segment display, providing a complete timekeeping solution that can be easily integrated into various FPGA development boards.

## Features
- 24-hour time format (00:00:00 to 23:59:59)
- Real-time display on 7-segment displays
- Configurable clock frequency
- Reset functionality
- Efficient display multiplexing

## Files
- `digital_clock.v` - Main implementation of the digital clock
- `digital_clock_tb.v` - Testbench for simulation and verification

## Design Architecture
The digital clock consists of several key components:

1. **Clock Divider**: Converts the 100MHz system clock to a 1Hz clock for timekeeping
2. **Time Counter**: Tracks seconds, minutes, and hours with appropriate rollover logic
3. **Display Controller**: Manages the 7-segment display multiplexing
4. **7-Segment Decoder**: Converts BCD values to 7-segment display patterns

## Hardware Requirements
- FPGA development board (tested on boards with 100MHz clock)
- 6 seven-segment displays
- Reset button

## Getting Started

### Simulation
To simulate the design using your preferred Verilog simulator:

```bash
# Example for Icarus Verilog
iverilog -o digital_clock_sim digital_clock.v digital_clock_tb.v
vvp digital_clock_sim
```

### Implementation
To implement on an FPGA:

1. Add the source files to your project
2. Assign appropriate pins for:
   - System clock (`clk`)
   - Reset button (`reset`)
   - Anode signals (`an[7:0]`)
   - 7-segment display signals (`seg[6:0]`)
3. Generate bitstream and program your FPGA

## Customization
The clock frequency can be adjusted by modifying the `CLK_FREQ` parameter in the `digital_clock.v` file. For simulation purposes, you may want to reduce this value to speed up the simulation process.

## Testing
The included testbench (`digital_clock_tb.v`) provides a basic verification environment:
- Applies reset
- Runs the clock for an extended period
- Monitors time values and display outputs
