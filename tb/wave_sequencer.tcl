add_wave -radix bin {{/sequencer_tb/clk_500M}} {{/sequencer_tb/rst}} {{/sequencer_tb/dataOut}}
run all
save_wave_config {/home/f/Documents/projects-local/digitalcomm/sim_sequencer/sequencer_sim.wcfg}
