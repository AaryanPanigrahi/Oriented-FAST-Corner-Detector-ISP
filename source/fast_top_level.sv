`timescale 1ns / 10ps

module fast_top_level #(
    // parameters
    parameter X_MAX = 5,
    parameter Y_MAX = 5,
    parameter THRESHOLD = 20
) (
    input logic clk, n_rst,
    input logic [7:0] SRAM_in_gaus,
    input logic gaus_sample_flag, gaus_done,
    input logic new_trans, SRAM_in_fast,
    input logic [$clog2(X_MAX) - 1:0] max_x, max_y,

    output logic write_SRAM_fast, read_SRAM_gaus, read_SRAM_fast, write_SRAM_OUT,
    output logic [$clog2(X_MAX):0] x_addr_gaus, y_addr_gaus, x_addr_fast, y_addr_fast, x_addr_OUT, y_addr_OUT,
    output logic [23:0] SRAM_OUT_wdata
);


logic [$clog2(X_MAX)-1:0] current_x, current_y;
logic update_sample_tb, update_sample_tb1, update_sample_tb2, start, start_circle;
logic [$clog2(X_MAX):0] x_addr4_tb, y_addr4_tb, x_addr4_tb2, y_addr4_tb2;

assign update_sample_tb = update_sample_tb1 || update_sample_tb2;
assign x_addr_fast = x_addr4_tb | x_addr4_tb2;
assign y_addr_fast = y_addr4_tb | y_addr4_tb2;

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
    .fast_start(start),
    .circle_done_flag(update_sample_tb),
    .circle_start(start_circle)
);

pipelined_buffer_loader #(.THRESHOLD(THRESHOLD), .X_MAX(X_MAX), .Y_MAX(Y_MAX)) fast_compute (
    .clk(clk),
    .n_rst(n_rst),
    .curr_x({1'b0, current_x}),
    .curr_y({1'b0, current_y}),
    .input_pixel(SRAM_in_gaus),
    .start(start),
    .x_addr_gaus(x_addr_gaus),
    .y_addr_gaus(y_addr_gaus),
    .x_addr_fast(x_addr4_tb),
    .y_addr_fast(y_addr4_tb),
    .update_sample(update_sample_tb1),
    .read_SRAM_gaus(read_SRAM_gaus),
    .write_SRAM_fast(write_SRAM_fast)
);

draw_circle #(.X_MAX(X_MAX), .Y_MAX(Y_MAX)) draw_circle(
    .clk(clk),
    .n_rst(n_rst),
    .curr_x({1'b0, current_x}),
    .curr_y({1'b0, current_y}),
    .start(start_circle),
    .x_addr_OUT(x_addr_OUT),
    .y_addr_OUT(y_addr_OUT),
    .x_addr_fast(x_addr4_tb2),
    .y_addr_fast(y_addr4_tb2),
    .pink(SRAM_OUT_wdata),
    .update_pos(update_sample_tb2),
    .read_SRAM_fast(read_SRAM_fast),
    .SRAM_in_fast(SRAM_in_fast),
    .write_SRAM_OUT(write_SRAM_OUT)
);

endmodule

