onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix unsigned /tb_param_controller/clk
add wave -noupdate -expand -group Sync -label n_rst -radix unsigned /tb_param_controller/n_rst
add wave -noupdate -expand -group SRAM -group Read -label ren_params -radix unsigned /tb_param_controller/ren_params
add wave -noupdate -expand -group SRAM -group Read -label addr_params -radix unsigned /tb_param_controller/addr_params
add wave -noupdate -expand -group SRAM -group Read -label rdat_params -radix unsigned /tb_param_controller/rdat_params
add wave -noupdate -expand -group SRAM -group Write -label wen_params -radix unsigned /tb_param_controller/wen_params
add wave -noupdate -expand -group SRAM -group Write -label addr_write_params -radix unsigned /tb_param_controller/addr_write_params
add wave -noupdate -expand -group SRAM -group Write -label wdat_params -radix unsigned /tb_param_controller/wdat_params
add wave -noupdate -expand -group SRAM -label ram -expand /tb_param_controller/DUT_RAM/ram
add wave -noupdate -expand -group IO -label new_trans -radix unsigned /tb_param_controller/new_trans
add wave -noupdate -expand -group IO -label img_done -radix unsigned /tb_param_controller/img_done
add wave -noupdate -expand -group Output -label max_x -radix unsigned /tb_param_controller/max_x
add wave -noupdate -expand -group Output -label max_y -radix unsigned /tb_param_controller/max_y
add wave -noupdate -expand -group Output -label kernel_size -radix unsigned /tb_param_controller/kernel_size
add wave -noupdate -expand -group Output -label signma -radix unsigned /tb_param_controller/sigma
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 187
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
WaveRestoreZoom {0 ps} {1128750 ps}
