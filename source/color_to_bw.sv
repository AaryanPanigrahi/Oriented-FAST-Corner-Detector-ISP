`timescale 1ns / 10ps

module color_to_bw #(
    parameter X_MAX = 400,
    parameter Y_MAX = 400,
    parameter PIXEL_DEPTH = 24
)(    
    input  logic clk, n_rst,
    input  logic start,
    input  logic [$clog2(X_MAX)-1:0] curr_x,
    input  logic [$clog2(Y_MAX)-1:0] curr_y,

    // SRAM Input
    output logic ren_img,
    output logic [$clog2(X_MAX):0] x_addr_img, 
    output logic [$clog2(Y_MAX):0] y_addr_img,
    input  logic [PIXEL_DEPTH-1:0] rdat_img,

    // SRAM Output
    output logic wen_bw,
    output logic [$clog2(X_MAX):0] x_addr_bw, 
    output logic [$clog2(Y_MAX):0] y_addr_bw,

    output logic [7:0] wdat_bw,

    // Control
    output logic bw_done,
    output logic update_pos
);

typedef enum logic [1:0] {
    IDLE,
    READ_PIXEL,
    WRITE_PIXEL,
    DONE
} state_t;

state_t current_state, next_state;

// Counter to track pixels processed
logic [$clog2(X_MAX*Y_MAX+1)-1:0] pixel_count;
logic [23:0] rdat_latched;

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        current_state <= IDLE;
        pixel_count   <= 0;
        rdat_latched <= 0;
    end else begin
        current_state <= next_state;
        rdat_latched <= rdat_img; // latch SRAM output
        if (current_state == WRITE_PIXEL)
            pixel_count <= pixel_count + 1;
        else if (current_state == IDLE)
            pixel_count <= 0;
    end
end

logic [10:0] sum;

always_comb begin
    // Default outputs
    next_state   = current_state;
    ren_img      = 1'b0;
    wen_bw     = 1'b0;
    bw_done      = 1'b0;
    update_pos   = 1'b0;
    x_addr_img   = curr_x;
    y_addr_img   = curr_y;
    x_addr_bw  = curr_x;
    y_addr_bw  = curr_y;

    wdat_bw    = 0;

    case (current_state)
        IDLE: begin
            if (start)
                next_state = READ_PIXEL;
        end

        READ_PIXEL: begin
            ren_img    = 1'b1;
            next_state = WRITE_PIXEL; // wait 1 cycle for SRAM read
        end

        WRITE_PIXEL: begin
            wen_bw    = 1'b1;
            sum = rdat_img[23:16] + rdat_img[15:8] + rdat_img[7:0];
            wdat_bw = (sum * 86) >> 8;
            //wdat_bw = (sum * 8'd86) >> 8;
            update_pos  = 1'b1; // signal to pixel_pos to advance

            if (pixel_count + 1 == X_MAX*Y_MAX)
                next_state = DONE;
            else
                next_state = READ_PIXEL;
        end

        DONE: begin
            bw_done   = 1'b1;
            next_state = IDLE;
        end
    endcase
end

endmodule
