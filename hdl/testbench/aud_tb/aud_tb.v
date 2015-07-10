`include "../../rtl/aud_core/aud_defs.vh"

module aud_tb;

reg clk_sys, rst_n;
reg [3:0] aud_data_o;
reg aud_data_oe;
reg aud_ck_o, aud_ck_oe;
reg aud_nsync_o, aud_nsync_oe;
reg [31:0] wb_adr_o;
reg [31:0] wb_dat_o;
reg wb_stb_o;
reg wb_we_o;
wire [31:0] wb_dat_i;
wire wb_ack_i;

wire [3:0] aud_data;
wire aud_ck;
wire aud_nsync;

assign aud_data 	= 	aud_data_oe 	? aud_data_o 	: 4'hZ;
assign aud_ck 		= 	aud_ck_oe 		? aud_ck_o 		: 1'bZ;
assign aud_nsync 	= 	aud_nsync_oe 	? aud_nsync_o 	: 1'bZ;

aud_core U_AudCore (
    .clk_sys_i	(clk_sys),
    .rst_n_i	(rst_n),
    .aud_data	(aud_data),
    .aud_nrst	(aud_nrst),
    .aud_md		(aud_md),
    .aud_ck		(aud_ck),
    .aud_nsync	(aud_nsync),
    .wb_adr_i	(wb_adr_o),
    .wb_dat_i	(wb_dat_o),
    .wb_dat_o	(wb_dat_i),
    .wb_stb_i	(wb_stb_o),
    .wb_we_i	(wb_we_o),
    .wb_ack_o	(wb_ack_i)
);

initial begin
	clk_sys			<= 1;
	rst_n			<= 1;
	aud_data_o		<= 4'h0;
	aud_data_oe		<= 0;
	aud_ck_o		<= 1;
	aud_ck_oe		<= 0;
	aud_nsync_o		<= 0;
	aud_nsync_oe	<= 0;
	wb_adr_o		<= 32'h00000000;
	wb_dat_o		<= 32'h00000000;
	wb_stb_o		<= 0;
	wb_we_o			<= 0;
end

always begin
	#5 clk_sys = !clk_sys;	
end

always begin
	#7 aud_ck_o = !aud_ck_o;	
end

task wb_write;
	input [31:0] addr;
	input [31:0] data;
	@(posedge clk_sys) begin
		wb_adr_o <= addr;
		wb_dat_o <= data;
		wb_we_o <= 1;
		wb_stb_o <= 1;
	end
endtask

task wb_read;
	input [31:0] addr;
	@(posedge clk_sys) begin
		wb_adr_o <= addr;
		wb_we_o <= 0;
		wb_stb_o <= 1;
	end
endtask

task wb_endcycle;
	@(posedge clk_sys) begin
		wb_stb_o <= 0;
	end
endtask

initial begin

	#5 rst_n <= 0;
	#20 rst_n <= 1;
	#1 wb_write(`ADDR_REG_CSR, 32'H00000009);
	#1 wb_write(`ADDR_REG_CSR, 32'H00000001);
	#1 wb_write(`ADDR_REG_RMM_ADDR, 32'hDEADBEEF);
	#1 wb_write(`ADDR_REG_RMM_LEN, 32'D4);
	#1 wb_write(`ADDR_REG_RMM_DATA, 32'H00010001);
	#1 wb_write(`ADDR_REG_RMM_DATA, 32'H00020002);
	#1 wb_write(`ADDR_REG_RMM_DATA, 32'H00030003);
	#1 wb_write(`ADDR_REG_RMM_DATA, 32'H00040004);
	#1 wb_write(`ADDR_REG_CSR, 32'H00000003);
	#1 wb_endcycle();
end

initial begin
	#330
	aud_data_oe <= 1;
	aud_data_o <= 4'b0000;
	#20
	aud_data_o <= 4'b0001;
end
endmodule