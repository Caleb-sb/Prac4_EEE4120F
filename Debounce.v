`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// Design Name :   Debounce
// File Name   :   Debounce.v
// Function    :   Debounces the button inputs
// Coder       :   Caleb Bredekamp [BRDCAL003]
// Comments    :   Because clock.v only changes on a btn rising edge, Debouncing
//                 can be a lot simpler since holding down the button only has
//                 1 rising edge
//------------------------------------------------------------------------------
module Debounce(
    input clk   ,       //The 100MHZ clock
    input btn   ,       //The button to be debounced
    output out_reg      //The debounced output
);

reg [20:0]Count = 21'b0; //assume count is null on FPGA configuration

//------------------------------------------------------------------------------
always @(posedge clk) begin

    if (btn != out_reg && Count == 0) begin     // if btn doesnt match output
        out_reg <= btn;                         // set output to state
        Count   <= 1'b1;                        // start counting
    end
    else if (Count != 0) Count <= Count+1'b1;   //keep counting
end

endmodule
