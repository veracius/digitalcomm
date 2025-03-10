add_wave -radix bin {{/encoder_tb/clk_500M}} {{/encoder_tb/rst}} {{/encoder_tb/dataIn}} {{/encoder_tb/x0}} {{/encoder_tb/x1}} {{/encoder_tb/x2}} 
run all
save_wave_config {/home/f/Documents/projects-local/digitalcomm/sim_encoder/encoder_sim.wcfg}