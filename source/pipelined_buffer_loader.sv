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
    output logic signed [$clog2(X_MAX):0] x_addr_gaus, y_addr_gaus, x_addr_fast,y_addr_fast,
    output logic update_sample,read_SRAM_gaus, write_SRAM_fast
);

logic [7:0] center,next_center;
logic [1:0] buffer_output [0:15];
logic [1:0] next_buffer_output [0:15];

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
    IDLE          = 6'b000000,

    LOAD_CENTER   = 6'b000001,

    LOAD_PIXEL_1  = 6'b000010,
    LOAD_PIXEL_9  = 6'b000011,
    LOAD_PIXEL_5  = 6'b000100,
    LOAD_PIXEL_13 = 6'b000101,

    LOAD_PIXEL_2  = 6'b000110,
    LOAD_PIXEL_3  = 6'b000111,
    LOAD_PIXEL_4  = 6'b001000,

    LOAD_PIXEL_6  = 6'b001001,
    LOAD_PIXEL_7  = 6'b001010,
    LOAD_PIXEL_8  = 6'b001011,

    LOAD_PIXEL_10 = 6'b001100,
    LOAD_PIXEL_11 = 6'b001101,
    LOAD_PIXEL_12 = 6'b001110,

    LOAD_PIXEL_14 = 6'b001111,
    LOAD_PIXEL_15 = 6'b010000,
    LOAD_PIXEL_16 = 6'b010001,

    DONE          = 6'b010010
} state_t;



state_t current_state, next_state;

