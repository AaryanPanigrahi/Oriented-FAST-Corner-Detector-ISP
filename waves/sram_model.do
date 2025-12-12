onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group PARAMS -label ADDR_WIDTH -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/ADDR_WIDTH
add wave -noupdate -expand -group PARAMS -label DATA_WIDTH -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/DATA_WIDTH
add wave -noupdate -expand -group PARAMS -label RAM_IS_SYNCHRONOUS -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/RAM_IS_SYNCHRONOUS
add wave -noupdate -expand -group PARAMS -label DUAL -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/DUAL
add wave -noupdate -expand -group Sync -label ramclk -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/ramclk
add wave -noupdate -expand -group Control -label addr -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/addr
add wave -noupdate -expand -group Control -label addr_write -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/addr_write
add wave -noupdate -expand -group Control -label wen -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/wen
add wave -noupdate -expand -group Control -label ren -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/ren
add wave -noupdate -expand -group IO -label wdat -radix hexadecimal -radixshowbase 0 /tb_sram_model/DUT/wdat
add wave -noupdate -expand -group IO -label rdat -radix hexadecimal -radixshowbase 0 /tb_sram_model/DUT/rdat
add wave -noupdate -expand -group Memory -label ram -radix unsigned -radixshowbase 0 /tb_sram_model/DUT/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68518 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 152
configure wave -valuecolwidth 85
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
WaveRestoreZoom {0 ps} {1891098 ps}
