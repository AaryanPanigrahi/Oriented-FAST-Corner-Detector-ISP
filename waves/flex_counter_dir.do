onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix binary -radixshowbase 0 /tb_flex_counter_dir/clk
add wave -noupdate -expand -group Sync -label n_rst -radix binary -radixshowbase 0 /tb_flex_counter_dir/n_rst
add wave -noupdate -label MODE_TYPE /tb_flex_counter_dir/MODE_TYPE
add wave -noupdate -expand -group Input -label clear -radix binary -radixshowbase 0 /tb_flex_counter_dir/clear
add wave -noupdate -expand -group Input -label count_enable -radix binary -radixshowbase 0 /tb_flex_counter_dir/count_enable
add wave -noupdate -expand -group Input -label mode -radix unsigned -radixshowbase 0 /tb_flex_counter_dir/mode
add wave -noupdate -expand -group Input -label wrap_val -radix unsigned -radixshowbase 0 /tb_flex_counter_dir/wrap_val
add wave -noupdate -expand -group Output -label count_out -radix unsigned -radixshowbase 0 /tb_flex_counter_dir/count_out
add wave -noupdate -expand -group Output -label rollover_flag -radix binary -radixshowbase 0 /tb_flex_counter_dir/rollover_flag
add wave -noupdate -expand -group Output -label wrap_flag -radix binary -radixshowbase 0 /tb_flex_counter_dir/wrap_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {127208 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 142
configure wave -valuecolwidth 70
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
WaveRestoreZoom {56045 ps} {504934 ps}
