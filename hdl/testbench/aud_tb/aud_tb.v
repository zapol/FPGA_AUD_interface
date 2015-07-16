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

assign aud_data 	= 	aud_data_oe 	? aud_data_o 	: 4'bZZZZ;
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

task automatic wb_read_verify;
	input [31:0] addr;
	input [31:0] data;
	begin
	$display ("Read started @ %d", $time);
		@(posedge clk_sys) begin
			wb_adr_o <= addr;
			wb_we_o <= 0;
			wb_stb_o <= 1;
		end
		@(posedge clk_sys)
		@(posedge clk_sys)
			if(data != wb_dat_i) $display( "WB read failed @ %d => expected %8h, got %8h", $time, data, wb_dat_i );
	end
endtask

task automatic wb_read;
	input [31:0] addr;
	input verbose;
	begin
	$display ("Read started @ %d", $time);
		@(posedge clk_sys) begin
			wb_adr_o <= addr;
			wb_we_o <= 0;
			wb_stb_o <= 1;
		end
		@(posedge clk_sys)
		@(posedge clk_sys)
			if(verbose) $display( "WB read  @ %d =>  got %8h", $time, wb_dat_i );
	end
endtask

task aud_write_sys;
	input [3:0] data;
	begin
		@(posedge clk_sys) aud_data_o <= data;
	end
endtask

task aud_write_aud;
	input [3:0] data;
	begin
		@(posedge aud_ck) aud_data_o <= data;
	end
endtask

task aud_rmm_write;
	input [31:0] data;
	begin
	$display ("AUD sending starts @ %d", $time);

	aud_write_sys(4'h0);
	aud_data_oe <= 1;

	aud_write_sys(4'h0);
	aud_write_sys(4'h1);
	aud_write_sys(4'h1);
	aud_write_sys(data[3:0]);
	aud_write_sys(data[7:4]);
	aud_write_sys(data[11:8]);
	aud_write_sys(data[15:12]);
	aud_write_sys(data[19:16]);
	aud_write_sys(data[23:20]);
	aud_write_sys(data[27:24]);
	aud_write_sys(data[31:28]);
	@(posedge clk_sys) aud_data_oe <= 0;
	if( U_AudCore.rmm_data_o != data)
		$display ("RMM data received incorrectly @ %d => expected %8h, got %8h", $time, data, U_AudCore.rmm_data_o);
	end
endtask

task aud_btm_write;
	input [31:0] data;
	input [1:0] len;
	input [2:0] real_len;

	begin
	$display ("AUD BTM sending starts @ %d", $time);


	aud_write_aud(4'b0011);
	aud_write_aud(4'b0011);
	aud_write_aud({2'b10,len});

	if(real_len>=0) aud_write_aud(data[3:0]);
	aud_nsync_o <= 0;
	if(real_len>=1) aud_write_aud(data[7:4]);
	if(real_len>=2) aud_write_aud(data[11:8]);
	if(real_len>=3) aud_write_aud(data[15:12]);
	if(real_len>=4) aud_write_aud(data[19:16]);
	if(real_len>=5) aud_write_aud(data[23:20]);
	if(real_len>=6) aud_write_aud(data[27:24]);
	if(real_len>=7) aud_write_aud(data[31:28]);
	@(posedge aud_ck) aud_nsync_o <= 1;
	end
endtask

task aud_receive_verify;
	input [31:0] data;
	begin
	$display ("AUD receiving starts @ %d", $time);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[3:0])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[3:0], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[7:4])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[7:4], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[11:8])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[11:8], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[15:12])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[15:12], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[19:16])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[19:16], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[23:20])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[23:20], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[27:24])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[27:24], aud_data[3:0]);
	@(posedge clk_sys) #1 if( aud_data[3:0] != data[31:28])
		$display ("RMM data chunk sent incorrectly @ %d => expected %1h, got %1h", $time, data[31:28], aud_data[3:0]);
	@(posedge clk_sys)
	@(posedge clk_sys) begin
		aud_data_oe <= 1;
		aud_data_o <= 4'h0;
	end
	@(posedge clk_sys)
	@(posedge clk_sys) aud_data_o <= 4'h1;
	@(posedge clk_sys)
	@(posedge clk_sys) aud_data_oe <= 0;
	end
