`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2020 04:36:03 PM
// Design Name: 
// Module Name: clock_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_tb;

reg CLK100MHZ = 0;
reg RESET_BTN =0;
reg INC_MIN =0;
reg INC_HOUR = 0;
reg [7:0] pwm_in = 0;
	//outputs - these will depend on your board's constraint files
wire [5:0] LED;
wire [7:0] SevenSegment;
wire [7:0] SegmentDrivers;

WallClock dut(
    .CLK100MHZ(CLK100MHZ),
    .RESET_BTN(RESET_BTN),
    .INC_MIN(INC_MIN),
    .INC_HOUR(INC_HOUR),
    .pwm_in(pwm_in),
    
    .LED(LED),
    .SevenSegment(SevenSegment),
    .SegmentDrivers(SegmentDrivers)
    );

integer k = 0;
initial begin
    $display("\t||\t\t  Time  \t\t|  SevenSegment  |\tSeconds\t||");
    $display("\t----------------------------------------------");
    
    $monitor("\t||%d\t| \t%b\t |\t%b\t||", $time, SevenSegment, LED);
    
    CLK100MHZ = 0;
    RESET_BTN =0;
    INC_MIN =0;
    INC_HOUR = 0;
    pwm_in = 5;
end

always
    #5 CLK100MHZ <= ~CLK100MHZ;
        
    
endmodule
