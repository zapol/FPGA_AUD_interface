vlib work

vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../rtl/aud_core/aud_btm.v
vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../rtl/aud_core/aud_rmm.v
vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../rtl/aud_core/afifo.v
vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../rtl/aud_core/aud_defs.vh
vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../rtl/aud_core/aud_core.v
vlog -reportprogress 300 -work work +incdir+../../rtl/aud_core ../../testbench/aud_tb/aud_tb.v

vsim -voptargs="+acc" -debugdb -lib work work.aud_tb

log -r /*

# add wave *
do wave.do

run 3000 ns
