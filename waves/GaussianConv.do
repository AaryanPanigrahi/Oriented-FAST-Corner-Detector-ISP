onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb_GaussianConv/clk
add wave -noupdate -radix decimal /tb_GaussianConv/n_rst
add wave -noupdate -radix decimal /tb_GaussianConv/sigma
add wave -noupdate -radix decimal /tb_GaussianConv/start_conv
add wave -noupdate -radix decimal /tb_GaussianConv/new_trans
add wave -noupdate -radix decimal /tb_GaussianConv/conv_done
add wave -noupdate -radix decimal /tb_GaussianConv/blurred_pixel
add wave -noupdate -radix decimal /tb_GaussianConv/err
add wave -noupdate -radix decimal /tb_GaussianConv/blur_complete
add wave -noupdate -radix decimal -childformat {{{/tb_GaussianConv/x_addr[4]} -radix decimal} {{/tb_GaussianConv/x_addr[3]} -radix decimal} {{/tb_GaussianConv/x_addr[2]} -radix decimal} {{/tb_GaussianConv/x_addr[1]} -radix decimal} {{/tb_GaussianConv/x_addr[0]} -radix decimal}} -expand -subitemconfig {{/tb_GaussianConv/x_addr[4]} {-height 16 -radix decimal} {/tb_GaussianConv/x_addr[3]} {-height 16 -radix decimal} {/tb_GaussianConv/x_addr[2]} {-height 16 -radix decimal} {/tb_GaussianConv/x_addr[1]} {-height 16 -radix decimal} {/tb_GaussianConv/x_addr[0]} {-height 16 -radix decimal}} /tb_GaussianConv/x_addr
add wave -noupdate -radix decimal -childformat {{{/tb_GaussianConv/y_addr[4]} -radix decimal} {{/tb_GaussianConv/y_addr[3]} -radix decimal} {{/tb_GaussianConv/y_addr[2]} -radix decimal} {{/tb_GaussianConv/y_addr[1]} -radix decimal} {{/tb_GaussianConv/y_addr[0]} -radix decimal}} -expand -subitemconfig {{/tb_GaussianConv/y_addr[4]} {-height 16 -radix decimal} {/tb_GaussianConv/y_addr[3]} {-height 16 -radix decimal} {/tb_GaussianConv/y_addr[2]} {-height 16 -radix decimal} {/tb_GaussianConv/y_addr[1]} {-height 16 -radix decimal} {/tb_GaussianConv/y_addr[0]} {-height 16 -radix decimal}} /tb_GaussianConv/y_addr
add wave -noupdate -radix decimal /tb_GaussianConv/wdat
add wave -noupdate -radix decimal /tb_GaussianConv/wen
add wave -noupdate -radix decimal /tb_GaussianConv/ren
add wave -noupdate -radix decimal /tb_GaussianConv/rdat
add wave -noupdate -radix decimal /tb_GaussianConv/q
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/clk
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/n_rst
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/rdat_img
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/sigma
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/start_conv
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/new_trans
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/blurred_pixel
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/err
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/blur_complete
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/ren_img
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/conv_done
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/x_addr_img
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/y_addr_img
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/kernel
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/input_matrix
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/comp_start
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/kernel_done
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/end_pos
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/new_sample_ready
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/curr_x
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/curr_y
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/next_dir
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/max_x
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_GaussianConv/DUT/max_y
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/kernel_size
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/new_trans
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/new_sample_req
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/new_sample_ready
add wave -noupdate -expand -group {conv memory} -group {SRAM Internal} /tb_GaussianConv/DUT/propogate_buffer/x_addr_img
add wave -noupdate -expand -group {conv memory} -group {SRAM Internal} /tb_GaussianConv/DUT/propogate_buffer/y_addr_img
add wave -noupdate -expand -group {conv memory} -group {SRAM Internal} /tb_GaussianConv/DUT/propogate_buffer/ren_img
add wave -noupdate -expand -group {conv memory} -group {SRAM Internal} /tb_GaussianConv/DUT/propogate_buffer/rdat_img
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/curr_x
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/curr_y
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/next_dir
add wave -noupdate -expand -group {conv memory} /tb_GaussianConv/DUT/propogate_buffer/working_memory
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/clk
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/n_rst
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/input_matrix
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/kernel
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/start
add wave -noupdate -group {Compute Kernel} -color Turquoise /tb_GaussianConv/DUT/pixel_blur/blurred_pixel
add wave -noupdate -group {Compute Kernel} -color Turquoise /tb_GaussianConv/DUT/pixel_blur/done
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/readyFlag
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/end_row
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/end_column
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/cur_x
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/cur_y
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/contConv
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/kernel_v
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/pixel_v
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/temp_rollover
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/queue_clear
add wave -noupdate -group {Compute Kernel} /tb_GaussianConv/DUT/pixel_blur/clear_flag
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/clk
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/n_rst
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/update_pos
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/new_trans
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/max_x
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/max_y
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/end_pos
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/next_dir
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/curr_x
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/curr_y
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/rollover_flag
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/rollover_flag_prev
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/rollover_flag_prev_exp
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/wrap_flag
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/wrap_flag_prev
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/wrap_flag_prev_exp
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/new_trans_prev
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/new_trans_prev_exp
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/new_trans_info
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/new_flag
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/old_flag
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/y_update
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/x_update
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/max_x_eff
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/max_y_eff
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/corr_clear
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/end_x
add wave -noupdate -group {Pixel Pos Module} -radix decimal /tb_GaussianConv/DUT/image_pos/end_y
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/ramclk
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/x_addr
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/y_addr
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/wen
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/ren
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/wdat
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/rdat
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/x_max_eff
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/y_max_eff
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/corr_addr
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/ren_prev
add wave -noupdate -expand -group {SRAM Module} /tb_GaussianConv/IMAGE_RAM/sram_rdat
add wave -noupdate -expand /tb_GaussianConv/IMAGE_RAM/IMAGE_DUT/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {379676 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
configure wave -valuecolwidth 100
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
WaveRestoreZoom {224909 ps} {971952 ps}
