`timescale 1ns / 1ps

module fpga_graycode(clk, binary, AN, seg);
    input clk;
    input [3:0] binary;
    wire [3:0] graycode;
    
    output reg [3:0] AN; 
    output reg [6:0] seg;
    
    buf hello(graycode[3], binary[3]);
    xor kontol(graycode[2], graycode[3], binary[2]);
    xor tai(graycode[1], graycode[2], binary[1]);
    xor apasih(graycode[0], graycode[1], binary[0]);
    
    reg [16:0] refresh = 17'd0;
    reg [2:0] sel = 2'b00;
    
    always @(posedge clk) begin
        refresh <= refresh + 17'd1;
        if (refresh == 17'd99999) begin
            refresh <= 17'd0; 
            sel <= sel + 2'd1;
        end
    end 
    
    always @(*) begin 
        case(sel) 
            2'b00: AN = 4'b0111;    
            2'b01: AN = 4'b1011;    
            2'b10: AN = 4'b1101;    
            2'b11: AN = 4'b1110;    
        endcase    
    end
    
    always @(*) begin
        case(AN)
            4'b0111: begin
            if(graycode >= 8 && graycode <= 15) seg = 7'b1111001;
            else seg = 7'b1000000;
            end
            
            4'b1011:
             begin
            if(graycode >= 4 && graycode <= 7 || graycode >= 12 && graycode <= 15) seg = 7'b1111001;
            else seg = 7'b1000000;
            end

            
            4'b1101:
             begin
            if(graycode == 2 || graycode == 3 || graycode == 6 || graycode == 7 || graycode == 10 || graycode == 11 || graycode == 14 || graycode == 15) seg = 7'b1111001;
            else seg = 7'b1000000;
            end
            
            4'b1110: 
                       begin
            if(graycode % 2 == 1) seg = 7'b1111001;
            else seg = 7'b1000000;
            end
        endcase
    end
    
endmodule
