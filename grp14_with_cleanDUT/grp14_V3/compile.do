vlog *.vp
vlog *.v
vlog -sv project.if_finalizing.sv
vlog -sv params.sv
vlog -sv param_mod.sv
vlog -sv Instruction.sv
vlog -sv Generator.sv
vlog -sv Driver.sv
vlog -sv Environment.sv
vlog -sv project.LC3_testbench.sv
vlog -sv project.test_top.sv
vlog -sv fetchj2.sv
vlog -sv decodeblock.sv
vlog -sv executeblock.sv
vlog -sv writeback.sv
vlog -sv MemAccess_GoldRef.sv
vlog -sv CON_scoreboard.sv
vlog -sv Coverage.sv
vsim -coverage -novopt -sv_seed 4983886 LC3_test_top
log -r /*


