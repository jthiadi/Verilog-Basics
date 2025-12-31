`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
    input clk, rst_n;
    input start;
    input [15:0] a;
    input [15:0] b;
    output done;
    output [15:0] gcd;
    
    parameter WAIT = 2'b00;
    parameter CAL = 2'b01;
    parameter FINISH = 2'b10;
    
    reg done;

    reg [1:0] current_state, next_state;
    reg [15:0] in_a, next_in_a, in_b, next_in_b;
    reg [15:0] final_gcd, process_gcd, gcd;
    reg calculation_done;
    reg two_cycle;

always @(posedge clk) begin
    if(!rst_n) begin
        current_state <= WAIT;
    end 
    
    else begin
        current_state <= next_state;
    end   
end

always @(posedge clk) begin
    in_a <= next_in_a;
    in_b <= next_in_b;
    final_gcd <= process_gcd;
end

always @(posedge clk) begin
    if(current_state == FINISH) begin
        two_cycle <= two_cycle + 1'b1;
    end
    
    else begin
        two_cycle <= 1'b0;
    end
end 

always @(*) begin
    if(current_state == CAL) next_state = calculation_done ? FINISH : CAL;
    else if(current_state == FINISH) next_state = two_cycle ? WAIT : FINISH;
    else next_state = start ? CAL : WAIT;
end

always @(*) begin
    if(current_state == CAL) begin
        if(in_a == 16'd0) begin
            if(in_b == 16'd0) begin
                next_in_a = in_a;
                next_in_b = in_b;
                process_gcd = 16'd0;
                calculation_done = 1'b1;
            end
            else begin
                next_in_a = in_a;
                next_in_b = in_b;
                process_gcd = in_b;
                calculation_done = 1'b1;
            end
        end
        
        else begin
            if(in_b != 16'd0) begin
                process_gcd = final_gcd;
                calculation_done = 1'b0;
                
                if(in_a > in_b) begin
                    next_in_a = in_a - in_b;
                end
                
                else begin
                    next_in_b = in_b - in_a;
                end
            end
            
            else begin
                next_in_a = in_a;
                next_in_b = in_b;
                process_gcd = in_a;
                calculation_done = 1'b1;           
            end
        end
    end
    
    else if(current_state == FINISH) begin
        next_in_a = in_a; 
        next_in_b = in_b;
        gcd = final_gcd;
        done = 1'b1;
        calculation_done = 1'b0; 
    end
    
    else begin
        next_in_a = a;
        next_in_b = b;
        gcd = 16'd0;
        done = 1'b0;
        calculation_done = 1'b0;
    end
end

endmodule
