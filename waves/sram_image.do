onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync -label clk -radix binary -radixshowbase 0 /tb_sram_image/clk
add wave -noupdate -group Params -label X_MAX -radix unsigned -radixshowbase 0 /tb_sram_image/X_MAX
add wave -noupdate -group Params -label Y_MAX -radix unsigned -radixshowbase 0 /tb_sram_image/Y_MAX
add wave -noupdate -group Params -label PIXEL_DEPTH -radix unsigned -radixshowbase 0 /tb_sram_image/PIXEL_DEPTH
add wave -noupdate -expand -group Input -label wen -radix binary -radixshowbase 0 /tb_sram_image/wen
add wave -noupdate -expand -group Input -label ren -radix binary -radixshowbase 0 /tb_sram_image/ren
add wave -noupdate -expand -group Input -label x_addr -radix unsigned -radixshowbase 0 /tb_sram_image/x_addr
add wave -noupdate -expand -group Input -label y_addr -radix unsigned -radixshowbase 0 /tb_sram_image/y_addr
add wave -noupdate -expand -group Input -label wdat /tb_sram_image/wdat
add wave -noupdate -expand -group Output -label rdat /tb_sram_image/rdat
add wave -noupdate -expand -group Internal -label corr_addr -radix unsigned -radixshowbase 0 /tb_sram_image/IMAGE_RAM/corr_addr
add wave -noupdate -expand -group Internal -label corr_addr_write -radix unsigned -radixshowbase 0 /tb_sram_image/IMAGE_RAM/corr_addr_write
add wave -noupdate -expand -group Internal -label addr_oob /tb_sram_image/IMAGE_RAM/addr_oob
add wave -noupdate -expand -group Internal -label x_addr_prev -radix unsigned /tb_sram_image/IMAGE_RAM/x_addr_prev
add wave -noupdate -expand -group Internal -label y_addr_prev -radix unsigned /tb_sram_image/IMAGE_RAM/y_addr_prev
add wave -noupdate -expand -group Internal -group IMAGE_DUT -label wen -radix unsigned -radixshowbase 0 /tb_sram_image/IMAGE_RAM/IMAGE_DUT/wen
add wave -noupdate -expand -group Internal -group IMAGE_DUT -label wdat /tb_sram_image/IMAGE_RAM/IMAGE_DUT/wdat
add wave -noupdate -expand -group Internal -group IMAGE_DUT -label ren -radix unsigned -radixshowbase 0 /tb_sram_image/IMAGE_RAM/IMAGE_DUT/ren
add wave -noupdate -expand -group Internal -group IMAGE_DUT -label ren_prev /tb_sram_image/IMAGE_RAM/ren_prev
add wave -noupdate -expand -group Internal -group IMAGE_DUT -label rdat /tb_sram_image/IMAGE_RAM/IMAGE_DUT/rdat
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label {PIXEL DEPTH} -radix unsigned /tb_sram_image/IMAGE_RAM/PIXEL_DEPTH
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label X_MAX -radix unsigned /tb_sram_image/IMAGE_RAM/X_MAX
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label Y_MAX -radix unsigned /tb_sram_image/IMAGE_RAM/Y_MAX
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label X_MAX_EFF -radix unsigned /tb_sram_image/IMAGE_RAM/X_MAX_EFF
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label Y_MAX_EFF -radix unsigned /tb_sram_image/IMAGE_RAM/Y_MAX_EFF
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label DUAL -radix unsigned /tb_sram_image/IMAGE_RAM/DUAL
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label ADDR_WIDTH -radix unsigned /tb_sram_image/IMAGE_RAM/ADDR_WIDTH
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label WORD_WIDTH -radix unsigned /tb_sram_image/IMAGE_RAM/WORD_WIDTH
add wave -noupdate -expand -group Internal -expand -group {Params Int} -label IMG_PX_PER_LINE -radix unsigned /tb_sram_image/IMAGE_RAM/IMG_PX_PER_LINE
add wave -noupdate -expand -group Memory -label ram -expand /tb_sram_image/IMAGE_RAM/IMAGE_DUT/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {125314 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 181
configure wave -valuecolwidth 93
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
WaveRestoreZoom {22304 ps} {227498 ps}
