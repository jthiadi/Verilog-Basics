`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
    input clk, rst_n;
    input enable;
    output  direction;
    output [4-1:0] out;
    
    reg [4-1:0] next_value, out; 
    reg next_direction, direction;

    always @(posedge clk) begin
        if (!rst_n) begin
            direction <= 1'b1;
            out <= 4'b0000;
        end
        else if (enable) begin
            direction <= next_direction;
            out <= next_value;
        end
    end
    
    always @(*) begin
        if (enable) begin
            if (direction) begin
                if (out == 4'b1111) begin
                    next_direction = 1'b0;
                    next_value = out - 4'b1;
                end
                else begin
                    next_direction = direction;
                    next_value = out + 4'b1;
                end
            end 
            else if (direction == 1'b0) begin
                if (out == 4'b0000) begin
                     next_direction = 1'b1;
                     next_value = out + 4'b1;
                end
                else begin
                    next_direction = direction;
                    next_value = out - 4'b1;
                end
            end
        end 
        else begin
            next_value = out;
            next_direction = direction;
        end
    
    end

endmodule
