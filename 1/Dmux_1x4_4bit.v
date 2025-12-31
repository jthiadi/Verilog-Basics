`timescale 1ns/1ps

// 1-to-4 DMUX with 4-bit input
module Dmux_1x4_4bit(in, a, b, c, d, sel);
    // 4-bit input and 2-bit selector
    input [4-1:0] in;
    input [2-1:0] sel;
    
    // 4 4-bit outputs
    output [4-1:0] a, b, c, d;
    
    // to hold output values of the first 1-to-2 DMUX
    wire [4-1:0] mux1_out_0, mux1_out_1;

    // 1-to-2 DMUX based on MSB of selector
    Dmux_1x2_4bit dmux_1(in, mux1_out_0, mux1_out_1, sel[1]);

    // demuxing each output from the previous 1-to-2 DMUX based on LSB of selector
    Dmux_1x2_4bit dmux_2(mux1_out_0, a, b, sel[0]);
    Dmux_1x2_4bit dmux_3(mux1_out_1, c, d, sel[0]);

endmodule

// 1-to-2 DMUX with 4-bit input
module Dmux_1x2_4bit(in, and_out_1, and_out_2, sel);
    // 4-bit input and 1-bit selector
    input [4-1:0] in;
    input sel;

    // 4-bit outputs
    output [4-1:0] and_out_1, and_out_2;
    
    // to hold inverted value of selector
    wire not_sel;

    // invert selector for AND logic
    not NOT1(not_sel, sel);

    // AND gates to pass input bits to and_out_1 when selector is 0
    and AND1(and_out_1[3], not_sel, in[3]),
        AND2(and_out_1[2], not_sel, in[2]),
        AND3(and_out_1[1], not_sel, in[1]),
        AND4(and_out_1[0], not_sel, in[0]);

    // AND gates to pass input bits to and_out_2 when selector is 1
    and AND5(and_out_2[3], sel, in[3]),
        AND6(and_out_2[2], sel, in[2]),
        AND7(and_out_2[1], sel, in[1]),
        AND8(and_out_2[0], sel, in[0]);

endmodule
