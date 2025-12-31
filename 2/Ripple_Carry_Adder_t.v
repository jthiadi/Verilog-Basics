`timescale 1ns/1ps

module Ripple_Carry_Adder_tb;

// Declare testbench variables
reg [7:0] a, b;
reg cin;
wire cout;
wire [7:0] sum;

// Instantiate the Ripple Carry Adder
Ripple_Carry_Adder RCA (
    .a(a),
    .b(b),
    .cin(cin),
    .cout(cout),
    .sum(sum)
);

// Test sequence
initial begin
    // Test case 1: a = 8'h00, b = 8'h00, cin = 0
    a = 8'h00; b = 8'h00; cin = 1'b0;
    #10;  // Wait for 10 time units
    $display("Test case 1: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);
    
    // Test case 2: a = 8'hFF, b = 8'h01, cin = 0 (Adding max unsigned value + 1)
    a = 8'hFF; b = 8'h01; cin = 1'b0;
    #10;
    $display("Test case 2: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);
    
    // Test case 3: a = 8'hAA, b = 8'h55, cin = 0
    a = 8'hAA; b = 8'h55; cin = 1'b0;
    #10;
    $display("Test case 3: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);

    // Test case 4: a = 8'h0F, b = 8'hF0, cin = 1
    a = 8'h0F; b = 8'hF0; cin = 1'b1;
    #10;
    $display("Test case 4: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);
    
    // Test case 5: Random test case
    a = 8'h12; b = 8'h34; cin = 1'b0;
    #10;
    $display("Test case 5: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);
    
    // Test case 6: overflow in signed addition
    a = 8'h00; b = 8'hFF; cin = 1'b1;
    #10;
    $display("Test case 6: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);
    
    // Test case 7: overflow with carry_in
    a = 8'hFF; b = 8'hFF; cin = 1'b1;
    #10;
    $display("Test case 7: a = %h, b = %h, cin = %b => sum = %h, cout = %b", a, b, cin, sum, cout);

    // End the simulation
    $finish;
end

endmodule
