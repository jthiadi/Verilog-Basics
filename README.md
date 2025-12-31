# Verilog-Basics

This repository contains a collection of **digital logic design labs implemented in Verilog HDL** and developed using **Xilinx Vivado**.  
The projects progress from **basic combinational logic and arithmetic units** through **sequential logic, FSM design, Design-for-Testability (DFT), and full FPGA-based systems**.

All designs were **simulated using Vivado Simulator**, and FPGA-oriented designs were synthesized and deployed on hardware using Vivado.

## 📚 Lab Overview

| Folder | Theme | Topics |
|-----|------|--------|
| **1** | Basic Components & Crossbars | Multiplexing, T-Flip-Flop, Routing logic |
| **2** | Adders & Multiplier | Ripple-Carry, Carry-Look-Ahead, Arithmetic Units |
| **3** | Sequential Logic & Arbitration | Ping-Pong Counters, FIFO Round-Robin Arbiter |
| **4** | Design-for-Testability | Scan Chains, BIST, Mealy FSM |
| **5** | FSM & Datapath Systems | GCD, Traffic Light FSM, FPGA Applications |
| **6** | Full FPGA System Design | Slot Machine & Chip-to-Chip Control |

---

## 🧪 1 — Basic Logic & Crossbars

**Toggle_Flip_Flop.v**  
This code builds a T flip-flop. When the toggle input is 1, the output changes from 0→1 or 1→0 on every clock edge.

**Toggle_Flip_Flop_t.v**  
This is the testbench for the T flip-flop. It gives clock and toggle signals and checks if the output toggles correctly.

**Crossbar_2x2_4bit.v**  
This code makes a 2×2 crossbar switch for 4-bit data. It connects two inputs to two outputs depending on a select signal.

**Crossbar_2x2_4bit_t.v**  
Testbench for the 2×2 crossbar. It changes the inputs and select signal to see if the outputs are routed correctly.

**Crossbar_2x2_4bit_fpga.v**  
FPGA version of the 2×2 crossbar. It connects the crossbar to FPGA pins (switches/LEDs) so you can test it on real hardware.

**Crossbar_4x4_4bit.v**  
This code makes a 4×4 crossbar switch for 4-bit data, allowing four inputs to be connected to four outputs based on control signals.

**Crossbar_4x4_4bit_t.v**  
Testbench for the 4×4 crossbar. It tries different routes and checks if each output gets the right input.

**Dmux_1x4_4bit.v**  
This is a 1-to-4 demultiplexer for 4-bit data. One input is sent to one of four outputs, based on a select signal.

**Dmux_1x4_4bit_t.v**  
Testbench for the 1-to-4 demux. It tests different select values and checks which output gets the input.

---

## ➕ 2 — Adders & Multiplier

**Ripple_Carry_Adder.v**  
This code builds an 8-bit ripple-carry adder, which adds two 8-bit numbers by passing the carry from one bit to the next.

**Ripple_Carry_Adder_t.v**  
Testbench for the ripple-carry adder. It gives different input pairs and checks if the sum and carry are correct.

**Carry_Look_Ahead_Adder_8bit.v**  
This is an 8-bit carry-look-ahead adder. It also adds two 8-bit numbers but computes carries faster using extra logic.

**Carry_Look_Ahead_Adder_8bit_t.v**  
Testbench for the carry-look-ahead adder. It compares the outputs with expected sums to confirm correctness.

**Multiplier_4bit.v**  
This code is a 4-bit multiplier. It multiplies two 4-bit numbers and produces an 8-bit result.

**Multiplier_4bit_t.v**  
Testbench for the 4-bit multiplier. It tries many input combinations and checks the product.

---

## 🔁 3 — Counters & Arbiter

**Ping_Pong_Counter.v**  
This code builds a ping-pong counter. It counts up to a maximum value, then counts back down, and repeats.

**Ping_Pong_Counter_t.v**  
Testbench for the ping-pong counter. It checks that the counter goes up, then down, in the right order.

