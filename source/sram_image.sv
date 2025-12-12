`timescale 1ns / 10ps

module sram_image #(
    PIXEL_DEPTH = 8,
    X_MAX = 5,
    Y_MAX = 5,
    DUAL = 0
) (
    input logic ramclk,
    input logic signed [$clog2(X_MAX):0] x_addr,
    input logic signed [$clog2(Y_MAX):0] y_addr,
    input logic signed [$clog2(X_MAX):0] x_addr_write,
    input logic signed [$clog2(Y_MAX):0] y_addr_write,
    input logic wen, ren,
    input logic [PIXEL_DEPTH-1:0] wdat,
    output logic [PIXEL_DEPTH-1:0] rdat
);
    localparam ADDR_WIDTH = $clog2(X_MAX * Y_MAX);
    localparam WORD_WIDTH = 32;                                   // SRAM word size
    localparam IMG_PX_PER_LINE = WORD_WIDTH / PIXEL_DEPTH;        // Pixels per 32 bit word

    localparam Y_MAX_EFF = Y_MAX - 1;
    localparam X_MAX_EFF = X_MAX - 1;

    logic [$clog2(X_MAX):0] x_addr_prev;
    logic [$clog2(Y_MAX):0] y_addr_prev;

    logic addr_oob;
    // Address Flip Flops
    always_ff @(posedge ramclk) begin
        x_addr_prev <= x_addr;
        y_addr_prev <= y_addr;
    end
    assign addr_oob = (x_addr_prev > X_MAX_EFF) || (y_addr_prev > Y_MAX_EFF);

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    // Map 1D SRAM as 2D SRAM
    logic [ADDR_WIDTH-1:0] corr_addr, corr_addr_write; 
    assign corr_addr = x_addr + y_addr * X_MAX;
    assign corr_addr_write = (DUAL) ? (x_addr_write + (y_addr_write * X_MAX)) : corr_addr;
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    logic ren_prev;
    always_ff @(posedge ramclk) begin
        ren_prev <= ren;
    end

    // If addr out of bounds, ret 0 - else sram_rdat
    logic [PIXEL_DEPTH-1:0] sram_rdat;
    always_comb begin
            rdat = sram_rdat;
            
            // Out of Bounds - Padding
            if (ren_prev && addr_oob) rdat = '0;
    end

    sram_model #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(PIXEL_DEPTH), .RAM_IS_SYNCHRONOUS(1), .DUAL(1)) IMAGE_DUT (
        .ramclk(ramclk), 
        .addr(corr_addr), .addr_write(corr_addr_write),
        .wen(wen), .ren(ren), 
        .wdat(wdat), 
        .rdat(sram_rdat)
    );                                                                     
    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////

    ////    ////    ////    ////    ////    ////    ////    ////    ////    //// 
    // Inside sram_image
    function automatic void load_img(input string fname,
                                input int xdim,
                                input int ydim);
        automatic bit [PIXEL_DEPTH-1:0] temp_img []; 
        automatic int total_pixels;
        automatic int ram_idx;
        automatic int px_idx;
        automatic int image_idx;
        
        total_pixels = xdim * ydim;
        temp_img = new[total_pixels];
        $readmemh(fname, temp_img);

        // Clear entire SRAM
        for (int i = 0; i < (1 << ADDR_WIDTH); i++) begin
            IMAGE_DUT.ram[i] = '0;                       // <<<<< ----- parameter  this
        end

        for (int y = 0; y < ydim; y++) begin
            for (int x = 0; x < xdim; x++) begin
                ram_idx = x + (y * X_MAX);
                px_idx = x + (y * xdim);
                if (px_idx < total_pixels)
                    IMAGE_DUT.ram[ram_idx] = temp_img[px_idx];
            end
        end
    endfunction

    localparam int MAX_PIXELS = X_MAX * Y_MAX;

    task dump_img(input string fname, 
                  input int xdim, 
                  input int ydim);

        // STATIC array — required for writememh
        bit [PIXEL_DEPTH-1:0] temp_img [0:MAX_PIXELS-1];

        int ram_idx;
        int px_idx;

        // Copy SRAM contents into temp array
        for (int y = 0; y < ydim; y++) begin
            for (int x = 0; x < xdim; x++) begin
                ram_idx = x + (y * X_MAX);
                px_idx  = x + (y * xdim);

                if (px_idx < MAX_PIXELS)
                    temp_img[px_idx] = IMAGE_DUT.ram[ram_idx];
                    //$display("urgay");
            end
        end

        // Write to hex file (only works with static arrays)
        $writememh(fname, temp_img, 0, MAX_PIXELS - 1);
        $display("SRAM dumped to file '%s'", fname);
    endtask
endmodule
