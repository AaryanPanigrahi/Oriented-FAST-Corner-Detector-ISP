`timescale 1ns / 10ps

module AccumulatorControl (
    input logic clk, n_rst,
    input logic clear, start,
    output logic [3:0] src1, src2, dest,
    output logic [2:0] op,
    output logic ready
);

typedef enum bit [2:0] {
    IDLE = 3'd0,
    RESET = 3'd1,
    LOAD_P = 3'd2,  
    LOAD_K = 3'd3,
    MUL0 = 3'd4,
    SUM0 = 3'd5
} ACCU;

typedef enum bit [2:0] {
    NOP = 3'b000,
    COPY = 3'b001,
    LOAD1 = 3'b010,
    LOAD2 = 3'b011,
    ADD = 3'b100,
    SUB = 3'b101,
    MUL = 3'b110
} OPERATION;
ACCU state, nextState;

always_ff @(posedge clk, negedge n_rst) begin : State_Transition
    if (~n_rst) state <= IDLE;
    else state <= nextState;
end

always_comb begin : Accumulator_FSM
    nextState = IDLE;
    op = NOP; src1 = '0; src2 = '0; dest = '0; ready = 1'b0;
    case (state)
        IDLE: begin
            if (clear) nextState = RESET;
            else if (start) nextState = LOAD_P;
            else nextState = state;
            op = NOP;
            src1 = '0; src2 = '0; dest = '0;
            ready = 1'b1;
        end
        RESET: begin
            nextState = IDLE;
            op = SUB;
            src1 = '0; src2 = '0;
            dest = 4'd4;
            ready = 1'b0;
        end
        LOAD_P: begin
            nextState = LOAD_K;
            op = LOAD1;
            src1 = 0; src2 = '0;
            dest = 4'd1;
            ready = 1'b0;
        end
        LOAD_K: begin
            nextState = MUL0;
            op = LOAD2;
            src1 = '0; src2 = '0; 
            dest = 4'd2;
            ready = 1'b0;
        end
        MUL0: begin
            nextState = SUM0;
            op = MUL;
            src1 = 4'd1;
            src2 = 4'd2;
            dest = 4'd3;
            ready = 1'b0;
        end
        SUM0: begin
            nextState = IDLE;
            op = ADD;
            src1 = 4'd3;
            src2 = 4'd4;
            dest = 4'd4;
            ready = 1'b0;
        end
        default: begin
            nextState = IDLE;
            op = NOP;
            src1 = '0; src2 = '0; dest = '0;
            ready = 1'b0;
        end
    endcase
end

endmodule
