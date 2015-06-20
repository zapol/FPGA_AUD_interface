
`define MODE_4		0
`define MODE_8		1
`define MODE_16		2
`define MODE_32		3

module aud_btm (
	br_addr,
	addr_valid,
	oe,
	rst,
	buserror,
	aud_data,
	aud_ck,
	aud_nsync
);

output [31:0] br_addr;
output addr_valid;
output oe;
input rst;
input [3:0] aud_data;
input aud_ck;
input aud_nsync;

reg [31:0] last_good_addr;
reg [31:0] rcv_addr;
reg [31:0] br_addr_reg;
reg [3:0] rcv_cnt;
reg [1:0] mode;
reg oe_reg, oe_reg_d, addr_valid_reg;

assign br_addr = br_addr_reg;
assign oe = oe_reg_d;
assign addr_valid = addr_valid_reg;

always @(posedge aud_ck) begin 	// Output enable is delayed by half clock cycle to let the data settle
	oe_reg_d <= oe_reg;
end

always @(negedge aud_ck or posedge rst) begin
	if (rst) begin 	// reset
		last_good_addr <= 0;
		mode <= 0;
	end
	else begin
		if(aud_nsync) begin
			if(rcv_cnt != 0) begin
				oe_reg <= 1;
				br_addr_reg = rcv_addr;

				if(rcv_cnt == (4<<mode)) begin 				// Complete address received
					addr_valid_reg <= 1;
				end	else begin 								// Address transmission interrupted by another branch
					addr_valid_reg <= 0;
				end
			end else begin
				oe_reg <= 0;
			end

			rcv_cnt <= 0;
			rcv_addr <= last_good_addr;

			if(aud_data[3:0] == 0'b0011) begin 				// normal synchronization symbol
				buserror <= 0;
			end else if (aud_data[3:2] == 0'b10) begin 		// Start receiving 
				buserror <= 0;
				mode <= aud_data[1:0];
			end else begin 									// Invalid bus state
				buserror <= 1;
			end			
		end else begin 										// Receive next 4 bits of address
			rcv_cnt <= rcv_cnt + 1;
			rcv_addr [4*(rcv_cnt[2:0]+1):4*rcv_cnt[2:0]] <= aud_data;
		end
	end
end
