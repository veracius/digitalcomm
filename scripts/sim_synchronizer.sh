projectTopDir=$(pwd)
mkdir sim_work
mkdir ./sim_work/sim_synchronizer
cd ./sim_work/sim_synchronizer
xvlog $projectTopDir/rtl/synchronizer.v
xvlog $projectTopDir/tb/synchronizer_tb.v
xelab -debug typical synchronizer_tb -s synchronizer_sim
xsim synchronizer_sim -gui -t $projectTopDir/tb/wave_synchronizer.tcl
