module aud_core (
	// system/FIFO clock 
	clk_sys_i,

	// AUD interface byte clock
	clk_aud_i,
	
	rst_n_i,

	// AUD signals
	aud_data;
	aud_nrst_o;
	aud_md_o;
	aud_ck;
	aud_nsync_o;

	// Host control registers (WBv4 pipelined, clk_sys_i clock domain)
	wb_adr_i,
	wb_dat_i,
	wb_dat_o,
	wb_sel_i,
	wb_cyc_i,
	wb_stb_i,
	wb_we_i,
	wb_ack_o,
	wb_stall_o
);

parameter g_aud_fifo_len = 16;

input clk_sys_i,clk_aud_i,rst_n_i;

inout [3:0] aud_data;
output aud_nrst_o, aud_md_o, aud_nsyns_o;
inout aud_ck;

// Host control registers (WBv4 pipelined, clk_sys_i clock domain)
input	[31:0]	wb_adr_i;
input	[31:0]	wb_dat_i;
output	[31:0]	wb_dat_o;
input	[3:0]	wb_sel_i;
input			wb_cyc_i, wb_stb_i, wb_we_i;
output			wb_ack_o, wb_stall_o;