endtask

task wb_endcycle;
	@(posedge clk_sys) begin
		wb_stb_o <= 0;
	end
endtask


initial begin

	// RMM write test
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
	#120 aud_receive_verify(32'H00010001);
	#110 aud_receive_verify(32'H00020002);
	#110 aud_receive_verify(32'H00030003);
	#110 aud_receive_verify(32'H00040004);

	#100
	// RMM read test
	// #1 wb_write(`ADDR_REG_CSR, 32'H00000009);
	// #1 wb_write(`ADDR_REG_CSR, 32'H00000001);
	#1 wb_write(`ADDR_REG_RMM_ADDR, 32'hDEADBEEF);
	#1 wb_write(`ADDR_REG_RMM_LEN, 32'D4);
	#1 wb_write(`ADDR_REG_CSR, 32'H00000005);
	#1 wb_endcycle();
	#130 aud_rmm_write(32'h01234567);
	#130 aud_rmm_write(32'h89abcdef);
	#130 aud_rmm_write(32'hDEADBEEF);
	#130 aud_rmm_write(32'hbeefdeaf);

	fork
	#10 wb_read_verify(`ADDR_REG_RMM_DATA,32'h01234567);
	#20 wb_read_verify(`ADDR_REG_RMM_DATA,32'h89abcdef);
	#30 wb_read_verify(`ADDR_REG_RMM_DATA,32'hDEADBEEF);
	#40 wb_read_verify(`ADDR_REG_RMM_DATA,32'hbeefdeaf);
	#50	wb_endcycle();
	join

	// BTM test
	#1 wb_write(`ADDR_REG_CSR, 32'H00000008);
	#1 wb_write(`ADDR_REG_CSR, 32'H00000000);
	aud_ck_oe <= 1;
	aud_nsync_oe <= 1;
	aud_data_o <= 4'b0011;
	aud_data_oe <= 1;
	aud_nsync_o <= 1;
	#1 wb_endcycle();

	aud_btm_write(32'h01234567, 2'b11, 3'h7);
	aud_btm_write(32'h89abcdef, 2'b11, 3'h6);
	aud_btm_write(32'hDEADBEEF, 2'b10, 3'h3);
	aud_btm_write(32'hbeefdeaf, 2'b11, 3'h3);

	#20
	fork
	#10 wb_read(`ADDR_REG_BTF,1);
	#20 wb_read_verify(`ADDR_REG_BAF,32'h01234567);
	#30 wb_read(`ADDR_REG_BTF,1);
	#40 wb_read_verify(`ADDR_REG_BAF,32'h09abcdef);
	#50 wb_read(`ADDR_REG_BTF,1);
	#60 wb_read_verify(`ADDR_REG_BAF,32'h0123BEEF);
	#70 wb_read(`ADDR_REG_BTF,1);
	#80 wb_read_verify(`ADDR_REG_BAF,32'h0123deaf);
	#90	wb_endcycle();
	join
	// aud_write_aud(4'b0011);
	// aud_data_oe <= 1;
	// aud_write_aud(4'b0011);
	// aud_write_aud(4'b0011);
	// aud_write_aud(4'b0011);

	// aud_write_aud(4'b1011);
	// aud_nsync_o <= 0;
	// aud_write_aud(4'h1);
	// aud_write_aud(4'h2);
	// aud_write_aud(4'h3);
	// aud_write_aud(4'h4);
	// aud_write_aud(4'h5);
	// aud_write_aud(4'h6);
	// aud_write_aud(4'h7);
	// aud_write_aud(4'h8);

end

endmodule