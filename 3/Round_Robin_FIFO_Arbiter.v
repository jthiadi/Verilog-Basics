`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output [7:0] dout;
output valid;

reg [1:0] current_FIFO, output_FIFO;
wire [7:0] dout_a, dout_b, dout_c, dout_d;
wire[2:0] renA, renB, renC, renD, wenA, wenB, wenC, wenD;
wire error_a, error_b, error_c, error_d;
reg [7:0] dout_reg;
reg valid_reg;

assign wenA = wen[0];
assign wenB = wen[1];
assign wenC = wen[2];
assign wenD = wen[3];

assign renA = (!wenA && current_FIFO == 2'b00)? 1'b1 : 1'b0;
assign renB = (!wenB && current_FIFO == 2'b01)? 1'b1 : 1'b0;
assign renC = (!wenC && current_FIFO == 2'b10)? 1'b1 : 1'b0;
assign renD = (!wenD && current_FIFO == 2'b11)? 1'b1 : 1'b0;

// Instantiate the FIFOs
FIFO_8 FIFO_A(clk, rst_n, wen[0], renA, a, dout_a, error_a);
FIFO_8 FIFO_B(clk, rst_n, wen[1], renB, b, dout_b, error_b);
FIFO_8 FIFO_C(clk, rst_n, wen[2], renC, c, dout_c, error_c);
FIFO_8 FIFO_D(clk, rst_n, wen[3], renD, d, dout_d, error_d);

always @(posedge clk) begin
    if (!rst_n) begin
        current_FIFO <= 2'b00;  // Start with FIFO A
        output_FIFO <= output_FIFO;
    end else begin
        case (current_FIFO)
            2'b00: begin
                output_FIFO <= 2'b00;
            end
            2'b01: begin
                output_FIFO <= 2'b01;
            end
            2'b10: begin
                output_FIFO <= 2'b10;
            end
            2'b11: begin
                output_FIFO <= 2'b11;
            end
        endcase
        
        current_FIFO <= current_FIFO + 1;
    end
end

always @(*) begin
    if(!rst_n) begin
        dout_reg <= 8'b0;
        valid_reg <= 1'b0;
    end
    
    else begin
        valid_reg <= 1'b0;
        case(output_FIFO)
            2'b00: begin
                if(!wen[0] && !error_a)begin
                    dout_reg <= dout_a;
                    valid_reg <= 1'b1;
                end
                
                else dout_reg <= 8'd0;
            end
            
            2'b01: begin
                if(!wen[1] && !error_b)begin
                    dout_reg <= dout_b;
                    valid_reg <= 1'b1;
                end 
                
                else dout_reg <= 8'd0;
            end
            
            2'b10: begin
                if(!wen[2] && !error_c)begin
                    dout_reg <= dout_c;
                    valid_reg <= 1'b1;
                end 
                
                else dout_reg <= 8'd0;
            end
            
            2'b11: begin
                if(!wen[3] && !error_d)begin
                    dout_reg <= dout_d;
                    valid_reg <= 1'b1;
                end 
                
                else dout_reg <= 8'd0;
            end
                
        endcase
    end
end

assign dout = (clk == 1'b1)? dout_reg : dout;
assign valid = (clk == 1'b1)? valid_reg : valid;

endmodule


module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output error;

reg error_reg =0;
reg [2:0]write_ptr =3'd0;
reg [2:0]read_ptr =3'd0;
reg [3:0]count = 4'd0;
reg [7:0] FIFO[7:0];
reg [8-1:0] dout_reg;

integer i ;
always @(posedge clk) begin
    if(!rst_n) begin
        write_ptr <= 0;
        read_ptr <= 0;
        count <= 0;
        dout_reg <= 0;
        for(i = 0 ; i < 8 ; i = i + 1) begin
            FIFO[i] <= 8'd0;
        end
    end
    
    else begin
        if(ren == 1) begin
            if (count == 0)
                error_reg <= 1;  // Underflow condition
            else begin
                dout_reg <= FIFO[read_ptr];
                read_ptr <= (read_ptr + 1) % 8;
                count <= count - 1;
                error_reg <= 0;
            end
        end
        
        if(wen == 1) begin
            if(count == 8) 
                error_reg <= 1;  // Overflow condition
            else begin
                FIFO[write_ptr] <= din;
                write_ptr <= (write_ptr + 1)%8;
                count <= count + 1;
                error_reg <= 0;
            end
        end
    end
end

assign error = error_reg;
assign dout = dout_reg;

endmodule
