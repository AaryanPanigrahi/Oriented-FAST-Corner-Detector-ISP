`timescale 1ns / 10ps

module pixel_pos #(
    parameter X_MAX = 5,
    parameter Y_MAX = 5,
    parameter MODE = 0
) (
    input logic clk, n_rst,

    input logic update_pos, new_trans,
    input logic [$clog2(X_MAX) - 1:0] max_x,
    input logic [$clog2(Y_MAX) - 1:0] max_y,
    output logic end_pos,
    output logic [1:0] next_dir,
    output logic [$clog2(X_MAX) - 1:0] curr_x, 
    output logic [$clog2(Y_MAX) - 1:0] curr_y
);

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    
    // Previous Value updates
    logic rollover_flag, rollover_flag_prev, rollover_flag_prev_exp;
    logic wrap_flag, wrap_flag_prev, wrap_flag_prev_exp;

    always_ff @(posedge clk, negedge n_rst) begin : UPDATE_PREV
        if (!n_rst) begin
            rollover_flag_prev  <= 0;
            wrap_flag_prev      <= 0;
        end

        else begin
            rollover_flag_prev   <= rollover_flag_prev_exp;
            wrap_flag_prev       <= wrap_flag_prev_exp;
        end
    end

    always_comb begin : UPDATE_PREV_EXP
        rollover_flag_prev_exp  = rollover_flag_prev;
        wrap_flag_prev_exp      = wrap_flag_prev;

        if (update_pos) begin
            rollover_flag_prev_exp  = rollover_flag;
            wrap_flag_prev_exp      = wrap_flag;
        end
    end

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    logic new_trans_prev, new_trans_prev_exp, new_trans_info;
    assign new_trans_info = new_trans || new_trans_prev;

    always_ff @(posedge clk, negedge n_rst) begin : UPDATE_TRANS_PREV
        if (!n_rst) 
            new_trans_prev  <= 0;

        else
            new_trans_prev  <= (new_trans || new_trans_prev_exp);
    end

    always_comb begin : UPDATE_TRANS_PREV_EXP
        new_trans_prev_exp = new_trans_prev;

        if (update_pos)
            new_trans_prev_exp = new_trans;
    end

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////  
    logic new_flag;
    assign new_flag = wrap_flag || rollover_flag;

    logic y_update_flag;
    logic y_update_flag_keep;

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst)
            y_update_flag_keep <= 0;
        else
            y_update_flag_keep <= y_update_flag;
    end

        always_comb begin : FLAG_INFO
        y_update_flag = y_update_flag_keep;

        if (new_trans_info)
            y_update_flag = 0;
        else if (!y_update_flag_keep && new_flag && update_pos)
            y_update_flag = 1;
        else if (y_update_flag_keep && update_pos)
            y_update_flag = 0;
    end

    logic y_update, x_update;

    always_comb begin : MODULE_UPDATES
        y_update = update_pos && (y_update_flag);
        x_update = update_pos && (!y_update_flag || new_trans);
    end
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    //// 

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    logic [$clog2(X_MAX) - 1:0] max_x_eff;
    logic [$clog2(Y_MAX) - 1:0] max_y_eff;

    assign max_x_eff = max_x - 1;
    assign max_y_eff = max_y - 1;
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    //// 
    logic corr_clear;

    assign corr_clear = new_trans || (end_pos && update_pos); 
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    //// 

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    //// 
    logic end_x, end_y;

    always_comb begin : END_DATA
        // If odd or normal sweep
        if (MODE || (max_y % 2))
            end_x = (curr_x == max_x_eff);
        // If Even
        else 
            end_x = (curr_x == 0);

        // End Of Y
        end_y = (max_y_eff == curr_y);

        end_pos = end_x && end_y;
    end

    logic x_dir, y_dir;
    logic dir_reg;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) dir_reg <= 1'b0;
        else if (rollover_flag) dir_reg <= 1'b0;
        else if (wrap_flag) dir_reg <= 1'b1;
    end

    always_comb begin : DIRECTION_INFO
        // If Normal
        if (MODE)
            next_dir = {wrap_flag, 1'b0};

        // If Snake
        else begin
            y_dir = new_flag && !y_update_flag_keep && !new_trans_prev;
            x_dir = (wrap_flag || dir_reg) && !(rollover_flag);

            next_dir = {y_dir, x_dir};
        end
    end
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    localparam X_MODE = (MODE) ? 2'd0 : 2'd2;      // UP-DOWN
    localparam Y_MODE = 2'd0;                      // COUNT-UP

    flex_counter_dir #(.SIZE($clog2(X_MAX))) X_CORR 
                            (.clk(clk), .n_rst(n_rst),
                            .count_enable(x_update), .wrap_val(max_x_eff), .mode(X_MODE), .clear(corr_clear || (MODE && end_x && update_pos)),
                            .count_out(curr_x), .wrap_flag(wrap_flag), .rollover_flag(rollover_flag));

    flex_counter_dir #(.SIZE($clog2(Y_MAX))) Y_CORR 
                            (.clk(clk), .n_rst(n_rst),
                            .count_enable(y_update), .wrap_val(max_y_eff), .mode(Y_MODE), .clear(corr_clear),
                            .count_out(curr_y), .wrap_flag(), .rollover_flag());
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
endmodule