onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_GaussianConv/clk
add wave -noupdate -expand -group Sync /tb_GaussianConv/n_rst
add wave -noupdate -group Params /tb_GaussianConv/SIZE
add wave -noupdate -group Params /tb_GaussianConv/X_MAX
add wave -noupdate -group Params /tb_GaussianConv/Y_MAX
add wave -noupdate -group Params /tb_GaussianConv/PIXEL_DEPTH
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/x_addr
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/y_addr
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/wen
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/wdat
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/ren
add wave -noupdate -group SRAM /tb_GaussianConv/IMAGE_RAM/rdat
add wave -noupdate -expand -group {Top Level Signals} /tb_GaussianConv/DUT/new_trans
add wave -noupdate -expand -group {Top Level Signals} /tb_GaussianConv/DUT/start_conv
add wave -noupdate -expand -group {Top Level Signals} /tb_GaussianConv/DUT/init_trans
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample1
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample1_latch
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample2
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample2_latch
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_kernel
add wave -noupdate -expand -group {Top Level Signals} -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_kernel_latch
add wave -noupdate -expand -group {Kernel Info} /tb_GaussianConv/DUT/kernel_done
add wave -noupdate -expand -group {Kernel Info} -radix unsigned /tb_GaussianConv/DUT/sigma
add wave -noupdate -expand -group {Kernel Info} -radix unsigned -childformat {{{/tb_GaussianConv/DUT/kernel[4]} -radix unsigned} {{/tb_GaussianConv/DUT/kernel[3]} -radix unsigned} {{/tb_GaussianConv/DUT/kernel[2]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/kernel[1]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/kernel[0]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}}} -radixshowbase 0 -subitemconfig {{/tb_GaussianConv/DUT/kernel[4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[2][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][0]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[1][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][0]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[0][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][0]} {-radix unsigned -radixshowbase 0}} /tb_GaussianConv/DUT/kernel
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/start
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/sum
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/done
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/e
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_gauss
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_x
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_y
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/real_bits_gauss
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/end_row
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/end_column
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/cur_x
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/cur_y
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/nextDone
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/nextKernel
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/center
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/nextSum
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/contConv
add wave -noupdate -expand -group {Conv Memory} /tb_GaussianConv/DUT/new_sample_req
add wave -noupdate -expand -group {Conv Memory} /tb_GaussianConv/DUT/new_sample_ready
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} /tb_GaussianConv/DUT/propogate_buffer/kernel_size
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} /tb_GaussianConv/DUT/propogate_buffer/sample_updater
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {Reg Busses} /tb_GaussianConv/DUT/propogate_buffer/reg_bus_out
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {Reg Busses} /tb_GaussianConv/DUT/propogate_buffer/reg_bus_le
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {Reg Busses} /tb_GaussianConv/DUT/propogate_buffer/reg_bus_in
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/pipeline_count
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/next_dir
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/curr_x
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/curr_y
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_trans_flag
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_end_pos
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_x_addr_curr
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_y_addr_curr
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/input_matrix
add wave -noupdate -expand -group Convolution /tb_GaussianConv/DUT/err
add wave -noupdate -expand -group Convolution /tb_GaussianConv/DUT/blur_complete
add wave -noupdate -expand -group Convolution -radix decimal /tb_GaussianConv/DUT/blurred_pixel
add wave -noupdate -expand -group Convolution /tb_GaussianConv/DUT/conv_done
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/start
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/blurred_pixel
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/done
add wave -noupdate -expand -group ComputeKernel -expand -group {Done Pr} -color Aquamarine /tb_GaussianConv/DUT/pixel_blur/contConv
add wave -noupdate -expand -group ComputeKernel -expand -group {Done Pr} /tb_GaussianConv/DUT/pixel_blur/end_pos
add wave -noupdate -expand -group ComputeKernel -expand -group {Done Pr} /tb_GaussianConv/DUT/pixel_blur/readyFlag
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/cur_x
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/cur_y
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/kernel_v
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/pixel_v
add wave -noupdate -expand -group ComputeKernel /tb_GaussianConv/DUT/pixel_blur/clear_flag
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/kernel_v
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/pixel_v
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/start
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/ready
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/clear_flag
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/sum
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/state
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/nextState
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/nextSum
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/bufferSum
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/temp_kv
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/temp_pv
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/product
add wave -noupdate -expand -group ComputeKernel -expand -group {Accumulator Module} /tb_GaussianConv/DUT/pixel_blur/get_accumulator/nextProduct
add wave -noupdate -expand -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/curr_x
add wave -noupdate -expand -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/curr_y
add wave -noupdate -expand -group {Pixel Pos} /tb_GaussianConv/DUT/next_dir
add wave -noupdate -expand -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/end_pos
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/update_pos
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/max_x
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/max_y
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/end_pos
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/next_dir
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/curr_x
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/curr_y
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/rollover_flag
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/wrap_flag
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/y_update_flag
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/y_update
add wave -noupdate -expand -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/x_update
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {703942 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 181
configure wave -valuecolwidth 47
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {4851145660 ps} {4851475918 ps}
