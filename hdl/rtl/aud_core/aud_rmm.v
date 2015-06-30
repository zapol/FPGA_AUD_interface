
`define FSM_SIZE 			4
`define IDLE 				4'b0000
`define WRITE_CMD			4'b0001
`define WRITE_ADDR			4'b0011
`define WRITE_DATA			4'b0111
`define WRITE_DIR_SWITCH	4'b0101
`define WRITE_WAIT_DONE		4'b1101
`define WRITE_DONE			4'b1001
`define READ_CMD			4'b0010
`define READ_ADDR			4'b0110
`define READ_DIR_SWITCH		4'b0100
`define READ_WAIT_READY		4'b1100
`define READ_READY			4'b1110
`define READ_DATA			4'b1010
`define READ_DONE			4'b1000

module aud_rmm(
	rst,
	addr,
	data,
	size,
	we,
	re,
	err,
	done,
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
output done;
inout [3:0] aud_data;
input aud_ck;
output aud_nsync;

reg [`FSM_SIZE-1:0] state;
reg [31:0] data_reg;
reg [31:0] addr_reg;
reg [3:0] aud_data_reg;
reg [1:0] size_reg;
reg data_oe;
reg aud_data_oe;
reg err_reg,done_reg,aud_nsync_reg;
reg [2:0] counter;

assign data = data_oe ? data_reg : 32'hZZZZZZZZ;
assign aud_data = aud_data_oe ? aud_data_reg : 4'hZ;
assign err = err_reg;
assign aud_nsync = aud_nsync_reg;
assign done = done_reg;

always @(posedge aud_ck or posedge rst) begin
	if (rst) begin
		state <= 0;
		data_reg <= 0;
		aud_data_oe <= 0;
		err_reg <= 0;
		done_reg <= 0;
		aud_nsync_reg <= 1;
	end
	else begin
		case (state)
			`IDLE: begin
				data_oe <= 0;
				done_reg <= 0;
				err_reg <= 0;
				if (we) begin
					aud_data_oe <= 1;
					aud_data_reg <= 4'b0000;
					data_reg <= data;
					addr_reg <= addr;
					size_reg <= size;
					aud_nsync_reg <= 0;
					state <= `WRITE_CMD;
				end else if (re) begin
					aud_data_oe <= 1;
					aud_data_reg <= 4'b0000;
					data_reg <= 0;
					addr_reg <= addr;
					size_reg <= size;
					aud_nsync_reg <= 0;
					state <= `READ_CMD;
				end else begin
					aud_data_oe <= 0;
					aud_nsync_reg <= 1;
				end
			end
			`WRITE_CMD: begin
				aud_data_reg[3:2] <= 2'b11;
				aud_data_reg[1:0] <= size_reg[1:0];
				counter <= 0;
				state <= `WRITE_ADDR;
				end
			`WRITE_ADDR: begin		
				case (counter)
					0: begin
						aud_data_reg[3:0] <= addr_reg[3:0];
					end
					1: begin
						aud_data_reg[3:0] <= addr_reg[7:4];
					end
					2: begin
						aud_data_reg[3:0] <= addr_reg[11:8];
					end
					3: begin
						aud_data_reg[3:0] <= addr_reg[15:12];
					end
					4: begin
						aud_data_reg[3:0] <= addr_reg[19:16];
					end
					5: begin
						aud_data_reg[3:0] <= addr_reg[23:20];
					end
					6: begin
						aud_data_reg[3:0] <= addr_reg[27:24];
					end
					7: begin
						aud_data_reg[3:0] <= addr_reg[31:28];
					end
				endcase
				if(counter == 7) begin
					counter <= 0;
					state <= `WRITE_DATA;
				end	else begin
					counter <= counter+1;
				end
			end
			`WRITE_DATA: begin		
				case (counter)
					0: begin
						aud_data_reg[3:0] <= data_reg[3:0];
					end
					1: begin
						aud_data_reg[3:0] <= data_reg[7:4];
					end
					2: begin
						aud_data_reg[3:0] <= data_reg[11:8];
					end
					3: begin
						aud_data_reg[3:0] <= data_reg[15:12];
					end
					4: begin
						aud_data_reg[3:0] <= data_reg[19:16];
					end
					5: begin
						aud_data_reg[3:0] <= data_reg[23:20];
					end
					6: begin
						aud_data_reg[3:0] <= data_reg[27:24];
					end
					7: begin
						aud_data_reg[3:0] <= data_reg[31:28];
					end
				endcase
				if(counter == (2<<size_reg)-1) begin
					counter <= 0;
					state <= `WRITE_DIR_SWITCH;
				end else begin
					counter <= counter+1;
				end
			end
			`WRITE_DIR_SWITCH: begin
				aud_data_oe <= 0;
			end
			`WRITE_DONE: begin
				aud_nsync_reg <= 1;
				done_reg <= 1;
				state <= `IDLE;
			end
			`READ_CMD: begin
				aud_data_reg[3:2] <= 2'b10;
				aud_data_reg[1:0] <= size_reg[1:0];
				counter <= 0;
				state <= `READ_ADDR;
			end
			`READ_ADDR: begin		
				case (counter)
					0: begin
						aud_data_reg[3:0] <= addr_reg[3:0];
					end
					1: begin
						aud_data_reg[3:0] <= addr_reg[7:4];
					end
					2: begin
						aud_data_reg[3:0] <= addr_reg[11:8];
					end
					3: begin
						aud_data_reg[3:0] <= addr_reg[15:12];
					end
					4: begin
						aud_data_reg[3:0] <= addr_reg[19:16];
					end
					5: begin
						aud_data_reg[3:0] <= addr_reg[23:20];
					end
					6: begin
						aud_data_reg[3:0] <= addr_reg[27:24];
					end
					7: begin
						aud_data_reg[3:0] <= addr_reg[31:28];
					end
				endcase
				if(counter == 7) begin
					counter <= 0;
					state <= `READ_DIR_SWITCH;
				end	else begin
					counter <= counter+1;
				end
			end
			`READ_DIR_SWITCH: begin
				aud_data_oe <= 0;
			end
			`READ_READY: begin
				aud_nsync_reg <= 1;
				if(err_reg)
					done_reg <= 1;
			end
			`READ_DONE: begin
				done_reg <= 1;
				state <= `IDLE;
			end
		endcase
	end
