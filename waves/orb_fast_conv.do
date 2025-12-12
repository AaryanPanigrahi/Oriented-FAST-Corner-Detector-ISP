onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -radix unsigned /tb_orb_fast_conv/clk
add wave -noupdate -expand -group Sync -radix unsigned /tb_orb_fast_conv/n_rst
add wave -noupdate -expand -group IO -radix unsigned /tb_orb_fast_conv/new_trans
add wave -noupdate -expand -group IO -radix unsigned /tb_orb_fast_conv/img_done
add wave -noupdate -group {IMG SRAM} -label x_addr_img -radix unsigned /tb_orb_fast_conv/x_addr_img
add wave -noupdate -group {IMG SRAM} -label y_addr_img -radix unsigned /tb_orb_fast_conv/y_addr_img
add wave -noupdate -group {IMG SRAM} -label ren_img -radix unsigned /tb_orb_fast_conv/ren_img
add wave -noupdate -group {IMG SRAM} -label rdat_img -radix unsigned /tb_orb_fast_conv/rdat_img
add wave -noupdate -group {IMG SRAM} -label {Img Ram} -radix unsigned /tb_orb_fast_conv/IMAGE_BW_RAM/IMAGE_DUT/ram
add wave -noupdate -group {PARAM SRAM} -expand -group {PARAM SRAM} -label addr_params -radix unsigned /tb_orb_fast_conv/addr_params
add wave -noupdate -group {PARAM SRAM} -expand -group {PARAM SRAM} -label ren_params -radix unsigned /tb_orb_fast_conv/ren_params
add wave -noupdate -group {PARAM SRAM} -expand -group {PARAM SRAM} -label rdat_params -radix unsigned /tb_orb_fast_conv/rdat_params
add wave -noupdate -group {PARAM SRAM} -expand -group {Param Write} -radix unsigned /tb_orb_fast_conv/addr_write_params
add wave -noupdate -group {PARAM SRAM} -expand -group {Param Write} -radix unsigned /tb_orb_fast_conv/wen_params
add wave -noupdate -group {PARAM SRAM} -expand -group {Param Write} -radix unsigned /tb_orb_fast_conv/wdat_params
add wave -noupdate -group {Conv SRAM} -expand -group {Conv SRAM} -radix unsigned /tb_orb_fast_conv/x_addr_conv
add wave -noupdate -group {Conv SRAM} -expand -group {Conv SRAM} -radix unsigned /tb_orb_fast_conv/y_addr_conv
add wave -noupdate -group {Conv SRAM} -expand -group {Conv SRAM} -radix unsigned /tb_orb_fast_conv/wen_conv
add wave -noupdate -group {Conv SRAM} -expand -group {Conv SRAM} -radix unsigned /tb_orb_fast_conv/wdat_conv
add wave -noupdate -group {Conv SRAM} -expand -group {Conv Read} -radix unsigned /tb_orb_fast_conv/x_addr_conv_fast
add wave -noupdate -group {Conv SRAM} -expand -group {Conv Read} -radix unsigned /tb_orb_fast_conv/y_addr_conv_fast
add wave -noupdate -group {Conv SRAM} -expand -group {Conv Read} -radix unsigned /tb_orb_fast_conv/ren_conv_fast
add wave -noupdate -group {Conv SRAM} -expand -group {Conv Read} -radix unsigned /tb_orb_fast_conv/rdat_conv_fast
add wave -noupdate -group {FAST SRAM} -radix unsigned /tb_orb_fast_conv/x_addr_fast
add wave -noupdate -group {FAST SRAM} -radix unsigned /tb_orb_fast_conv/y_addr_fast
add wave -noupdate -group {FAST SRAM} -radix unsigned /tb_orb_fast_conv/wen_fast
add wave -noupdate -group {FAST SRAM} -radix unsigned /tb_orb_fast_conv/wdat_fast
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/addr_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/ren_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/rdat_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/addr_write_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/wen_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/wdat_params
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/new_trans
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/img_done
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/max_x
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/max_y
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/kernel_size
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/sigma
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/reg_bus_in
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/reg_bus_le
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/idx
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/x_max_lower
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/x_max_upper
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/y_max_lower
add wave -noupdate -expand -group {Param Control} -radix unsigned /tb_orb_fast_conv/dut/PARAM_CONTROL/y_max_upper
add wave -noupdate -expand -group {Param Control} /tb_orb_fast_conv/dut/PARAM_CONTROL/currState
add wave -noupdate -expand -group {Param Control} /tb_orb_fast_conv/dut/PARAM_CONTROL/nextState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {217523 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
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
WaveRestoreZoom {0 ps} {339088 ps}
