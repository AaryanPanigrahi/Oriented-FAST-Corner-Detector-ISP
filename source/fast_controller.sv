`timescale 1ns / 10ps

module fast_controller #(
    parameter int WIDTH = 400
)(
    input  logic clk,
    input  logic n_rst,

    input  logic gaus_sample_flag,  // Gaussian pulse
    input  logic gaus_done,         // Gaussian done
    input  logic fast_done_flag,    // FAST unit done
    input  logic circle_done_flag,

    output logic fast_start, circle_start, done          // Trigger FAST
);

typedef enum logic [2:0] {
    S_INIT_WAIT,
    S_FAST_RUN,
    S_WAIT_GAUS,
    S_FAST_RUN_AFTER,
    S_FINAL_FAST,
    S_CIRCLE,
    S_DONE
} state_t;

state_t current_state, next_state;

// Counters
logic [$clog2(WIDTH*3+1)-1:0] gaus_count_ff, gaus_count_next;
logic [$clog2(WIDTH)+1:0] fast_count_ff, fast_count_next;
logic [$clog2(WIDTH * WIDTH):0] circle_count_ff, circle_count_next;

// FSM sequential update
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        current_state <= S_INIT_WAIT;
        gaus_count_ff <= 0;
        fast_count_ff <= 0;
        circle_count_ff <= 0;
    end else begin
        current_state <= next_state;
        gaus_count_ff <= gaus_count_next;
        fast_count_ff <= fast_count_next;
        circle_count_ff <= circle_count_next;
        // fast_start assigned in combinational block
    end
end

// FSM combinational
always_comb begin
    next_state      = current_state;
    gaus_count_next = gaus_count_ff;
    fast_count_next = fast_count_ff;
    circle_count_next = circle_count_ff;

    fast_start      = 1'b0;
    circle_start = 0;
    done = 0;

    gaus_count_next = gaus_count_ff;
    if (gaus_sample_flag)
        gaus_count_next = gaus_count_ff + 1;

    case(current_state)
        S_INIT_WAIT: begin

            // Example transition (adjust logic yourself)
            if (gaus_count_ff >= 3*WIDTH) begin
                next_state      = S_FAST_RUN;
                gaus_count_next = 0;
                fast_count_next = 0;
            end
        end
        
        S_FAST_RUN: begin
            fast_start = 1'b1;
            if (fast_done_flag)
                fast_count_next = fast_count_ff + 1;
            if (fast_count_ff >= WIDTH) begin
                fast_count_next = 0;
                fast_start = 0;
                next_state = S_WAIT_GAUS; // or S_FINAL_FAST depending on gaus_done
            end
        end

        S_WAIT_GAUS: begin
            fast_start = 0;
            if (gaus_count_next >= WIDTH) begin
                gaus_count_next = 0;
                if (gaus_done)
                    next_state = S_FINAL_FAST;
                else
                    next_state = S_FAST_RUN_AFTER; // or S_FINAL_FAST depending on gaus_done
            end
        end

        S_FAST_RUN_AFTER: begin
            fast_start = 1'b1;
            if (fast_done_flag)
                fast_count_next = fast_count_ff + 1;
            if (fast_count_ff >= WIDTH) begin
                fast_count_next = 0;
                fast_start = 0;
                next_state = S_WAIT_GAUS;
            end
        end

        S_FINAL_FAST: begin
            fast_start = 1'b1;
            if (fast_done_flag)
                fast_count_next = fast_count_ff + 1;
            if (fast_count_ff >= 3*WIDTH - 1) begin
                fast_count_next = 0;
                next_state = S_CIRCLE;
            end
        end

        S_CIRCLE: begin
            circle_start = 1;
            if (circle_done_flag)
                circle_count_next = circle_count_ff + 1;
            if (circle_count_ff >= WIDTH * WIDTH - 1) begin
                circle_count_next = 0;
                next_state = S_DONE;
            end
        end

        S_DONE: begin
            fast_start = 1'b0;
            circle_start = 0;
            done = 1;
        end
    endcase
end

endmodule
