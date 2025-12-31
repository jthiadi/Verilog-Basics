`timescale 1ns / 1ps

`timescale 1ns / 1ps

module VendingMachine(
    inout PS2_DATA,
    inout PS2_CLK,
    input clk,
    input top_reset,
    input left_five,
    input right_fifty,
    input down_cancel,
    input center_ten,
    output reg[3:0] led,
    output[3:0] an,
    output[6:0] segment
);

 wire [511:0] key_down;
 wire [8:0] last_change;
 wire vakid_key;
 
 parameter [8:0] KEY_CODES_A = 9'b0_0001_1100;
 parameter [8:0] KEY_CODES_S = 9'b0_0001_1011; 
 parameter [8:0] KEY_CODES_D = 9'b0_0010_0011;
 parameter [8:0] KEY_CODES_F = 9'b0_0010_1011;
    
wire top_reset_db, left_five_db, right_fifty_db, down_cancel_db, center_ten_db;
wire top_reset_op, left_five_op, right_fifty_op, down_cancel_op, center_ten_op;

reg[7:0] money, updated_money;
reg state, next_state;
reg[26:0] refresh_counter = 27'd0;

parameter insert_state = 1'b0;
parameter return_state = 1'b1;

debounce db1(top_reset_db, top_reset, clk);
debounce db2(left_five_db, left_five, clk);
debounce db3(right_fifty_db, right_fifty, clk);
debounce db4(center_ten_db, center_ten, clk);
debounce db5(down_cancel_db, down_cancel, clk);

OnePulse op1(top_reset_op, top_reset_db, clk);
OnePulse op2(left_five_op, left_five_db, clk);
OnePulse op3(right_fifty_op, right_fifty_db, clk);
OnePulse op4(center_ten_op, center_ten_db, clk);
OnePulse op5(down_cancel_op, down_cancel_db, clk);

segment_doing sd(clk, money, segment, an, top_reset_op);
KeyboardDecoder kb_dec(key_down, last_change, valid_key, PS2_DATA, PS2_CLK, pulse_rst, clk);

