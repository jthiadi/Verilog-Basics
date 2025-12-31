`timescale 1ns / 1ps

module Lab4_Team11_Scan_Chain_Design_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg scan_in = 1'b0;
    reg scan_en = 1'b0;

    wire scan_out;

    always #5 clk = !clk;

    Scan_Chain_Design SCD(
        .clk(clk),
        .rst_n(rst_n),
        .scan_in(scan_in),
        .scan_en(scan_en),
        .scan_out(scan_out)
    );
    
    integer i;
    task scan_in_pattern(input [7:0] pattern);
        for (i = 7; i >= 0; i = i - 1) begin
            scan_in = pattern[i];
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
        scan_in_pattern(8'b10111010);  

        $display("Test case 3: capturing the result");
        capture_result();  

        $display("Test case 4: scanning out the result");
        scan_out_pattern();   // answer should be 010000001

        $display("Test case 5: scanning in pattern 11001100");
        scan_en = 1'b1;
        scan_in_pattern(8'b11001100);  

        $display("Test case 6: capturing and scanning out the result again");
        capture_result();  
        scan_out_pattern(); // answer should be 00001001

        #10;
        $finish;
    end
endmodule
