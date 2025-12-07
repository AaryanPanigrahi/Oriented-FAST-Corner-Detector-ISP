onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix binary -radixshowbase 0 /tb_pixel_pos/clk
add wave -noupdate -expand -group Sync -label n_rst -radix binary -radixshowbase 0 /tb_pixel_pos/n_rst
add wave -noupdate -expand -group Input -label new_trans -radix binary -radixshowbase 0 /tb_pixel_pos/new_trans
add wave -noupdate -expand -group Input -label update_pos -radix binary -radixshowbase 0 /tb_pixel_pos/update_pos
add wave -noupdate -expand -group Input -label max_x -radix unsigned -radixshowbase 0 /tb_pixel_pos/max_x
add wave -noupdate -expand -group Input -label max_y -radix unsigned -radixshowbase 0 /tb_pixel_pos/max_y
add wave -noupdate -expand -group Output -label curr_x -radix unsigned -radixshowbase 0 /tb_pixel_pos/curr_x
add wave -noupdate -expand -group Output -label curr_y -radix unsigned -radixshowbase 0 /tb_pixel_pos/curr_y
add wave -noupdate -expand -group Output -label next_dir -radix binary -radixshowbase 0 /tb_pixel_pos/next_dir
add wave -noupdate -expand -group Output -label next_move /tb_pixel_pos/next_move
add wave -noupdate -expand -group Output -label end_pos -radix binary -radixshowbase 0 /tb_pixel_pos/end_pos
add wave -noupdate -expand -group Updates /tb_pixel_pos/dut/x_update
add wave -noupdate -expand -group Updates /tb_pixel_pos/dut/y_update
add wave -noupdate -expand -group Updates /tb_pixel_pos/dut/y_update_flag
add wave -noupdate -expand -group Updates /tb_pixel_pos/dut/y_update_flag_keep
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/rollover_flag
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/wrap_flag
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/rollover_flag_prev
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/rollover_flag_prev_exp
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/wrap_flag_prev
add wave -noupdate -expand -group _over_logic /tb_pixel_pos/dut/wrap_flag_prev_exp
add wave -noupdate /tb_pixel_pos/dut/new_trans_prev
add wave -noupdate /tb_pixel_pos/dut/new_trans_prev_exp
add wave -noupdate /tb_pixel_pos/dut/corr_clear
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {252212 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 384
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
WaveRestoreZoom {7558 ps} {262995 ps}
