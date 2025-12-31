`timescale 1ns/1ps

module Lab4_Team11_Mealy_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Mealy_Sequence_Detector m (
    .clk (clk),
    .rst_n (rst_n),
    .in (in),
    .dec (dec)
);

// uncomment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $fsdbDumpfile("Mealy.fsdb");
//     $fsdbDumpvars;
// end

initial begin
    @ (posedge clk) rst_n = 1'b0;
    @ (negedge clk)

    @ (negedge clk) rst_n = 1'b1;

    in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk)
    @ (negedge clk)
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk)
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk)
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b1;
    @ (negedge clk) in = 1'b0;
    @ (negedge clk) in = 1'b0;

    $finish;
end

// Monitor on positive edge of clock
always @ (posedge clk) begin
    $display("POS: Time: %0t | clk: %b | rst_n: %b | in: %b | dec: %b", $time, clk, rst_n, in, dec);
end

// Monitor on negative edge of clock
always @ (negedge clk) begin
    $display("NEG: Time: %0t | clk: %b | rst_n: %b | in: %b | dec: %b", $time, clk, rst_n, in, dec);
end

endmodule
