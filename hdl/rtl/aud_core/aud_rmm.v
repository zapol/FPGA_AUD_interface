
`define FSM_SIZE 	2
`define IDLE 		2'b01

module aud_rmm U_AudRmm(
	rst,
	addr,
	data,
	size,
	we,
	re,
	err,
	idle,
	clk_sys_i,
	clk_aud_i,
	aud_data,
	aud_ck,
	aud_nsync
	);

input rst;
input [31:0] addr;
inout [31:0] data;
input [1:0] size;
input we;
input re;
output err;
output idle;
input clk_sys_i;
input clk_aud_i;
inout [3:0] aud_data;
output aud_ck;
output aud_nsync;

reg [FSM_SIZE-1:0] state;
