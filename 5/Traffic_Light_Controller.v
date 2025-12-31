`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
    input clk, rst_n;
    input lr_has_car;
    output [2:0] hw_light;
    output [2:0] lr_light;

    reg [2:0] hw_light;
    reg [2:0] lr_light;

    parameter HW_GREEN  = 3'd0;
    parameter HW_YELLOW = 3'd1;
    parameter LR_GREEN  = 3'd2;
    parameter LR_YELLOW = 3'd3;
    parameter HW_RED  = 3'd4;
    parameter LR_RED = 3'd5;
    
    parameter GREEN = 3'b100;
    parameter YELLOW = 3'b010;
    parameter RED = 3'b001;
    
    reg [2:0] current_state, next_state;
    reg [6:0] counter;

    always @(posedge clk) begin
        if (!rst_n) current_state <= HW_GREEN;
        else current_state <= next_state;
    end

    always @(posedge clk) begin
        if(!rst_n || current_state != next_state) counter <= 7'd0;
        
        else begin
            if(counter == 7'd70) counter <= counter;
            else counter <= counter + 1;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            HW_GREEN: begin
                if (lr_has_car && counter >= 7'd69) next_state = HW_YELLOW;
            end

            HW_YELLOW: begin
                if (counter == 7'd24) next_state = HW_RED;
            end
            
            HW_RED: begin
                if (counter == 7'd0) next_state = LR_GREEN;
            end
            
            LR_GREEN: begin
                if (counter >= 7'd69) next_state = LR_YELLOW;
            end

            LR_YELLOW: begin
                if (counter == 7'd24) next_state = LR_RED;
            end

            LR_RED: begin
                if (counter == 7'd0) next_state = HW_GREEN;
            end
        endcase
    end

    always @(*) begin
        case (current_state)
            HW_GREEN: begin
                hw_light = GREEN;
                lr_light = RED;
            end

            HW_YELLOW: begin
                hw_light = YELLOW;
                lr_light = RED;
            end
            
           HW_RED: begin
                hw_light = RED;
                lr_light = RED;
            end

            LR_GREEN: begin
                hw_light = RED;
                lr_light = GREEN;
            end

            LR_YELLOW: begin
                hw_light = RED;
                lr_light = YELLOW;
            end

            LR_RED: begin
                hw_light = RED;
                lr_light = RED;
            end
            
            default: begin
                hw_light = GREEN;
                lr_light = RED;
            end
        endcase
    end
endmodule
