`timescale 1ns / 10ps

module pipelined_buffer_loader #(
    // parameters
    parameter int THRESHOLD = 20,
    parameter X_MAX = 5,
    parameter Y_MAX = 5
) (
    input logic clk, n_rst,
    input logic signed [$clog2(X_MAX):0] curr_x, curr_y,
    input logic [7:0] input_pixel,
    input logic start,
    output logic signed [$clog2(X_MAX):0] x_addr, y_addr, x_addr4,y_addr4,
    output logic update_sample,read_SRAM2, write_SRAM4,
    output logic [11:0] corner_score
);

logic [7:0] center,next_center;
logic [11:0] next_corner_score;
logic [1:0] buffer_output [0:15];
logic [1:0] next_buffer_output [0:15];

logic [7:0] difference_values [0:15];
logic [7:0] next_difference_values [0:15];

logic in_is_corner_flag;


logic signed [5:0] dx_lut [0:15] = '{
     0,  // pixel 1
    +1,  // pixel 2
    +2,  // pixel 3
    +3,  // pixel 4
    +3,  // pixel 5
    +3,  // pixel 6
    +2,  // pixel 7
    +1,  // pixel 8
    +0,  // pixel 9
    -1,  // pixel10
    -2,  // pixel11
    -3,  // pixel12
    -3,  // pixel13
    -3,  // pixel14
    -2,  // pixel15
    -1   // pixel16
};

// dy LUT for FAST circle
logic signed [5:0] dy_lut [0:15] = '{
    +3,  // pixel 1
    +3,  // pixel 2
    +2,  // pixel 3
    +1,  // pixel 4
    +0,  // pixel 5
    -1,  // pixel 6
    -2,  // pixel 7
    -3,  // pixel 8
    -3,  // pixel 9
    -3,  // pixel10
    -2,  // pixel11
    -1,  // pixel12
    -0,  // pixel13
    +1,  // pixel14
    +2,  // pixel15
    +3   // pixel16
};

typedef enum logic [5:0] {
    IDLE            = 6'b000000,

    LOAD_CENTER     = 6'b000001,
    WAIT_CENTER     = 6'b000010,

    LOAD_PIXEL_1    = 6'b000011,
    WAIT_PIXEL_1    = 6'b000100,

    LOAD_PIXEL_9    = 6'b000101,
    WAIT_PIXEL_9    = 6'b000110,

    LOAD_PIXEL_5    = 6'b000111,
    WAIT_PIXEL_5    = 6'b001000,

    LOAD_PIXEL_13   = 6'b001001,
    WAIT_PIXEL_13   = 6'b001010,
    
    //---------------------------
    LOAD_PIXEL_2    = 6'b001011,
    WAIT_PIXEL_2    = 6'b001100,

    LOAD_PIXEL_3    = 6'b001101,
    WAIT_PIXEL_3    = 6'b001110,

    LOAD_PIXEL_4    = 6'b001111,
    WAIT_PIXEL_4    = 6'b010000,

    LOAD_PIXEL_6    = 6'b010001,
    WAIT_PIXEL_6    = 6'b010010,

    LOAD_PIXEL_7    = 6'b010011,
    WAIT_PIXEL_7    = 6'b010100,

    LOAD_PIXEL_8    = 6'b010101,
    WAIT_PIXEL_8    = 6'b010110,

    LOAD_PIXEL_10   = 6'b010111,
    WAIT_PIXEL_10   = 6'b011000,

    LOAD_PIXEL_11   = 6'b011001,
    WAIT_PIXEL_11   = 6'b011010,

    LOAD_PIXEL_12   = 6'b011011,
    WAIT_PIXEL_12   = 6'b011100,

    LOAD_PIXEL_14   = 6'b011101,
    WAIT_PIXEL_14   = 6'b011110,

    LOAD_PIXEL_15   = 6'b011111,
    WAIT_PIXEL_15   = 6'b100000,

    LOAD_PIXEL_16   = 6'b100001,
    WAIT_PIXEL_16   = 6'b100010,

    DONE = 6'b100011

} state_t;

state_t current_state, next_state;

always_ff @(posedge clk or negedge n_rst) begin
    if(!n_rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin : NEXT_STATE_LOGIC
    next_state = current_state;
    update_sample = 0;
    write_SRAM4 = 0;
    x_addr4 = 0;
    y_addr4 = 0;

    case (current_state)

        IDLE: begin
            if (start)
                next_state = LOAD_CENTER;
        end


        LOAD_CENTER:    next_state = WAIT_CENTER;
        WAIT_CENTER:    next_state = LOAD_PIXEL_1;

        LOAD_PIXEL_1:   next_state = WAIT_PIXEL_1;
        WAIT_PIXEL_1:   next_state = LOAD_PIXEL_9;

        LOAD_PIXEL_9:   next_state = WAIT_PIXEL_9;
        WAIT_PIXEL_9:   next_state = LOAD_PIXEL_5;

        LOAD_PIXEL_5: begin
            if ((buffer_output[0][1] && buffer_output[8][1]) || (buffer_output[0][0] && buffer_output[8][0])) begin
                next_state = WAIT_PIXEL_5;
            end
            else begin
                next_state = IDLE;
                update_sample = 1;
            end
        end
        WAIT_PIXEL_5:   next_state = LOAD_PIXEL_13;

        LOAD_PIXEL_13:  next_state = WAIT_PIXEL_13;
        WAIT_PIXEL_13:  next_state = LOAD_PIXEL_2;

        LOAD_PIXEL_2: begin
            if ((buffer_output[4][1] && buffer_output[12][1]) || (buffer_output[4][0] && buffer_output[12][0])) begin
                next_state = WAIT_PIXEL_2;
            end
            else begin
                next_state = IDLE;
                update_sample = 1;
            end
        end
        WAIT_PIXEL_2:   next_state = LOAD_PIXEL_3;

        LOAD_PIXEL_3:   next_state = WAIT_PIXEL_3;
        WAIT_PIXEL_3:   next_state = LOAD_PIXEL_4;

        LOAD_PIXEL_4:   next_state = WAIT_PIXEL_4;
        WAIT_PIXEL_4:   next_state = LOAD_PIXEL_6;

        LOAD_PIXEL_6:   next_state = WAIT_PIXEL_6;
        WAIT_PIXEL_6:   next_state = LOAD_PIXEL_7;

        LOAD_PIXEL_7:   next_state = WAIT_PIXEL_7;
        WAIT_PIXEL_7:   next_state = LOAD_PIXEL_8;

        LOAD_PIXEL_8:   next_state = WAIT_PIXEL_8;
        WAIT_PIXEL_8:   next_state = LOAD_PIXEL_10;

        LOAD_PIXEL_10:  next_state = WAIT_PIXEL_10;
        WAIT_PIXEL_10:  next_state = LOAD_PIXEL_11;

        LOAD_PIXEL_11:  next_state = WAIT_PIXEL_11;
        WAIT_PIXEL_11:  next_state = LOAD_PIXEL_12;

        LOAD_PIXEL_12:  next_state = WAIT_PIXEL_12;
        WAIT_PIXEL_12: begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM4 = 1;
                x_addr4 = curr_x;
                y_addr4 = $signed(curr_y);
            end
            else
                next_state = LOAD_PIXEL_14;
        end
        LOAD_PIXEL_14:  next_state = WAIT_PIXEL_14;
        WAIT_PIXEL_14: begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM4 = 1;
                x_addr4 = curr_x;
                y_addr4 = $signed(curr_y);
            end
            else
                next_state = LOAD_PIXEL_15;
        end

        LOAD_PIXEL_15:  next_state = WAIT_PIXEL_15;
        WAIT_PIXEL_15: begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM4 = 1;
                x_addr4 = curr_x;
                y_addr4 = $signed(curr_y);
            end
            else
                next_state = LOAD_PIXEL_16;
        end

        LOAD_PIXEL_16:  next_state = WAIT_PIXEL_16;
        WAIT_PIXEL_16:  begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM4 = 1;
                x_addr4 = curr_x;
                y_addr4 = $signed(curr_y);
            end else
                next_state = DONE;
        end

        DONE: begin
            next_state = IDLE;
            update_sample = 1;
            if (in_is_corner_flag) begin
                write_SRAM4 = 1;
                x_addr4 = curr_x;
                y_addr4 = $signed(curr_y);
            end
        end
        default: begin
            next_state = IDLE;
            update_sample = 0;
            write_SRAM4 = 0;
            x_addr4 = 0;
            y_addr4 = 0;
        end
    endcase
end

logic [4:0] pixel_index;  

always_comb begin : ADDRESS_LOGIC
    x_addr = 0;
    y_addr = 0;
    read_SRAM2 = 0;
    pixel_index = 0;
    unique case (current_state)

        // Center
        LOAD_CENTER: begin
            x_addr = $signed(curr_x);
            y_addr = $signed(curr_y);
            read_SRAM2 = 1;
        end

        // Circle neighbors
        LOAD_PIXEL_1: begin
            pixel_index = 0;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_2: begin
            pixel_index = 1;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_3: begin
            pixel_index = 2;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_4: begin
            pixel_index = 3;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_5: begin
            pixel_index = 4;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_6: begin
            pixel_index = 5;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_7: begin
            pixel_index = 6;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_8: begin
            pixel_index = 7;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_9: begin
            pixel_index = 8;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_10: begin
            pixel_index = 9;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_11: begin
            pixel_index = 10;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_12: begin
            pixel_index = 11;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_13: begin
            pixel_index = 12;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_14: begin
            pixel_index = 13;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_15: begin
            pixel_index = 14;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        LOAD_PIXEL_16: begin
            pixel_index = 15;
            x_addr = $signed(curr_x) + dx_lut[pixel_index];
            y_addr = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM2 = 1;
        end

        default: begin
            x_addr = '0;
            y_addr = '0;
            read_SRAM2 = 0;
            pixel_index = 0;
        end
    endcase
end

function automatic logic [1:0] fast_compare(
    input logic [7:0] pixel,
    input logic [7:0] center
);
    logic signed [9:0] diff;
begin

    // Correct: zero-extend first, then subtract
    diff = $signed({1'b0, pixel}) - $signed({1'b0, center});

    if (diff >= $signed(THRESHOLD)) begin
        fast_compare = 2'b10;   // brighter
    end
    else if (diff <= -$signed(THRESHOLD)) begin
        fast_compare = 2'b01;   // darker
    end
    else begin
        fast_compare = 2'b00;   // same
    end
end
endfunction

// Function to compute absolute difference
function automatic logic [7:0] abs_diff_compute(
    input logic [7:0] pixel,
    input logic [7:0] center
);
    logic signed [9:0] diff;
begin
    // Compute signed difference
    diff = $signed({1'b0, pixel}) - $signed({1'b0, center});

    // Take absolute value
    if (diff < 0)
        abs_diff_compute = -diff[7:0]; // truncate to 8 bits
    else
        abs_diff_compute = diff[7:0];
end
endfunction

always_ff @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        for (int i = 0; i < 16; i++) begin
            buffer_output[i] <= 2'b00;
            difference_values[i] <= 8'b00000000;
            center <= 8'b00000000;
            corner_score <= 12'd0;
        end
    end else begin
        for (int i = 0; i < 16; i++) begin
            buffer_output[i] <= next_buffer_output[i];
            difference_values[i] <= next_difference_values[i];
            center <= next_center;
            corner_score <= 12'hFFF;
            //corner_score <= next_corner_score;
        end
    end
end


always_comb begin : BUFFER_LOAD_LOGIC
    next_center = center;  // default: hold previous
    for (int i=0; i<16; i++) begin
        next_buffer_output[i] = buffer_output[i]; // default: hold previous
        next_difference_values[i] = difference_values[i];
    end
    next_corner_score = corner_score
    ;

    
    case (current_state)
        IDLE:begin
            for (int i = 0; i < 16; i++) begin
                next_buffer_output[i] = 2'b00;
                next_difference_values[i] = 8'b00000000;
            end
            next_corner_score = 12'd0;

        end
        WAIT_CENTER: begin
            next_center = input_pixel;
        end

        WAIT_PIXEL_1:  begin
            next_buffer_output[0]  = fast_compare(input_pixel, center);
            next_difference_values[0] = abs_diff_compute(input_pixel, center);
            next_corner_score = 12'd0 + next_difference_values[0];
        end
        WAIT_PIXEL_2:  begin
            next_buffer_output[1]  = fast_compare(input_pixel, center);
            next_difference_values[1] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[1];
        end
        WAIT_PIXEL_3:  begin
            next_buffer_output[2]  = fast_compare(input_pixel, center);
            next_difference_values[2] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[2];
        end
        WAIT_PIXEL_4:  begin
            next_buffer_output[3]  = fast_compare(input_pixel, center);
            next_difference_values[3] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[3];
        end
        WAIT_PIXEL_5:  begin
            next_buffer_output[4]  = fast_compare(input_pixel, center);
            next_difference_values[4] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[4];
        end
        WAIT_PIXEL_6:  begin
            next_buffer_output[5]  = fast_compare(input_pixel, center);
            next_difference_values[5] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[5];
        end
        WAIT_PIXEL_7:  begin
            next_buffer_output[6]  = fast_compare(input_pixel, center);
            next_difference_values[6] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[6];
        end
        WAIT_PIXEL_8:  begin
            next_buffer_output[7]  = fast_compare(input_pixel, center);
            next_difference_values[7] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[7];
        end
        WAIT_PIXEL_9:  begin
            next_buffer_output[8]  = fast_compare(input_pixel, center);
            next_difference_values[8] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[8];
        end
        WAIT_PIXEL_10: begin
            next_buffer_output[9]  = fast_compare(input_pixel, center);
            next_difference_values[9] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[9];
        end
        WAIT_PIXEL_11: begin
            next_buffer_output[10] = fast_compare(input_pixel, center);
            next_difference_values[10] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[10];
        end
        WAIT_PIXEL_12: begin
            next_buffer_output[11] = fast_compare(input_pixel, center);
            next_difference_values[11] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[11];
        end
        WAIT_PIXEL_13: begin
            next_buffer_output[12] = fast_compare(input_pixel, center);
            next_difference_values[12] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[12];
        end
        WAIT_PIXEL_14: begin
            next_buffer_output[13] = fast_compare(input_pixel, center);
            next_difference_values[13] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[13];
        end
        WAIT_PIXEL_15: begin
            next_buffer_output[14] = fast_compare(input_pixel, center);
            next_difference_values[14] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[14];
        end
        WAIT_PIXEL_16: begin
            next_buffer_output[15] = fast_compare(input_pixel, center);
            next_difference_values[15] = abs_diff_compute(input_pixel, center);
            next_corner_score = corner_score + next_difference_values[15];
        end

        default begin
        end
    endcase
end

logic is_bright_corner, is_dark_corner;
logic [31:0] bright_wrap, dark_wrap;

always_comb begin
    bright_wrap = 32'd0;
    dark_wrap   = 32'd0;

    for (int i = 0; i < 16; i++) begin
        bright_wrap[i]      = next_buffer_output[i][1];
        dark_wrap[i]        = next_buffer_output[i][0];
        bright_wrap[i+16]   = next_buffer_output[i][1];
        dark_wrap[i+16]     = next_buffer_output[i][0];
    end
end

always_comb begin
    is_bright_corner   = 1'b0;
    is_dark_corner     = 1'b0;
    in_is_corner_flag  = 1'b0;

    for (int i = 0; i < 16; i++) begin
        if (&bright_wrap[i +: 12])
            is_bright_corner = 1'b1;
        if (&dark_wrap[i +: 12])
            is_dark_corner = 1'b1;
    end

    in_is_corner_flag = is_bright_corner || is_dark_corner;
end

always_comb begin

end

endmodule

