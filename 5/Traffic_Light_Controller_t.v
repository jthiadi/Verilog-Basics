`include "Lab5_Team11_Traffic_Light_Controller.v"

module Traffic_Light_Controller_tb;

  // Testbench signals
  reg clk;
  reg rst_n;
  reg lr_has_car;
  wire [2:0] hw_light;
  wire [2:0] lr_light;

  // Instantiate the Traffic Light Controller module
  Traffic_Light_Controller uut (
    .clk(clk),
    .rst_n(rst_n),
    .lr_has_car(lr_has_car),
    .hw_light(hw_light),
    .lr_light(lr_light)
  );

  // Clock generation
  always #5 clk = ~clk; // 10ns period clock

  // Test procedure
  initial begin
    $dumpfile("Traffic_Controller.vcd");
    $dumpvars(0, Traffic_Light_Controller_tb);
    // Initialize signals
    clk = 0;
    rst_n = 0;
    lr_has_car = 0;

    // Apply reset
    #10 rst_n = 1; // Release reset after 10ns

    // Test sequence based on FSM
    // State 0 (HW: Green, LR: Red) -> State 1 (HW: Yellow, LR: Red) after 70 cycles if lr_has_car is high
    repeat(75) @(posedge clk);
    lr_has_car = 1; // lr_has_car becomes 1 to trigger transition
    @(posedge clk);

    // State 1: HW = Yellow, LR = Red for 25 cycles
    repeat(25) @(posedge clk);

    // State 2: HW = Red, LR = Red for 1 cycle
    @(posedge clk);

    // State 3: HW = Red, LR = Green for 70 cycles
    repeat(70) @(posedge clk);

    // State 4: HW = Red, LR = Yellow for 25 cycles
    repeat(25) @(posedge clk);

    // State 5: HW = Red, LR = Red for 1 cycle
    @(posedge clk);

    // The FSM should return to State 0: HW = Green, LR = Red
    @(posedge clk);

    // Finish simulation
    $finish;
  end

  // Monitor output signals
  initial begin
    $monitor("Time=%0t | State=%0b | HW Light=%0b | LR Light=%0b | lr_has_car=%b",
             $time, uut.state, hw_light, lr_light, lr_has_car);
  end

endmodule
