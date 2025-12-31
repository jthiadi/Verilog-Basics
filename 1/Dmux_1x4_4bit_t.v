`timescale 1ns/1ps

module Dmux_1x4_4bit_t;

reg [3:0] in = 4'b1011;
reg [1:0] sel = 2'b0;
wire [3:0] a, b, c, d;

Dmux_1x4_4bit m1(
    .in (in),
    .a (a),
    .b (b),
    .c (c),
    .d (d),
    .sel (sel)
);

initial begin

    $monitor("Time = %0t | in = %b | sel = %b | a = %b | b = %b | c = %b | d = %b", 
             $time, in, sel, a, b, c, d);

    repeat (2 ** 2) begin
        #1 sel = sel + 2'b1;
    end
    
    #1 $finish;
end

// For waveform generation
initial begin
    $dumpfile("Dmux_1x4_4bit.vcd");
    $dumpvars("+all");
end

endmodule
