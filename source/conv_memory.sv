`timescale 1ns / 10ps

module conv_memory #(
    parameter MAX_KERNAL = 31,
    parameter X_MAX = 60,
    parameter Y_MAX = 60,
    parameter PIXEL_DEPTH = 8
) (
    // Sync
    input logic clk, n_rst,

    // getting from image SRAM
    output logic [$clog2(X_MAX):0] x_addr_img,
    output logic [$clog2(Y_MAX):0] y_addr_img,
    output logic ren_img,
    input logic [PIXEL_DEPTH-1:0] rdat_img,

    // getting from img_param SRAM
    input logic [7:0] kernel_size,

    // pixel_pos.sv
    input logic [1:0] next_dir,
    input logic [$clog2(X_MAX) - 1:0] curr_x,
    input logic [$clog2(Y_MAX) - 1:0] curr_y,

    // from gaussian conv
    input logic new_sample_req,
    input logic new_trans,

    // to gaussian conv
    output logic new_sample_ready,
    output logic [MAX_KERNAL-1:0][MAX_KERNAL-1:0][PIXEL_DEPTH - 1:0] working_memory 
);
    ////    ////    ////    ////    ////    ////    
    // Register Access (k + 2)x(k + 1) sized
    logic [MAX_KERNAL+1:0][MAX_KERNAL:0][PIXEL_DEPTH - 1:0] reg_bus_out;
    logic [MAX_KERNAL+1:0][MAX_KERNAL:0]                    reg_bus_le;
    logic [MAX_KERNAL+1:0][MAX_KERNAL:0][PIXEL_DEPTH - 1:0] reg_bus_in;

    // Direction Params
    localparam RIGHT    = 2'b00;
    localparam LEFT     = 2'b01;
    localparam DOWN     = 2'b10;
    localparam DOWN2    = 2'b11;
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    
    // Output Reg Mapping
    int idx_x;
    int idx_y;

    always_ff @(posedge clk, negedge n_rst) begin : OUTPUT_MAPPING
        if (!n_rst) begin
            for (idx_x = 0; idx_x < MAX_KERNAL; idx_x++) begin
                    for (idx_y = 0; idx_y < MAX_KERNAL; idx_y++) begin
                        working_memory[idx_x][idx_y][PIXEL_DEPTH - 1:0] <= 0;
                    end
            end
        end
        
        else begin
            if (new_trans) begin
                for (idx_x = 0; idx_x < MAX_KERNAL; idx_x++) begin
                    for (idx_y = 0; idx_y < MAX_KERNAL; idx_y++) begin
                        working_memory[idx_x][idx_y][PIXEL_DEPTH - 1:0] <= 0;
                    end
                end
            end

            else if (new_sample_req) begin
                for (idx_x = 0; idx_x < MAX_KERNAL; idx_x++) begin
                    for (idx_y = 0; idx_y < MAX_KERNAL; idx_y++) begin
                        // Registers have 1 extra on left and right
                        working_memory[idx_x][idx_y][PIXEL_DEPTH - 1:0] <= reg_bus_out[idx_x+1][idx_y][PIXEL_DEPTH - 1:0];
                    end
                end
            end
        end
    end
    ////    ////    ////    ////    ////    ////    

    ////    ////    ////    ////    ////    ////    
    // Generate the Memory Mapping (one more than kernal size)
    generate
        genvar idx_x2, idx_y2;

        // Registers have 1 extra on left and right
        for (idx_x2 = 0; idx_x2 <= MAX_KERNAL + 1; idx_x2++) begin
            // Registers have 1 extra at bottom
            for (idx_y2 = 0; idx_y2 <= MAX_KERNAL; idx_y2++) begin
                memory_reg #(.SIZE(PIXEL_DEPTH), .RESET(0)) MEMORY_ (.clk(clk), .n_rst(n_rst),
                                .load_enable(reg_bus_le[idx_x2][idx_y2]), .parallel_in(reg_bus_in[idx_x2][idx_y2][7:0]),
                                .parallel_out(reg_bus_out[idx_x2][idx_y2][7:0]));
            end
        end
    endgenerate
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////
    localparam COUNT_DOWN = 2'b00;

    logic [7:0]    pipeline_count, pipeline_count_prev;
    logic count_enable, count_clear;
    logic wrap_flag;

    flex_counter_dir #(
        .SIZE(8)
    ) dut (
        .clk           (clk),
        .n_rst         (n_rst),
        .clear         (count_clear),
        .count_enable  (count_enable),
        .wrap_val      (kernel_size),
        .mode          (COUNT_DOWN),
        .count_out     (pipeline_count),
        .rollover_flag(),
        .wrap_flag (wrap_flag)
    );

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) pipeline_count_prev <= 0;
        else pipeline_count_prev <= pipeline_count;
    end
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////
    logic first_trans_flag, first_trans_flag_keep, first_trans_flag_prev;

    logic first_end_pos;
    logic [$clog2(MAX_KERNAL) - 1:0] first_x_addr_curr, first_y_addr_curr, first_x_addr_prev, first_y_addr_prev;

    pixel_pos #(.X_MAX(MAX_KERNAL), .Y_MAX(MAX_KERNAL)) FIRST_TRANS_CORR (
        .clk(clk),
        .n_rst(n_rst),
        .update_pos(first_trans_flag_keep),
        .new_trans(new_trans),
        .max_x(kernel_size),
        .max_y(kernel_size),
        .end_pos(first_end_pos),
        .next_dir(),
        .curr_x(first_x_addr_curr),
        .curr_y(first_y_addr_curr)
    );

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) first_trans_flag <= 0;
        else first_trans_flag <= first_trans_flag_keep || new_trans || first_trans_flag_prev;
    end

    always_comb begin
        first_trans_flag_keep = first_trans_flag;

        if (first_end_pos)
            first_trans_flag_keep = 0;
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) first_trans_flag_prev  <= 0;
        else first_trans_flag_prev <= first_trans_flag_keep;
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            first_x_addr_prev <= '0;
            first_y_addr_prev <= '0;
        end

        else begin
            first_x_addr_prev <= first_x_addr_curr;
            first_y_addr_prev <= first_y_addr_curr;
        end
    end
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////
    // Latch on to final count - clear when new req
    logic new_sample_ready_int, new_sample_ready_w;       // Wires

    always_ff @(posedge clk, negedge n_rst) begin : SAMPLE_READY_FF
        if (!n_rst) begin
            new_sample_ready_int    <= 0;
            new_sample_ready        <= 0;
        end
        
        // One after rollover flag
        else begin
            new_sample_ready_int    <= new_sample_ready_w && !new_sample_req;
            new_sample_ready        <= new_sample_ready_int;
        end
    end

    logic new_sample_req_prev, new_sample_req_info;
    assign new_sample_req_info = new_sample_req_prev || new_sample_req;

    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) new_sample_req_prev <= 0;
        else        new_sample_req_prev <= new_sample_req;
    end


    always_comb begin : NEW_SAMPLE_TRACKER
        new_sample_ready_w  = wrap_flag && !first_trans_flag;

        if (new_sample_req_info) begin
            new_sample_ready_w = 0;
        end
    end
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////
    always_comb begin : COUNTER_LOGIC
        // Init
        count_enable = 0;
        count_clear = !n_rst || (first_trans_flag && !first_trans_flag_prev);

        // When Sample Ready - ask for a new sample
        if (new_sample_req) begin
            count_enable = 1;
            count_clear = 1;
        end

        // When sample isn't ready
        else if (!wrap_flag) begin
            count_enable = 1;
        end
    end
    ////    ////    ////    ////    ////    ////  

    ////    ////    ////    ////    ////    ////
    // Get SRAM information
    // Image Information Extraction (Prediction)
    always_comb begin : ADDR_LOGIC
        ren_img = 1;            // Always on

        // Image Init
        x_addr_img = '0;
        y_addr_img = '0;

        if (first_trans_flag) begin
            x_addr_img = first_x_addr_curr;
            y_addr_img = first_y_addr_curr;
        end

        else begin
            if (next_dir == RIGHT) begin
                x_addr_img = curr_x + kernel_size;
                y_addr_img = curr_y + pipeline_count;
            end

            else if (next_dir == LEFT) begin
                x_addr_img = curr_x - 1;
                y_addr_img = curr_y + pipeline_count;
            end 

            else if (next_dir == DOWN || next_dir == DOWN2) begin
                x_addr_img = curr_x + pipeline_count;
                y_addr_img = curr_y + kernel_size;
            end
        end
    end

    logic sample_updater, sample_updater_int;
    always_ff @(posedge clk, negedge n_rst) begin
        if (!n_rst) begin
            sample_updater_int      <= 1;
            sample_updater          <= 1;

        end

        else begin
            sample_updater_int      <= !new_sample_ready_w;
            sample_updater          <= (sample_updater_int && !new_sample_ready_int && !first_trans_flag_prev);
        end
    end
    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////
    // Output Reg Mapping
    int idx_x3, idx_y3;

    always_comb begin
        // Fill it with 0s - Start
        for (idx_x3 = 0; idx_x3 <= MAX_KERNAL + 1; idx_x3++) begin
            for (idx_y3 = 0; idx_y3 <= MAX_KERNAL; idx_y3++) begin
                reg_bus_in[idx_x3][idx_y3][PIXEL_DEPTH - 1:0]   = '0;
                reg_bus_le[idx_x3][idx_y3]                      = 0;
            end
        end

        // If first transaction - fill complete array
        if (first_trans_flag) begin
            reg_bus_in[first_x_addr_prev + 1][first_y_addr_prev][PIXEL_DEPTH - 1:0]    = rdat_img;
            reg_bus_le[first_x_addr_prev + 1][first_y_addr_prev]                       = 1;
        end
        
        // If not reached end of sample - fill 1 sample prev (rdat takes a sample to load)
        else if (sample_updater) begin
            if (next_dir == RIGHT) begin
                reg_bus_in[kernel_size + 1][pipeline_count_prev][PIXEL_DEPTH - 1:0]    = rdat_img;
                reg_bus_le[kernel_size + 1][pipeline_count_prev]                       = 1;
            end

            else if (next_dir == LEFT) begin
                reg_bus_in[0][pipeline_count_prev][PIXEL_DEPTH - 1:0]  = rdat_img;
                reg_bus_le[0][pipeline_count_prev]                     = 1;
            end

            else if (next_dir == DOWN || next_dir == DOWN2) begin
                reg_bus_in[pipeline_count_prev + 1][kernel_size][PIXEL_DEPTH - 1:0]    = rdat_img;
                reg_bus_le[pipeline_count_prev + 1][kernel_size]                       = 1;
            end
        end

        // Shifting Out Values - synced by new_sample_req
        else if (new_sample_req) begin : SHIFTING_LOGIC
            for (idx_x3 = 0; idx_x3 < MAX_KERNAL; idx_x3++) begin
                for (idx_y3 = 0; idx_y3 < MAX_KERNAL; idx_y3++) begin
                    // Moving Right
                    if (next_dir == RIGHT)
                        reg_bus_in[idx_x3+1][idx_y3][PIXEL_DEPTH-1:0] = reg_bus_out[idx_x3+2][idx_y3][PIXEL_DEPTH-1:0];

                    // Moving Left
                    else if (next_dir == LEFT)
                        reg_bus_in[idx_x3+1][idx_y3][PIXEL_DEPTH-1:0] = reg_bus_out[idx_x3][idx_y3][PIXEL_DEPTH-1:0];

                    // Moving Down
                    else if (next_dir == DOWN || next_dir == DOWN2)
                        reg_bus_in[idx_x3+1][idx_y3][PIXEL_DEPTH-1:0] = reg_bus_out[idx_x3+1][idx_y3+1][PIXEL_DEPTH-1:0];

                    // Update all Load enables
                    reg_bus_le[idx_x3+1][idx_y3] = 1;
                end
            end
        end
    end
    ////    ////    ////    ////    ////    ////

endmodule
