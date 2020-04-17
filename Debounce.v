`timescale 1ns / 1ps
module Debounce(
    input clk,
    input btn,
    output reg out_reg
);

reg [20:0]Count = 21'b0; //assume count is null on FPGA configuration


//--------------------------------------------
always @(posedge clk) begin
    // implement your logic here
    if (btn != out_reg && Count == 0) begin
        out_reg <= btn;
        Count <= 1'b1;
    end
    else if (Count != 0) Count <= Count+1'b1;
end


endmodule