**Parameterized_Ping_Pong_Counter.v**  
This is a configurable ping-pong counter. You can change the size or limit using parameters instead of rewriting the code.

**Parameterized_Ping_Pong_Counter_t.v**  
Testbench for the parameterized ping-pong counter. It tests the counter with different parameter settings.

**Parameterized_Ping_Pong_Counter_fpga.v**  
FPGA version of the parameterized ping-pong counter, wired to FPGA inputs/outputs so you can see the count on LEDs or displays.

**Round_Robin_FIFO_Arbiter.v**  
This code creates a round-robin arbiter. When several inputs request service, it gives each one a turn in order so no one starves.

**Round_Robin_FIFO_Arbiter_t.v**  
Testbench for the round-robin arbiter. It makes different request patterns and checks if the grants rotate fairly.

---

## 🧷 4 — DFT: Scan Chain, BIST, Mealy FSM

**Mealy_Sequence_Detector.v**  
This code implements a Mealy sequence detector. It watches a serial input and raises an output when a specific bit pattern appears.

**Mealy_Sequence_Detector_t.v**  
Testbench for the sequence detector. It feeds in bit streams and checks if the detection output is correct.

**Scan_Chain_Design.v**  
This builds a scan chain, a row of flip-flops that can shift data in and out for testing, or work normally in functional mode.

**Scan_Chain_Design_t.v**  
Testbench for the scan chain. It checks shifting behavior (scan mode) and normal operation.

**Built_In_Self_Test.v**  
This is a Built-In Self-Test (BIST) circuit. It can generate its own test patterns and check the output to see if the circuit is OK.

**Built_In_Self_Test_t.v**  
Testbench for the BIST logic. It runs the self-test and verifies the final “pass/fail” or signature result.

**Built_In_Self_Test_fpga.v**  
FPGA version of the BIST design. It maps control and result signals to FPGA switches/LEDs so you can see the test result on hardware.

---

## 🚦5 — FSMs & Datapath Systems

**Traffic_Light_Controller.v**  
This code implements a traffic light controller using an FSM. It changes the lights (green/yellow/red) based on a timing sequence.

**Traffic_Light_Controller_t.v**  
Testbench for the traffic light controller. It simulates time passing and checks that the lights change in the right order.

**Greatest_Common_Divisor.v**  
This module computes the GCD (Greatest Common Divisor) of two numbers using an iterative algorithm (like repeated subtraction or modulo).

**Greatest_Common_Divisor_t.v**  
Testbench for the GCD module. It tests different pairs of numbers and checks that the result matches the true GCD.

**Vending_Machine_fpga.v**  
This code is a vending machine controller for FPGA. It takes coin inputs and selection signals, then decides when to dispense a product or give change.

**Music_fpga.v**  
This module plays simple music or tones on FPGA hardware. It uses counters to create different sound frequencies and timing.

**graycodeToBinary.v**  
This code converts a Gray code input into a binary number. It’s useful when the code comes from Gray-coded counters or sensors.

---

## 🎰 6 — System-Level FPGA Designs

**Chip2chip_slave_control.v**  
This module is a chip-to-chip slave controller. It waits for commands from a master, follows the protocol, and sends/receives data accordingly.

**Slot_Machine_fpga.v**  
This is a slot machine game on FPGA. It uses random-like values to spin “reels”, lets the user start/stop the game, and checks if the user wins.

---

# 🛠 Vivado Workflow (Simulation + FPGA)

### 🔍 Behavioral Simulation
1. Open **Vivado**
2. Create RTL project
3. Add module `.v`
4. Add matching `_t.v` testbench
5. Set testbench as **Top Module**
6. Run **Behavioral Simulation**

### 💡 FPGA Deployment
1. Add design sources
2. Add `.xdc` constraints (buttons, LEDs, 7-seg, buzzer, etc.)
3. Run:
   - Synthesis  
   - Implementation  
   - Bitstream Generation  
4. Program FPGA

---

