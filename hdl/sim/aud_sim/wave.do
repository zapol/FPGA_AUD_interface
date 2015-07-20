#add wave -r /*

add wave -noupdate -group TB /aud_tb/clk_sys
add wave -noupdate -group TB /aud_tb/rst_n
add wave -noupdate -group TB -radix hexadecimal /aud_tb/aud_data_o
add wave -noupdate -group TB /aud_tb/aud_data_oe
add wave -noupdate -group TB /aud_tb/aud_ck_o
add wave -noupdate -group TB /aud_tb/aud_ck_oe
add wave -noupdate -group TB /aud_tb/aud_nsync_o
add wave -noupdate -group TB /aud_tb/aud_nsync_oe
add wave -noupdate -group TB -radix hexadecimal /aud_tb/wb_adr_o
add wave -noupdate -group TB -radix hexadecimal /aud_tb/wb_dat_o
add wave -noupdate -group TB /aud_tb/wb_stb_o
add wave -noupdate -group TB /aud_tb/wb_we_o
add wave -noupdate -group TB -radix hexadecimal /aud_tb/wb_dat_i
add wave -noupdate -group TB /aud_tb/wb_ack_i
add wave -noupdate -group TB -radix hexadecimal /aud_tb/aud_data
add wave -noupdate -group TB /aud_tb/aud_ck
add wave -noupdate -group TB /aud_tb/aud_nsync
add wave -noupdate -group TB /aud_tb/aud_nrst
add wave -noupdate -group TB /aud_tb/aud_md
add wave -noupdate -group AUD /aud_tb/U_AudCore/clk_sys_i
add wave -noupdate -group AUD /aud_tb/U_AudCore/rst_n_i
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/aud_data
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_rst
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_rst
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_rst_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_rst
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_nrst
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_md
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_nsync
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_ck
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_idle
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/wb_adr_i
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/wb_dat_i
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/wb_dat_o
add wave -noupdate -group AUD /aud_tb/U_AudCore/wb_stb_i
add wave -noupdate -group AUD /aud_tb/U_AudCore/wb_we_i
add wave -noupdate -group AUD /aud_tb/U_AudCore/wb_ack_o
#add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_rmm_ck
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_rmm_nsync
#add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_btm_ck
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_btm_nsync
#add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/aud_rmm_data
#add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/aud_btm_data
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_err
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/rmm_data_i
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/rmm_data_o
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/btm_addr_o
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/rmm_addr_reg
add wave -noupdate -group AUD -radix unsigned /aud_tb/U_AudCore/rmm_len_reg
#add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_md_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_md_tmp_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_re_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/aud_we_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_we_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_re_reg
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_err_reg
#add wave -noupdate -group AUD /aud_tb/U_AudCore/wb_ack_reg
#add wave -noupdate -group AUD /aud_tb/U_AudCore/wb_ack_reg_d
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_fovf
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_fund
add wave -noupdate -group AUD /aud_tb/U_AudCore/btmfifo_re
add wave -noupdate -group AUD /aud_tb/U_AudCore/btmfifo_re_reg_wb
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_fovf
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_fund
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_we
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_we_reg_wb
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_we_reg_rmm
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_re
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_re_reg_wb
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmmfifo_re_reg_rmm
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_ff
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_fe
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_ff
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_fe
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/rmmfifo_dat_o
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/btmfifo_dat_o
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/rmmfifo_dat_i
add wave -noupdate -group AUD -radix hexadecimal /aud_tb/U_AudCore/btmfifo_dat_i
add wave -noupdate -group AUD -radix unsigned /aud_tb/U_AudCore/timer_reg
add wave -noupdate -group AUD -radix unsigned /aud_tb/U_AudCore/btmfifo_count_o
add wave -noupdate -group AUD -radix unsigned /aud_tb/U_AudCore/rmmfifo_count_o
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_idle_prev
add wave -noupdate -group AUD /aud_tb/U_AudCore/rmm_idle
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_oe_o
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_addrvalid_o
add wave -noupdate -group AUD /aud_tb/U_AudCore/btm_buserror_o
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/clk_i
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/rst_i
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/addr_i
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/data_i
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/data_o
add wave -noupdate -group RMM -radix unsigned /aud_tb/U_AudCore/U_AudRmm/size_i
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/we_i
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/re_i
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/err_o
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/idle_o
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/aud_data
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/aud_nsync_o
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/state
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/data_reg
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/addr_reg
add wave -noupdate -group RMM -radix hexadecimal /aud_tb/U_AudCore/U_AudRmm/aud_data_reg
add wave -noupdate -group RMM -radix unsigned /aud_tb/U_AudCore/U_AudRmm/size_reg
add wave -noupdate -group RMM /aud_tb/U_AudCore/U_AudRmm/aud_data_oe
add wave -noupdate -group RMM -radix unsigned /aud_tb/U_AudCore/U_AudRmm/counter
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/rst
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/br_addr
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/oe
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/addr_valid
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/buserror
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/aud_data
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/aud_ck
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/aud_nsync
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/last_good_addr
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/rcv_addr
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/br_addr_reg
add wave -noupdate -group BTM -radix unsigned /aud_tb/U_AudCore/U_AudBtm/rcv_cnt
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/mode
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/oe_reg
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/oe_reg_d
add wave -noupdate -group BTM -radix hexadecimal /aud_tb/U_AudCore/U_AudBtm/addr_valid_reg
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/buserror_reg
add wave -noupdate -group BTM /aud_tb/U_AudCore/U_AudBtm/busserror
add wave -noupdate -group BTMFIFO /aud_tb/U_AudCore/U_BtmFifo/rst
add wave -noupdate -group BTMFIFO /aud_tb/U_AudCore/U_BtmFifo/we_i
add wave -noupdate -group BTMFIFO /aud_tb/U_AudCore/U_BtmFifo/re_i
add wave -noupdate -group BTMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_BtmFifo/data
add wave -noupdate -group BTMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_BtmFifo/dat_i
add wave -noupdate -group BTMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_BtmFifo/dat_o
add wave -noupdate -group BTMFIFO -radix unsigned /aud_tb/U_AudCore/U_BtmFifo/count_o
add wave -noupdate -group BTMFIFO -radix unsigned /aud_tb/U_AudCore/U_BtmFifo/rPtr
add wave -noupdate -group BTMFIFO -radix unsigned /aud_tb/U_AudCore/U_BtmFifo/wPtr
add wave -noupdate -group RMMFIFO /aud_tb/U_AudCore/U_RmmFifo/rst
add wave -noupdate -group RMMFIFO /aud_tb/U_AudCore/U_RmmFifo/we_i
add wave -noupdate -group RMMFIFO /aud_tb/U_AudCore/U_RmmFifo/re_i
add wave -noupdate -group RMMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_RmmFifo/data
add wave -noupdate -group RMMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_RmmFifo/dat_i
add wave -noupdate -group RMMFIFO -radix hexadecimal /aud_tb/U_AudCore/U_RmmFifo/dat_o
add wave -noupdate -group RMMFIFO -radix unsigned /aud_tb/U_AudCore/U_RmmFifo/count_o
add wave -noupdate -group RMMFIFO -radix unsigned /aud_tb/U_AudCore/U_RmmFifo/rPtr
add wave -noupdate -group RMMFIFO -radix unsigned /aud_tb/U_AudCore/U_RmmFifo/wPtr

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
