#add wave -r /*

add wave -noupdate -radix hexadecimal /btm_tb/aud_data
add wave -noupdate /btm_tb/aud_ck
add wave -noupdate /btm_tb/aud_nsync
add wave -noupdate -radix hexadecimal /btm_tb/br_addr
add wave -noupdate /btm_tb/addr_valid
add wave -noupdate /btm_tb/oe
add wave -noupdate /btm_tb/rst
add wave -noupdate /btm_tb/buserror

add wave -noupdate -radix hexadecimal /btm_tb/U_AudBtm/last_good_addr
add wave -noupdate -radix hexadecimal /btm_tb/U_AudBtm/rcv_addr
add wave -noupdate -radix hexadecimal /btm_tb/U_AudBtm/br_addr_reg
add wave -noupdate -radix unsigned /btm_tb/U_AudBtm/rcv_cnt
add wave -noupdate /btm_tb/U_AudBtm/mode

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2394 ns} 0}
configure wave -namecolwidth 268
configure wave -valuecolwidth 116
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
