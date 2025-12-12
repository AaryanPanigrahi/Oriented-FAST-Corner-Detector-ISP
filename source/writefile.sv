`timescale 1ns/10ps

module writefile;
    logic [7:0] test_mem [0:15];
    logic [7:0] test_mem2 [0:15];
    integer i;

    initial begin
        // Load from hex file (you said this works)
        $readmemh("image/testing.hex", test_mem);

        // Print all values being written
        for (i = 0; i < 16; i = i + 1) begin
            $display("test_mem[%0d] = %02h", i, test_mem[i]);
        end

        // Write memory back to another file
        $writememh("image/output.hex", test_mem);

        $readmemh("image/output.hex", test_mem2);

        for (i = 0; i < 16; i = i + 1) begin
            $display("test_mem2[%0d] = %02h", i, test_mem2[i]);
        end

        $display("Memory written to output.txt");
        $finish;
    end
endmodule
