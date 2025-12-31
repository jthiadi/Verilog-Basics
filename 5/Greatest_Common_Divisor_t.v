`timescale 1ns/1ps

module Greatest_Common_Divisor_tb;

    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] a;
    reg [15:0] b;

    wire done;
    wire [15:0] gcd;

    Greatest_Common_Divisor testbench (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .a(a),
        .b(b),
        .done(done),
        .gcd(gcd)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        start = 0;
        a = 0;
        b = 0;
        
        @(negedge clk) rst_n = 1;
        
        // Test Case 1: 0 and non-zero
        a = 16'd0;
        b = 16'd36;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 1: Expected = 36, Answer = %d", gcd);
        wait(!done);
        #10;
        
        // Test Case 2: non_zero and 0
        a = 16'd111;
        b = 16'd0;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 2: Expected = 111, Answer = %d", gcd);
        wait(!done);
        #10;
        
        // Test Case 3: two equal numbers
        a = 16'd11;
        b = 16'd11;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 3: Expected = 11, Answer = %d", gcd);
        wait(!done);
        #10;

        // Test Case 4: two coprime numbers 
        a = 16'd37;
        b = 16'd75;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 4: Expected = 1, Answer = %d", gcd);
        wait(!done);
        #10;
        
        // Test Case 5: has common divisor
        a = 16'd65;
        b = 16'd25;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 5: Expected = 5, Answer = %d", gcd);
        wait(!done);
        #10;
        
        
        // Test Case 6: random
        a = $random;
        b = $random;
        start = 1;
        #10 start = 0;
        wait(done);
        $display("Test Case 6: The GCD of %d and %d is %d", a, b, gcd);        
        wait(!done);
        #10;
        
        $finish;
    end
endmodule
