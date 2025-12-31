`timescale 1ns/1ps

module Crossbar_4x4_4bit_tb;

    // Declare inputs and outputs for the testbench
    reg [3:0] in1, in2, in3, in4;   // 4-bit inputs
    reg [4:0] control;              // 5-bit control signal
    wire [3:0] out1, out2, out3, out4; // 4-bit outputs

    // Instantiate the 4x4 Crossbar Switch module
    Crossbar_4x4_4bit uut (
        .in1(in1), 
        .in2(in2), 
        .in3(in3), 
        .in4(in4), 
        .control(control), 
        .out1(out1), 
        .out2(out2), 
        .out3(out3), 
        .out4(out4)
    );

    // Apply test cases
    initial begin
        // Define inputs
        in1 = 4'b0000;
        in2 = 4'b0001;
        in3 = 4'b0010;
        in4 = 4'b0100;

        control = 5'b00000;

        repeat(33) begin
            #1; 
            $display("Control: %b", control);
            $display("Outputs: out1 = %b, out2 = %b, out3 = %b, out4 = %b", out1, out2, out3, out4);
            control = control + 5'b00001; 
        end
        $finish;
        
        $dumpfile("Crossbar_4x4_4bit.vcd");
        $dumpvars("+all");
    end

endmodule