module ConvertBW #(
    parameter X_MAX = 200,
    parameter Y_MAX = 200,
    parameter PIXEL_DEPTH = 8
) (
    // Starting
    input logic clk, n_rst,
    input logic new_trans,
    output logic bw_done,

    // PIXEL POS
    input logic [$clog2(X_MAX) - 1:0] max_x,
    input logic [$clog2(Y_MAX) - 1:0] max_y,

    // SRAM Input
    output logic [$clog2(X_MAX):0] x_addr_img, 
    output logic [$clog2(Y_MAX):0] y_addr_img,
    output logic ren_img,
    input logic [PIXEL_DEPTH-1:0] rdat_img,

    // SRAM Output
    output logic [$clog2(X_MAX):0] x_addr_conv, 
    output logic [$clog2(Y_MAX):0] y_addr_conv,
    output logic wen_conv,
    output logic [PIXEL_DEPTH-1:0] wdat_conv
);

// Pixel Info
logic bw_complete, err;
logic [PIXEL_DEPTH-1:0] bw_pixel;
logic [1:0] next_dir;
logic end_pos, end_pos_latch;
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////   
// Control Signals
logic new_sample_ready;
logic new_sample_req;

////    ////    ////    ////    ////    ////    ////    ////    

typedef enum bit [1:0] {
    IDLE =  2'd0,
    COMPUTING = 2'd1,
    COMPLETE =  2'd2,
    FLAG =  2'd3
} BW_CONV;
BW_CONV bwState, nextState;

always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) bwState <= IDLE;
    else bwState <= nextState;
end

always_comb begin
    case (bwState)
        IDLE: begin
            if (new_trans) nextState = COMPUTING; // Begin computing
            else nextState = convState;
            
            bw_done = 1'b0;
        end
        COMPUTING: begin
            if (end_pos) nextState = COMPLETE; // Move to the last value
            else nextState = convState;


            bw_done = 1'b0;
        end
        COMPLETE: begin
            if (blur_complete) nextState = FLAG; 
            else nextState = convState;

            bw_done = 1'b0;
        end
        FLAG: begin
            nextState = IDLE;

            bw_done = 1'b1;
        end
        default: begin
            nextState = IDLE;

            bw_done = 1'b0;
        end

    endcase
end
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    //// 
always_ff @(posedge clk, negedge n_rst) begin
    if(~n_rst) begin 
        new_sample_req <= 1'b0;
        compAck <= 1'b0;
        end_pos_latch <= 1'b0;
    end
    else begin
        new_sample_req <= bw_complete;

        // end_pos_latch 
        if (end_pos) end_pos_latch <= 1'b1;
        else if (bw_done) end_pos_latch <= 1'b0;

        // compAck
        if (clear_signal) begin 
            compAck <= 1'b1;
        end
        if (comp_clear_flag) compAck <= 1'b0;
    end
end
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////   
pixel_pos #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .MODE(0)) image_pos (
    .clk(clk), .n_rst(n_rst),
    .new_trans(new_trans),
    .update_pos(new_sample_req),
    .max_x(max_x),          
    .max_y(max_y),         
    .curr_x(curr_x),
    .curr_y(curr_y),
    .end_pos(end_pos),
    .next_dir(next_dir));
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////'
ComputeBW #(.MAX_KERNEL(MAX_KERNEL)) gray_pixel (
    .clk(clk),
    .n_rst(n_rst),
    // Telemetry
    .start((new_sample_ready && _in_progress)),
    .done(blur_complete),

    // Params
    .kernel_size(kernel_size),

    // Memory Input
    .kernel(kernel),
    .input_matrix(input_matrix),

    // Other Control
    .clear(compAck),
    .clear_signal(clear_signal),
    .clear_flag(comp_clear_flag),
    .blurred_pixel(blurred_pixel));
////    ////    ////    ////    ////    ////    ////    ////
endmodule