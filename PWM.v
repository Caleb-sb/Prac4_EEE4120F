`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// Design Name :   PWM
// File Name   :   PWM.v
// Function    :   PWM to adjust 7Seg brightness according to switches
// Coder       :   Caleb Bredekamp [BRDCAL003]
// Comments    :   Adapted from template written for EEE4120F
//------------------------------------------------------------------------------
module PWM(
    input clk,          //input clock
    input [7:0] pwm_in, //input from switches
    output pwm_out      //output of PWM
);

reg [7:0] Counter;      // Period of 2.55us

always @(posedge clk) begin
    pwm_out <= (pwm_in > Counter) ? 1 : 0;
    Counter <= Counter + 1'b1;
end

endmodule
