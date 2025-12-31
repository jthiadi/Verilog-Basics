`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg dec;
reg[3:0] current_state, next_state;
parameter S0 = 4'd0;
parameter S1 = 4'd1;
parameter S2 = 4'd2;
parameter S3 = 4'd3;
parameter S4 = 4'd4;
parameter S5 = 4'd5;
parameter S6 = 4'd6;
parameter S7 = 4'd7;
parameter S8 = 4'd8;
parameter S9 = 4'd9;
parameter S10 = 4'd10;

always @(*) begin
        if(current_state == S0)begin 
            if(in == 1) begin next_state <= S4; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S1; dec <= 1'b0; end
        end
        
        else if(current_state == S1)begin
            if(in == 1) begin next_state <= S2; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S8; dec <= 1'b0; end
        end
        
        else if(current_state == S2) begin
            if(in == 1) begin next_state <= S3; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S9; dec <= 1'b0; end
        end
        
        else if(current_state == S3) begin
            if(in == 1) begin next_state <= S0; dec <= 1'b1; end
            else if(in == 0) begin next_state <= S0; dec <= 1'b0; end 
        end
        
        else if(current_state == S4)begin
            if(in == 1) begin next_state <= S7; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S5; dec <= 1'b0; end
        end
        
        else if(current_state == S5) begin
            if(in == 1) begin next_state <= S9; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S6; dec <= 1'b0; end
        end
        
        else if(current_state == S6)begin
            if(in == 1) begin next_state <= S0; dec <= 1'b1; end
            else if(in == 0) begin next_state <= S0; dec <= 1'b0; end
        end
        
        else if(current_state == S7) begin
            if(in == 1) begin next_state <= S10; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S9; dec <= 1'b0; end
        end
        
        else if(current_state == S8) begin
            if(in == 1) begin next_state <= S9; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S9; dec <= 1'b0; end
        end
        
        else if(current_state == S9) begin
            if(in == 1) begin next_state <= S0; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S0; dec <= 1'b0; end
        end
        
        else if(current_state == S10) begin
            if(in == 1) begin next_state <= S0; dec <= 1'b0; end
            else if(in == 0) begin next_state <= S0; dec <= 1'b1; end
        end
end

/*always @(posedge clk) begin
    if(!rst_n) dec <= 1'b0;
    else begin 
        if((current_state == S4 && next_state == S6 && in == 0) || (current_state == S3 && next_state == S4 && in == 1) || (current_state == S5 && next_state == S2 && in == 1) || (current_state == S8 && next_state == S6 && in == 0)) dec <= 1'b1;
        else dec <= 1'b0;
    end
end*/

always @(posedge clk) begin
    if(!rst_n) begin current_state <= S0; next_state <= S0;end
    else current_state <= next_state;
end

endmodule
