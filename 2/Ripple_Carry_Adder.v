`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
    input [8-1:0] a, b;
    input cin;
    output cout;
    output [8-1:0] sum;
    wire [6:0] carry;

    Full_Adder FA1(a[0], b[0], cin, carry[0], sum[0]);
    Full_Adder FA2(a[1], b[1], carry[0], carry[1], sum[1]);
    Full_Adder FA3(a[2], b[2], carry[1], carry[2], sum[2]);
    Full_Adder FA4(a[3], b[3], carry[2], carry[3], sum[3]);
    Full_Adder FA5(a[4], b[4], carry[3], carry[4], sum[4]);
    Full_Adder FA6(a[5], b[5], carry[4], carry[5], sum[5]);
    Full_Adder FA7(a[6], b[6], carry[5], carry[6], sum[6]);
    Full_Adder FA8(a[7], b[7], carry[6], cout, sum[7]);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire ha_cout, ha_sum, carry2;

    // to generate sum
    Half_Adder HA1(a, b, ha_cout, ha_sum);
    Half_Adder HA2(ha_sum, cin, carry2, sum);

    // to generate cout
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