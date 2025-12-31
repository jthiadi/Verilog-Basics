module TOP (input clk,
            inout PS2_DATA,
            inout PS2_CLK,
            output pmod_1,
            output pmod_2,
            output pmod_4
           );

    parameter DUTY_BEST = 10'd512;	//duty cycle=50%
    
    wire [31:0] freq;
    wire [7:0] ibeatNum;
    wire beatFreq;
    
    wire r_button, s_button, w_button, enter_button;
    wire r_op;
    wire [31:0] BEAT_FREQ;

    reg reset;
    assign pmod_2 = 1'd1;	//no gain(6dB)
    assign pmod_4 = 1'd1;	//turn-on   
                      
    wsr_enter_button wsrEnter(.rst(reset),
                              .clk(clk),
                              .w_button(w_button),
                              .s_button(s_button),                              
                              .r_button(r_button),
                              .enter_button(enter_button),
                              .PS2_DATA(PS2_DATA),
                              .PS2_CLK(PS2_CLK)
                              );

    OnePulse op_r(.signal_single_pulse(r_op),
                  .signal(r_button),
                  .clock(clk)
                 );      
          
    //Generate Beat frequency
    BEATFREQ_gen bfGen(.BEAT_FREQ (BEAT_FREQ),
                       .r_op (r_op), 
                       .enter_button(enter_button)
                       );
    
    //Generate beat speed
    PWM_gen btSpeedGen (.clk(clk), 
                        .reset(reset),
                        .freq(BEAT_FREQ),
                        .duty(DUTY_BEST), 
                        .PWM(beatFreq)
                       );
	
    //manipulate beat
    PlayerCtrl playerCtrl_00 (.clk(beatFreq),
                              .w_button(w_button),
                              .s_button(s_button),
                              .enter_button(enter_button),
                              .ibeat(ibeatNum)
                             );	
        
    //Generate variant freq. of tones
    Music music00 (.ibeatNum(ibeatNum),
                   .tone(freq)
                  );

    // Generate particular freq. signal
    PWM_gen toneGen (.clk(clk), 
                     .reset(reset), 
                     .freq(freq),
                     .duty(DUTY_BEST), 
                     .PWM(pmod_1)
                    );                    
endmodule

