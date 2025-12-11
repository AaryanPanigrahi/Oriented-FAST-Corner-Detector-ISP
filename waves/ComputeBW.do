onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /tb_ComputeBW/clk
add wave -noupdate -radix unsigned /tb_ComputeBW/n_rst
add wave -noupdate -expand -group {Control Logic} -radix unsigned /tb_ComputeBW/start
add wave -noupdate -expand -group {Control Logic} -radix unsigned /tb_ComputeBW/clear_flag
add wave -noupdate -expand -group {Control Logic} -radix unsigned /tb_ComputeBW/clear
add wave -noupdate -expand -group {Comp Logic} -radix unsigned /tb_ComputeBW/pixel_red
add wave -noupdate -expand -group {Comp Logic} -radix unsigned /tb_ComputeBW/pixel_green
add wave -noupdate -expand -group {Comp Logic} -radix unsigned /tb_ComputeBW/pixel_blue
add wave -noupdate -expand -group {Comp Logic} -radix unsigned /tb_ComputeBW/grayed_pixel
add wave -noupdate -expand -group {FF Logic} -radix unsigned /tb_ComputeBW/DUT/nextGray
add wave -noupdate -expand -group {FF Logic} -radix unsigned /tb_ComputeBW/DUT/next_clear_flag
add wave -noupdate -expand -group {Test Bench Signals} /tb_ComputeBW/expected
add wave -noupdate -expand -group {Test Bench Signals} /tb_ComputeBW/percent_error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {17995 ps} 0}
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
WaveRestoreZoom {0 ps} {74552 ps}
