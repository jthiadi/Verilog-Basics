`timescale 1ns/1ps

module tb_Carry_Look_Ahead_Adder_8bit();

// Testbench signals
reg [7:0] a, b;
reg c0;
wire [7:0] s;
wire c8;

// Instantiate the 8-bit CLA
Carry_Look_Ahead_Adder_8bit CLA_8bit (
    .a(a),
    .b(b),
    .c0(c0),
    .s(s),
    .c8(c8)
);

initial begin
    // Test cases
    $display("Time | a        | b        | c0 | s        | c8");
    $monitor("%4t | %b | %b |  %b | %b |  %b", $time, a, b, c0, s, c8);
    
    // Initialize inputs
    a = 8'b00000000; b = 8'b00000000; c0 = 1'b0; #10;  // Test Case 1: Both inputs zero
    a = 8'b00001111; b = 8'b00001111; c0 = 1'b0; #10;  // Test Case 2: Simple addition
    a = 8'b11110000; b = 8'b00001111; c0 = 1'b1; #10;  // Test Case 3: With carry-in
    a = 8'b10101010; b = 8'b01010101; c0 = 1'b0; #10;  // Test Case 4: Alternating bits
    a = 8'b11111111; b = 8'b11111111; c0 = 1'b1; #10;  // Test Case 5: Maximum inputs with carry-in

    // Finish the simulation
    $finish;
end

endmodule
