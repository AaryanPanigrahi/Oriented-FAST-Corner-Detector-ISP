onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -radix unsigned /tb_orb_fast_conv/clk
add wave -noupdate -expand -group Sync -radix unsigned /tb_orb_fast_conv/n_rst
add wave -noupdate -expand -group IO -radix unsigned /tb_orb_fast_conv/new_trans
add wave -noupdate -expand -group IO -radix unsigned /tb_orb_fast_conv/img_done
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/ramclk
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/x_addr
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/y_addr
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/x_addr_write
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/y_addr_write
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/wen
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/ren
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/wdat
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/rdat
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/x_addr_prev
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/y_addr_prev
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/addr_oob
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/corr_addr
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/corr_addr_write
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/ren_prev
add wave -noupdate -expand -group {IMG RAM} /tb_orb_fast_conv/IMAGE_RAM/sram_rdat
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/ramclk
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/addr
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/addr_write
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/wen
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/ren
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/wdat
add wave -noupdate -expand -group PARAMS /tb_orb_fast_conv/PARAM_RAM/rdat
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/x_addr
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/y_addr
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/x_addr_write
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/y_addr_write
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/wen
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/ren
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/wdat
add wave -noupdate -expand -group {IMAGE BW RAM} /tb_orb_fast_conv/IMAGE_BW_RAM/rdat
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/x_addr
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/y_addr
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/x_addr_write
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/y_addr_write
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/wen
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/ren
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/wdat
add wave -noupdate -expand -group {CONV RAM} /tb_orb_fast_conv/CONV_RAM/rdat
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/corr_addr
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/x_addr
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/y_addr
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/x_addr_write
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/y_addr_write
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/wen
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/ren
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/wdat
add wave -noupdate -expand -group {FAST RAM} /tb_orb_fast_conv/FAST_RAM/rdat
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/x_addr
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/y_addr
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/x_addr_write
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/y_addr_write
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/wen
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/ren
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/wdat
add wave -noupdate -group {OUT RAM} /tb_orb_fast_conv/OUT_RAM/rdat
add wave -noupdate -expand -group BW_MODULE /tb_orb_fast_conv/OVERALL/convert_bw/bw_bw/rdat_img
add wave -noupdate -expand -group BW_MODULE /tb_orb_fast_conv/OVERALL/convert_bw/bw_bw/wdat_bw
add wave -noupdate -expand -group BW_MODULE /tb_orb_fast_conv/OVERALL/convert_bw/bw_bw/bw_done
add wave -noupdate -expand -group BW_MODULE /tb_orb_fast_conv/OVERALL/convert_bw/bw_bw/current_state
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/curr_x
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/curr_y
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/x_addr_gaus
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/y_addr_gaus
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/x_addr_fast
add wave -noupdate -group FAST -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/y_addr_fast
add wave -noupdate -group FAST /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/write_SRAM_fast
add wave -noupdate -group FAST /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/buffer_output
add wave -noupdate -group FAST /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_compute/current_state
add wave -noupdate -group CONTROLLER -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_controller/gaus_count_ff
add wave -noupdate -group CONTROLLER -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_controller/fast_count_ff
add wave -noupdate -group CONTROLLER -radix unsigned /tb_orb_fast_conv/OVERALL/FAST_COMP/fast_controller/current_state
add wave -noupdate /tb_orb_fast_conv/FAST_RAM/IMAGE_DUT/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3618911465 ps} 0}
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
WaveRestoreZoom {3618702562 ps} {3619233648 ps}
