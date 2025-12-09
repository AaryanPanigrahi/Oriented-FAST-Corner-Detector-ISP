onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_memory_reg/clk
add wave -noupdate -expand -group Sync /tb_memory_reg/n_rst
add wave -noupdate -expand -group Input /tb_memory_reg/load_enable
add wave -noupdate -expand -group Input -radix binary -radixshowbase 0 /tb_memory_reg/parallel_in
add wave -noupdate -expand -group Out -radix binary -radixshowbase 0 /tb_memory_reg/parallel_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 281
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {863 ps}
