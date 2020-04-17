# Prac 4
A state machine implementation of a WallClock on an FPGA with Verilog.

For a demo video of rubric functionality, please see: https://youtu.be/QmgJPbyS560

##Test Bench
If you want to run the test bench on Vivado, it might be better to increase the increment speed of seconds as well as the speed of the SS_Driver to update the digits of the
seven segment display faster. This is to help complete a full cycle of the test bench a bit faster.

Note also: The output of the testbench is exactly what the SevenSegment display will receive and is translated into decimal digits. Therefore, at rollover times (ie:23:59),
the TestBench will refresh only as fast as the SS_Driver refreshes that particular digit. This means the output will change as 23:59, 03:59, 00:59, 00:09, 00:00 since
that is the order that the SS_Driver updates digits.

When simulating the project itself, however, it is sufficient to only change the speed of the seconds as the register contents are directly visible in the waveform window.
