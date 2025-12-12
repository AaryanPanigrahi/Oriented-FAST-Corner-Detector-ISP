onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fast_controller/clk
add wave -noupdate /tb_fast_controller/n_rst
add wave -noupdate /tb_fast_controller/gaus_sample_flag
add wave -noupdate /tb_fast_controller/gaus_done
add wave -noupdate /tb_fast_controller/fast_done_flag
add wave -noupdate /tb_fast_controller/fast_start
add wave -noupdate /tb_fast_controller/DUT/current_state
add wave -noupdate /tb_fast_controller/DUT/gaus_count_ff
add wave -noupdate /tb_fast_controller/DUT/fast_count_ff
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {548031 ps} 0}
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
WaveRestoreZoom {0 ps} {871500 ps}
