/*
name: sram_tb_model
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

`timescale 1ns / 10ps

module sram_model #(
    parameter ADDR_WIDTH = 18,
    parameter DATA_WIDTH = 32,
    parameter RAM_IS_SYNCHRONOUS = 1,
    parameter DUAL = 0
)(
    input logic ramclk,                     // Acts as en/dis (if async) - no reset
    input logic [ADDR_WIDTH-1:0] addr,
    input logic [ADDR_WIDTH-1:0] addr_write,
    input logic wen, ren,
    input logic [DATA_WIDTH-1:0] wdat,
    output logic [DATA_WIDTH-1:0] rdat
);

bit [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH]; 

////    ////    ////    ////    ////    ////    ////    ////    ////    //// 
// WRITE - if mode then uses addr_write
always_ff @(posedge ramclk) begin : WRITE
    if (wen) begin
        if (DUAL)   ram[addr_write] <= wdat;
        else        ram[addr]       <= wdat;
    end
end

// READ - always uses addr
generate
    if (RAM_IS_SYNCHRONOUS) begin : READ_SYNC
        always_ff @(posedge ramclk) begin : READ_SYNC_FF
            if (ren) begin
                if (addr == {ADDR_WIDTH{1'b1}})   // check if address is all ones (max value)
                    rdat <= '0;                  // return 0
                // RAW handler - write addr and read addr same
                else if (DUAL && (addr_write == addr) && wen)
                    rdat <= wdat;
                else
                    rdat <= ram[addr];
            end
            else begin
                rdat <= 'x;
            end
        end
    end
    else begin : READ_ASYNC
        assign rdat = (ren) ? ((addr == {ADDR_WIDTH{1'b1}}) ? '0 : ram[addr]) : 'x;
    end
endgenerate

////    ////    ////    ////    ////    ////    ////    ////    ////    ////   

////    ////    ////    ////    ////    ////    ////    ////    ////    ////    
// Helper Funtions
function rmh(input string fname);
    $readmemh(fname, ram);    
endfunction
////    ////    ////    ////    ////    ////    ////    ////    ////    ////    

endmodule
