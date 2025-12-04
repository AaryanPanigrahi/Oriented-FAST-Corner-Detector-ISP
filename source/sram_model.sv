/*
name: sram_model
Description: 
- Single port ram model for TB
- No implementation of multi-cycle access
- Seperate wires for input and ouput
- By default synchronous
- Dead simple, no timing, no banks :(

Author: Spencer Bowles
Adapted: Aaryan Panigrahi
Date: 11/18/2025
*/

module sram_model #(
    parameter ADDR_WIDTH = 18,
    parameter DATA_WIDTH = 32,
    parameter RAM_IS_SYNCHRONOUS = 1
)(
    input logic ramclk,                     // Acts as en/dis (if async) - no reset
    input logic [ADDR_WIDTH-1:0] addr,
    input logic wen, ren,
    input logic [DATA_WIDTH-1:0] wdat,
    output logic [DATA_WIDTH-1:0] rdat
);

bit [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH]; 

////    ////    ////    ////    ////    ////    ////    ////    ////    //// 
// WRITE
generate
    if (RAM_IS_SYNCHRONOUS)
        always_ff @(posedge ramclk) begin : WRITE_SYNC
            if (wen) ram[addr] <= wdat;
        end
    else 
        if (wen) assign ram[addr] = wdat;
endgenerate

// READ
generate
    if (RAM_IS_SYNCHRONOUS)
        always_ff @(posedge ramclk) begin : READ_SYNC
            rdat <= (ren) ? ram[addr] : 'x;
        end
    else
        assign rdat = (ren) ? ram[addr] : 'x;
endgenerate
////    ////    ////    ////    ////    ////    ////    ////    ////    ////   

////    ////    ////    ////    ////    ////    ////    ////    ////    ////    
// Helper Funtions
function rmh(input string fname);
    $readmemh(fname, ram);    
endfunction

parameter IMG_COLOR_DEPTH = 8;
parameter IMG_COLOR_CHANNELS = 1;                                   // only supports 1 channel right now
localparam IMG_PX_PER_LINE = DATA_WIDTH / IMG_COLOR_DEPTH;          // single channel

function memdump_img(input string fname, input int xdim, ydim);
    int line_idx, px_in_line_idx;
    bit [IMG_COLOR_DEPTH-1:0] out;  
    for (int y = 0; y < ydim; y++) begin
        for (int x = 0; x < xdim; x++) begin
            line_idx = (y * xdim + x) / IMG_PX_PER_LINE;
            px_in_line_idx = (y * xdim + x) % IMG_PX_PER_LINE;
            out = ram[line_idx][IMG_PX_PER_LINE * px_in_line_idx +: IMG_PX_PER_LINE];
            $display("%d %d %x", x, y, out);
        end    
    end
endfunction
////    ////    ////    ////    ////    ////    ////    ////    ////    ////    

endmodule
