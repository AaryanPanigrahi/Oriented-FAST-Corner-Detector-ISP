onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Sync /tb_ComputeKernel/clk
add wave -noupdate -expand -group Sync /tb_ComputeKernel/n_rst
add wave -noupdate -expand -group Params /tb_ComputeKernel/build_kernel/sigma
add wave -noupdate -expand -group Params /tb_ComputeKernel/kernel_size
add wave -noupdate -expand -group {Input array} /tb_ComputeKernel/kernel
add wave -noupdate -expand -group {Input array} /tb_ComputeKernel/input_matrix
add wave -noupdate -expand -group Out /tb_ComputeKernel/blurred_pixel
add wave -noupdate -expand -group Out /tb_ComputeKernel/build_kernel/err
add wave -noupdate -expand -group Control /tb_ComputeKernel/start
add wave -noupdate -expand -group Control /tb_ComputeKernel/done
add wave -noupdate -expand -group Control -expand -group Clear /tb_ComputeKernel/clear
add wave -noupdate -expand -group Control -expand -group Clear /tb_ComputeKernel/clear_flag
add wave -noupdate -expand -group {Kernel Gen Control} /tb_ComputeKernel/kernel_start
add wave -noupdate -expand -group {Kernel Gen Control} /tb_ComputeKernel/kernel_done
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/start
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/done
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/end_row
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/end_column
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/cur_x
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/cur_y
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/numerator
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/quotient
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/sum
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/start_nn
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/nextDone
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/nnKernel
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/nextKernel
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/contConv
add wave -noupdate -group {Kernel Gen} /tb_ComputeKernel/build_kernel/contConv_latch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {414585 ps} 0}
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
WaveRestoreZoom {0 ps} {6651648 ps}
