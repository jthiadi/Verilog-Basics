`timescale 1ns / 1ps

module Multiplier_4bit_tb;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [7:0] p;

    // Instantiate the Multiplier_4bit module
    Multiplier_4bit uut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        // Initialize inputs
        a = 4'b0000;
        b = 4'b0000;

        // Monitor changes in a, b, and p
        $monitor("At time %t: a = %b, b = %b, product = %b", $time, a, b, p);

        // Test case 1
        #10;
        a = 4'b0011; // 3 in decimal
        b = 4'b0010; // 2 in decimal
        #10;
        $display("Test Case 1: a = 3, b = 2, p = %d", p);

        // Test case 2
        #10;
        a = 4'b0101; // 5 in decimal
        b = 4'b0101; // 5 in decimal
        #10;
        $display("Test Case 2: a = 5, b = 5, p = %d", p);

        // Test case 3
        #10;
        a = 4'b1111; // 15 in decimal
        b = 4'b1111; // 15 in decimal
        #10;
        $display("Test Case 3: a = 15, b = 15, p = %d", p);

        // Test case 4
        #10;
        a = 4'b1001; // 9 in decimal
        b = 4'b0011; // 3 in decimal
        #10;
        $display("Test Case 4: a = 9, b = 3, p = %d", p);

        // End of simulation
        #10;
        $finish;
    end

endmodule
