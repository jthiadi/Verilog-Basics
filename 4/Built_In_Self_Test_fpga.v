`timescale 1ns/1ps

module Built_In_Self_Test_fpga (rst_n, dclk, clk, scan_en, LFSR_reset_value, AN, seg, ScanDFF_Q);
    input rst_n, dclk;
    input clk;          // system clock
    input scan_en;
    input [8-1:0] LFSR_reset_value;
    
    output [4-1:0] AN;
    output [7-1:0] seg;
    output [8-1:0] ScanDFF_Q;
    
    wire scan_in, scan_out;
    wire [4-1:0] a, b;

    wire rst_debounced, rst_onepulse, dclk_debounced, dclk_onepulse;
    
    reg [16:0] counter;
    reg [1:0] display;

    debounce rst1(rst_debounced, rst_n, clk);
    onepulse rst1_1(rst_debounced, clk, rst_onepulse);

    debounce dclk1(dclk_debounced, dclk, clk);
    onepulse dclk1_1(dclk_debounced, clk, dclk_onepulse);
    
    always @(posedge clk or posedge rst_onepulse) begin
        if (rst_onepulse) begin
            display <= 2'd0;
            counter <= 17'd0;
        end
        else begin
            if (counter == 17'd99999) begin
                display <= display + 2'd1;
                counter <= 17'd0;
            end
            else counter <= counter + 17'd1;
        end
    end

    Built_In_Self_Test BIST(dclk_onepulse, rst_onepulse, scan_en, scan_in, scan_out, LFSR_reset_value, a, b, ScanDFF_Q);
    Seven_Segment_Control DISPLAY(scan_in, scan_out, a, b, display, AN, seg);
    
endmodule 

module Seven_Segment_Control (scan_in, scan_out, a, b, display, AN, seg);
    input scan_in, scan_out;
    input [4-1:0] a,b;
    input [1:0] display;

    output reg [4-1:0] AN; 
    output reg [7-1:0] seg;
    
    parameter ZERO  = 7'b100_0000;  
    parameter ONE   = 7'b111_1001;  
    parameter TWO   = 7'b010_0100;  
    parameter THREE = 7'b011_0000;  
    parameter FOUR  = 7'b001_1001;  
    parameter FIVE  = 7'b001_0010;  
    parameter SIX   = 7'b000_0010;  
    parameter SEVEN = 7'b111_1000;  
    parameter EIGHT = 7'b000_0000;  
    parameter NINE  = 7'b001_0000;  
    parameter A     = 7'b000_1000;  //10
    parameter B     = 7'b000_0011;  //11
    parameter C     = 7'b100_0110;  //12
    parameter D     = 7'b010_0001;  //13
    parameter E     = 7'b000_0110;  //14
    parameter F     = 7'b000_1110;  //15
    
    always @(display) begin
            case (display)
                2'b00: AN <= 4'b1110;
                2'b01: AN <= 4'b1101;
                2'b10: AN <= 4'b1011;
                2'b11: AN <= 4'b0111;
                default: AN <= 4'b1111;
            endcase
        end
    
    always @(*) begin
        case(display)
            2'b00:
            begin
                if (scan_out == 1'b0) seg <= ZERO;
                else seg <= ONE;
            end
            
            2'b01:
            begin
                case (b)
                    4'd0: seg <= ZERO;
                    4'd1: seg <= ONE;
                    4'd2: seg <= TWO;
                    4'd3: seg <= THREE;
                    4'd4: seg <= FOUR;
                    4'd5: seg <= FIVE;
                    4'd6: seg <= SIX;
                    4'd7: seg <= SEVEN;
                    4'd8: seg <= EIGHT;
                    4'd9: seg <= NINE;
                    4'd10: seg <= A;
                    4'd11: seg <= B;
                    4'd12: seg <= C;
                    4'd13: seg <= D;
                    4'd14: seg <= E;
                    4'd15: seg <= F;

                    default: seg <= ZERO;
                endcase
            end
            
            2'b10:
            begin
                case (a)
                    4'd0: seg <= ZERO;
                    4'd1: seg <= ONE;
                    4'd2: seg <= TWO;
                    4'd3: seg <= THREE;
                    4'd4: seg <= FOUR;
                    4'd5: seg <= FIVE;
                    4'd6: seg <= SIX;
                    4'd7: seg <= SEVEN;
                    4'd8: seg <= EIGHT;
                    4'd9: seg <= NINE;
                    4'd10: seg <= A;
                    4'd11: seg <= B;
                    4'd12: seg <= C;
                    4'd13: seg <= D;
                    4'd14: seg <= E;
                    4'd15: seg <= F;

                    default: seg <= ZERO;
                endcase
            end
            
            2'b11:
            begin
                if(scan_in == 1'b0) seg <= ZERO;
                else seg <= ONE;
            end

            default: seg <= ZERO;
        endcase
    end
endmodule

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out, LFSR_reset_value, a_out, b_out, ScanDFF_Q);
    input clk;
    input rst_n;
    input scan_en;
    input [8-1:0] LFSR_reset_value;
    output scan_in;
    output scan_out;

    output [4-1:0] a_out, b_out;
    output [8-1:0] ScanDFF_Q;
    
    wire scan_in_SCD;

    Many_To_One_LFSR LFSR(clk, rst_n, scan_in_SCD, LFSR_reset_value);
    Scan_Chain_Design SCD (clk, rst_n, scan_in_SCD, scan_en, scan_out, a_out, b_out, ScanDFF_Q);
    
    assign scan_in = scan_in_SCD;

endmodule

module Many_To_One_LFSR(clk, rst_n, out, LFSR_reset_value);
    input clk;
    input rst_n;
    input [8-1:0] LFSR_reset_value; 

    output out;
    reg [8-1:0] DFF;
    wire in;
    
    always @(posedge clk or posedge rst_n)
    begin
        if (rst_n) DFF <= LFSR_reset_value;
        
        else begin
            DFF[7:1] <= DFF[6:0];
            DFF[0] 	 <= in;
        end
    
    end

    assign in = (DFF[7] ^ DFF[3]) ^ (DFF[2] ^ DFF[1]);
    assign out = DFF[7];
endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out, a_out, b_out, ScanDFF_Q);
    input clk;
    input rst_n;
    input scan_in;
    input scan_en;
    output scan_out;
    output [4-1:0] a_out, b_out;
    output [8-1:0] ScanDFF_Q;
    
    wire [4-1:0] a, b;
    wire [8-1:0] p;
    
    multiplier_4_bit mul1(p, a, b);
    Scan_DFF SDFF1(a[3], rst_n, clk, scan_in, scan_en, p[7]);
    Scan_DFF SDFF2(a[2], rst_n, clk, a[3], scan_en, p[6]);
    Scan_DFF SDFF3(a[1], rst_n, clk, a[2], scan_en, p[5]);
    Scan_DFF SDFF4(a[0], rst_n, clk, a[1], scan_en, p[4]);
    Scan_DFF SDFF5(b[3], rst_n, clk, a[0], scan_en, p[3]);
    Scan_DFF SDFF6(b[2], rst_n, clk, b[3], scan_en, p[2]);
    Scan_DFF SDFF7(b[1], rst_n, clk, b[2], scan_en, p[1]);
    Scan_DFF SDFF8(b[0], rst_n, clk, b[1], scan_en, p[0]);
    
    assign scan_out = b[0];
    assign ScanDFF_Q [7:4] = a;
    assign ScanDFF_Q [3:0] = b;
    assign a_out = a;
    assign b_out = b;
endmodule

module multiplier_4_bit(out, a, b);
    input [4-1:0] a, b;
    output [8-1:0] out;
    
    reg [8-1:0] out;
    
    always @(a or b) begin
       out = a * b;
    end
endmodule

module Scan_DFF(out, rst_n, clk, scan_in, scan_en, data);
    input scan_en, scan_in, data, rst_n, clk;
    output out;
    
    reg DFF;
    
    always @(posedge clk or posedge rst_n)begin
        if (rst_n)begin
            DFF <= 1'b0;
        end

        else begin
            if (scan_en) DFF <= scan_in;
            else DFF <= data;
        end
    end
    
    assign out = DFF;
endmodule

module debounce (pb_debounced, pb, clk);
    input pb, clk;
    output pb_debounced;
    reg [3:0]DFF;
    always @(posedge clk) begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign pb_debounced = (DFF == 4'b1111) ? 1'b1 : 1'b0;
endmodule

module onepulse (pb_debounced, clk, pb_onepulse);
    input pb_debounced, clk;
    output reg pb_onepulse;
    reg pb_debounced_delay;

    always @(posedge clk) begin
        pb_onepulse <= pb_debounced & (!pb_debounced_delay);
        pb_debounced_delay <= pb_debounced;
    end
endmodule