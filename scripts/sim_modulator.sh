projectTopDir=$(pwd)
mkdir sim_work
mkdir ./sim_work/sim_modulator
cp ./vec/basis0.mem ./sim_work/sim_modulator/basis0.mem
cp ./vec/basis1.mem ./sim_work/sim_modulator/basis1.mem
cp ./vec/basis2.mem ./sim_work/sim_modulator/basis2.mem
cd ./sim_work/sim_modulator
xvlog $projectTopDir/rtl/modulator.v
xvlog $projectTopDir/tb/modulator_tb.v
xelab -debug typical modulator_tb -s modulator_sim
xsim modulator_sim -gui -t $projectTopDir/tb/wave_modulator.tcl
