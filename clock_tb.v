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
//DUT inputs
reg CLK100MHZ = 0;
reg RESET_BTN =0;
reg INC_MIN =0;
reg INC_HOUR = 0;
reg [7:0] pwm_in = 0;
//DUT outputs
wire [5:0] LED;
wire [7:0] SevenSegment;
wire [7:0] SegmentDrivers;

//used for translated time printout
reg[3:0] digit = 0;
reg[3:0] slot = 0;
reg[3:0] hrs2 = 0; 
reg[3:0] hrs1 = 0;
reg[3:0] min2 = 0;
reg[3:0] min1 = 0;

//For stopping the sim
integer cycle_counter = 0; 

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

initial begin

    $display("\t||\t\t  Time  \t\t|      Wallclock    ||");
    $display("\t--------------------------------------------------------------------");
    $monitor("\t||%d\t|\t%d%d : %d%d : %d ||", $time, hrs2, hrs1, min2, min1, LED);
    
    CLK100MHZ = 0;
    RESET_BTN =0;
    INC_MIN =0;
    INC_HOUR = 0;
    pwm_in = 0;
end


always
    #5 CLK100MHZ <= ~CLK100MHZ;   
    
always @(posedge CLK100MHZ) begin
    cycle_counter = cycle_counter+1;
    if(cycle_counter == 865717990) begin
        $stop;
    end
end

always @(*) begin
    case(SevenSegment)
        ~7'b0111111 : digit <=  4'd0;  
        ~7'b0000110 : digit <=  4'd1;  
        ~7'b1011011 : digit <=  4'd2;  
        ~7'b1001111 : digit <=  4'd3;  
        ~7'b1100110 : digit <=  4'd4;  
        ~7'b1101101 : digit <=  4'd5;  
        ~7'b1111101 : digit <=  4'd6;  
        ~7'b0000111 : digit <=  4'd7;  
        ~7'b1111111 : digit <=  4'd8;  
        ~7'b1101111 : digit <=  4'd9;
        default: digit <= 7'b0000000;
    endcase
    
    case(SegmentDrivers)
        8'b11110111 : hrs2 <= digit;
        8'b11111011 : hrs1 <= digit;
        8'b11111101 : min2 <= digit;
        8'b11111110 : min1 <= digit;
    endcase
end

endmodule
