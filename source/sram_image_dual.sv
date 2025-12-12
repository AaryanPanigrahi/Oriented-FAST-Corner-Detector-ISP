`timescale 1ns / 10ps

module sram_image_dual #(
    PIXEL_DEPTH = 8,
    X_MAX = 5,
    Y_MAX = 5
) (
    input logic signed [$clog2(X_MAX):0] x_addr,
    input logic signed [$clog2(Y_MAX):0] y_addr,
    input logic wen, ren,
    input logic [PIXEL_DEPTH-1:0] wdat,
    output logic [PIXEL_DEPTH-1:0] rdat
);

    localparam ADDR_WIDTH = $clog2(X_MAX * Y_MAX);
    localparam WORD_WIDTH = 32;                                   // SRAM word size
    localparam IMG_PX_PER_LINE = WORD_WIDTH / PIXEL_DEPTH;        // Pixels per 32 bit word

    logic [$clog2(X_MAX):0] x_max_eff;
    logic [$clog2(Y_MAX):0] y_max_eff;
    assign y_max_eff = Y_MAX - 1;
    assign x_max_eff = X_MAX - 1;

    logic addr_oob;
    assign addr_oob = (x_addr > x_max_eff) || (y_addr > y_max_eff);

    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////    ////
    // Map 1D SRAM as 2D SRAM
    logic [ADDR_WIDTH-1:0] corr_addr; 
    assign corr_addr = addr_oob ? '1 : (x_addr + y_addr * X_MAX);


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
            
            if (ren_prev) begin
                // Out of Bounds
                if ((x_addr > x_max_eff) || (y_addr > y_max_eff)) rdat = '0;
            end
    end

    sram_model #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(PIXEL_DEPTH), .RAM_IS_SYNCHRONOUS(1)) IMAGE_DUT (
        .ramclk(ramclk), .addr(corr_addr), .wen(wen), .ren(ren), 
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
            IMAGE_DUT.ram[i] = 8'hFF;                       // <<<<< ----- parameter  this
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
