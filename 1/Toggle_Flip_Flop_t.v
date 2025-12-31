`timescale 1ns/1ps

module T_Flip_Flop_t;

// input and output signals
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
wire q;

// generate clk
always#(1) clk = ~clk;

// test instance instantiation
Toggle_Flip_Flop TFF(
    .clk(clk),
    .t(t),
    .q(q),
    .rst_n(rst_n)
);

initial begin
    $monitor("Time = %0t | clk = %b | t = %b | rst_n = %b | q = %b", 
             $time, clk, t, rst_n, q);
             
    @(negedge clk) t = 1'b1; rst_n =1'b0;
    @(negedge clk) t = 1'b0; rst_n =1'b1;
    @(negedge clk) t = 1'b1; 
    @(negedge clk) t = 1'b1; 
    @(negedge clk) t = 1'b1;
    @(negedge clk) t = 1'b0;
    @(negedge clk) t = 1'b1; 
    @(negedge clk) t = 1'b0;  
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) $finish;
end

initial begin
   $dumpfile("Toggle_Flip_Flop.vcd");
   $dumpvars("+all");
end

endmodule