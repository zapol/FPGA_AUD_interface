#add wave -r /*

add wave -noupdate /rmm_tb/rst
add wave -noupdate -radix hexadecimal /rmm_tb/addr
add wave -noupdate -radix hexadecimal /rmm_tb/data
add wave -noupdate -radix hexadecimal /rmm_tb/data_reg
add wave -noupdate /rmm_tb/data_oe
add wave -noupdate -radix hexadecimal /rmm_tb/size
add wave -noupdate /rmm_tb/we
add wave -noupdate /rmm_tb/re
add wave -noupdate -radix hexadecimal /rmm_tb/aud_data
add wave -noupdate -radix hexadecimal /rmm_tb/aud_data_reg
add wave -noupdate /rmm_tb/aud_data_oe
add wave -noupdate /rmm_tb/aud_ck
add wave -noupdate /rmm_tb/err
add wave -noupdate /rmm_tb/done
add wave -noupdate /rmm_tb/aud_nsync
add wave -noupdate /rmm_tb/U_AudRmm/rst
#add wave -noupdate /rmm_tb/U_AudRmm/aud_data
add wave -noupdate /rmm_tb/U_AudRmm/state
add wave -noupdate -radix unsigned /rmm_tb/U_AudRmm/counter
#add wave -noupdate -radix hexadecimal /rmm_tb/U_AudRmm/size_reg
add wave -noupdate -radix hexadecimal /rmm_tb/U_AudRmm/addr_reg
add wave -noupdate /rmm_tb/U_AudRmm/data_oe
add wave -noupdate -radix hexadecimal /rmm_tb/U_AudRmm/data_reg
add wave -noupdate /rmm_tb/U_AudRmm/aud_data_oe
add wave -noupdate -radix hexadecimal /rmm_tb/U_AudRmm/aud_data_reg

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
