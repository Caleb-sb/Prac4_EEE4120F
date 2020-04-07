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

  // Instantiate the device under test
  WallClock DUT(
    .CLK100MHZ(CLK100MHZ),
    .RESET_BTN(RESET_BTN),
    .INC_MIN(INC_MIN),
    .INC_HOUR(INC_HOUR),
    .pwm_in(pwm_in),
    .LED(LED),
    .SevenSegment(SevenSegment),
    .SegmentDrivers(SegmentDrivers)
    );

  // Generate Clock
  always
    begin // clock signal with period = 2 * halfPeriod
      clk = 1; #halfPeriod; clk = 0; #halfPeriod;
    end
    
end module
