vlib work

vlog -reportprogress 300 -work work ../../rtl/aud_core/aud_btm.v
vlog -reportprogress 300 -work work ../../testbench/btm_tb/btm_tb.v

vsim -voptargs="+acc" -debugdb -lib work work.btm_tb

log -r /*

# add wave *
do wave.do

run 1000 ns
