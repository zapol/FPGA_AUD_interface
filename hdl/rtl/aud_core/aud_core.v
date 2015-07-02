`include "aud_defs.vh"

module aud_core (
	// system/FIFO clock 
	clk_sys_i,

	// AUD interface byte clock
	clk_aud_i,
	
	rst_n_i,

	// AUD signals
	aud_data,
	aud_nrst,
	aud_md,
	aud_ck,
	aud_nsync,

	// Host control registers (WBv4 pipelined, clk_sys_i clock domain)
	wb_adr_i,
	wb_dat_i,
	wb_dat_o,
	wb_cyc_i,
	wb_stb_i,
	wb_we_i,
	wb_ack_o,
	wb_stall_o
);

parameter g_aud_fifo_len = 16;

input clk_sys_i,clk_aud_i,rst_n_i;

inout [3:0] aud_data;
output aud_nrst, aud_md, aud_nsyns_o;
inout aud_ck;

// Host control registers (WBv4 pipelined, clk_sys_i clock domain)
input	[31:0]	wb_adr_i;
input	[31:0]	wb_dat_i;
output	[31:0]	wb_dat_o;
input	[3:0]	wb_sel_i;
input			wb_cyc_i, wb_stb_i, wb_we_i;
output			wb_ack_o, wb_stall_o;

wire clk_aud_rmm;
wire clk_aud_btm;

reg		[31:0]	aud_cr;
wire	[31:0]	aud_sr;
reg		[31:0]	aud_dr;
reg		[31:0]	aud_addr;
reg		[31:0]	aud_len;

aud_rmm U_AudRmm(
	.en(aud_cr[AUD_CR_MD],
	.start_addr_i(aud_addr),
	.len(aud_len),
	.idle(aud_rmm_idle),
	.clk_sys_i(clk_sys_i),
	.clk_aud_i(clk_aud_i),
	.rst_n_i(rst_n_i),
	.aud_data(rmm_data),
	.aud_ck(rmm_ck),
	.aud_nsync(rmm_nsync)
	);

aud_btm U_AudBtm(
	.br_addr(btm_br_addr),
	.addr_valid(btm_addr_valid),
	.oe(btm_oe),
	.rst(!rst_n_i),
	.aud_data(btm_data),
	.aud_ck(btm_ck),
	.aud_nsync(btm_nsync)
	);

aud_wb_adapter U_AudWbAdapter(
	.wb_adr_i(wb_adr_i),
	.wb_dat_i(wb_dat_i),
	.wb_dat_o(wb_dat_o),
	.wb_cyc_i(wb_cyc_i),
	.wb_stb_i(wb_stb_i),
	.wb_we_i(wb_we_i),
	.wb_ack_o(wb_ack_o),
	.wb_stall_o(wb_stall_o),
	.fifo_data_i(fifo_wb_i),
	.fifo_data_o(fifo_wb_o),
	.fifo_count_i(fifo_count_o),
	.fifo_empty_i(fifo_empty_o),
	.fifo_full_i(fifo_full_o),
	.fifo_underrun_i(fifo_underrun_o),
	.fifo_overflow_i(fifo_overflow_o),
	.fifo_wr_o(fifo_wb_wr_o),
	.fifo_rd_o(fifo_wb_rd_o),
	.aud_reset_o(aud_reset),
	.aud_enable_o(aud_enable),
	.aud_mode_o(aud_mode)
	);

aud_fifo U_AudFifo(
	)

if(!aud_cr[AUD_CR_MD]) begin 	// RAM Monitor Mode
	assign aud_sr[AUD_SR_IDLE] = aud_rmm_idle;
	assign aud_data = rmm_data;
	assign aud_nrst = rmm_nrst;
	assign aud_ck = rmm_ck;
	assign aud_nsync = rmm_nsync;
end else begin 					// Branch Trace Mode
	assign aud_sr[AUD_SR_IDLE] = aud_btm_idle;
	assign aud_data = btm_data;
	assign aud_nrst = btm_nrst;
	assign aud_ck = btm_ck;
	assign aud_nsync = btm_nsync;
end

assign aud_md = aud_cr[AUD_CR_MD];

always @(posedge clk_sys_i) begin
	if (!rst_n_i) begin
		// reset
		
	end
	else begin
		
	end
end