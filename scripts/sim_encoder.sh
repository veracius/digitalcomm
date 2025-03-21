projectTopDir=$(pwd)
mkdir sim_work
mkdir ./sim_work/sim_encoder
#cp ./vec/encoder.vec ./encoder.vec
cd ./sim_work/sim_encoder
xvlog $projectTopDir/rtl/encoder.v
xvlog $projectTopDir/tb/encoder_tb.v
xelab -debug typical encoder_tb -s encoder_sim
xsim encoder_sim -gui -t $projectTopDir/tb/wave_encoder.tcl
