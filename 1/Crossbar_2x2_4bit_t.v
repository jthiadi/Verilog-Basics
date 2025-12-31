`timescale 1ns/1ps

module tb_Crossbar_2x2_4bit;

// Inputs
reg [3:0] in1;
reg [3:0] in2;
reg control;

// Outputs
wire [3:0] out1;
wire [3:0] out2;

// Instantiate the crossbar switch module
Crossbar_2x2_4bit uut (
    .in1(in1),
    .in2(in2),
    .control(control),
    .out1(out1),
    .out2(out2)
);

// Testbench procedure
initial begin
    // Initialize inputs
    in1 = 4'b0000;
    in2 = 4'b0000;
    control = 0;

    // Display results
    $monitor("Time = %0t | in1 = %b | in2 = %b | control = %b | out1 = %b | out2 = %b", 
             $time, in1, in2, control, out1, out2);

    // Test case 1: control = 0, pass in1 to out1, in2 to out2
    #10 in1 = 4'b1010; in2 = 4'b0101; control = 0;

    // Test case 2: control = 1, cross in1 and in2
    #10 control = 1;

    // Test case 3: change inputs, control = 0
    #10 in1 = 4'b1111; in2 = 4'b0000; control = 0;

    // Test case 4: change inputs, control = 1
    #10 control = 1;

    #10 $finish;
end

initial begin
   $dumpfile("Crossbar_2x2_4bit.vcd");
   $dumpvars("+all");
end

endmodule

