`timescale 1ns/1ps

module Built_In_Self_Test_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg scan_en = 1'b0;
    
    wire scan_in;
    wire scan_out;
    
    always #5 clk = !clk;

    Built_In_Self_Test BIST(
        .clk(clk),
        .rst_n(rst_n),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .scan_out(scan_out)
    );

    integer i;
    task scan_in_pattern();
        for (i = 7; i >= 0; i = i - 1) begin
            @(negedge clk);
            $display("Scanning in bit %b", scan_in);  // Display the scanned in bit
        end
    endtask

    task capture_result();
    begin
        scan_en = 1'b0;
        @(negedge clk);  // wait for capture phase
        $display("Capture phase done");  
    end
    endtask

    task scan_out_pattern();
    begin
        $display("p[0] = %b", scan_out);
        scan_en = 1'b1;
        for (i = 1; i <= 7; i = i + 1) begin
            @(negedge clk);
            $display("p[%0d] = %b", i, scan_out);  
        end
    end
    endtask

    initial begin
        @(negedge clk)
        rst_n = 1'b0;
        $display("reset off");
        @(negedge clk)
        rst_n = 1'b1; 
        $display("reset on");
        scan_en = 1'b0; 
        
        $display("Test case 2: scanning in pattern 10111010");
        scan_en = 1'b1;
        scan_in_pattern();  

        $display("Test case 3: capturing the result");
        capture_result();  

        $display("Test case 4: scanning out the result");
        scan_out_pattern();   
        
        #10;
        $finish;
    end
endmodule