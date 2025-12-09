onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix unsigned -radixshowbase 0 /tb_conv_memory/clk
add wave -noupdate -expand -group Sync -label n_rst -radix unsigned -radixshowbase 0 /tb_conv_memory/n_rst
add wave -noupdate -group SRAM2 -label x_addr_test -radix unsigned -radixshowbase 0 /tb_conv_memory/x_addr_test
add wave -noupdate -group SRAM2 -label y_addr_test -radix unsigned -radixshowbase 0 /tb_conv_memory/y_addr_test
add wave -noupdate -group SRAM2 -label ren_test -radix unsigned -radixshowbase 0 /tb_conv_memory/ren_test
add wave -noupdate -group SRAM2 -label rdat_test -radix unsigned -radixshowbase 0 /tb_conv_memory/rdat_test
add wave -noupdate -expand -group {IMG Param} -label kernel_size -radix unsigned -radixshowbase 0 /tb_conv_memory/kernel_size
add wave -noupdate -expand -group {Gaussian Conv} -label new_trans -radix unsigned -radixshowbase 0 /tb_conv_memory/new_trans
add wave -noupdate -expand -group {Gaussian Conv} -label new_sample_req -radix unsigned -radixshowbase 0 /tb_conv_memory/new_sample_req
add wave -noupdate -expand -group {Gaussian Conv} -label new_sample_ready -radix unsigned -radixshowbase 0 /tb_conv_memory/new_sample_ready
add wave -noupdate -expand -group {Gaussian Conv} -group {Gaussian Out} -label new_sample_ready_w -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/new_sample_ready_w
add wave -noupdate -expand -group {Gaussian Conv} -group {Gaussian Out} -label new_sample_req_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/new_sample_req_prev
add wave -noupdate -expand -group {Gaussian Conv} -group {Gaussian Out} -label sample_updater -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/sample_updater
add wave -noupdate -expand -group {Gaussian Conv} -group {Gaussian Out} -label sample_updater_int /tb_conv_memory/GAUSSIAN_MEM/sample_updater_int
add wave -noupdate -group Pixel_pos -label curr_x -radix unsigned -radixshowbase 0 /tb_conv_memory/curr_x
add wave -noupdate -group Pixel_pos -label curr_y -radix unsigned -radixshowbase 0 /tb_conv_memory/curr_y
add wave -noupdate -group Pixel_pos -label next_dir -radix binary -radixshowbase 0 /tb_conv_memory/next_dir
add wave -noupdate -group Pixel_pos -group Extra -label max_x -radix unsigned -radixshowbase 0 /tb_conv_memory/max_x
add wave -noupdate -group Pixel_pos -group Extra -label max_y -radix unsigned -radixshowbase 0 /tb_conv_memory/max_y
add wave -noupdate -group Pixel_pos -group Extra -label next_move /tb_conv_memory/next_move
add wave -noupdate -group SRAM -label x_addr_img -radix unsigned -radixshowbase 0 /tb_conv_memory/x_addr_img
add wave -noupdate -group SRAM -label y_addr_img -radix unsigned -radixshowbase 0 /tb_conv_memory/y_addr_img
add wave -noupdate -group SRAM -label ren_img -radix unsigned -radixshowbase 0 /tb_conv_memory/ren_img
add wave -noupdate -group SRAM -label rdat_img /tb_conv_memory/rdat_img
add wave -noupdate -expand -group Memory -expand -group {Memory Edges} -label first -radix hexadecimal -radixshowbase 0 /tb_conv_memory/first
add wave -noupdate -expand -group Memory -expand -group {Memory Edges} -label bottom_left -radix hexadecimal -radixshowbase 0 /tb_conv_memory/bottom_left
add wave -noupdate -expand -group Memory -expand -group {Memory Edges} -label top_right -radix hexadecimal -radixshowbase 0 /tb_conv_memory/top_right
add wave -noupdate -expand -group Memory -expand -group {Memory Edges} -label last -radix hexadecimal -childformat {{{/tb_conv_memory/last[7]} -radix hexadecimal} {{/tb_conv_memory/last[6]} -radix hexadecimal} {{/tb_conv_memory/last[5]} -radix hexadecimal} {{/tb_conv_memory/last[4]} -radix hexadecimal} {{/tb_conv_memory/last[3]} -radix hexadecimal} {{/tb_conv_memory/last[2]} -radix hexadecimal} {{/tb_conv_memory/last[1]} -radix hexadecimal} {{/tb_conv_memory/last[0]} -radix hexadecimal}} -radixshowbase 0 -subitemconfig {{/tb_conv_memory/last[7]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[6]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[5]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[4]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[3]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[2]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[1]} {-height 16 -radix hexadecimal -radixshowbase 0} {/tb_conv_memory/last[0]} {-height 16 -radix hexadecimal -radixshowbase 0}} /tb_conv_memory/last
add wave -noupdate -expand -group Memory -label working_memory -subitemconfig {{/tb_conv_memory/working_memory[2]} -expand {/tb_conv_memory/working_memory[1]} -expand {/tb_conv_memory/working_memory[0]} -expand} /tb_conv_memory/working_memory
add wave -noupdate -expand -group Memory -label ram /tb_conv_memory/IMAGE_RAM/IMAGE_DUT/ram
add wave -noupdate -group Internal -expand -group {Reg Busses} -label reg_bus_out -expand -subitemconfig {{/tb_conv_memory/GAUSSIAN_MEM/reg_bus_out[4]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_out[3]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_out[2]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_out[1]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_out[0]} -expand} /tb_conv_memory/GAUSSIAN_MEM/reg_bus_out
add wave -noupdate -group Internal -expand -group {Reg Busses} -label reg_bus_le /tb_conv_memory/GAUSSIAN_MEM/reg_bus_le
add wave -noupdate -group Internal -expand -group {Reg Busses} -label reg_bus_in -expand -subitemconfig {{/tb_conv_memory/GAUSSIAN_MEM/reg_bus_in[4]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_in[3]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_in[2]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_in[1]} -expand {/tb_conv_memory/GAUSSIAN_MEM/reg_bus_in[0]} -expand} /tb_conv_memory/GAUSSIAN_MEM/reg_bus_in
add wave -noupdate -group Internal -expand -group {Flex Counter} -label pipeline_count -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/pipeline_count
add wave -noupdate -group Internal -expand -group {Flex Counter} -label pipeline_count_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/pipeline_count_prev
add wave -noupdate -group Internal -expand -group {Flex Counter} -label count_enable -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/count_enable
add wave -noupdate -group Internal -expand -group {Flex Counter} -label count_clear -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/count_clear
add wave -noupdate -group Internal -expand -group {Flex Counter} -label wrap_flag -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/wrap_flag
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -label y_update /tb_conv_memory/PIXEL_CORR/y_update
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -label x_update /tb_conv_memory/PIXEL_CORR/x_update
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_flag /tb_conv_memory/PIXEL_CORR/new_flag
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_trans_prev /tb_conv_memory/PIXEL_CORR/new_trans_prev
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -label new_trans_prev_exp /tb_conv_memory/PIXEL_CORR/new_trans_prev_exp
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag /tb_conv_memory/PIXEL_CORR/rollover_flag
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag_prev /tb_conv_memory/PIXEL_CORR/rollover_flag_prev
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label rollover_flag_prev_exp /tb_conv_memory/PIXEL_CORR/rollover_flag_prev_exp
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag_prev
add wave -noupdate -group Internal -group PIXEL_POS -expand -group {Update Flags} -expand -group {Wave Groups} -label wrap_flag_prev_exp -radix unsigned -radixshowbase 0 /tb_conv_memory/PIXEL_CORR/wrap_flag_prev_exp
add wave -noupdate -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/corr_clear
add wave -noupdate -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_x
add wave -noupdate -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_y
add wave -noupdate -group Internal -group PIXEL_POS -group Other /tb_conv_memory/PIXEL_CORR/end_pos
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label max_x -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/FIRST_TRANS_CORR/max_x
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label max_y -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/FIRST_TRANS_CORR/max_y
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_x_addr_curr -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_x_addr_curr
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_y_addr_curr -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_y_addr_curr
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_x_addr_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_x_addr_prev
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_y_addr_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_y_addr_prev
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_trans_flag -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_trans_flag
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_trans_flag_keep -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_trans_flag_keep
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_trans_flag_prev -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_trans_flag_prev
add wave -noupdate -group Internal -group {First Trans Pixel Pos} -label first_end_pos -radix unsigned -radixshowbase 0 /tb_conv_memory/GAUSSIAN_MEM/first_end_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3617310 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 232
configure wave -valuecolwidth 40
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
WaveRestoreZoom {3556106 ps} {3943155 ps}
