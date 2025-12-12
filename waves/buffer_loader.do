onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_buffer_loader/curr_x
add wave -noupdate /tb_buffer_loader/curr_y
add wave -noupdate /tb_buffer_loader/input_pixel
add wave -noupdate /tb_buffer_loader/start
add wave -noupdate -radix decimal /tb_buffer_loader/x_addr
add wave -noupdate -radix decimal /tb_buffer_loader/y_addr
add wave -noupdate /tb_buffer_loader/done
add wave -noupdate -radix decimal /tb_buffer_loader/DUT/pixel_index
add wave -noupdate /tb_buffer_loader/center_value
add wave -noupdate /tb_buffer_loader/clk
add wave -noupdate /tb_buffer_loader/n_rst
add wave -noupdate /tb_buffer_loader/DUT/current_state
add wave -noupdate -expand /tb_buffer_loader/DUT/buff_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109346 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {430500 ps}
