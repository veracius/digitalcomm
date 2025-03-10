add_wave -radix bin {{/synchronizer_tb/clk_100M}} {{/synchronizer_tb/clk_500M}} {{/synchronizer_tb/rst}} {{/synchronizer_tb/dataIn}} {{/synchronizer_tb/dataOut}}
run all
save_wave_config {/home/f/Documents/projects-local/digitalcomm/sim_synchronizer/synchronizer_sim.wcfg}
