# Prac 4
A state machine implementation of a WallClock on an FPGA with Verilog.

For a demo video of rubric functionality, please see: https://youtu.be/QmgJPbyS560

## Adding to Vivado
After downloading and extracting, add all .v files to Design Sources except for clock_tb.v.
Add the constr.xdc file to Constraints and clock_tb.v file to Simulation Sources.

## Changing Wall Clock speed
The speed of the clock can be changed in Clock.v by changing CountLimit variable

## Test Bench
If you want to run the test bench on Vivado, it might be better to increase the speed of the WallClock with CountLimit as well as the speed of the SS_Driver to update the digits of the
seven segment display faster. This is to help complete a full cycle of the test bench a bit faster.

When simulating the project itself, however, it is sufficient to only change the speed of the seconds as the register contents are directly visible in the waveform window.

Note also: The printed output of the testbench is exactly what the SevenSegment display will receive and is translated into decimal digits. Therefore, at rollover times (ie:23:59),
the TestBench will refresh only as fast as the SS_Driver refreshes that particular digit. This means the output will change as 23:59, 03:59, 00:59, 00:09, 00:00 since
that is the order that the SS_Driver updates digits. However, the hours2, hours1, mins2 and mins1 registers are all rolling over correctly and can be viewed directly in the
waveform view in Vivado.