module wsr_enter_button(
    input wire rst,
    input wire clk,
    output reg w_button,
  	output reg s_button,    
  	output reg r_button,
    output reg enter_button,
    inout wire PS2_DATA,
    inout wire PS2_CLK
    );
  	
  	parameter [8:0] KEY_CODES_R = 9'b0_0010_1101; // r -> 2D
  	parameter [8:0] KEY_CODES_S = 9'b0_0001_1011; // s -> 1B
  	parameter [8:0] KEY_CODES_W = 9'b0_0001_1101; // w -> 1D
    parameter [8:0] KEY_CODES_Enter = 9'b0_0101_1010; // enter -> 5A
  
  	reg [4-1:0] key_rsw;
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
        
    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );

    always @ (*) begin
        case (last_change)
          	KEY_CODES_R : key_rsw = 4'b0001;
          	KEY_CODES_S : key_rsw = 4'b0010;
          	KEY_CODES_W : key_rsw = 4'b0100;
          	KEY_CODES_Enter: key_rsw = 4'b1000;
            default : key_rsw = 4'b1111;
        endcase
    end
  
  always @(*)begin
    if (been_ready && key_down[last_change] == 1'b1)begin
      case(key_rsw)
        4'b0001: r_button = 1'b1;
        4'b0010: s_button = 1'b1;
        4'b0100: w_button = 1'b1;
        4'b1000: enter_button = 1'b1;
        default: {r_button, s_button, w_button, enter_button} = 4'b0000;
      endcase
    end
    else {r_button, s_button, w_button, enter_button} = 4'b0000;
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
    
    OnePulse op (
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

module OnePulse (
    output reg signal_single_pulse,
    input wire signal,
    input wire clock
    );
    
    reg signal_delay;

    always @(posedge clock) begin
        if (signal == 1'b1 & signal_delay == 1'b0)
            signal_single_pulse <= 1'b1;
        else
            signal_single_pulse <= 1'b0;
        signal_delay <= signal;
    end
endmodule

module BEATFREQ_gen(output [31:0] BEAT_FREQ,
                       input r_op, 
                       input enter_button 
                       );
  reg r_clicked;		//0 -> fast			1 -> slow
  always @(posedge r_op, posedge enter_button)begin
    if (enter_button) r_clicked <= 1'b1;
    else if (r_op) r_clicked <= ~r_clicked;
  end
  
  assign BEAT_FREQ = ((r_clicked == 1'b0) ? 32'd8 : 32'd4);
endmodule

module PWM_gen (input wire clk,
                input wire reset,
	            input [31:0] freq,
                input [9:0] duty,
                output reg PWM
                );
                
wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule


module PlayerCtrl (input clk,
                   input w_button, 
                   input s_button, 
                   input enter_button,
	               output reg [7:0] ibeat
                  );

    parameter BEATLENGTH = 115;
    reg control = 1'b1;	                   // 1 -> ascend		0 -> descend

    always @(posedge clk or posedge enter_button or posedge w_button or posedge s_button) begin
        if (enter_button) begin
            ibeat <= 8'd0;
            control <= 1'b1;
        end
        else if (w_button) begin
            control <= 1'b1;
        end
        else if (s_button) begin
            control <= 1'b0;
        end
        else if (control == 1'b1) begin
            if (ibeat != BEATLENGTH) begin
                ibeat <= ibeat + 8'd1;
            end
            else if (ibeat == BEATLENGTH) control <= 1'b1;
            else begin
                control <= 1'b0;  
            end
        end
        else if (control == 1'b0) begin
            if (ibeat != 8'd0) begin
                ibeat <= ibeat - 8'd1;
            end
            else if (ibeat == 8'd0) control <= 1'b0;
            else begin
                control <= 1'b1;  
            end
        end
        else control <= 1'b1;
    end


endmodule

`define NM1 32'd262 //C_freq
`define NM2 32'd294 //D_freq
`define NM3 32'd330 //E_freq
`define NM4 32'd349 //F_freq
`define NM5 32'd392 //G_freq
`define NM6 32'd440 //A_freq
`define NM7 32'd494 //B_freq
`define NM0 32'd20000 //slience (over freq.)

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);
always @(*) begin
	case (ibeatNum)		// 1/4 beat
		8'd0 : tone = `NM1;	//C4
		8'd1 : tone = `NM1;
		8'd2 : tone = `NM1;
		8'd3 : tone = `NM1;
		8'd4 : tone = `NM2;	//D4
		8'd5 : tone = `NM2;
		8'd6 : tone = `NM2;
		8'd7 : tone = `NM2;
		8'd8 : tone = `NM3;	//E4
		8'd9 : tone = `NM3;
		8'd10 : tone = `NM3;
		8'd11 : tone = `NM3;
		8'd12 : tone = `NM4; //F4
		8'd13 : tone = `NM4;
		8'd14 : tone = `NM4;
		8'd15 : tone = `NM4;
		8'd16 : tone = `NM5; //G4
		8'd17 : tone = `NM5;
		8'd18 : tone = `NM5;
		8'd19 : tone = `NM5;
		8'd20 : tone = `NM6; //A4
		8'd21 : tone = `NM6;
		8'd22 : tone = `NM6;
		8'd23 : tone = `NM6;
		8'd24 : tone = `NM7; //B4
		8'd25 : tone = `NM7;
		8'd26 : tone = `NM7;
		8'd27 : tone = `NM7;

		8'd28 : tone = `NM1 << 1; //C5
		8'd29 : tone = `NM1 << 1;
		8'd30 : tone = `NM1 << 1;
		8'd31 : tone = `NM1 << 1;
		8'd32 : tone = `NM2 << 1; //D5
		8'd33 : tone = `NM2 << 1;
		8'd34 : tone = `NM2 << 1;
		8'd35 : tone = `NM2 << 1;
		8'd36 : tone = `NM3 << 1; //E5
		8'd37 : tone = `NM3 << 1;
		8'd38 : tone = `NM3 << 1;
		8'd39 : tone = `NM3 << 1;
		8'd40 : tone = `NM4 << 1; //F5
		8'd41 : tone = `NM4 << 1;
		8'd42 : tone = `NM4 << 1;
		8'd43 : tone = `NM4 << 1;
		8'd44 : tone = `NM5 << 1; //G5
		8'd45 : tone = `NM5 << 1;
		8'd46 : tone = `NM5 << 1;
		8'd47 : tone = `NM5 << 1;
		8'd48 : tone = `NM6 << 1; //A5
		8'd49 : tone = `NM6 << 1;
		8'd50 : tone = `NM6 << 1;
		8'd51 : tone = `NM6 << 1;
		8'd52 : tone = `NM7 << 1; //B5
		8'd53 : tone = `NM7 << 1;
		8'd54 : tone = `NM7 << 1;
		8'd55 : tone = `NM7 << 1;

		8'd56 : tone = `NM1 << 2; //C6
		8'd57 : tone = `NM1 << 2; 
		8'd58 : tone = `NM1 << 2;
		8'd59 : tone = `NM1 << 2;
		8'd60 : tone = `NM2 << 2; //D6
		8'd61 : tone = `NM2 << 2;
		8'd62 : tone = `NM2 << 2;
		8'd63 : tone = `NM2 << 2;
		8'd64 : tone = `NM3 << 2; //E6
		8'd65 : tone = `NM3 << 2;
		8'd66 : tone = `NM3 << 2;
		8'd67 : tone = `NM3 << 2;
		8'd68 : tone = `NM4 << 2; //F6
		8'd69 : tone = `NM4 << 2;
		8'd70 : tone = `NM4 << 2;
		8'd71 : tone = `NM4 << 2;
		8'd72 : tone = `NM5 << 2; //G6
		8'd73 : tone = `NM5 << 2;
		8'd74 : tone = `NM5 << 2;
		8'd75 : tone = `NM5 << 2;
		8'd76 : tone = `NM6 << 2; //A6
		8'd77 : tone = `NM6 << 2;
		8'd78 : tone = `NM6 << 2;
		8'd79 : tone = `NM6 << 2;
		8'd80 : tone = `NM7 << 2; //B6
		8'd81 : tone = `NM7 << 2;
		8'd82 : tone = `NM7 << 2;
		8'd83 : tone = `NM7 << 2;

		8'd84 : tone = `NM1 << 3; //C7
		8'd85 : tone = `NM1 << 3;
		8'd86 : tone = `NM1 << 3;
		8'd87 : tone = `NM1 << 3;
		8'd88 : tone = `NM2 << 3; //D7
		8'd89 : tone = `NM2 << 3;
		8'd90 : tone = `NM2 << 3;
		8'd91 : tone = `NM2 << 3;
		8'd92 : tone = `NM3 << 3; //E7
		8'd93 : tone = `NM3 << 3;
		8'd94 : tone = `NM3 << 3;
		8'd95 : tone = `NM3 << 3;
		8'd96 : tone = `NM4 << 3; //F7
		8'd97 : tone = `NM4 << 3;
		8'd98 : tone = `NM4 << 3;
		8'd99 : tone = `NM4 << 3;
		8'd100 : tone = `NM5 << 3; //G7
		8'd101 : tone = `NM5 << 3;
		8'd102 : tone = `NM5 << 3;
		8'd103 : tone = `NM5 << 3;
		8'd104 : tone = `NM6 << 3; //A7
		8'd105 : tone = `NM6 << 3;
		8'd106 : tone = `NM6 << 3;
		8'd107 : tone = `NM6 << 3;
		8'd108 : tone = `NM7 << 3; //B7
		8'd109 : tone = `NM7 << 3;
		8'd110 : tone = `NM7 << 3;
		8'd111 : tone = `NM7 << 3;
		
		8'd112 : tone = `NM1 << 4; //C8
		8'd113 : tone = `NM1 << 4;
		8'd114 : tone = `NM1 << 4;
		8'd115 : tone = `NM1 << 4;
		
		default : tone = `NM0;
	endcase
end

endmodule