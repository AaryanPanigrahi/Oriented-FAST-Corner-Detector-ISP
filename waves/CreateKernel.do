onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_CreateKernel/clk
add wave -noupdate -expand -group Sync /tb_CreateKernel/n_rst
add wave -noupdate -expand -group Params /tb_CreateKernel/sigma
add wave -noupdate -expand -group Params /tb_CreateKernel/kernel_size
add wave -noupdate -expand -group Telemetry /tb_CreateKernel/start
add wave -noupdate -expand -group Telemetry /tb_CreateKernel/done
add wave -noupdate -expand -group Out /tb_CreateKernel/err
add wave -noupdate -expand -group Out /tb_CreateKernel/kernel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {213214 ps} 0}
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
WaveRestoreZoom {0 ps} {2194500 ps}
