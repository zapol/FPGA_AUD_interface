
module rmm_tb;

reg rst;
reg [31:0] addr;
wire [31:0] data;
reg [31:0] data_reg;
reg data_oe;
reg [1:0] size;
reg we;
reg re;
wire [3:0] aud_data;
reg [3:0] aud_data_reg;
reg aud_data_oe;
reg aud_ck;

assign data = data_oe ? data_reg : 32'hZZZZZZZZ;
assign aud_data = aud_data_oe ? aud_data_reg : 4'hZ;

aud_rmm U_AudRmm(
	.rst		(rst),
	.addr		(addr),
	.data		(data),
	.size		(size),
	.we			(we),
	.re			(re),
	.err		(err),
	.idle		(idle),
	.aud_data	(aud_data),
	.aud_ck		(aud_ck),
	.aud_nsync	(aud_nsync)
	);

initial begin
	rst 		= 0;
	addr		= 0;
	data_reg 	= 0;
	data_oe 	= 0;
	size 		= 0;
	we 			= 0;
	re 			= 0;
	aud_ck 		= 0;
	aud_data_reg= 0;
	aud_data_oe = 0;
end

always begin
	#5 aud_ck = !aud_ck;	
end

initial begin
	#15 rst = 1;
	#20 rst = 0;

	#25
	addr = 32'h01234567;
	data_oe = 1;
	data_reg = 32'h89ABCDEF;
	size = 2;
	we = 1;
	#30
	we = 0;
	#165
	aud_data_oe = 1;
	aud_data_reg = 4'b0000;
	#20
	aud_data_reg = 4'b0001;
	#20
	aud_data_oe = 0;

	#25
	addr = 32'h01234567;
	data_oe = 0;
	size = 2;
	re = 1;
	#30
	re = 0;
	#85
	aud_data_oe = 1;
	aud_data_reg = 4'b0000;
	#20
	aud_data_reg = 4'b0001;
	#20
	aud_data_reg = 4'H0;
	#10
	aud_data_reg = 4'H1;
	#10
	aud_data_reg = 4'H2;
	#10
	aud_data_reg = 4'H3;
	#10
	aud_data_reg = 4'H4;
	#10
	aud_data_reg = 4'H5;
	#10
	aud_data_reg = 4'H6;
	#10
	aud_data_reg = 4'H7;
	#10
	aud_data_oe = 0;
end
endmodule