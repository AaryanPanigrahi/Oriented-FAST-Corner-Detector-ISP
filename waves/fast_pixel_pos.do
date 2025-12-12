onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fast_top_level/clk
add wave -noupdate /tb_fast_top_level/n_rst
add wave -noupdate /tb_fast_top_level/SRAM_in
add wave -noupdate /tb_fast_top_level/write_SRAM4
add wave -noupdate /tb_fast_top_level/DUT/pos_inst/update_pos
add wave -noupdate /tb_fast_top_level/DUT/new_trans
add wave -noupdate /tb_fast_top_level/DUT/fast_compute/curr_x
add wave -noupdate /tb_fast_top_level/DUT/fast_compute/curr_y
add wave -noupdate /tb_fast_top_level/read_SRAM2
add wave -noupdate -radix unsigned /tb_fast_top_level/x_addr
add wave -noupdate -radix unsigned /tb_fast_top_level/y_addr
add wave -noupdate /tb_fast_top_level/x_addr4
add wave -noupdate /tb_fast_top_level/y_addr4
add wave -noupdate /tb_fast_top_level/DUT/fast_compute/current_state
add wave -noupdate /tb_fast_top_level/DUT/fast_compute/center
add wave -noupdate /tb_fast_top_level/DUT/fast_compute/input_pixel
add wave -noupdate -expand /tb_fast_top_level/DUT/fast_compute/buffer_output
add wave -noupdate -expand -group controller /tb_fast_top_level/gaus_sample_flag
add wave -noupdate -expand -group controller /tb_fast_top_level/DUT/start
add wave -noupdate -expand -group controller /tb_fast_top_level/DUT/fast_controller/current_state
add wave -noupdate -expand -group controller -radix unsigned /tb_fast_top_level/DUT/fast_controller/gaus_count_ff
add wave -noupdate -expand -group controller -radix unsigned /tb_fast_top_level/DUT/fast_controller/fast_count_ff
add wave -noupdate -expand -group CIRCLE /tb_fast_top_level/DUT/draw_circle/SRAM_in
add wave -noupdate -expand -group CIRCLE /tb_fast_top_level/DUT/draw_circle/pink
add wave -noupdate -expand -group CIRCLE /tb_fast_top_level/DUT/draw_circle/state
add wave -noupdate -expand -group CIRCLE -radix unsigned /tb_fast_top_level/DUT/draw_circle/curr_x
add wave -noupdate -expand -group CIRCLE -radix unsigned /tb_fast_top_level/DUT/draw_circle/curr_y
add wave -noupdate -expand -group CIRCLE -radix unsigned /tb_fast_top_level/DUT/draw_circle/x_addr
add wave -noupdate -expand -group CIRCLE -radix unsigned /tb_fast_top_level/DUT/draw_circle/y_addr
add wave -noupdate -expand -group SRAM2 -radix unsigned /tb_fast_top_level/SRAM2/corr_addr
add wave -noupdate -expand -group SRAM2 /tb_fast_top_level/SRAM2/IMAGE_DUT/ram
add wave -noupdate -expand -group SRAM4 /tb_fast_top_level/SRAM4/corr_addr
add wave -noupdate -expand -group SRAM4 /tb_fast_top_level/SRAM4/IMAGE_DUT/ram
add wave -noupdate -expand -group SRAM5 -radix unsigned /tb_fast_top_level/SRAM5/corr_addr
add wave -noupdate -expand -group SRAM5 /tb_fast_top_level/SRAM5/IMAGE_DUT/wdat
add wave -noupdate -expand -group SRAM5 /tb_fast_top_level/SRAM5/IMAGE_DUT/wen
add wave -noupdate -expand -group SRAM5 -expand /tb_fast_top_level/SRAM5/IMAGE_DUT/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48142995895 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {48141881298 ps} {48143079932 ps}
