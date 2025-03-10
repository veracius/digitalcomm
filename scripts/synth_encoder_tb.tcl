#Add the files, synthesis encoder and encoder testbench

#First remove files, in case they changed
remove_files [get_files]

#Add HDL Source files
read_verilog [glob ./rtl/encoder.v]
read_verilog [glob ./tb/encoder_tb.v]

synth_design -top encoder_tb -part $partnumber
write_checkpoint -force $outputdir/post_synth.dcp
report_timing_summary -file $outputdir/post_synth_timing_summary.rpt
report_utilization -file $outputdir/post_synth_util.rpt