always_ff @(posedge clk or negedge n_rst) begin
    if(!n_rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin : NEXT_STATE_LOGIC
    next_state     = current_state;
    update_sample  = 0;
    write_SRAM_fast    = 0;
    x_addr_fast        = 0;
    y_addr_fast        = 0;

    case (current_state)

        IDLE: begin
            if (start)
                next_state = LOAD_CENTER;
        end

        LOAD_CENTER:   next_state = LOAD_PIXEL_1;

        LOAD_PIXEL_1:  next_state = LOAD_PIXEL_9;
        LOAD_PIXEL_9:  next_state = LOAD_PIXEL_5;
        LOAD_PIXEL_5:  next_state = LOAD_PIXEL_13;//begin
        //     if ((next_buffer_output[0][1] && next_buffer_output[8][1]) || (next_buffer_output[0][0] && next_buffer_output[8][0])) begin
        //         next_state = LOAD_PIXEL_13;
        //     end
        //     else begin
        //         next_state = IDLE;
        //         update_sample = 1;
        //     end
        // end
        LOAD_PIXEL_13: next_state = LOAD_PIXEL_2;

        LOAD_PIXEL_2:  next_state = LOAD_PIXEL_3;
        LOAD_PIXEL_3:  next_state = LOAD_PIXEL_4;//begin
        //     if ((next_buffer_output[4][1] && next_buffer_output[12][1]) || (next_buffer_output[4][0] && next_buffer_output[12][0])) begin
        //         next_state = LOAD_PIXEL_4;
        //     end
        //     else begin
        //         next_state = IDLE;
        //         update_sample = 1;
        //     end
        // end
        LOAD_PIXEL_4:  next_state = LOAD_PIXEL_6;
        LOAD_PIXEL_6:  next_state = LOAD_PIXEL_7;
        LOAD_PIXEL_7:  next_state = LOAD_PIXEL_8;

        LOAD_PIXEL_8:  next_state = LOAD_PIXEL_10;
        LOAD_PIXEL_10: next_state = LOAD_PIXEL_11;
        LOAD_PIXEL_11: next_state = LOAD_PIXEL_12;

        LOAD_PIXEL_12: next_state = LOAD_PIXEL_14;
        LOAD_PIXEL_14: begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM_fast = 1;
                x_addr_fast = curr_x;
                y_addr_fast = $signed(curr_y);
            end
            else
                next_state = LOAD_PIXEL_15;
        end
        LOAD_PIXEL_15: begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM_fast = 1;
                x_addr_fast = curr_x;
                y_addr_fast = $signed(curr_y);
            end
            else
                next_state = LOAD_PIXEL_16;
        end
        LOAD_PIXEL_16:begin
            if (in_is_corner_flag) begin
                next_state = IDLE;
                update_sample = 1;
                write_SRAM_fast = 1;
                x_addr_fast = curr_x;
                y_addr_fast = $signed(curr_y);
            end
            else
                next_state = DONE;
        end
        DONE: begin
            next_state = IDLE;
            update_sample = 1;
            if (in_is_corner_flag) begin
                write_SRAM_fast = 1;
                x_addr_fast = curr_x;
                y_addr_fast = $signed(curr_y);
            end
        end
        default: begin
            next_state = IDLE;
            update_sample = 0;
            write_SRAM_fast = 0;
            x_addr_fast = 0;
            y_addr_fast = 0;
        end

    endcase
end

logic [4:0] pixel_index;  

always_comb begin : ADDRESS_LOGIC
    x_addr_gaus = 0;
    y_addr_gaus = 0;
    read_SRAM_gaus = 0;
    pixel_index = 0;
    unique case (current_state)

        // Center
        LOAD_CENTER: begin
            x_addr_gaus = $signed(curr_x);
            y_addr_gaus = $signed(curr_y);
            read_SRAM_gaus = 1;
        end

        // Circle neighbors
        LOAD_PIXEL_1: begin
            pixel_index = 0;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_2: begin
            pixel_index = 1;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_3: begin
            pixel_index = 2;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_4: begin
            pixel_index = 3;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_5: begin
            pixel_index = 4;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_6: begin
            pixel_index = 5;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_7: begin
            pixel_index = 6;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_8: begin
            pixel_index = 7;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_9: begin
            pixel_index = 8;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_10: begin
            pixel_index = 9;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_11: begin
            pixel_index = 10;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_12: begin
            pixel_index = 11;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_13: begin
            pixel_index = 12;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_14: begin
            pixel_index = 13;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_15: begin
            pixel_index = 14;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        LOAD_PIXEL_16: begin
            pixel_index = 15;
            x_addr_gaus = $signed(curr_x) + dx_lut[pixel_index];
            y_addr_gaus = $signed(curr_y) + dy_lut[pixel_index];
            read_SRAM_gaus = 1;
        end

        default: begin
            x_addr_gaus = '0;
            y_addr_gaus = '0;
            read_SRAM_gaus = 0;
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
// function automatic logic [7:0] abs_diff_compute(
//     input logic [7:0] pixel,
//     input logic [7:0] center
// );
//     logic signed [9:0] diff;
// begin
//     // Compute signed difference
//     diff = $signed({1'b0, pixel}) - $signed({1'b0, center});

//     // Take absolute value
//     if (diff < 0)
//         abs_diff_compute = -diff[7:0]; // truncate to 8 bits
//     else
//         abs_diff_compute = diff[7:0];
// end
// endfunction

always_ff @(posedge clk or negedge n_rst) begin
    if (!n_rst) begin
        for (int i = 0; i < 16; i++) begin
            buffer_output[i] <= 2'b00;
            center <= 8'b00000000;
        end
    end else begin
        for (int i = 0; i < 16; i++) begin
            buffer_output[i] <= next_buffer_output[i];
            center <= next_center;
        end
    end
end


always_comb begin : BUFFER_LOAD_LOGIC
    next_center = center;  // default: hold previous
    for (int i=0; i<16; i++) begin
        next_buffer_output[i] = buffer_output[i]; // default: hold previous
    end
    
    case (current_state)
        IDLE:begin
            for (int i = 0; i < 16; i++) begin
                next_buffer_output[i] = 2'b00;
            end

        end
        LOAD_PIXEL_1: begin
            next_center = input_pixel;
        end

        LOAD_PIXEL_9:  begin
            next_buffer_output[0]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_5:  begin
            next_buffer_output[8]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_13:  begin
            next_buffer_output[4]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_2:  begin
            next_buffer_output[12]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_3:  begin
            next_buffer_output[1]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_4:  begin
            next_buffer_output[2]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_6:  begin
            next_buffer_output[3]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_7:  begin
            next_buffer_output[5]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_8:  begin
            next_buffer_output[6]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_10:  begin
            next_buffer_output[7]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_11: begin
            next_buffer_output[9]  = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_12: begin
            next_buffer_output[10] = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_14: begin
            next_buffer_output[11] = fast_compare(input_pixel, center);
        end
        LOAD_PIXEL_16: begin
            next_buffer_output[13] = fast_compare(input_pixel, center);
        end
        DONE: begin
            next_buffer_output[15] = fast_compare(input_pixel, center);
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
        if (&bright_wrap[i +: 9])
            is_bright_corner = 1'b1;
        if (&dark_wrap[i +: 9])
            is_dark_corner = 1'b1;
    end

    in_is_corner_flag = is_bright_corner || is_dark_corner;
end

endmodule

