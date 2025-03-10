add_wave -radix bin {{/modulator_tb/clk_50M}} {{/modulator_tb/clk_500M}} {{/modulator_tb/rst}} {{/modulator_tb/dataIn}} {{/modulator_tb/x0}} {{/modulator_tb/x1}} {{/modulator_tb/x2}}
add_wave -radix hex {{/modulator_tb/dataOut}} 
add_wave_divider MUT
add_wave -radix hex {{/modulator_tb/modulator_mut/sample_index_reg}}
add_wave -radix bin {{/modulator_tb/modulator_mut/x0_reg}} {{/modulator_tb/modulator_mut/x1_reg}} {{/modulator_tb/modulator_mut/x2_reg}}
add_wave -radix unsigned {{/modulator_tb/modulator_mut/psi0_reg}} {{/modulator_tb/modulator_mut/psi1_reg}} {{/modulator_tb/modulator_mut/psi2_reg}} {{/modulator_tb/modulator_mut/mixed_reg}}
run all
save_wave_config {/home/f/Documents/projects-local/digitalcomm/sim_modulator/modulator_sim.wcfg}