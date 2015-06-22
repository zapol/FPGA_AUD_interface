
module btm_tb;

reg rst;
reg [3:0] aud_data;
reg aud_ck;
reg aud_nsync;
wire [31:0] br_addr;
wire addr_valid;
wire oe;
wire buserror;

aud_btm U_AudBtm(
	.br_addr	(br_addr),
	.addr_valid	(addr_valid),
	.oe			(oe),
	.rst		(rst),
	.buserror	(buserror),
	.aud_data	(aud_data),
	.aud_ck		(aud_ck),
	.aud_nsync	(aud_nsync)
	);

initial begin
	rst 		= 0;
	aud_ck 		= 0;
	aud_nsync 	= 1;
	aud_data	= 4'b0000;
end

always begin
	#5 aud_ck = !aud_ck;	
end

initial begin
	#25 rst = 1;
	#30 rst = 0;

	#50 aud_data = 4'b0000;
	#50 aud_data = 4'b0001;
	#50 aud_data = 4'b1111;
	#50 aud_data = 4'b0011;

	// Start transmitting address (32 bits)
	#50 aud_data = 4'b1011;

	#10
	aud_data = 4'b0000;
	aud_nsync = 0;
	#10 aud_data = 4'b0001;
	#10 aud_data = 4'b0010;
	#10 aud_data = 4'b0011;
	#10 aud_data = 4'b0100;
	#10 aud_data = 4'b0101;
	#10 aud_data = 4'b0110;
	#10 aud_data = 4'b0111;
	#10
	aud_data = 4'b0011;
	aud_nsync = 1;

	// Start transmitting address (16 bits)
	#10 aud_data = 4'b1010;

	#10
	aud_data = 4'b0100;
	aud_nsync = 0;
	#10 aud_data = 4'b0101;
	#10 aud_data = 4'b0110;
	#10 aud_data = 4'b0111;
	#10
	aud_data = 4'b0011;
	aud_nsync = 1;

	// Start transmitting address (16 bits, incomplete)
	#10 aud_data = 4'b1010;

	#10
	aud_data = 4'b0000;
	aud_nsync = 0;
	#10 aud_data = 4'b0000;
	#10 aud_data = 4'b0000;
	#10
	aud_data = 4'b0011;
	aud_nsync = 1;

	// Start transmitting address (16 bits) again
	#10 aud_data = 4'b1010;

	#10
	aud_data = 4'b0100;
	aud_nsync = 0;
	#10 aud_data = 4'b0101;
	#10 aud_data = 4'b0110;
	#10 aud_data = 4'b0111;
	#10
	aud_data = 4'b0011;
	aud_nsync = 1;

end
endmodule