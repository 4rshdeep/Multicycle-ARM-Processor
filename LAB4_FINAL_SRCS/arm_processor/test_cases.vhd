add_force {/processor/DATAPATH/mem_out} -radix hex {E3A01003 0ns}
add_force {/processor/reset} -radix hex {1 0ns}
run 200 ns
add_force {/processor/clock} -radix hex {1 0ns} {0 50000ps} -repeat_every 100000ps
run 200 ns
add_force {/processor/reset} -radix hex {0 0ns}
run 200 ns
add_wave {{/processor/DATAPATH/res_out}} 
add_wave {{/processor/DATAPATH/alu_out}} 
add_wave {{/processor/DATAPATH/mem_out}} 
add_wave {{/processor/DATAPATH/pc_final}} 
add_wave {{/processor/DATAPATH/IW}} 
run 100 ns
run 100 ns
run 100 ns
run 100 ns




add_force {/processor/DATAPATH/mem_out} -radix hex {E3A02005 0ns}
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns

add_force {/processor/DATAPATH/mem_out} -radix hex {E0823001 0ns}
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns








----------------------------------------------------------------
add_force {/processor/DATAPATH/mem_out} -radix hex {E3A01003 0ns}
add_force {/processor/reset} -radix hex {1 0ns}
run 200 ns
add_force {/processor/clock} -radix hex {1 0ns} {0 50000ps} -repeat_every 100000ps
run 200 ns
add_force {/processor/reset} -radix hex {0 0ns}
run 200 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns




add_force {/processor/DATAPATH/mem_out} -radix hex {E3A02005 0ns}
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns

add_force {/processor/DATAPATH/mem_out} -radix hex {E0823001 0ns}
run 100 ns
run 100 ns
run 100 ns
run 100 ns
run 100 ns


add_force {/processor/DATAPATH/pc_final} -radix hex {0 0ns}
add_force {/processor/DATAPATH/PW} -radix hex {1 0ns}

remove_forces { {/processor/DATAPATH/PW} }
remove_forces { {/processor/DATAPATH/pc_final} }
