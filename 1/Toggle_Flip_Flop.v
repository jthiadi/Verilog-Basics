`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
    input clk;      // clock signal
    input t;        // for toggling
    input rst_n;    // reset signal
    output q;       // current state
    wire and1_out, not_q, and2_out, not_t, or1_out, and3_out;
    
    // invert t and q to make XOR
    not NOT1(not_t, t);
    not NOT2(not_q, q);
    
    // xor
    and AND1(and1_out, not_q, t);
    and AND2(and2_out, q, not_t);
    or OR1(or1_out, and1_out, and2_out);
    
    // rst_n
    and AND3(and3_out, or1_out, rst_n);
    
    // result from AND3 is used as input for dff
    D_Flip_Flop dff(q, clk, and3_out);
    
endmodule

module D_Flip_Flop(q, clk, d);
    input clk, d;
    output q;
    wire not_clk, master_out;

    not NOT2(not_clk, clk);

    D_Latch master_1atch(master_out, not_clk, d),
            slave_latch(q, clk, master_out);

endmodule

module D_Latch(q, En, d);
input En, d;
output q;

wire not_D, not_Q, nand1_out, nand2_out;

not NOT1(not_D, d);

nand NAND1(nand1_out, d, En);
nand NAND2(nand2_out, not_D, En);
nand NAND3(not_Q, nand1_out, q);
nand NAND4(q, nand2_out, not_Q);

endmodule