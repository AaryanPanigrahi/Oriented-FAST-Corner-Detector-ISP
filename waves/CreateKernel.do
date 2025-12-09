onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_InitKernel/clk
add wave -noupdate -expand -group Sync /tb_InitKernel/n_rst
add wave -noupdate -expand -group Setup /tb_InitKernel/sigma
add wave -noupdate -expand -group Setup /tb_InitKernel/kernel_size
add wave -noupdate -expand -group Telemetry /tb_InitKernel/start
add wave -noupdate -expand -group Telemetry /tb_InitKernel/done
add wave -noupdate -expand -group Out -radix unsigned -radixshowbase 0 /tb_InitKernel/sum
add wave -noupdate -expand -group Out /tb_InitKernel/kernel
add wave -noupdate -group Internal /tb_InitKernel/DUT/e
add wave -noupdate -group Internal /tb_InitKernel/DUT/calc_gauss
add wave -noupdate -group Internal /tb_InitKernel/DUT/calc_x
add wave -noupdate -group Internal /tb_InitKernel/DUT/calc_y
add wave -noupdate -group Internal /tb_InitKernel/DUT/curr_x
add wave -noupdate -group Internal /tb_InitKernel/DUT/curr_y
add wave -noupdate -group Internal /tb_InitKernel/DUT/real_bits_gauss
add wave -noupdate -group Internal /tb_InitKernel/DUT/nextDone
add wave -noupdate -group Internal /tb_InitKernel/DUT/nextKernel
add wave -noupdate -group Internal /tb_InitKernel/DUT/center
add wave -noupdate -group Internal /tb_InitKernel/DUT/nextSum
add wave -noupdate -group Internal /tb_InitKernel/DUT/contConv_latch
add wave -noupdate -group Internal /tb_InitKernel/DUT/contConv
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/update_pos
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/new_trans
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/max_x
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/max_y
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/next_dir
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/curr_x
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/curr_y
add wave -noupdate -group {Pixel Pos} /tb_InitKernel/DUT/kernel_pos/end_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {403699 ps} 0}
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
WaveRestoreZoom {325786 ps} {656538 ps}
