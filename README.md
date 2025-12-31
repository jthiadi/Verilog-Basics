# Verilog-Basics

This repository contains a collection of **digital logic design labs implemented in Verilog HDL** and developed using **Xilinx Vivado**.  
The projects progress from **basic combinational logic and arithmetic units** through **sequential logic, FSM design, Design-for-Testability (DFT), and full FPGA-based systems**.

All designs were **simulated using Vivado Simulator**, and FPGA-oriented designs were synthesized and deployed on hardware using Vivado.

## 📚 Lab Overview

| Lab | Theme | Topics |
|-----|------|--------|
| **Lab 1** | Basic Components & Crossbars | Multiplexing, T-Flip-Flop, Routing logic |
| **Lab 2** | Adders & Multiplier | Ripple-Carry, Carry-Look-Ahead, Arithmetic Units |
| **Lab 3** | Sequential Logic & Arbitration | Ping-Pong Counters, FIFO Round-Robin Arbiter |
| **Lab 4** | Design-for-Testability | Scan Chains, BIST, Mealy FSM |
| **Lab 5** | FSM & Datapath Systems | GCD, Traffic Light FSM, FPGA Applications |
| **Lab 6** | Full FPGA System Design | Slot Machine & Chip-to-Chip Control |

---

## 🧪 Lab 1 — Basic Logic & Crossbars

**Lab1_Team11_Toggle_Flip_Flop.v**  
This code builds a T flip-flop. When the toggle input is 1, the output changes from 0→1 or 1→0 on every clock edge.

**Lab1_Team11_Toggle_Flip_Flop_t.v**  
This is the testbench for the T flip-flop. It gives clock and toggle signals and checks if the output toggles correctly.

**Lab1_Team11_Crossbar_2x2_4bit.v**  
This code makes a 2×2 crossbar switch for 4-bit data. It connects two inputs to two outputs depending on a select signal.

**Lab1_Team11_Crossbar_2x2_4bit_t.v**  
Testbench for the 2×2 crossbar. It changes the inputs and select signal to see if the outputs are routed correctly.

**Lab1_Team11_Crossbar_2x2_4bit_fpga.v**  
FPGA version of the 2×2 crossbar. It connects the crossbar to FPGA pins (switches/LEDs) so you can test it on real hardware.

**Lab1_Team11_Crossbar_4x4_4bit.v**  
This code makes a 4×4 crossbar switch for 4-bit data, allowing four inputs to be connected to four outputs based on control signals.

**Lab1_Team11_Crossbar_4x4_4bit_t.v**  
Testbench for the 4×4 crossbar. It tries different routes and checks if each output gets the right input.

**Lab1_Team11_Dmux_1x4_4bit.v**  
This is a 1-to-4 demultiplexer for 4-bit data. One input is sent to one of four outputs, based on a select signal.

**Lab1_Team11_Dmux_1x4_4bit_t.v**  
Testbench for the 1-to-4 demux. It tests different select values and checks which output gets the input.

---

## ➕ Lab 2 — Adders & Multiplier

**Lab2_Team11_Ripple_Carry_Adder.v**  
This code builds an 8-bit ripple-carry adder, which adds two 8-bit numbers by passing the carry from one bit to the next.

**Lab2_Team11_Ripple_Carry_Adder_t.v**  
Testbench for the ripple-carry adder. It gives different input pairs and checks if the sum and carry are correct.

**Lab2_Team11_Carry_Look_Ahead_Adder_8bit.v**  
This is an 8-bit carry-look-ahead adder. It also adds two 8-bit numbers but computes carries faster using extra logic.

**Lab2_Team11_Carry_Look_Ahead_Adder_8bit_t.v**  
Testbench for the carry-look-ahead adder. It compares the outputs with expected sums to confirm correctness.

**Lab2_Team11_Multiplier_4bit.v**  
This code is a 4-bit multiplier. It multiplies two 4-bit numbers and produces an 8-bit result.

**Lab2_Team11_Multiplier_4bit_t.v**  
Testbench for the 4-bit multiplier. It tries many input combinations and checks the product.

---

## 🔁 Lab 3 — Counters & Arbiter

