`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
    input clk, rst_n;
    input enable;
    input flip;
    input [4-1:0] max;
    input [4-1:0] min;
    output direction;
    output [4-1:0] out;
    
    reg [4-1:0] out, next_value;
    reg direction, next_direction;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            out <= min;              
            direction <= 1'b1;      
        end
        else if (enable) begin
            out <= next_value;      
            direction <= next_direction;  
        end
    end
    
    always @(*) begin
        if (enable) begin 
            if (out > max || out < min || (out == max && max == min) || min >= max || min == max) begin
                next_value = out;        
                next_direction = direction;
            end
            
            else begin 
                if (flip) begin
                    next_direction = ~direction;   
                    
                    if (!next_direction) 
                        next_value = out - 4'b1;   
                    else 
                        next_value = out + 4'b1;   
                end
                else begin
                    if (direction) begin
                        if (out == max) begin
                            next_value = out - 4'b1; 
                            next_direction = 1'b0;
                        end
                        else begin
                           next_value = out + 4'b1; 
                           next_direction = direction;
                        end
                    end
                    else if (!direction) begin 
                        if (out == min) begin
                           next_value = out + 4'b1; 
                           next_direction = 1'b1;
                        end
                        else begin
                         next_value = out - 4'b1;  
                         next_direction = direction;
                        end
                    end
                end
            end
        end
        
        else begin 
            next_value = out;
            next_direction = direction;
        end
end

endmodule