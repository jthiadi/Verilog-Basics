`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_FPGA (clk, rst_n, enable, flip, max, min, AN, seg);
    input clk, rst_n;
    input enable;
    input flip;
    input [4-1:0] max;
    input [4-1:0] min;

    output [3:0] AN;
    output [6:0] seg;

    wire [4-1:0] out;
    wire direction;
    wire [1:0] sel; // for mux selection

    // debounce and one-pulse for flip and reset signals
    wire rst_debounced, rst_onepulse, flip_debounced, flip_onepulse;
    debounce rst1(rst_debounced, rst_n, clk);
    onepulse rst1_1(rst_debounced, clk, rst_onepulse);

    debounce flip1(flip_debounced, flip, clk);
    onepulse flip1_1(flip_debounced, clk, flip_onepulse);

    wire clkout;
    Clock_1Hz convert(clk, clkout);

    Parameterized_Ping_Pong_Counter counter(clk, rst_onepulse, enable, flip_onepulse, clkout, max, min, out, direction);
    
    // to slow down the display
    reg [19:0]refresh;
    always @(posedge clk) begin
        refresh <= refresh + 1;
    end
    
    assign sel = refresh[19:18];

    Seven_Segment_Display seven_seg_disp(clk, out, direction, AN, seg, sel);
endmodule

// debounce circuit
module debounce (pb_debounced, pb, clk);
    input pb, clk;
    output pb_debounced;
    reg [3:0]DFF;
    always @(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = (DFF == 4'b1111) ? 1'b1 : 1'b0;
endmodule

// one-pulse circuit
module onepulse (pb_debounced, clk, pb_onepulse);
    input pb_debounced, clk;
    output reg pb_onepulse;
    reg pb_debounced_delay;

    always @(posedge clk) begin
        pb_onepulse <= pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
    end
endmodule

// clock divider to generate 1Hz clock from high frequency clock
module Clock_1Hz(clk, clkout);
    input clk;
    output clkout;
    reg clkout;
    reg [26:0] counter = 0;

    always @(posedge clk) begin
        if (counter >= 99999999) 
        begin
            counter <= 0;
            clkout <= 1;  // set clkout high when counter reaches 99999999
        end 
        else 
        begin
            counter <= counter + 1;
            clkout <= 0;  // set clkout low otherwise
        end
    end
endmodule

// seven segment display
module Seven_Segment_Display (clk, out, direction, AN, seg, sel);
    input clk;
    input [3:0] out;
    input direction;
    output [3:0] AN;
    output [6:0] seg;
    input [1:0] sel;
    
    reg [3:0] AN;
    reg [6:0] seg;

    always @(*) begin
        case (sel)
            2'b00 : AN = 4'b0111;
            2'b01 : AN = 4'b1011;
            2'b10 : AN = 4'b1101;
            2'b11 : AN = 4'b1110;
            default : AN = 4'b0111;
        endcase
    end

    always @(*) begin 
        case (AN)
            // display out
            4'b0111 : begin 
                if (out >= 4'd10) seg = 7'b1001111;
                else seg = 7'b0000001;
            end
            4'b1011 : begin 
                case (out) 
                    4'd0, 4'd10: seg = 7'b0000001;
                    4'd1, 4'd11: seg = 7'b1001111;
                    4'd2, 4'd12: seg = 7'b0010010;
                    4'd3, 4'd13: seg = 7'b0000110;
                    4'd4, 4'd14: seg = 7'b1001100;
                    4'd5, 4'd15: seg = 7'b0100100;
                    4'd6: seg = 7'b0100000;
                    4'd7: seg = 7'b0001111;
                    4'd8: seg = 7'b0000000;
                    4'd9: seg = 7'b0000100;
                endcase
            end
            // display direction
            4'b1101, 4'b1110: begin
                if (direction == 1'b1) seg = 7'b0011101;
                else seg = 7'b1100011;
            end
            default: seg = 7'b0000000;
        endcase
    end
endmodule

// parameterized ping-pong counter module (modified)
module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, clkout, max, min, out, direction);
    input clk;
    input rst_n;
    input enable;
    input flip;
    input clkout;
    input [3:0] max;
    input [3:0] min;
    output [3:0] out;
    output direction;
    
    reg [3:0] out;
    reg direction;
    always @(posedge clk) begin
        if (rst_n) 
        begin  
            out <= min;              
            direction <= 1'b1;        
        end 
        
        else if (max > min && out < max && out > min && enable && flip) 
        begin
            if (direction == 1'b1) 
            begin 
                direction <= 1'b0;
                out <= out - 1'b1;
            end 
            
            else 
            begin 
                direction <= 1'b1;
                out <= out + 1'b1;
            end
        end 
        
        else 
        begin
            if (enable && clkout) 
            begin  // only update when enabled and clock pulse is high
                if (out > max || out < min || (out == max && max == min) || min >= max || min == max) 
                begin
                    out <= out;         // stay at current value if invalid range
                    direction <= direction;
                end 
                
                else 
                begin
                    if (direction) 
                    begin
                        if (out == max) 
                        begin
                            out <= out - 4'b1; // at max, start decrementing
                            direction <= 1'b0;
                        end 
                        
                        else 
                        begin
                            out <= out + 4'b1; // increment
                            direction <= direction;
                        end
                    end 
                    
                    else if (!direction) 
                    begin
                        if (out == min) 
                        begin
                            out <= out + 4'b1; // at min, start incrementing
                            direction <= 1'b1;
                        end 
                        
                        else 
                        begin
                            out <= out - 4'b1; // decrement
                            direction <= direction;
                        end
                    end
                end
            end
        end
    end
endmodule