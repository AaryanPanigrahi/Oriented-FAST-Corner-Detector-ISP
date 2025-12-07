onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix binary -radixshowbase 0 /tb_pixel_pos/clk
add wave -noupdate -expand -group Sync -label n_rst -radix binary -radixshowbase 0 /tb_pixel_pos/n_rst
add wave -noupdate -expand -group Input -label new_trans -radix binary -radixshowbase 0 /tb_pixel_pos/new_trans
add wave -noupdate -expand -group Input -label update_pos -radix binary -radixshowbase 0 /tb_pixel_pos/update_pos
add wave -noupdate -expand -group Input -label max_x -radix unsigned -radixshowbase 0 /tb_pixel_pos/max_x
add wave -noupdate -expand -group Input -label max_y -radix unsigned -radixshowbase 0 /tb_pixel_pos/max_y
add wave -noupdate -expand -group Output -label curr_x -radix unsigned -radixshowbase 0 /tb_pixel_pos/curr_x
add wave -noupdate -expand -group Output -label curr_y -radix unsigned -radixshowbase 0 /tb_pixel_pos/curr_y
add wave -noupdate -expand -group Output -label next_dir -radix binary -radixshowbase 0 /tb_pixel_pos/next_dir
add wave -noupdate -expand -group Output -label end_pos -radix binary -radixshowbase 0 /tb_pixel_pos/end_pos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {574048934 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 128
configure wave -valuecolwidth 39
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
WaveRestoreZoom {574032201 ps} {574065666 ps}
