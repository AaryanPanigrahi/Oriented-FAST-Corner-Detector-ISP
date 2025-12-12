`timescale 1ns / 10ps

module fast_pixel_pos #(
    // parameters
) (     
    input logic clk, n_rst,
    input logic [7:0] SRAM_in,
    input logic start, new_trans,

    output logic write_SRAM4, read_SRAM2,
    output logic [8:0] x_addr, y_addr, x_addr4, y_addr4
);

logic signed [8:0] current_x, current_y;
logic update_sample_tb;

pixel_pos #()
    pos_inst (
    .clk(clk),
    .n_rst(n_rst),

    .update_pos(update_sample_tb),
    .new_trans(new_trans),
    .max_x(),
    .max_y(),
    .end_pos(),                    // unconnected OK
    .next_dir(),                   // unconnected OK
    .curr_x(current_x),
    .curr_y(current_y)
);


pipelined_buffer_loader #() fast_compute (
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
    .write_SRAM4(write_SRAM4)
);


endmodule

