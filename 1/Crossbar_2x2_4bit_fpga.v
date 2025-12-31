`timescale 1ns/1ps

// 2x2 4-bit crossbar
module Crossbar_2x2_4bit(in1, in2, control, out1, out2, out1_1, out2_1);
    input [4-1:0] in1, in2;         // 4-bit inputs (in1, in2)
    input control;                  // control signal to select path
    output [4-1:0] out1, out2;      // 4-bit outputs (buffered)
    output [4-1:0] out1_1, out2_1;  // outputs (unbuffered)

    wire [3:0] w1, w2, w3, w4;      // connection between DMUX and MUX
    wire not_sel;                   // for inverted control signal

    // invert control signal
    not not1(not_sel, control);

    // demux the inputs based on the control signal
    Dmux_1x2_4bit dmux1 (in1, w1, w2, control);    // demux in1 into w1 and w2
    Dmux_1x2_4bit dmux2 (in2, w3, w4, not_sel);    // demux in2 into w3 and w4

    // mux the demuxed outputs back based on control
    Mux_2x1 mux1 (control, w1, w3, out1_1);  // select between w1 and w3 for out1_1
    Mux_2x1 mux2 (not_sel, w2, w4, out2_1);  // select between w2 and w4 for out2_1

    // buffer the outputs (so that each output can correspond to 2 LEDs)
    buf BUF1(out1[0], out1_1[0]),
        BUF2(out1[1], out1_1[1]),
        BUF3(out1[2], out1_1[2]),
        BUF4(out1[3], out1_1[3]);

    buf BUF5(out2[0], out2_1[0]),
        BUF6(out2[1], out2_1[1]),
        BUF7(out2[2], out2_1[2]),
        BUF8(out2[3], out2_1[3]);

endmodule

// 4-bit 1x2 de-multiplexer
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

// 2x1 4-bit Multiplexer Module
module Mux_2x1(sel_1, a, b, f);
    input [4-1:0] a, b;           // 4-bit inputs a and b
    input sel_1;                  // selector
    output [4-1:0] f;             // 4-bit output
    
    wire sel_0;                   // inverted selector
    wire [4-1:0] a1, a2;          // for AND outputs

    // invert select signal
    not NOT1(sel_0, sel_1);

    // AND the inputs with the selector (mux logic)
    and AND1(a1[3], sel_0, a[3]),
        AND2(a1[2], sel_0, a[2]),
        AND3(a1[1], sel_0, a[1]),
        AND4(a1[0], sel_0, a[0]);

    and AND5(a2[3], sel_1, b[3]),
        AND6(a2[2], sel_1, b[2]),
        AND7(a2[1], sel_1, b[1]),
        AND8(a2[0], sel_1, b[0]);

    // OR the AND results to produce final output
    or OR1(f[3], a1[3], a2[3]),
       OR2(f[2], a1[2], a2[2]),
       OR3(f[1], a1[1], a2[1]),
       OR4(f[0], a1[0], a2[0]);

endmodule