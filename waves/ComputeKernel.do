onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TB /tb_ComputeKernel/clk
add wave -noupdate -expand -group TB /tb_ComputeKernel/n_rst
add wave -noupdate -expand -group TB /tb_ComputeKernel/input_matrix
add wave -noupdate -expand -group TB /tb_ComputeKernel/kernel
add wave -noupdate -expand -group TB /tb_ComputeKernel/start
add wave -noupdate -expand -group TB -radix decimal /tb_ComputeKernel/blurred_pixel
add wave -noupdate -expand -group TB /tb_ComputeKernel/kernel_size
add wave -noupdate -expand -group TB /tb_ComputeKernel/done
add wave -noupdate -expand -group TB /tb_ComputeKernel/clear
add wave -noupdate -expand -group TB /tb_ComputeKernel/clear_flag
add wave -noupdate -expand -group TB /tb_ComputeKernel/sigma
add wave -noupdate -expand -group TB /tb_ComputeKernel/kernel_start
add wave -noupdate -expand -group TB /tb_ComputeKernel/kernel_done
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/clk
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/n_rst
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/input_matrix
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/kernel
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/kernel_size
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/start
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/clear_flag
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/clear
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/done
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/blurred_pixel
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/readyFlag
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/readyFlag_prev
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/cur_x
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/cur_y
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/contConv
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/kernel_v
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/pixel_v
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/end_pos
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/end_pos_prev
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/single_pulse_start
add wave -noupdate -expand -group {Mod Signals} /tb_ComputeKernel/DUT/start_prev
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {463119 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 274
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
WaveRestoreZoom {381666 ps} {608909 ps}