end

always @(negedge aud_ck ) begin
	case(state)
		`WRITE_DIR_SWITCH: begin
			if(aud_data_oe == 0)
				state <= `WRITE_WAIT_DONE;
		end
		`WRITE_WAIT_DONE: begin
			if ( aud_data[0] ) begin
				state <= `WRITE_DONE;
			end
			if ( aud_data[3:1]!=0 ) begin
				err_reg <= 1;
			end
		end
		`READ_DIR_SWITCH: begin
			if(aud_data_oe == 0) begin
				state <= `READ_WAIT_READY;
			end
		end
		`READ_WAIT_READY: begin
			if ( aud_data[0] ) begin
				state <= `READ_READY;
			end
			if ( aud_data[3:1]!=0 ) begin
				err_reg <= 1;
			end
		end
		`READ_READY: begin
			if ( err_reg ) begin
				state <= `IDLE;
			end else begin
				counter <= 0;
				state <= `READ_DATA;
			end
		end		
		`READ_DATA: begin		
			case (counter)
				0: begin
					data_reg[3:0] <= aud_data[3:0];
				end
				1: begin
					data_reg[7:4] <= aud_data[3:0];
				end
				2: begin
					data_reg[11:8] <= aud_data[3:0];
				end
				3: begin
					data_reg[15:12] <= aud_data[3:0];
				end
				4: begin
					data_reg[19:16] <= aud_data[3:0];
				end
				5: begin
					data_reg[23:20] <= aud_data[3:0];
				end
				6: begin
					data_reg[27:24] <= aud_data[3:0];
				end
				7: begin
					data_reg[31:28] <= aud_data[3:0];
				end
			endcase
			if(counter == (2<<size_reg)-1) begin
				state <= `READ_DONE;
				data_oe <= 1;
			end else begin
				counter <= counter+1;
			end
		end
	endcase
end
endmodule
