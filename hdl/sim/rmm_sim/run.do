vlib work

vlog -reportprogress 300 -work work ../../rtl/aud_core/aud_rmm.v
vlog -reportprogress 300 -work work ../../testbench/rmm_tb/rmm_tb.v

vsim -voptargs="+acc" -debugdb -lib work work.rmm_tb

log -r /*

# add wave *
do wave.do

run 1000 ns
