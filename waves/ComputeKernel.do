onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_GaussianConv/clk
add wave -noupdate -expand -group Sync /tb_GaussianConv/n_rst
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
add wave -noupdate -expand -group {Top Level Signals} /tb_GaussianConv/conv_done
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches /tb_GaussianConv/DUT/init_trans_latch
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches /tb_GaussianConv/DUT/convulution_in_progress
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches /tb_GaussianConv/DUT/first_trans
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_sample_latch
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_kernel
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {First Trans Signals} /tb_GaussianConv/DUT/init_trans_kernel_latch
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {Comp Latches} /tb_GaussianConv/DUT/compLatch
add wave -noupdate -expand -group {Top Level Signals} -expand -group Latches -group {Comp Latches} /tb_GaussianConv/DUT/compLatch_prev
add wave -noupdate -expand -group {Kernel Info} -group {Kernel Control} -radix unsigned /tb_GaussianConv/DUT/sigma
add wave -noupdate -expand -group {Kernel Info} -group {Kernel Control} /tb_GaussianConv/DUT/kernel_size
add wave -noupdate -expand -group {Kernel Info} /tb_GaussianConv/DUT/kernel_done
add wave -noupdate -expand -group {Kernel Info} -radix unsigned -childformat {{{/tb_GaussianConv/DUT/kernel[4]} -radix unsigned} {{/tb_GaussianConv/DUT/kernel[3]} -radix unsigned} {{/tb_GaussianConv/DUT/kernel[2]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/kernel[1]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/kernel[0]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}}} -radixshowbase 0 -subitemconfig {{/tb_GaussianConv/DUT/kernel[4]} {-height 16 -radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[3]} {-height 16 -radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[2][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[2][0]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[1][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[1][0]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/kernel[0][4]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][3]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][2]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][1]} {-radix unsigned -radixshowbase 0} {/tb_GaussianConv/DUT/kernel[0][0]} {-radix unsigned -radixshowbase 0}} /tb_GaussianConv/DUT/kernel
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/start
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/sum
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/done
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/e
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_gauss
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_x
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/calc_y
add wave -noupdate -expand -group {Kernel Info} -group {Non-Normalized Kernel} /tb_GaussianConv/DUT/get_kernel/non_normalized_kernel/real_bits_gauss
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
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/curr_x
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/curr_y
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Counts /tb_GaussianConv/DUT/propogate_buffer/wrap_flag
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_trans_flag
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_end_pos
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_x_addr_curr
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group {First Trans} /tb_GaussianConv/DUT/propogate_buffer/first_y_addr_curr
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Updaters /tb_GaussianConv/DUT/propogate_buffer/new_sample_ready_next
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Updaters /tb_GaussianConv/DUT/propogate_buffer/new_sample_req_prev
add wave -noupdate -expand -group {Conv Memory} -group {Conv Mem Internal} -group Updaters /tb_GaussianConv/DUT/propogate_buffer/sample_updater_int
add wave -noupdate -expand -group {Conv Memory} -radix unsigned -childformat {{{/tb_GaussianConv/DUT/propogate_buffer/working_memory[4]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/propogate_buffer/working_memory[3]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/propogate_buffer/working_memory[2]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/propogate_buffer/working_memory[1]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {{/tb_GaussianConv/DUT/propogate_buffer/working_memory[0]} -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}}}} -subitemconfig {{/tb_GaussianConv/DUT/propogate_buffer/working_memory[4]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[4][4]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[4][3]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[4][2]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[4][1]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[4][0]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3][4]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3][3]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3][2]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3][1]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[3][0]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2][4]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2][3]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2][2]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2][1]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[2][0]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1][4]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1][3]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1][2]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1][1]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[1][0]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0]} {-height 16 -radix unsigned -childformat {{{[4]} -radix unsigned} {{[3]} -radix unsigned} {{[2]} -radix unsigned} {{[1]} -radix unsigned} {{[0]} -radix unsigned}} -expand} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0][4]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0][3]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0][2]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0][1]} {-radix unsigned} {/tb_GaussianConv/DUT/propogate_buffer/working_memory[0][0]} {-radix unsigned}} /tb_GaussianConv/DUT/propogate_buffer/working_memory
add wave -noupdate -expand -group Convolution -expand -group Control /tb_GaussianConv/DUT/pixel_blur/clear
add wave -noupdate -expand -group Convolution -expand -group Control /tb_GaussianConv/DUT/pixel_blur/start
add wave -noupdate -expand -group Convolution -expand -group Control /tb_GaussianConv/DUT/pixel_blur/clear_flag
add wave -noupdate -expand -group Convolution -expand -group Control /tb_GaussianConv/DUT/pixel_blur/done
add wave -noupdate -expand -group Convolution -expand -group Control -group {Pulse Cont} /tb_GaussianConv/DUT/pixel_blur/single_pulse_start
add wave -noupdate -expand -group Convolution -expand -group Control -group {Pulse Cont} /tb_GaussianConv/DUT/pixel_blur/start_prev
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/blurred_pixel
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/readyFlag
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/contConv
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/readyFlag_prev
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/end_pos_prev
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/cur_x
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/cur_y
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/end_pos
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/kernel_v
add wave -noupdate -expand -group Convolution -radix unsigned /tb_GaussianConv/DUT/pixel_blur/pixel_v
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/input_matrix
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/kernel
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/kernel_size
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/start
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/clear
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/clear_flag
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/done
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/blurred_pixel
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/readyFlag
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/readyFlag_prev
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/cur_x
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/cur_y
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/contConv
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/kernel_v
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/pixel_v
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/end_pos
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/end_pos_prev
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/compState
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/nextState
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/single_pulse_start
add wave -noupdate -expand -group {Compute Kernel Module} /tb_GaussianConv/DUT/pixel_blur/start_prev
add wave -noupdate -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/curr_x
add wave -noupdate -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/curr_y
add wave -noupdate -group {Pixel Pos} /tb_GaussianConv/DUT/next_dir
add wave -noupdate -group {Pixel Pos} -radix unsigned /tb_GaussianConv/DUT/end_pos
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/update_pos
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/max_x
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/max_y
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/end_pos
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/next_dir
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/curr_x
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/curr_y
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/rollover_flag
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/wrap_flag
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/y_update_flag
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/y_update
add wave -noupdate -group {Pixel Pos} -group Internal /tb_GaussianConv/DUT/image_pos/x_update
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {614891 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
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
WaveRestoreZoom {259776 ps} {967011 ps}
