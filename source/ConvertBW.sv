module ConvertBW #(
    parameter X_MAX = 200,
    parameter Y_MAX = 200,
    parameter PIXEL_DEPTH = 24
) (
    // Starting
    input logic clk, n_rst,
    input logic new_trans, start,
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
    output logic [$clog2(X_MAX):0] x_addr_bw, 
    output logic [$clog2(Y_MAX):0] y_addr_bw,
    output logic wen_bw,
    output logic [7:0] wdat_bw
);

    logic [$clog2(X_MAX)-1:0] curr_x;
    logic [$clog2(Y_MAX)-1:0] curr_y;
    logic update_pos;

////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////   
pixel_pos #(.X_MAX(X_MAX), .Y_MAX(Y_MAX), .MODE(0)) image_pos (
    .clk(clk), .n_rst(n_rst),
    .new_trans(new_trans),
    .update_pos(update_pos),
    .max_x(max_x),          
    .max_y(max_y),         
    .curr_x(curr_x),
    .curr_y(curr_y),
    .end_pos(),
    .next_dir());
////    ////    ////    ////    ////    ////    ////    ////    

////    ////    ////    ////    ////    ////    ////    ////'
color_to_bw #(.X_MAX(X_MAX),.Y_MAX(Y_MAX),.PIXEL_DEPTH(PIXEL_DEPTH)) bw_bw(
    .clk(clk),
    .n_rst(n_rst),
    .start(start),
    .update_pos(update_pos),
    .curr_x(curr_x),
    .curr_y(curr_y),
    .x_addr_img(x_addr_img),
    .y_addr_img(y_addr_img),
    .ren_img(ren_img),
    .rdat_img(rdat_img),
    .x_addr_bw(x_addr_bw),
    .y_addr_bw(y_addr_bw),
    .wen_bw(wen_bw),
    .wdat_bw(wdat_bw),
    .bw_done(bw_done)
);


////    ////    ////    ////    ////    ////    ////    ////
endmodule