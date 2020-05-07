`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// Design Name :   Wallclock
// File Name   :   Wallclock.v
// Function    :   Implements a digital 24hr clock with variable speed
// Coder(s)    :   Caleb Bredekamp [BRDCAL003] and Taboka Nyadza [NYDTAB001]
// Comments    :   Clock speed adjustable through variable CountLimit
//------------------------------------------------------------------------------
module WallClock(
    // Wallclock Inputs
    input CLK100MHZ,
    input wire RESET_BTN,
    input wire INC_MIN,
    input wire INC_HOUR,
    input wire [7:0] pwm_in,
    // Wallclock Outputs
    output wire [5:0] LED,
    output wire [7:0] SevenSegment,
    output wire [7:0] SegmentDrivers
);

//-----------Debouncing Inputs and Initing Registers and Helper Modules---------

    // Reset and Delay
    wire ResetButton;
    // This negates the need for Debouncing Reset Button since Reset signal is
    // localised in the module and we check for a rising edge on reset
    Delay_Reset reset_delayed(CLK100MHZ, RESET_BTN, ResetButton);

    // Add the buttons
    wire MButton;
    wire HButton;
    reg previous_hour   =   0;  //Created to check for rising edge
    reg previous_min    =   0;  //Created to check for rising edge
    // No point doing this to reset since Delay module keeps reset high while
    // btn pressed

    // Debounce Min and Hour Increment
    Debounce Min_Debounce(CLK100MHZ, INC_MIN, MButton);
    Debounce Hour_Debounce(CLK100MHZ, INC_HOUR, HButton);

    // Registers for storing the time
    reg [3:0] hours1    =   4'd0;
    reg [3:0] hours2    =   4'd0;
    reg [3:0] mins1     =   4'd0;
    reg [3:0] mins2     =   4'd0;
    reg [5:0] secs      =   6'b000000;    //for counting seconds
    assign LED          =   secs;         //LEDs on board display the seconds

    reg [26:0]Count     =   27'b0;        //Used to time the wallclock seconds

    // Register to change speed of the clock: must be > 2^17 for testbench if
    // leaving SS_driver timing unchanged
    reg [26:0] CountLimit = 524288;

    //Initialize seven segment
    SS_Driver SS_Driver1(
        // SS Driver Inputs
        CLK100MHZ, ResetButton, hours2, hours1, mins2, mins1, pwm_in,
        // SS Driver Outputs
        SegmentDrivers, SevenSegment
        );

//---------------------------State Machine Variables----------------------------

    reg[1:0] CurrentState   =   2'b0;
    reg[1:0] NextState;

    // Assigning numerical values to states
    parameter [1:0] post_zero   =   0;
    parameter [1:0] post_ten    =   1;
    parameter [1:0] post_twenty =   2;

    //States determine the max output of hour1
    reg [3:0] max_hour1;

//------------------------Sequential Wallclock Operation------------------------

    //The main logic
    always @(posedge CLK100MHZ) begin

        if(ResetButton) begin                       // On reset btn push
            CurrentState <= post_zero;
            mins1   <=  0;
            mins2   <=  0;
            hours1  <=  0;
            hours2  <=  0;
            secs    <=  0;
        end

        else if (MButton && ~previous_min) begin    //Detecting a rising edge
            previous_min    <=  MButton;
            mins1           <=  mins1 + 1;
            if (mins1+1 > 4'd9) begin
                mins1   <=  4'd0;
                mins2   <=  mins2 + 4'd1;
                if (mins2+1 > 4'd5) begin
                    mins2   <=  4'd0;
                end
            end
        end

        else if (HButton && ~previous_hour) begin    //Detecting a rising edge
            previous_hour   <=  HButton;
            hours1          <=  hours1+1;
            if (hours1+1 > max_hour1) begin
                hours1          <=  4'd0;
                CurrentState    <=  NextState;
                hours2          <=  hours2 + 4'd1;
                if (hours2+1 > 4'd2) begin
                    hours2          <=  4'd0;
                    CurrentState    <=  NextState;
                end
            end
        end

        if (~MButton) previous_min  <=  0;
        if (~HButton) previous_hour <=  0;

        if(Count == 0) begin
            if (secs < 6'b111011) begin
                secs    <=  secs + 1'b1;
            end

            else begin
                secs    <=  6'b000000;
                mins1   <=  mins1+1;
                if (mins1+1 > 4'd9) begin
                    mins1   <=  4'd0;
                    mins2   <=  mins2 + 4'd1;
                    if (mins2+1 > 4'd5) begin
                        mins2   <=  4'd0;
                        hours1  <=  hours1 +4'd1;
                        if (hours1+1 > max_hour1) begin
                            hours1          <=  4'd0;
                            CurrentState    <=  NextState;
                            hours2          <=  hours2+4'd1;
                            if (hours2+1 > 4'd2) begin
                                hours2          <=  4'd0;
                                CurrentState    <=  NextState;
                            end
                        end
                    end
                end
            end
        end
        Count <= (Count <= CountLimit) ? Count+1 : 0;

        // This State Machine changes the maximum value which hours1 can reach
        // there are three states: the first two let hours reach 9 and the last
        // allows up till hour 3. (placed here to avoid inferred latch)
        case (CurrentState)
            post_zero: begin
                NextState   <=  post_ten;
                max_hour1   <=  4'd9;
            end
                post_ten: begin
                NextState   <=  post_twenty;
                max_hour1   <=  4'd9;
            end
            post_twenty: begin
                NextState   <=  post_zero;
                max_hour1   <=  4'd3;
            end
        endcase
    end

endmodule
