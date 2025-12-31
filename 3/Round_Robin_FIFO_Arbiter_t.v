`timescale 1ns/1ps

module tb_Round_Robin_FIFO_Arbiter;

  // Inputs
  reg clk;
  reg rst_n;
  reg [3:0] wen;
  reg [7:0] a, b, c, d;

  // Outputs
  wire [7:0] dout;
  wire valid;

  // Instantiate the Unit Under Test (UUT)
  Round_Robin_FIFO_Arbiter uut (
    .clk(clk), 
    .rst_n(rst_n), 
    .wen(wen), 
    .a(a), 
    .b(b), 
    .c(c), 
    .d(d), 
    .dout(dout), 
    .valid(valid)
  );

  // Clock generation
  
  always #5 clk = ~clk;  // 10ns period

  // Test sequence
  initial begin
    // Initial setup
    clk = 0;
    rst_n = 0;
    wen = 4'b0000;
    a = 8'd0;
    b = 8'd0;
    c = 8'd0;
    d = 8'd0;
    
    // Apply reset
    #10 rst_n = 1;  // Release reset after 10 ns

    // Cycle 1: Write to all FIFOs
    wen = 4'b1111;
        a = 8'd87;
        b = 8'd56;
        c = 8'd9;
        d = 8'd13;

    // Cycle 2: Only write to FIFO D
    #10 wen = 4'b1000;
        a = 8'dx;
        b = 8'dx;
        c = 8'dx;
        d = 8'd85;

    // Cycle 3: Only write to FIFO C
    #10 wen = 4'b0100;
        a = 8'dx;
        b = 8'dx;
        c = 8'd139;
        d = 8'dx;

    // Cycle 4: No writes, expect reads
    #20 wen = 4'b0000;

    // Cycle 5: Write to FIFO A
    #10 wen = 4'b0001;
        a = 8'd51;
        b = 8'dx;
        c = 8'dx;
        d = 8'dx;

    // Cycle 6: No writes, expect reads
    #10 wen = 4'b0000;

    #50 $stop;
  end

  // Monitor outputs
  always @(posedge clk) begin
  // Check for writes
  if (wen != 4'b0000) begin
    $display("Time: %0dns, Writing to FIFO(s):", $time);
    if (wen[0]) $display("  FIFO A, Input: %d", a);
    if (wen[1]) $display("  FIFO B, Input: %d", b);
    if (wen[2]) $display("  FIFO C, Input: %d", c);
    if (wen[3]) $display("  FIFO D, Input: %d", d);
  end

  // Check for reads when valid signal is high
  if (valid) begin
    $display("Time: %0dns, dout: %d (Read from FIFO)", $time, dout);
  end

  // Indicate when no write or valid read occurs
  if (wen == 4'b0000 && !valid) begin
    $display("Time: %0dns, No write, No read (Idle)", $time);
  end
end

endmodule
