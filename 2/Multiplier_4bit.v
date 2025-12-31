`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
    input [4-1:0] a, b;
    output [8-1:0] p;

    //p0 = a0b0
    and_gate p0_result(a[0], b[0], p[0]);

    //First FA
    wire [3:0] ab0, ab1, sum1, cout1;
    and_gate a1(a[1], b[0], ab0[0]);
    and_gate a2(a[2], b[0], ab0[1]);
    and_gate a3(a[3], b[0], ab0[2]);

    Multiplier_4x1 M1(a, b[1], ab1);
    FA_4bit FA1(0, ab0[2], ab0[1], ab0[0], ab1[3], ab1[2], ab1[1], ab1[0], 0, cout1, sum1);

    //p1 = a1b0 + a0b1
    and_gate p1_result(sum1[0], sum1[0], p[1]);

    //Second FA
    wire[3:0] ab2, sum2, cout2;

    Multiplier_4x1 M2(a, b[2], ab2);
    
    FA_4bit FA2(cout1[3], sum1[3], sum1[2], sum1[1], ab2[3], ab2[2], ab2[1], ab2[0], 0, cout2, sum2);

    //p2 = a2b0 + a1b1 + a0b2
    and_gate p2_result(sum2[0], sum2[0], p[2]);

    //Third FA
    wire[3:0] ab3, sum3, cout3;

    Multiplier_4x1 M3(a, b[3], ab3);

    FA_4bit FA3(cout2[3], sum2[3], sum2[2], sum2[1], ab3[3], ab3[2], ab3[1], ab3[0], 0, cout3, sum3);

    //p3 = a3b0 + a2b1 + a1b2 + a0b3
    and_gate p3_result(sum3[0], sum3[0], p[3]);

    //p4 = cout FA1 + a3b1 + a2b2 + a1b3
    and_gate p4_result(sum3[1], sum3[1], p[4]);

    //p5 = cout FA2 + a3b2 + a2b3
    and_gate p5_result(sum3[2], sum3[2], p[5]);

    //p6 = cout FA3 + a3b3, p7 = the cout of the HA
    and_gate p6_result(sum3[3], sum3[3], p[6]);

    //p7
    and_gate p7_result(cout3[3], cout3[3], p[7]);
endmodule

module Multiplier_4x1(a, b, out);
    input[3:0] a;
    input b;
    output [3:0] out;

    and_gate a1(a[0], b, out[0]);
    and_gate a2(a[1], b, out[1]);
    and_gate a3(a[2], b, out[2]);
    and_gate a4 (a[3], b, out[3]);
endmodule

module FA_4bit(a, b, c, d, e , f, g, h, cin, carry, sum);
    input a, b, c, d, e, f, g, h, cin;
    output  [3:0] sum;
    output [4:1] carry;

    Full_Adder FA1(d, h, cin, carry[1], sum[0]); 
    Full_Adder FA2(c, g, carry[1], carry[2], sum[1]);
    Full_Adder FA3(b, f, carry[2], carry[3], sum[2]);
    Full_Adder FA4(a, e, carry[3], carry[4], sum[3]);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire ha_cout, ha_sum, carry2;

    Half_Adder HA1(a, b, ha_cout, ha_sum);
    Half_Adder HA2(ha_sum, cin, carry2, sum);
    Majority m1(a, b, cin, cout);
endmodule

module Half_Adder(a, b, cout, sum);
    input a, b;
    output cout, sum;
    wire xor_temp1, xor_temp2, a_not, b_not;

    //not
    nand nand1(a_not, a, a);
    nand nand2(b_not, b, b);

    //sum
    nand nand5_1(xor_temp1, a_not, b);
    nand nand5_2(xor_temp2, a, b_not);
    nand nand5_3(sum, xor_temp1, xor_temp2);

    //carry
    nand nand6_1(and_temp, a, b);
    nand nand6_2(cout, and_temp, and_temp);
endmodule

module Majority(a, b, c, out);
    input a, b, c;
    output out;
    wire w1, w2, w3, w4;

    and_gate and1(a, b, w1);
    and_gate and2(b, c, w2);
    and_gate and3(c, a, w3);

    or_gate or1(w1, w2, w4);
    or_gate or2(w4, w3, out);
endmodule

module and_gate(a, b, out);
    input a, b;
    output out;
    wire and_temp, and_gate;

    nand nand6_1(and_temp, a, b);
    nand nand6_2(out, and_temp, and_temp);
endmodule

module or_gate(a, b, out);
    input a, b;
    output out;
    wire a_not, b_not;

    nand not_a(a_not, a, a);
    nand not_b(b_not, b, b);

    nand nand4_1(out, a_not, b_not);
endmodule