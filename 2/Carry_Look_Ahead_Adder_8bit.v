`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;
wire c4;

wire[1:0]p, g;
wire c_temp;
CLA_4bit CLA4_1(a[3:0], b[3:0],c0,s[3:0], p[0], g[0], c4);
CLA_4bit CLA4_2(a[7:4], b[7:4],c4, s[7:4], p[1], g[1], c_temp);
CLA_2bit CLA2_3(p, g, c0, c8);
endmodule

module and_gate(a, b, out);
input a, b;
output out;
wire and_temp;

nand and_1(and_temp, a, b);
nand and_2(out, and_temp, and_temp);
endmodule

module xor_gate(a, b, out);
input a, b;
output out;
wire not_a, not_b;
nand not1(not_a, a, a);
nand no2(not_b, b, b);

wire xor_temp1, xor_temp2;
nand xor1(xor_temp1, a, not_b);
nand xor2(xor_temp2, b, not_a);
nand xor3(out, xor_temp1, xor_temp2);
endmodule

module or_gate(a, b, out);
input a, b;
output out;

wire not_a, not_b;
nand not1(not_a, a, a);
nand no2(not_b, b, b);

nand result(out, not_a, not_b);
endmodule

module CLA_4bit(a, b, cin, sum, pro, gen, carry);
input [3:0] a, b;
input cin;
output [3:0] sum;
output pro, gen, carry;
wire [3:0] p, g;
wire [3:1] c;

// find the p from a xor b
xor_gate xor1(a[0], b[0], p[0]);
xor_gate xor2(a[1], b[1], p[1]);
xor_gate xor3(a[2], b[2], p[2]);
xor_gate xor4(a[3], b[3], p[3]);

// find the g from a and b
and_gate andg1(a[0], b[0], g[0]);
and_gate andg2(a[1], b[1], g[1]);
and_gate andg3(a[2], b[2], g[2]);
and_gate andg4(a[3], b[3], g[3]);

//find the carry
wire and_temp; // c0
and_gate gate1(p[0], cin, and_temp); //p0c0
or_gate result(and_temp, g[0], c[1]); // g0 + p0c0

wire and_temp2, and_temp3, or_temp; //c1
and_gate g1(and_temp, p[1], and_temp2); //p1p0c0
and_gate g2(p[1], g[0], and_temp3); //p1g0
or_gate g3(and_temp2, and_temp3, or_temp); //p1p0c0 + p1g0
or_gate result1(or_temp, g[1], c[2]); //p1p0c0 + p1g0 + g1

wire and_temp4, and_temp5, and_temp6, or_temp2, or_temp3; //c2
and_gate ga1(and_temp2, p[2], and_temp4); //p2p1p0c0
and_gate ga2(and_temp3, p[2], and_temp5); //p2p1g0
and_gate ga3(p[2], g[1], and_temp6); //p2g1
or_gate ga4(and_temp4, and_temp5, or_temp2); 
or_gate ga5(or_temp2, and_temp6, or_temp3);
or_gate result2(or_temp3, g[2], c[3]);

wire and_temp7, and_temp8, and_temp9, and_temp10, or_temp4, or_temp5, or_temp6;
and_gate gat1(and_temp4, p[3], and_temp7); //p3p2p1p0c0
and_gate gat2(and_temp5, p[3], and_temp8); //p3p2p1g0
and_gate gat3(and_temp6, p[3], and_temp9); //p3p2g1
and_gate gat4(p[3], g[2], and_temp10); //p3g2
or_gate orr1(and_temp7, and_temp8, or_temp4);
or_gate orr2(or_temp4, and_temp9, or_temp5);
or_gate orr3(or_temp5, and_temp10, or_temp6);
or_gate result3(or_temp6, g[3], carry);

//find the sum
xor_gate sum1(p[0], cin, sum[0]);
xor_gate sum2(p[1], c[1], sum[1]);
xor_gate sum3(p[2], c[2], sum[2]);
xor_gate sum4(p[3], c[3], sum[3]);

// p0-3 = p3p2p1p0, let's make (p0-3)
wire p_temp1, p_temp2;
and_gate and1(p[3], p[2], p_temp1);
and_gate and2(p_temp1, p[1], p_temp2);
and_gate and3(p_temp2, p[0], pro);

// let's make the g0-3
wire p3g2, p3p2g1, pg_temp1, p3p2p1g0, pg_temp2;
and_gate p3andg2(p[3], g[2], p3g2);

and_gate and_1(p[3], p[2], pg_temp1);
and_gate and_2(pg_temp1, g[1], p3p2g1);

and_gate and_3(pg_temp1, p[1], pg_temp2);
and_gate and_4(pg_temp2, g[0], p3p2p1g0);

//g0-3 = g3 + p3g2 + p3p2g1 + p3p2p1g0
wire org_temp1, org_temp2, org_temp3;
or_gate or1(g[3], p3g2, org_temp1);
or_gate or2(org_temp1, p3p2g1, org_temp2);
or_gate or3(org_temp2, p3p2p1g0, gen);
endmodule

module CLA_2bit(a,b, cin, carry);
input[1:0] a,b;
input cin;
wire [1:0] sum;
output carry;

wire temp, c1;
and_gate and1(a[0], cin, temp);
or_gate or1(temp, b[0], c1);

wire temp2;
and_gate and2(a[1], c1, temp2);
or_gate or2(temp2, b[1], carry);

//the sum (formality)
wire temp3, temp4;
xor_gate xor1(a[0], b[0], temp3);
xor_gate xor2(temp3, cin, sum[0]);
xor_gate xor3(a[1], b[1], temp4);
xor_gate xor4(temp4, c1, sum[1]);
endmodule