**Lab3_Team11_Ping_Pong_Counter.v**  
This code builds a ping-pong counter. It counts up to a maximum value, then counts back down, and repeats.

**Lab3_Team11_Ping_Pong_Counter_t.v**  
Testbench for the ping-pong counter. It checks that the counter goes up, then down, in the right order.

**Lab3_Team11_Parameterized_Ping_Pong_Counter.v**  
This is a configurable ping-pong counter. You can change the size or limit using parameters instead of rewriting the code.

**Lab3_Team11_Parameterized_Ping_Pong_Counter_t.v**  
Testbench for the parameterized ping-pong counter. It tests the counter with different parameter settings.

**Lab3_Team11_Parameterized_Ping_Pong_Counter_fpga.v**  
FPGA version of the parameterized ping-pong counter, wired to FPGA inputs/outputs so you can see the count on LEDs or displays.

**Lab3_Team11_Round_Robin_FIFO_Arbiter.v**  
This code creates a round-robin arbiter. When several inputs request service, it gives each one a turn in order so no one starves.

**Lab3_Team11_Round_Robin_FIFO_Arbiter_t.v**  
Testbench for the round-robin arbiter. It makes different request patterns and checks if the grants rotate fairly.

---

## 🧷 Lab 4 — DFT: Scan Chain, BIST, Mealy FSM

**Lab4_Team11_Mealy_Sequence_Detector.v**  
This code implements a Mealy sequence detector. It watches a serial input and raises an output when a specific bit pattern appears.

**Lab4_Team11_Mealy_Sequence_Detector_t.v**  
Testbench for the sequence detector. It feeds in bit streams and checks if the detection output is correct.

**Lab4_Team11_Scan_Chain_Design.v**  
This builds a scan chain, a row of flip-flops that can shift data in and out for testing, or work normally in functional mode.

**Lab4_Team11_Scan_Chain_Design_t.v**  
Testbench for the scan chain. It checks shifting behavior (scan mode) and normal operation.

**Lab4_Team11_Built_In_Self_Test.v**  
This is a Built-In Self-Test (BIST) circuit. It can generate its own test patterns and check the output to see if the circuit is OK.

**Lab4_Team11_Built_In_Self_Test_t.v**  
Testbench for the BIST logic. It runs the self-test and verifies the final “pass/fail” or signature result.

**Lab4_Team11_Built_In_Self_Test_fpga.v**  
FPGA version of the BIST design. It maps control and result signals to FPGA switches/LEDs so you can see the test result on hardware.

---

## 🚦 Lab 5 — FSMs & Datapath Systems

**Lab5_Team11_Traffic_Light_Controller.v**  
This code implements a traffic light controller using an FSM. It changes the lights (green/yellow/red) based on a timing sequence.

**Lab5_Team11_Traffic_Light_Controller_t.v**  
Testbench for the traffic light controller. It simulates time passing and checks that the lights change in the right order.

**Lab5_Team11_Greatest_Common_Divisor.v**  
This module computes the GCD (Greatest Common Divisor) of two numbers using an iterative algorithm (like repeated subtraction or modulo).

**Lab5_Team11_Greatest_Common_Divisor_t.v**  
Testbench for the GCD module. It tests different pairs of numbers and checks that the result matches the true GCD.

**Lab5_Team11_Vending_Machine_fpga.v**  
This code is a vending machine controller for FPGA. It takes coin inputs and selection signals, then decides when to dispense a product or give change.

**Lab5_Team11_Music_fpga.v**  
This module plays simple music or tones on FPGA hardware. It uses counters to create different sound frequencies and timing.

**graycodeToBinary.v**  
This code converts a Gray code input into a binary number. It’s useful when the code comes from Gray-coded counters or sensors.

---

## 🎰 Lab 6 — System-Level FPGA Designs

**Lab6_Team11_Chip2chip_slave_control.v**  
This module is a chip-to-chip slave controller. It waits for commands from a master, follows the protocol, and sends/receives data accordingly.

**Lab6_Team11_Slot_Machine_fpga.v**  
This is a slot machine game on FPGA. It uses random-like values to spin “reels”, lets the user start/stop the game, and checks if the user wins.
