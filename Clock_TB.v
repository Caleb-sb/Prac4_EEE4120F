// Clock.v TestBench file

module clock_tb();
  // clock and reset are internal
  reg clk, reset;

  // values from testvectors
  reg CLK100MHZ, RESET_BTN, INC_MIN, INC_HOUR, [7:0] pwm_in;

  // output of circuit
  wire [5:0] LED, [7:0] SevenSegment, [7:0] SegmentDrivers;

  // Set up testvector registers
  reg [31:0] vectornum, errors;
  reg [3:0] testvectors[10000:0]; // array of testvectors

end module