// State Machine
always @(posedge clk) begin
    if (top_reset_op) begin
        refresh_counter <= 27'd0;
        state <= insert_state;
        money <= 8'd0;
    end else begin
        state <= next_state;

        if (state == return_state) begin
            if (refresh_counter == 27'd99999999) begin  // Reduced count for faster operation
                refresh_counter <= 27'd0;
                money <= updated_money;
            end else begin
                refresh_counter <= refresh_counter + 1;
            end
        end else if (state == insert_state) begin
            money <= updated_money;
        end
    end
end

// State Transitions and Actions
always @(*) begin
    next_state = state;
    updated_money = money;
    
    if (state == insert_state) begin
        if (left_five_op && (money + 8'd5 <= 8'd100)) begin
            updated_money = money + 8'd5;
        end else if (center_ten_op && (money + 8'd10 <= 8'd100)) begin
            updated_money = money + 8'd10;
        end else if (right_fifty_op && (money + 8'd50 <= 8'd100)) begin
            updated_money = money + 8'd50;
        end else if (down_cancel_op) begin
            next_state = return_state;
        end else if (valid_key && key_down[last_change]) begin
            if (last_change == KEY_CODES_A && money >= 8'd80) begin
                updated_money = money - 8'd80;
                next_state = return_state;
            end else if (last_change == KEY_CODES_S && money >= 8'd30) begin
                updated_money = money - 8'd30;
                next_state = return_state;
            end else if (last_change == KEY_CODES_D && money >= 8'd25) begin
                updated_money = money - 8'd25;
                next_state = return_state;
            end else if (last_change == KEY_CODES_F && money >= 8'd20) begin
                updated_money = money - 8'd20;
                next_state = return_state;
            end
        end
    end else if (state == return_state) begin
        if (money > 8'd0) begin
            updated_money = money - 8'd5;
        end else begin
            updated_money = 8'd0;
            next_state = insert_state;
        end
    end
end

// LED Indicator Logic
always @(*) begin
    led[0] = (state == insert_state && money >= 8'd20);
    led[1] = (state == insert_state && money >= 8'd25);
    led[2] = (state == insert_state && money >= 8'd30);
    led[3] = (state == insert_state && money >= 8'd80);
end

endmodule

module segment_doing(clk, number, segment, an, rst);
input clk;
input rst;
input[7:0] number;
output[6:0] segment;
output[3:0] an;

reg [6:0] segment;
reg [3:0] an;
reg [15:0] refresh_counter = 16'd0;
reg [1:0] digit = 2'd0;
reg [3:0] num;

always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
    if (refresh_counter == 16'd50000) begin
        digit <= digit + 1;
        refresh_counter <= 16'd0;
    end
end

always @(*) begin
    case (digit)
        2'b00: an = 4'b0111;
        2'b01: an = 4'b1011;
        2'b10: an = 4'b1101;
        2'b11: an = 4'b1110;
    endcase
end

always @(*) begin
    case (digit)
        2'b11: num = (number % 100) % 10;
        2'b10: begin
            if((number % 100) / 10 != 0 || number == 8'd100) num = (number % 100) / 10;
            else num = 4'd10;
        end
        2'b01: num = (number /100 ==1)?1'b1 : 4'd10;
        default: num = 4'd10;
    endcase
end

always @(*) begin
    case (num)
        4'd0: segment = 7'b1000000;
        4'd1: segment = 7'b1111001;
        4'd2: segment = 7'b0100100;
        4'd3: segment = 7'b0110000;
        4'd4: segment = 7'b0011001;
        4'd5: segment = 7'b0010010;
        4'd6: segment = 7'b0000010;
        4'd7: segment = 7'b1111000;
        4'd8: segment = 7'b0000000;
        4'd9: segment = 7'b0010000;
        default: segment = 7'b1111111;
    endcase
end

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

module OnePulse(
    output reg signal_single_pulse,
    input wire signal,
    input wire clock
);
    
    reg signal_delay;
    
    always @(posedge clock) begin
        if(signal == 1'b1 & signal_delay == 1'b0)
            signal_single_pulse <= 1'b1;
        else
            signal_single_pulse <= 1'b0;
        signal_delay <= signal;
    end
endmodule

module KeyboardDecoder(
    output reg [511:0] key_down,
    output wire [8:0] last_change,
    output reg key_valid,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk
);
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
    parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key, next_key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state, next_state;
    reg been_ready, been_extend, been_break;
    reg next_been_ready, next_been_extend, next_been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
        .key_in(key_in),
        .is_extend(is_extend),
        .is_break(is_break),
        .valid(valid),
        .err(err),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );
    
    OnePulse op(
        .signal_single_pulse(pulse_been_ready),
        .signal(been_ready),
        .clock(clk)
    );
    
     always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            been_ready  <= 1'b0;
            been_extend <= 1'b0;
            been_break  <= 1'b0;
            key <= 10'b0_0_0000_0000;
        end else begin
            state <= next_state;
            been_ready  <= next_been_ready;
            been_extend <= next_been_extend;
            been_break  <= next_been_break;
            key <= next_key;
        end
    end
    
    always @ (*) begin
        case (state)
            INIT:            next_state = (key_in == IS_INIT) ? WAIT_FOR_SIGNAL : INIT;
            WAIT_FOR_SIGNAL: next_state = (valid == 1'b0) ? WAIT_FOR_SIGNAL : GET_SIGNAL_DOWN;
            GET_SIGNAL_DOWN: next_state = WAIT_RELEASE;
            WAIT_RELEASE:    next_state = (valid == 1'b1) ? WAIT_RELEASE : WAIT_FOR_SIGNAL;
            default:         next_state = INIT;
        endcase
    end
    always @ (*) begin
        next_been_ready = been_ready;
        case (state)
            INIT:            next_been_ready = (key_in == IS_INIT) ? 1'b0 : next_been_ready;
            WAIT_FOR_SIGNAL: next_been_ready = (valid == 1'b0) ? 1'b0 : next_been_ready;
            GET_SIGNAL_DOWN: next_been_ready = 1'b1;
            WAIT_RELEASE:    next_been_ready = next_been_ready;
            default:         next_been_ready = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_extend = (is_extend) ? 1'b1 : been_extend;
        case (state)
            INIT:            next_been_extend = (key_in == IS_INIT) ? 1'b0 : next_been_extend;
            WAIT_FOR_SIGNAL: next_been_extend = next_been_extend;
            GET_SIGNAL_DOWN: next_been_extend = next_been_extend;
            WAIT_RELEASE:    next_been_extend = (valid == 1'b1) ? next_been_extend : 1'b0;
            default:         next_been_extend = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_break = (is_break) ? 1'b1 : been_break;
        case (state)
            INIT:            next_been_break = (key_in == IS_INIT) ? 1'b0 : next_been_break;
            WAIT_FOR_SIGNAL: next_been_break = next_been_break;
            GET_SIGNAL_DOWN: next_been_break = next_been_break;
            WAIT_RELEASE:    next_been_break = (valid == 1'b1) ? next_been_break : 1'b0;
            default:         next_been_break = 1'b0;
        endcase
    end
    always @ (*) begin
        next_key = key;
        case (state)
            INIT:            next_key = (key_in == IS_INIT) ? 10'b0_0_0000_0000 : next_key;
            WAIT_FOR_SIGNAL: next_key = next_key;
            GET_SIGNAL_DOWN: next_key = {been_extend, been_break, key_in};
            WAIT_RELEASE:    next_key = next_key;
            default:         next_key = 10'b0_0_0000_0000;
        endcase
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            key_valid <= 1'b0;
            key_down <= 511'b0;
        end else if (key_decode[last_change] && pulse_been_ready) begin
            key_valid <= 1'b1;
            if (key[8] == 0) begin
                key_down <= key_down | key_decode;
            end else begin
                key_down <= key_down & (~key_decode);
            end
        end else begin
            key_valid <= 1'b0;
            key_down <= key_down;
        end
    end
    
endmodule
