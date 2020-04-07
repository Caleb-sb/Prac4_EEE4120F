// Clock.v TestBench file

module clock_tb();
  // clock and reset are internal
  reg clk, reset;

  // values from testvectors
  reg CLK100MHZ, RESET_BTN, INC_MIN, INC_HOUR,
  [7:0] pwm_in, wire [5:0] LED_Expected,
  [7:0] SevenSegment_Expected, [7:0] SegmentDrivers_Expected;

  // output of circuit
  wire [5:0] LED, [7:0] SevenSegment, [7:0] SegmentDrivers;

  // Set up testvector registers
  reg [31:0] vectornum, errors;
  reg [33:0] testvectors[10000:0]; // array of testvectors (each one is size 34 bit)
  reg halfPeriod = 5;

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


  initial // Will execute at the beginning once
    begin
      // NB: ClockTestVector.tv must be written in hexadecimal
      $readmemb("ClockTestVector.tv", testvectors); // Read vectors
      vectornum = 0; errors = 0; // Initialize
      reset = 1; #27; reset = 0; // Apply reset wait
    end

  // apply test vectors on rising edge of clk
  // apply 1ns delay so that inputs don't change same time with clock
  always @(posedge clk)
    begin
      #1; {CLK100MHZ, RESET_BTN, INC_MIN, INC_HOUR,
      pwm_in, LED_Expected, SevenSegment_Expected,
      SegmentDrivers_Expected} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  // results must be checked here before next clock rise (where next test will happen)
  always @(negedge clk)
    if (~reset) // skip during reset
      begin
        if (LED !== LED_Expected || SevenSegment !== SevenSegment_Expected || SegmentDrivers !== SegmentDrivers_Expected)
          begin
            // Now display details about the error and increment error counter
            $display("Error: inputs = %b", {CLK100MHZ, RESET_BTN, INC_MIN, INC_HOUR, pwm_in});
            $display(" outputs = %b (%b exp)", LED, LED_Expected);
            $display(" outputs = %b (%b exp)", SevenSegment, SevenSegment_Expected);
            $display(" outputs = %b (%b exp)", SegmentDrivers, SegmentDrivers_Expected);
            errors = errors + 1;
          end

        // increment array index and read next testvector
        vectornum = vectornum + 1;
        if (testvectors[vectornum] === 4'bx) // might have issue here
          begin
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish; // End simulation
          end
      end




end module
