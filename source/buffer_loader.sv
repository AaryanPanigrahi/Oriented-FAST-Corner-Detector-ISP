`timescale 1ns / 10ps

module buffer_loader #(
    // parameters
) (
    input logic clk, n_rst,
    input logic signed [8:0] curr_x, curr_y,
    input logic [7:0] input_pixel,
    input logic start,
    output logic [8:0] x_addr, y_addr,
    output logic done,
    output logic [7:0] buff_output [15:0],
    output logic [7:0] center_value

);

// dx LUT for FAST circle
logic signed [3:0] dx_lut [0:15] = '{
     0,  // pixel 0
    +1,  // pixel 1
    +2,  // pixel 2
    +3,  // pixel 3
    +2,  // pixel 4
    +1,  // pixel 5
     0,  // pixel 6
    -1,  // pixel 7
    -2,  // pixel 8
    -3,  // pixel 9
    -2,  // pixel10
    -1,  // pixel11
     0,  // pixel12 (wraps)
    +1,  // pixel13
    +2,  // pixel14
    +3   // pixel15
};

// dy LUT for FAST circle
logic signed [3:0] dy_lut [0:15] = '{
    -3,  // pixel 0
    -3,  // pixel 1
    -2,  // pixel 2
     0,  // pixel 3
    +2,  // pixel 4
    +3,  // pixel 5
    +3,  // pixel 6
    +3,  // pixel 7
    +2,  // pixel 8
     0,  // pixel 9
    -2,  // pixel10
    -3,  // pixel11
    -3,  // pixel12
    -3,  // pixel13
    -2,  // pixel14
     0   // pixel15
};



typedef enum logic [5:0] {
    IDLE          = 6'b000000,

    LOAD_CENTER   = 6'b000001,
    WAIT_CENTER   = 6'b000010,

    LOAD_PIXEL_1  = 6'b000011,
    WAIT_PIXEL_1  = 6'b000100,

    LOAD_PIXEL_2  = 6'b000101,
    WAIT_PIXEL_2  = 6'b000110,

    LOAD_PIXEL_3  = 6'b000111,
    WAIT_PIXEL_3  = 6'b001000,

    LOAD_PIXEL_4  = 6'b001001,
    WAIT_PIXEL_4  = 6'b001010,

    LOAD_PIXEL_5  = 6'b001011,
    WAIT_PIXEL_5  = 6'b001100,

    LOAD_PIXEL_6  = 6'b001101,
    WAIT_PIXEL_6  = 6'b001110,

    LOAD_PIXEL_7  = 6'b001111,
    WAIT_PIXEL_7  = 6'b010000,

    LOAD_PIXEL_8  = 6'b010001,
    WAIT_PIXEL_8  = 6'b010010,

    LOAD_PIXEL_9  = 6'b010011,
    WAIT_PIXEL_9  = 6'b010100,

    LOAD_PIXEL_10 = 6'b010101,
    WAIT_PIXEL_10 = 6'b010110,

    LOAD_PIXEL_11 = 6'b010111,
    WAIT_PIXEL_11 = 6'b011000,

    LOAD_PIXEL_12 = 6'b011001,
    WAIT_PIXEL_12 = 6'b011010,

    LOAD_PIXEL_13 = 6'b011011,
    WAIT_PIXEL_13 = 6'b011100,

    LOAD_PIXEL_14 = 6'b011101,
    WAIT_PIXEL_14 = 6'b011110,

    LOAD_PIXEL_15 = 6'b011111,
    WAIT_PIXEL_15 = 6'b100000,

    LOAD_PIXEL_16 = 6'b100001,
    WAIT_PIXEL_16 = 6'b100010

} state_t;

state_t current_state, next_state;

always_ff @(posedge clk or negedge n_rst) begin
    if(!n_rst)
        current_state = IDLE;
    else
        current_state <= next_state;
end

always_comb begin : NEXT_STATE_LOGIC
    next_state = current_state;

    unique case (current_state)

        //--------------------------------------------------------
        // IDLE → LOAD_CENTER
        //--------------------------------------------------------
        IDLE: begin
            if (start)
                next_state = LOAD_CENTER;
        end

        LOAD_CENTER:      next_state = WAIT_CENTER;
        WAIT_CENTER:      next_state = LOAD_PIXEL_1;

        LOAD_PIXEL_1:     next_state = WAIT_PIXEL_1;
        WAIT_PIXEL_1:     next_state = LOAD_PIXEL_2;

        LOAD_PIXEL_2:     next_state = WAIT_PIXEL_2;
        WAIT_PIXEL_2:     next_state = LOAD_PIXEL_3;

        LOAD_PIXEL_3:     next_state = WAIT_PIXEL_3;
        WAIT_PIXEL_3:     next_state = LOAD_PIXEL_4;

        LOAD_PIXEL_4:     next_state = WAIT_PIXEL_4;
        WAIT_PIXEL_4:     next_state = LOAD_PIXEL_5;

        LOAD_PIXEL_5:     next_state = WAIT_PIXEL_5;
        WAIT_PIXEL_5:     next_state = LOAD_PIXEL_6;

        LOAD_PIXEL_6:     next_state = WAIT_PIXEL_6;
        WAIT_PIXEL_6:     next_state = LOAD_PIXEL_7;

        LOAD_PIXEL_7:     next_state = WAIT_PIXEL_7;
        WAIT_PIXEL_7:     next_state = LOAD_PIXEL_8;

        LOAD_PIXEL_8:     next_state = WAIT_PIXEL_8;
        WAIT_PIXEL_8:     next_state = LOAD_PIXEL_9;

        LOAD_PIXEL_9:     next_state = WAIT_PIXEL_9;
        WAIT_PIXEL_9:     next_state = LOAD_PIXEL_10;

        LOAD_PIXEL_10:    next_state = WAIT_PIXEL_10;
        WAIT_PIXEL_10:    next_state = LOAD_PIXEL_11;

        LOAD_PIXEL_11:    next_state = WAIT_PIXEL_11;
        WAIT_PIXEL_11:    next_state = LOAD_PIXEL_12;

        LOAD_PIXEL_12:    next_state = WAIT_PIXEL_12;
        WAIT_PIXEL_12:    next_state = LOAD_PIXEL_13;

        LOAD_PIXEL_13:    next_state = WAIT_PIXEL_13;
        WAIT_PIXEL_13:    next_state = LOAD_PIXEL_14;

        LOAD_PIXEL_14:    next_state = WAIT_PIXEL_14;
        WAIT_PIXEL_14:    next_state = LOAD_PIXEL_15;

        LOAD_PIXEL_15:    next_state = WAIT_PIXEL_15;
        WAIT_PIXEL_15:    next_state = LOAD_PIXEL_16;

        LOAD_PIXEL_16:    next_state = WAIT_PIXEL_16;
        WAIT_PIXEL_16:    next_state = IDLE;

        default: next_state = IDLE;

    endcase
end


logic [4:0] pixel_index;   // 0–15

always_comb begin : ADDRESS_LOGIC
    x_addr = 0;
    y_addr = 0;

    unique case (current_state)

        // Center
        LOAD_CENTER: begin
            x_addr = curr_x;
            y_addr = curr_y;
        end

        // Circle neighbors
        LOAD_PIXEL_1: begin
            pixel_index = 0;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_2: begin
            pixel_index = 1;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_3: begin
            pixel_index = 2;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_4: begin
            pixel_index = 3;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_5: begin
            pixel_index = 4;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_6: begin
            pixel_index = 5;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_7: begin
            pixel_index = 6;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_8: begin
            pixel_index = 7;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_9: begin
            pixel_index = 8;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_10: begin
            pixel_index = 9;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_11: begin
            pixel_index = 10;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_12: begin
            pixel_index = 11;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_13: begin
            pixel_index = 12;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_14: begin
            pixel_index = 13;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_15: begin
            pixel_index = 14;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        LOAD_PIXEL_16: begin
            pixel_index = 15;
            x_addr = curr_x + dx_lut[pixel_index];
            y_addr = curr_y + dy_lut[pixel_index];
        end

        default: begin
            x_addr = '0;
            y_addr = '0;
        end
    endcase
end

always_comb begin : BUFFER_LOAD_LOGIC
    done  = 0;
    unique case (current_state)

        WAIT_CENTER: begin
            center_value = input_pixel;
        end

        WAIT_PIXEL_1:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_2:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_3:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_4:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_5:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_6:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_7:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_8:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_9:  buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_10: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_11: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_12: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_13: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_14: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_15: buff_output[pixel_index]     = input_pixel;
        WAIT_PIXEL_16: begin
            buff_output[pixel_index] = input_pixel;
            done  = 1;
        end
        
        default: begin
            done  = 0;
        end
    endcase
end


endmodule

