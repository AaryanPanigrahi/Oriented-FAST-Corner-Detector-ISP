`timescale 1ns / 10ps

module param_controller #(
    parameter NUM_PARAMS = 8,
    parameter BIT_DEPTH = 8,
    parameter X_MAX = 400,
    parameter Y_MAX = 400
) (
    // Sync
    input logic clk, n_rst,

    // Image Params
    output logic [$clog2(NUM_PARAMS)-1:0] addr_params,
    output logic ren_params,
    input logic [BIT_DEPTH-1:0] rdat_params, 
    // Writing Done States
    output logic [$clog2(NUM_PARAMS)-1:0] addr_write_params,
    output logic wen_params,
    output logic [BIT_DEPTH-1:0] wdat_params,

    // Param Pins
    // IO
    output logic new_trans,
    input logic img_done,
    // Image Dim
    output logic [$clog2(X_MAX)-1:0] max_x,
    output logic [$clog2(Y_MAX)-1:0] max_y,
    // Gaussian Settings
    output logic [7:0] kernel_size,
    output logic [2:0] sigma
);
    ////    ////    ////    ////    ////    ////    ////    
    // Address Locations - STANDARDIZED
    localparam NEW_IMG_ADDR     = 0;
    localparam X_MAX_LOWER_ADDR = 1;
    localparam X_MAX_UPPER_ADDR = 2;
    localparam Y_MAX_LOWER_ADDR = 3;
    localparam Y_MAX_UPPER_ADDR = 4;
    localparam KERNEL_ADDR      = 5;
    localparam SIGMA_ADDR       = 6;
    localparam DONE_ADDR        = 7;
    localparam DEF_ADDR         = 0;
    ////    ////    ////    ////    ////    ////    ////    

    ////    ////    ////    ////    ////    ////    ////    
    // Register Layout
    logic [NUM_PARAMS-1:0][BIT_DEPTH-1:0] reg_bus_in;
    logic [NUM_PARAMS-1:0]                reg_bus_le;
    // Variable to go over all
    logic [$clog2(NUM_PARAMS):0] idx;

    // Memory Management    //
    // X Max
    logic [BIT_DEPTH-1:0] x_max_lower, x_max_upper;
    memory_reg #(.SIZE(BIT_DEPTH), .RESET(0)) X_MAX_LOWER_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[X_MAX_LOWER_ADDR][BIT_DEPTH-1:0]), .load_enable(reg_bus_le[X_MAX_LOWER_ADDR]),
                            .parallel_out(x_max_lower));

    memory_reg #(.SIZE(BIT_DEPTH), .RESET(0)) X_MAX_UPPER_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[X_MAX_UPPER_ADDR][BIT_DEPTH-1:0]), .load_enable(reg_bus_le[X_MAX_UPPER_ADDR]),
                            .parallel_out(x_max_upper));
    assign max_x = {x_max_upper, x_max_lower};

    // Y Max
    logic [BIT_DEPTH-1:0] y_max_lower, y_max_upper;
    memory_reg #(.SIZE(BIT_DEPTH), .RESET(0)) Y_MAX_LOWER_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[Y_MAX_LOWER_ADDR][BIT_DEPTH-1:0]), .load_enable(reg_bus_le[Y_MAX_LOWER_ADDR]),
                            .parallel_out(y_max_lower));

    memory_reg #(.SIZE(BIT_DEPTH), .RESET(0)) Y_MAX_UPPER_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[Y_MAX_UPPER_ADDR][BIT_DEPTH-1:0]), .load_enable(reg_bus_le[Y_MAX_UPPER_ADDR]),
                            .parallel_out(y_max_upper));
    assign max_y = {y_max_upper, y_max_lower};

    // Kernel Size
    memory_reg #(.SIZE(8), .RESET(0)) KERNEL_SIZE_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[KERNEL_ADDR][7:0]), .load_enable(reg_bus_le[KERNEL_ADDR]),
                            .parallel_out(kernel_size));

    // Sigma
    memory_reg #(.SIZE(3), .RESET(0)) SIGMA_MEM (.clk(clk), .n_rst(n_rst),
                            .parallel_in(reg_bus_in[SIGMA_ADDR][2:0]), .load_enable(reg_bus_le[SIGMA_ADDR]),
                            .parallel_out(sigma));
    ////    ////    ////    ////    ////    ////    ////  

    ////    ////    ////    ////    ////    ////    ////    
    // FSM for Writing
    typedef enum bit [3:0] {
        IDLE, CLEAR_DONE, CLEAR_NEW_TRANS, X_LOWER_SET, X_UPPER_SET, Y_LOWER_SET, Y_UPPER_SET, KERNEL_SET, SIGMA_SET, NEW_TRANS_SET, PROCESS_MODE, DONE_SET
    } param_state_t;

    param_state_t currState, nextState;
    ////    ////    ////    ////    ////    ////    ////    

    ////    ////    ////    ////    ////    ////    //// 
    always_ff @(posedge clk, negedge n_rst) begin   : CURR_STATE_LOGIC
        if (!n_rst) currState <= IDLE;
        else        currState <= nextState;
    end

    // Walking through FSM
    always_comb begin   : NEXT_STATE_LOGIC
        nextState = currState;

        // Usually Reading
        addr_params = DEF_ADDR;
        ren_params = 1;

        // Ideally no new_trans or write
        addr_write_params = DEF_ADDR;
        wen_params = 0;
        wdat_params = 0;

        new_trans = 0;

        // Initialize Array
        for (idx = 0; idx < NUM_PARAMS; idx++) begin
            reg_bus_in[idx][BIT_DEPTH-1:0]  = '0;
            reg_bus_le[idx]                 = 0;
        end

        // Next State Logic
        case (currState) 
            IDLE: begin
                // Reading New Img Data
                addr_params = NEW_IMG_ADDR;

                // If not empty
                if (rdat_params) nextState = CLEAR_DONE;
            end

            CLEAR_DONE: begin
                nextState = CLEAR_NEW_TRANS;

                // Clear Done output
                addr_write_params = DONE_ADDR;
                wen_params = 1;
                wdat_params = 0;    // clear
            end

            CLEAR_NEW_TRANS: begin
                nextState = X_LOWER_SET;

                // Clear New Trans input
                addr_write_params = NEW_IMG_ADDR;
                wen_params = 1;
                wdat_params = 0;    // clear

                // Start reading X_LOWER_SET data
                addr_params = X_MAX_LOWER_ADDR;
            end

            X_LOWER_SET: begin
                nextState = X_UPPER_SET;

                // Read 
                reg_bus_in[X_MAX_LOWER_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[X_MAX_LOWER_ADDR] = 1;

                // Start reading X_MAX_UPPER_ADDR data
                addr_params = X_MAX_UPPER_ADDR;
            end

            X_UPPER_SET: begin
                nextState = Y_LOWER_SET;

                // Read 
                reg_bus_in[X_MAX_UPPER_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[X_MAX_UPPER_ADDR] = 1;

                // Start reading Y_MAX_LOWER_ADDR data
                addr_params = Y_MAX_LOWER_ADDR;
            end

            Y_LOWER_SET: begin
                nextState = Y_UPPER_SET;

                // Read 
                reg_bus_in[Y_MAX_LOWER_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[Y_MAX_LOWER_ADDR] = 1;

                // Start reading Y_MAX_UPPER_ADDR data
                addr_params = Y_MAX_UPPER_ADDR;
            end

            Y_UPPER_SET: begin
                nextState = KERNEL_SET;

                // Read 
                reg_bus_in[Y_MAX_UPPER_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[Y_MAX_UPPER_ADDR] = 1;

                // Start reading KERNEL_ADDR data
                addr_params = KERNEL_ADDR;
            end

            KERNEL_SET: begin
                nextState = SIGMA_SET;

                // Read 
                reg_bus_in[KERNEL_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[KERNEL_ADDR] = 1;

                // Start reading KERNEL_ADDR data
                addr_params = SIGMA_ADDR;
            end

            SIGMA_SET: begin
                nextState = NEW_TRANS_SET;

                // Read 
                reg_bus_in[SIGMA_ADDR][BIT_DEPTH-1:0] = rdat_params;
                reg_bus_le[SIGMA_ADDR] = 1;
            end

            NEW_TRANS_SET: begin
                nextState = PROCESS_MODE;

                // Set new trans high for 1 cycle
                new_trans = 1;
            end

            PROCESS_MODE: begin
                // If img done processing
                if (img_done) nextState = DONE_SET;

                // SRAM IDLE
                ren_params = 0;
            end

            DONE_SET: begin
                nextState = IDLE;

                // Set Done
                addr_write_params = DONE_ADDR;
                wen_params = 1;
                wdat_params = 1;
            end

            default: nextState = IDLE;
        endcase
    end
    ////    ////    ////    ////    ////    ////    //// 

endmodule
