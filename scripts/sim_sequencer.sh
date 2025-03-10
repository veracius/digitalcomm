#!/bin/bash

projectTopDir=$(pwd)
mkdir sim_work
mkdir ./sim_work/sim_sequencer
cd ./sim_work/sim_sequencer
xvlog $projectTopDir/rtl/sequencer.v
xvlog $projectTopDir/tb/sequencer_tb.v
xelab -debug typical sequencer_tb -s sequencer_sim
xsim sequencer_sim -gui -t $projectTopDir/tb/wave_sequencer.tcl
