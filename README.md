# digitalcomm
Attempt to create a basic communication system. The original intent of some of these modules is to be used in an actual hardware system, running at 500MHz for the digital logic and modulation occuring external to the digital chip, in circuitry onto carrier waves. 
A more academic design was taken for the initial build, which is why everything is in a single chip (currently targeting the ARTYA7-35)

```
┌────────────┐  ┌────────┐  ┌────────────┐  ┌─────────┐          
│ Sequence   │  │Encoder │  │CDC         │  │Digital  ┼──►Channel
│ Generator  ┼─►│        ┼─►│Synchronizer┼─►│Modulator│          
└────────────┘  └────────┘  └────────────┘  └─────────┘          
                                                                 
                                                                 
           ┌───────────┐    ┌───────┐                            
Channel───►│Digital    │    │Decoder│                            
           │Demodulator┼───►│       ├──►                         
           └───────────┘    └───────┘                            
```
Plan to use the switch as reset signal; eventually pipe decoder output to LEDs or an LCD screen to visualize constellation. Currently planning to run Digital Modulator inside the FPGA at high speed (500M); the rest of the logic will run relatively slowly (50M). This allows for 10 samples to be egested per low speed clock period. This isn't a physically "feasible" (Nyquist would not be happy), but is more for practice. In actual hardware system I would like to implement most of the modulation in circuits, using clock generator chips on the Tx side to generate high frequency carrier waves and corresponding circuitry on the Rx side to pull out the relative magnitude (some kind of basis detector, not sure how much of the MAP/ML would break down into digital vs analog sides).  

Currently, most of the Tx side is simulated. The Digital Modulator has bugs I'm still working out--seems to be an issue with computation of the /phi_i samples.
The Rx side isn't implemented at all. 

Modules are generally have registered output.

Future:
- [ ] Finish Digital Modulator
  - [ ] Check basis functions
- [ ] Synth-check
- [ ] Constrain (pins and timing: clocks, IO, CDC) & check Synth
- [ ] PAR
- [ ] Bistream + test on HW

## Modules
Everything uses an active high reset.
- Sequence Generator: PRBS31. 5 LSbs taken as message.
- Encoder: Borderline trivial. Takes 5 bit message and converts it into 3-component basis vector (4x4x2), by splitting bits.
- CDC Synchronizer: A recirculation mux synchronizer. Adds a couple clock delay on the high speed side as the control signal propogates through the synchronizer regs. Also has an extra register on the low speed input; this is potentially redundant since the previous module in the chain (currently) has registered outputs.
- Digital Modulator: Mostly design/hdl practice, since it doesn't sample fast enough. Currently set to run at 10x the symbol rate (10 samples per symbol). Uses basis functions (1/3)sinc(t)sin(2PI(t)), (1/3)sinc(t)sin(2PI(t)+PI/2), (1/3)sinc(t)sin(2PI(t)-PI/2). (Not *certain* they are orthogonal, but I'm pretty sure the first two are what QAM uses. Need to check the math on that). Uses samples of the functions to compute phi_i, then sums those values to compute output sample approximation of channel waveform. Currently bugged; computation isn't working properly in sim.

- Demod & Decoder: todo. Would like to try ML and MAP.


## Environment Setup
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
