`timescale 1ns / 10ps

module draw_circle #(
    parameter int X_MAX = 10,
    parameter int Y_MAX = 10)
(
    input  logic clk, n_rst,
    input  logic signed [$clog2(X_MAX):0] curr_x, curr_y,
    input  logic start, SRAM_in_fast,
    output logic signed [$clog2(X_MAX):0] x_addr_OUT, y_addr_OUT, x_addr_fast, y_addr_fast,
    output logic read_SRAM_fast, update_pos, write_SRAM_OUT,
    output logic [23:0] pink
);

logic signed [3:0] dx [0:11] = '{  0,  1,  2,  2,  2,  1,  0, -1, -2, -2, -2, -1 };
logic signed [3:0] dy [0:11] = '{  2,  2,  1,  0, -1, -2, -2, -2, -1,  0,  1,  2 };



typedef enum logic [3:0] {
    IDLE,
    CHECK,
    LOADC,
    LOAD1,
    LOAD2,
    LOAD3,
    LOAD4,
    LOAD5,
    LOAD6,
    LOAD7,
    LOAD8,
    LOAD9,
    LOAD10,
    LOAD11,
    LOAD12
} state_t;

state_t state, next_state;

always_ff @(posedge clk or negedge n_rst) begin
    if (!n_rst)
        state <= IDLE;
    else
        state <= next_state;
end

always_comb begin
    next_state = state;
    read_SRAM_fast = 0;
    update_pos = 0;
    x_addr_fast = 0;
    y_addr_fast = 0;
    case (state)

        IDLE: begin
            if (start) begin
                next_state = CHECK;
                read_SRAM_fast = 1;
                x_addr_fast = curr_x;
                y_addr_fast = curr_y;
            end
        end
        CHECK: begin
            if (SRAM_in_fast)
                next_state = LOAD1;
            else begin
                next_state = IDLE;
                update_pos = 1;
            end
        end
        LOAD1:  next_state = LOAD2;
        LOAD2:  next_state = LOAD3;
        LOAD3:  next_state = LOAD4;
        LOAD4:  next_state = LOAD5;
        LOAD5:  next_state = LOAD6;
        LOAD6:  next_state = LOAD7;
        LOAD7:  next_state = LOAD8;
        LOAD8:  next_state = LOAD9;
        LOAD9:  next_state = LOAD10;
        LOAD10: next_state = LOAD11;
        LOAD11: next_state = LOAD12;
        LOAD12: begin
            next_state = IDLE;
            update_pos = 1;
        end
        default: next_state = IDLE;

    endcase
end

always_comb begin
    x_addr_OUT = curr_x;
    y_addr_OUT = curr_y;
    pink   = '0;
    write_SRAM_OUT = 0;

    case (state)
        CHECK:  begin
            if (SRAM_in_fast) begin
                x_addr_OUT = curr_x;
                y_addr_OUT = curr_y;
                pink = 24'hFFFF00;
                write_SRAM_OUT = 1;
            end
        end
        LOAD1:  begin x_addr_OUT = curr_x + dx[0];  y_addr_OUT = curr_y + dy[0];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD2:  begin x_addr_OUT = curr_x + dx[1];  y_addr_OUT = curr_y + dy[1];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD3:  begin x_addr_OUT = curr_x + dx[2];  y_addr_OUT = curr_y + dy[2];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD4:  begin x_addr_OUT = curr_x + dx[3];  y_addr_OUT = curr_y + dy[3];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD5:  begin x_addr_OUT = curr_x + dx[4];  y_addr_OUT = curr_y + dy[4];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD6:  begin x_addr_OUT = curr_x + dx[5];  y_addr_OUT = curr_y + dy[5];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD7:  begin x_addr_OUT = curr_x + dx[6];  y_addr_OUT = curr_y + dy[6];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD8:  begin x_addr_OUT = curr_x + dx[7];  y_addr_OUT = curr_y + dy[7];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD9:  begin x_addr_OUT = curr_x + dx[8];  y_addr_OUT = curr_y + dy[8];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD10: begin x_addr_OUT = curr_x + dx[9];  y_addr_OUT = curr_y + dy[9];  pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD11: begin x_addr_OUT = curr_x + dx[10]; y_addr_OUT = curr_y + dy[10]; pink = 24'hFF2090; write_SRAM_OUT = 1; end
        LOAD12: begin 
            x_addr_OUT = curr_x + dx[11]; 
            y_addr_OUT = curr_y + dy[11]; 
            pink = 24'hFF2090;
            write_SRAM_OUT = 1;
            end
        default: ;
    endcase
end

endmodule
