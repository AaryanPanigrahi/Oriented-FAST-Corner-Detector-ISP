onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gray65 -radix decimal /tb_InitKernel/clk
add wave -noupdate -color Gray65 -radix decimal /tb_InitKernel/n_rst
add wave -noupdate -radix decimal /tb_InitKernel/start
add wave -noupdate -radix decimal /tb_InitKernel/sigma
add wave -noupdate -radix decimal /tb_InitKernel/kernel
add wave -noupdate -radix decimal /tb_InitKernel/sum
add wave -noupdate -radix decimal /tb_InitKernel/done
add wave -noupdate -radix ascii /tb_InitKernel/test_cur
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/clk
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/n_rst
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/start
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/sigma
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/kernel
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/sum
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/done
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/e
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/calc_gauss
add wave -noupdate -expand -group {Module Signals} -radix binary /tb_InitKernel/DUT/calc_x
add wave -noupdate -expand -group {Module Signals} -radix binary /tb_InitKernel/DUT/calc_y
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/real_bits_gauss
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/end_row
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/end_column
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/cur_x
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/cur_y
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/nextDone
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/nextKernel
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/center
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/nextSum
add wave -noupdate -expand -group {Module Signals} -radix decimal /tb_InitKernel/DUT/contConv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {237712 ps} 0}
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
WaveRestoreZoom {0 ps} {304500 ps}
