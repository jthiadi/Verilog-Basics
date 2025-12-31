`timescale 1ns/1ps

module tb_Ping_Pong_Counter();
    
    // Testbench signals
    reg clk;
    reg rst_n;
    reg enable;
    wire direction;
    wire [3:0] out;
    
    // Instantiate the Ping_Pong_Counter module
    Ping_Pong_Counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .direction(direction),
        .out(out)
    );
    
    // Clock generation (50 MHz, period = 20ns)
    always #10 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        enable = 0;
        
        // Apply reset
        #20;
        rst_n = 1; // Deassert reset
        enable = 1; // Enable counter
        
        // Let the counter run for a while
        #300;
        
        // Disable counter
        enable = 0;
        #50;
        
        // Re-enable counter
        enable = 1;
        #300;
        
        // Reset again to see if counter resets correctly
        rst_n = 0;
        #20;
        rst_n = 1;
        
        // Run again
        #200;
        
        // Finish simulation
        $stop;
    end
    
    // Monitor changes for debugging
    initial begin
        $monitor("Time: %0d, rst_n = %b, enable = %b, out = %b, direction = %b", $time, rst_n, enable, out, direction);
    end

endmodule
