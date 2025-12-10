`timescale 1ns / 10ps

module fast_top_level #(
    // parameters
    parameter X_MAX = 5,
    parameter Y_MAX = 5,
    parameter THRESHOLD = 20
) (
    input logic clk, n_rst,
    input logic [7:0] SRAM_in,
    input logic gaus_sample_flag, gaus_done,
    input logic new_trans,
    input logic [$clog2(X_MAX) - 1:0] max_x, max_y,

    output logic write_SRAM4, read_SRAM2,
    output logic [$clog2(X_MAX):0] x_addr, y_addr, x_addr4, y_addr4,
    output logic [11:0] corner_score
);

logic [$clog2(X_MAX):0] current_x, current_y;
logic update_sample_tb, start;

pixel_pos #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .MODE(1)) pos_inst (
    .clk(clk),
    .n_rst(n_rst),

    .update_pos(update_sample_tb),
    .new_trans(new_trans),
    .max_x(max_x),
    .max_y(max_y),
    .end_pos(),                    // unconnected OK
    .next_dir(),                   // unconnected OK
    .curr_x(current_x),
    .curr_y(current_y)
);

fast_controller #(.WIDTH(X_MAX)) fast_controller(
    .clk(clk),
    .n_rst(n_rst),
    .gaus_sample_flag(gaus_sample_flag),
    .gaus_done(gaus_done),
    .fast_done_flag(update_sample_tb),
    .fast_start(start)
);

pipelined_buffer_loader #(.THRESHOLD(THRESHOLD), .X_MAX(X_MAX), .Y_MAX(Y_MAX)) fast_compute (
    .clk(clk),
    .n_rst(n_rst),
    .curr_x(current_x),
    .curr_y(current_y),
    .input_pixel(SRAM_in),
    .start(start),
    .x_addr(x_addr),
    .y_addr(y_addr),
    .x_addr4(x_addr4),
    .y_addr4(y_addr4),
    .update_sample(update_sample_tb),
    .read_SRAM2(read_SRAM2),
    .write_SRAM4(write_SRAM4),
    .corner_score(corner_score)
);



endmodule

