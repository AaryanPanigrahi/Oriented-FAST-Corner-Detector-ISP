onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix unsigned -radixshowbase 0 /tb_conv_memory/clk
add wave -noupdate -expand -group Sync -label n_rst -radix unsigned -radixshowbase 0 /tb_conv_memory/n_rst
add wave -noupdate -group SRAM -label x_addr_img -radix unsigned -radixshowbase 0 /tb_conv_memory/x_addr_img
add wave -noupdate -group SRAM -label y_addr_img -radix unsigned -radixshowbase 0 /tb_conv_memory/y_addr_img
add wave -noupdate -group SRAM -label wdat /tb_conv_memory/wdat
add wave -noupdate -group SRAM -label wen -radix unsigned -radixshowbase 0 /tb_conv_memory/wen
add wave -noupdate -group SRAM -label ren_img -radix unsigned -radixshowbase 0 /tb_conv_memory/ren_img
add wave -noupdate -group SRAM -label rdat_img /tb_conv_memory/rdat_img
add wave -noupdate -expand -group {IMG Param} -label kernel_size -radix unsigned -radixshowbase 0 /tb_conv_memory/kernel_size
add wave -noupdate -group Pixel_pos -label new_trans -radix unsigned -radixshowbase 0 /tb_conv_memory/new_trans
add wave -noupdate -group Pixel_pos -label next_dir -radix binary -radixshowbase 0 /tb_conv_memory/next_dir
add wave -noupdate -group Pixel_pos -label next_move /tb_conv_memory/next_move
add wave -noupdate -group Pixel_pos -label max_x -radix unsigned -radixshowbase 0 /tb_conv_memory/max_x
add wave -noupdate -group Pixel_pos -label max_y -radix unsigned -radixshowbase 0 /tb_conv_memory/max_y
add wave -noupdate -group Pixel_pos -label curr_x -radix unsigned -radixshowbase 0 /tb_conv_memory/curr_x
add wave -noupdate -group Pixel_pos -label curr_y -radix unsigned -radixshowbase 0 /tb_conv_memory/curr_y
add wave -noupdate -expand -group {Gaussian Conv} -label new_sample_req -radix unsigned -radixshowbase 0 /tb_conv_memory/new_sample_req
add wave -noupdate -expand -group {Gaussian Conv} -label new_sample_ready -radix unsigned -radixshowbase 0 /tb_conv_memory/new_sample_ready
add wave -noupdate -expand -group Memory -label working_memory -expand -subitemconfig {{/tb_conv_memory/working_memory[2]} -expand {/tb_conv_memory/working_memory[1]} -expand {/tb_conv_memory/working_memory[0]} -expand} /tb_conv_memory/working_memory
add wave -noupdate -expand -group Memory -label ram /tb_conv_memory/IMAGE_RAM/IMAGE_DUT/ram
add wave -noupdate -expand -group Internal -expand -group {Reg Busses} -label reg_bus_out /tb_conv_memory/GAUSSIAN_MEM/reg_bus_out
add wave -noupdate -expand -group Internal -expand -group {Reg Busses} -label reg_bus_le /tb_conv_memory/GAUSSIAN_MEM/reg_bus_le
add wave -noupdate -expand -group Internal -expand -group {Reg Busses} -label reg_bus_in /tb_conv_memory/GAUSSIAN_MEM/reg_bus_in
add wave -noupdate -expand -group Internal -group {Flex Counter} -label pipeline_count -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/pipeline_count
add wave -noupdate -expand -group Internal -group {Flex Counter} -label count_enable -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/count_enable
add wave -noupdate -expand -group Internal -group {Flex Counter} -label count_clear -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/count_clear
add wave -noupdate -expand -group Internal -group {Flex Counter} -label wrap_flag -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/wrap_flag
add wave -noupdate -expand -group Internal -group {Gaussian Out} -label new_sample_ready_w -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/new_sample_ready_w
add wave -noupdate -expand -group Internal -group {Gaussian Out} -label sample_updater -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/sample_updater
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -label y_update /tb_conv_memory/PIXEL_CORR/y_update
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -label x_update /tb_conv_memory/PIXEL_CORR/x_update
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_flag /tb_conv_memory/PIXEL_CORR/new_flag
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_trans_prev /tb_conv_memory/PIXEL_CORR/new_trans_prev
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_trans_prev_exp /tb_conv_memory/PIXEL_CORR/new_trans_prev_exp
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag /tb_conv_memory/PIXEL_CORR/rollover_flag
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag_prev /tb_conv_memory/PIXEL_CORR/rollover_flag_prev
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag_prev_exp /tb_conv_memory/PIXEL_CORR/rollover_flag_prev_exp
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag_prev
add wave -noupdate -expand -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag_prev_exp -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag_prev_exp
add wave -noupdate -expand -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/corr_clear
add wave -noupdate -expand -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_x
add wave -noupdate -expand -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_y
add wave -noupdate -expand -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {145550 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 171
configure wave -valuecolwidth 48
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {662045 ps}
