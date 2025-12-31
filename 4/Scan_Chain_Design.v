`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;
    
    wire [4-1:0] a, b;
    wire [8-1:0] p;
    
    multiplier_4_bit mul1(p, a, b);
    Scan_DFF SDFF0(a[3], rst_n, clk, scan_in, scan_en, p[7]);
    Scan_DFF SDFF1(a[2], rst_n, clk, a[3], scan_en, p[6]);
    Scan_DFF SDFF2(a[1], rst_n, clk, a[2], scan_en, p[5]);
    Scan_DFF SDFF3(a[0], rst_n, clk, a[1], scan_en, p[4]);
    Scan_DFF SDFF4(b[3], rst_n, clk, a[0], scan_en, p[3]);
    Scan_DFF SDFF5(b[2], rst_n, clk, b[3], scan_en, p[2]);
    Scan_DFF SDFF6(b[1], rst_n, clk, b[2], scan_en, p[1]);
    Scan_DFF SDFF7(b[0], rst_n, clk, b[1], scan_en, p[0]);
    
    assign scan_out = b[0];
endmodule

module multiplier_4_bit(out, a, b);
    input [4-1:0] a, b;
    output [8-1:0] out;
    
    reg [8-1:0] out;
    
    always @(a or b) begin
       out = a * b;
    end
endmodule

module Scan_DFF(out, rst_n, clk, scan_in, scan_en, data);
    input scan_en, scan_in, data, rst_n, clk;
    output out;
    
    reg DFF;
    
    always @(posedge clk)begin
        if (!rst_n)begin
            DFF <= 1'b0;
        end

        else begin
            if (scan_en) DFF <= scan_in;
            else DFF <= data;
        end
    end
    
    assign out = DFF;
endmodule