module afifo
	#(parameter		DATA_WIDTH    = 32,
					ADDRESS_WIDTH = 4,
					FIFO_DEPTH    = (1 << ADDRESS_WIDTH))
	(
    input wire rst,
    input wire [DATA_WIDTH-1:0] dat_i,
    input wire we_i,
    input wire re_i,
    output wire [DATA_WIDTH-1:0] dat_o,
    output reg [ADDRESS_WIDTH:0] count_o
);

reg [DATA_WIDTH-1:0] data[FIFO_DEPTH-1:0];
reg [ADDRESS_WIDTH-1:0] rPtr, wPtr;

always @(posedge rst or posedge we_i or posedge re_i) begin
	if(rst) begin
		data[0] <= 0;
		rPtr <= 0;
		wPtr <= 0;
		count_o <= 0;		
	end else if (we_i) begin
		if(count_o != FIFO_DEPTH) begin
			data[wPtr] <= dat_i;
			wPtr <= wPtr+1;
			count_o <= count_o+1;
		end		
	end else if (re_i) begin
		if(count_o != 0) begin
			// dat_o <= data[rPtr];
			rPtr <= rPtr+1;
			count_o <= count_o-1;
		end		
	end
end

assign dat_o = data[rPtr];

endmodule
