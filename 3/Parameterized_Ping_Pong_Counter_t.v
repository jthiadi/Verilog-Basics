`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_t;

reg clk = 1'b0;
reg rst_n = 1'b0;
reg enable = 1'b1;
reg flip;
reg [3:0] max = 4'd4;  
reg [3:0] min = 4'd0;  

wire direction;
wire [3:0] out;

parameter cyc = 10;

// Clock generation
always #(cyc/2) clk = ~clk;

// Instantiate the counter module
Parameterized_Ping_Pong_Counter PPPC (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .flip(flip),
    .max(max),
    .min(min),
    .direction(direction),
    .out(out)
);

// Uncomment to dump waveform if using NTHUCAD
// initial begin
//     $fsdbDumpfile("Parameterized_Ping_Pong_Counter.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    // Reset sequence
    flip = 1'b0;
    @(negedge clk) rst_n = 1'b1; // Release reset
    enable = 1'b1;

    // Allow a few clock cycles for initialization
    repeat (3) @(negedge clk);

    // Test 1: Basic flip test
    $display("\nTest 1: Basic Flip Test - Enable flip");
    flip = 1'b1;   // Enable flip
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);
    
    flip = 1'b0;   // Disable flip
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);
    
    flip = 1'b1;
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);
    
    flip = 1'b0;   // Disable flip
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);

    // Allow a few more clock cycles
    repeat (3) @(negedge clk);

    // Test 2: Toggle direction again
    $display("\nTest 2: Toggle Direction Again - Enable flip");
    flip = 1'b1;   // Enable flip
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);
    
    flip = 1'b0;   // Disable flip
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);

    // Allow a few clock cycles
    repeat (5) @(negedge clk);

    // Test 3: Change max and min boundaries
    $display("\nTest 3: Change Max/Min Boundaries - max = 7, min = 1");
    max = 4'd7; 
    min = 4'd1; 
    @(negedge clk);
    $display("Time: %0dns | max = %0d, min = %0d, out = %0d, direction = %0b", $time, max, min, out, direction);

    // Final flip test
    flip = 1'b1;
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);
    
    flip = 1'b0;
    @(negedge clk);
    $display("Time: %0dns | flip = %0b, out = %0d, direction = %0b", $time, flip, out, direction);

    repeat (5) @(negedge clk);

    // Test 4: Enable/Disable counter while counting
    $display("\nTest 4: Enable/Disable Counter - Disable counting");
    enable = 1'b0;  // Disable counting
    @(negedge clk);
    $display("Time: %0dns | enable = %0b, out = %0d, direction = %0b", $time, enable, out, direction);
    
    repeat (3) @(negedge clk);

    $display("Enable counting");
    enable = 1'b1;  // Re-enable counting
    @(negedge clk);
    $display("Time: %0dns | enable = %0b, out = %0d, direction = %0b", $time, enable, out, direction);
    
    repeat (3) @(negedge clk);

    // Test 5: Edge case where max <= min
    $display("\nTest 5: Edge Case (max <= min) - max = 2, min = 3");
    max = 4'd2; 
    min = 4'd3; // Invalid range: max <= min
    @(negedge clk);
    $display("Time: %0dns | max = %0d, min = %0d, out = %0d, direction = %0b", $time, max, min, out, direction);
    
    repeat (5) @(negedge clk);

    // Test 6: Test min = max case (should freeze the counter)
    $display("\nTest 6: Degenerate Case (min = max) - max = 5, min = 5");
    max = 4'd5;
    min = 4'd5; // Degenerate case where min = max
    @(negedge clk);
    $display("Time: %0dns | max = %0d, min = %0d, out = %0d, direction = %0b", $time, max, min, out, direction);
    
    repeat (5) @(negedge clk);

    // Test 7: Large counter range
    $display("\nTest 7: Large Counter Range - max = 15, min = 0");
    max = 4'd15;
    min = 4'd0;
    @(negedge clk);
    $display("Time: %0dns | max = %0d, min = %0d, out = %0d, direction = %0b", $time, max, min, out, direction);
    
    repeat (10) @(negedge clk);

    // End simulation
    #1 $finish;
end

endmodule
