
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
	input wire clk_i,
	input wire rst_i,
	input wire [31:0] addr_i,
	input wire [31:0] data_i,
	output reg [31:0] data_o,
	input wire [1:0] size_i,
	input wire we_i,
	input wire re_i,
	output reg err_o,
	output reg idle_o,
	inout wire [3:0] aud_data,
	output reg aud_nsync_o
	);

reg [`FSM_SIZE-1:0] state;
reg [3:0] aud_data_reg;
reg [31:0] addr_reg;
reg [31:0] data_reg;
reg [1:0] size_reg;
reg aud_data_oe;
reg [2:0] counter;

assign aud_data = aud_data_oe ? aud_data_reg : 4'hZ;

always @(posedge we_i or re_i or posedge clk_i) begin 
	case (state)
		`IDLE: if(we_i | re_i) idle_o <= 0;
		`READ_DONE: idle_o <= 1;
		`WRITE_DONE: idle_o <= 1;
		`READ_READY: if(err_o) idle_o <= 1;
	endcase
end

always @(posedge clk_i or posedge rst_i) begin
	if (rst_i) begin
		state <= `IDLE;
		addr_reg <= 0;
		data_reg <= 0;
		data_o <= 0;
		aud_data_reg <= 0;
		aud_data_oe <= 0;
		size_reg <= 0;
		err_o <= 0;
		idle_o <= 1;
		aud_nsync_o <= 1;
		counter <= 0;
	end
	else begin
		case (state)
			`IDLE: begin
				err_o <= 0;
				if (we_i) begin
					// idle_o <= 0;
					aud_data_oe <= 1;
					aud_data_reg <= 4'b0000;
					data_reg <= data_i;
					addr_reg <= addr_i;
					size_reg <= size_i;
					aud_nsync_o <= 0;
					state <= `WRITE_CMD;
				end else if (re_i) begin
					// idle_o <= 0;
					aud_data_oe <= 1;
					aud_data_reg <= 4'b0000;
					addr_reg <= addr_i;
					size_reg <= size_i;
					aud_nsync_o <= 0;
					state <= `READ_CMD;
				end else begin
					aud_data_oe <= 0;
					aud_nsync_o <= 1;
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
				if(counter == (1<<size_reg)-1) begin
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
				aud_nsync_o <= 1;
				// idle_o <= 1;
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
				aud_nsync_o <= 1;
				// if(err_o)
				// 	idle_o <= 1;
			end
			`READ_DONE: begin
				// idle_o <= 1;
				state <= `IDLE;
			end
		endcase
	end
end

always @(negedge clk_i ) begin
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
				err_o <= 1;
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
				err_o <= 1;
			end
		end
		`READ_READY: begin
			if ( err_o ) begin
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
			if(counter == (1<<size_reg)-1) begin
				data_o[27:0] <= data_reg[27:0];
				data_o[31:28] <= aud_data[3:0];	// Ugly hack :/
				state <= `READ_DONE;
			end else begin
				counter <= counter+1;
			end
		end
	endcase
end
endmodule
