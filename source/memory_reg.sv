`timescale 1ns / 10ps

module memory_reg #(
    parameter SIZE = 8,
    parameter RESET = 0
) (
    input logic clk, n_rst,
    input logic load_enable,
    input logic [SIZE - 1:0] parallel_in,
    output logic [SIZE - 1:0] parallel_out
);
    logic [SIZE - 1:0] parallel_out_next;

    always_ff @(posedge clk, negedge n_rst) begin : NEXT_STATE_LOGIC
        if (!n_rst) parallel_out <= RESET;
        else        parallel_out <= parallel_out_next;
    end

    always_comb begin : COMB_LOGIC
        if (load_enable)    parallel_out_next = parallel_in;
        else                parallel_out_next = parallel_out;
    end

endmodule
