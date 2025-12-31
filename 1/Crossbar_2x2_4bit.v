`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire [3:0] w1, w2, w3, w4;
wire not_sel;

not not1(not_sel, control);
dmux_1to2 dmux1 (in1, control, w1, w2);
dmux_1to2 dmux2 (in2, not_sel, w3, w4);
Mux_2x1 mux1 (w1, w3, control, out1);
Mux_2x1 mux2 (w2, w4, not_sel, out2);
endmodule

module dmux_1to2(in, sel, a, b);
input[3:0] in;
input sel;
output[3:0] a, b;
wire not_sel;

not(not_sel, sel);
and and1(a[0], in[0], not_sel);
and and2(a[1], in[1], not_sel);
and and3(a[2], in[2], not_sel);
and and4(a[3], in[3], not_sel);

and and5(b[0], in[0], sel);
and and6(b[1], in[1], sel);
and and7(b[2], in[2], sel);
and and8(b[3], in[3], sel);
endmodule

module Mux_2x1(a, b, s, out);
input[3:0] a, b;
input s;
wire not_sel;
wire [3:0]w1, w2;
output[3:0] out;

not(not_sel, s);

and and0(w1[3], a[3], not_sel);
and and1(w1[2], a[2], not_sel);
and and2(w1[1], a[1], not_sel);
and and3(w1[0], a[0], not_sel);
 
and and4(w2[3], b[3], s);
and and5(w2[2], b[2], s);
and and6(w2[1], b[1], s);
and and7(w2[0], b[0], s);
 
or or1(out[3], w1[3], w2[3]);
or or2(out[2], w1[2], w2[2]);
or or3(out[1], w1[1], w2[1]);
or or4(out[0], w1[0], w2[0]);
 
endmodule