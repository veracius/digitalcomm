# digitalcomm

Initialize Vivado tools using the command:
source /tools/Xilinx/Vivado/2024.2/settings64.sh

Launch vivado in tcl shll mode using:
vivado -mode tcl

## Add a Module
Module files go into rtl/<filename.type>
Testbech for that module goes into tb/<filename_tb.type>
Waveform description TCL script also goes into tb/<wave_filename.tcl>
Bash script to create simulation goes into scripts/<sim_filename.sh>
Synth/Par/Build TCL scripts go into scripts, e.g. <synth/synth_filename_tb.tcl>]

### Testbench Simulation Scripts and details.
Scripts should be written for and run from the top level directory of the project.  

Test bench simulation runs a behavioral simulation in XSIM separate from Vivado Synthesis. Uses a BASH script to create a working directory. Import the module and testbench files using xvlog or xvhdl (for verilog and vhdl respectively), generate the netlists using xelab, then launch using xsim. The working directory should not be version controlled. Remember to chmod +x the bash script. 

Write a wave TCL script alongside the testbench and pass that to xsim as an argument to add waves to the screen and launch the run.  