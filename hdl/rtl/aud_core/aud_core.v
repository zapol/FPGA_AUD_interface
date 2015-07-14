`include "aud_defs.vh"

`define FIFO_ADDR_WIDTH 4
`define FIFO_LEN    (1 << `FIFO_ADDR_WIDTH)

module aud_core (
    // system/FIFO clock 
    input wire clk_sys_i,

    // AUD interface byte clock
    input wire rst_n_i,

    // AUD signals
    inout wire [3:0] aud_data,
    output wire aud_nrst,
    output reg aud_md,
    inout wire aud_ck,
    inout wire aud_nsync,

    // Host wishbone signals
    input wire [31:0] wb_adr_i,
    input wire [31:0] wb_dat_i,
    output reg [31:0] wb_dat_o,
    input wire wb_stb_i,
    input wire wb_we_i,
    output reg wb_ack_o
);

wire            aud_rmm_nsync, aud_btm_nsync;
// wire    [3:0]   aud_rmm_data, aud_btm_data;
wire            rmm_err, rmm_idle;
reg             rmm_idle_prev;
wire    [31:0]  rmm_data_o;
reg     [31:0]  rmm_data_i;
wire    [31:0]  btm_addr_o;

reg     [31:0]  rmm_addr_reg, rmm_addr_reg_i;
reg     [31:0]  rmm_len_reg;
reg             aud_md_tmp_reg, aud_re_reg, aud_we_reg, aud_rst_reg;
wire            aud_idle;
reg             rmm_we_reg, rmm_re_reg;
reg             rmm_err_reg;
reg     [31:0]  wb_adr_reg;

reg             btm_fovf, btm_fund, btmfifo_re_reg, btmfifo_we_d_reg, btmfifo_re_d_reg;
reg             rmm_fovf, rmm_fund, rmmfifo_we_reg, rmmfifo_re_reg, rmmfifo_we_d_reg, rmmfifo_re_d_reg;
wire            btm_ff, btm_fe, btm_rst;
wire            rmm_ff, rmm_fe, rmm_rst;
wire    [31:0]  rmmfifo_dat_o;
wire    [63:0]  btmfifo_dat_o;
reg     [31:0]  rmmfifo_dat_i;
wire    [63:0]  btmfifo_dat_i;
reg     [30:0]  timer_reg;

wire [`FIFO_ADDR_WIDTH:0]  btmfifo_count_o, rmmfifo_count_o;

aud_rmm U_AudRmm(
    .clk_i(clk_sys_i),
    .rst_i(rmm_rst),
    .addr_i(rmm_addr_reg_i),
    .data_i(rmm_data_i),
    .data_o(rmm_data_o),
    .size_i(2'b11),
    .we_i(rmm_we_reg),
    .re_i(rmm_re_reg),
    .err_o(rmm_err),
    .idle_o(rmm_idle),
    .aud_data(aud_data),
    .aud_nsync_o(aud_rmm_nsync)
    );

aud_btm U_AudBtm(
    .rst(btm_rst),
    .br_addr(btm_addr_o),
    .oe(btm_oe_o),
    .addr_valid(btm_addrvalid_o),
    .buserror(btm_buserror_o),
    .aud_data(aud_data),
    .aud_ck(aud_ck),
    .aud_nsync(aud_btm_nsync)
    );

afifo #(.DATA_WIDTH(64),.ADDRESS_WIDTH(`FIFO_ADDR_WIDTH)) U_BtmFifo(
    .rst(aud_rst),
    .dat_i(btmfifo_dat_i),
    .we_i(btmfifo_we_d_reg),
    .re_i(btmfifo_re_d_reg),
    .dat_o(btmfifo_dat_o),
    .count_o(btmfifo_count_o)
    );

afifo #(.DATA_WIDTH(32),.ADDRESS_WIDTH(`FIFO_ADDR_WIDTH)) U_RmmFifo(
    .rst(aud_rst),
    .dat_i(rmmfifo_dat_i),
    .we_i(rmmfifo_we_d_reg),
    .re_i(rmmfifo_re_d_reg),
    .dat_o(rmmfifo_dat_o),
    .count_o(rmmfifo_count_o)
    );

assign aud_idle         = aud_md    ? (rmm_idle | aud_rst_reg) : (!aud_rst_reg);
// assign aud_rmm_data     = aud_md    ? aud_data                  : 4'bZZZZ;
// assign aud_btm_data     = !aud_md   ? aud_btm_data              : 4'bZZZZ;
// assign aud_data     = aud_md ? aud_rmm_data                 : aud_btm_data;
assign aud_ck       = aud_md ? clk_sys_i                        : 1'bZ;
assign aud_nsync    = aud_md ? aud_rmm_nsync                    : aud_btm_nsync;

assign aud_rst      = aud_rst_reg | !rst_n_i;
assign aud_nrst     = !aud_rst;
assign rmm_rst      = aud_rst | !aud_md;
assign btm_rst      = aud_rst | aud_md;

// Reset all read/write requests to afifos
always@(negedge clk_sys_i) begin
    rmmfifo_we_reg <= 0;
    rmmfifo_re_reg <= 0;
    btmfifo_re_reg <= 0;
    rmmfifo_re_d_reg <= rmmfifo_re_reg;
    rmmfifo_we_d_reg <= rmmfifo_we_reg;
    btmfifo_re_d_reg <= btmfifo_re_reg;
    btmfifo_we_d_reg <= btm_oe_o;
end

// Wishbone transfers
always@(posedge clk_sys_i)
    if(!rst_n_i) begin
        wb_ack_o      <= 0;
        aud_md      <= 0;
        aud_md_tmp_reg  <= 0;
        aud_rst_reg     <= 1;
        aud_re_reg      <= 0;
        aud_we_reg      <= 0;
        rmm_err_reg     <= 0;
        rmm_addr_reg    <= 0;
        rmm_addr_reg_i    <= 0;
        rmm_len_reg     <= 0;
        wb_dat_o        <= 0;
        rmmfifo_dat_i   <= 0;
        rmm_data_i      <= 0;
    end else begin
        rmmfifo_re_d_reg <= rmmfifo_re_reg;
        rmmfifo_we_d_reg <= rmmfifo_we_reg;
        btmfifo_re_d_reg <= btmfifo_re_reg;
        btmfifo_we_d_reg <= btm_oe_o;
        wb_ack_o <= wb_stb_i;
        wb_adr_reg <= wb_adr_i;

        if( wb_stb_i || wb_ack_o) begin
            // Write cycles
            if(wb_we_i && wb_stb_i) begin
                case (wb_adr_i)
                    `ADDR_REG_CSR: begin
                        aud_md_tmp_reg <= wb_dat_i[`REG_CSR_MD_OFFSET];
                        aud_we_reg <= wb_dat_i[`REG_CSR_WE_OFFSET];
                        aud_re_reg <= wb_dat_i[`REG_CSR_RE_OFFSET];
                        aud_rst_reg <= wb_dat_i[`REG_CSR_RST_OFFSET];
                    end
                    `ADDR_REG_RMM_ADDR: begin
                        rmm_addr_reg[31:0] <= wb_dat_i[31:0];
                    end
                    `ADDR_REG_RMM_LEN: begin
                        rmm_len_reg[31:0] <= wb_dat_i[31:0];
                    end
                    `ADDR_REG_RMM_DATA: begin
                        rmmfifo_dat_i[31:0] <= wb_dat_i[31:0];
                        rmmfifo_we_reg <= 1;
                    end
                endcase
            // Read cycles
            end else if (!wb_we_i && wb_ack_o) begin
                case (wb_adr_reg)
                    `ADDR_REG_CSR: begin
                        wb_dat_o[`REG_CSR_MD_OFFSET] <= aud_md;
                        wb_dat_o[`REG_CSR_WE_OFFSET] <= 0;
                        wb_dat_o[`REG_CSR_RE_OFFSET] <= 0;
                        wb_dat_o[`REG_CSR_RST_OFFSET] <= aud_rst_reg;
                        wb_dat_o[`REG_CSR_IDLE_OFFSET] <= aud_idle;
                        wb_dat_o[`REG_CSR_ERR_OFFSET] <= rmm_err_reg;
                        wb_dat_o[`REG_CSR_BTM_FF_OFFSET] <= btm_ff;
                        wb_dat_o[`REG_CSR_BTM_FOVF_OFFSET] <= btm_fovf;
                        wb_dat_o[`REG_CSR_BTM_FE_OFFSET] <= btm_fe;
                        wb_dat_o[`REG_CSR_BTM_FUND_OFFSET] <= btm_fund;
                        wb_dat_o[`REG_CSR_RMM_FF_OFFSET] <= rmm_ff;
                        wb_dat_o[`REG_CSR_RMM_FOVF_OFFSET] <= rmm_fovf;
                        wb_dat_o[`REG_CSR_RMM_FE_OFFSET] <= rmm_fe;
                        wb_dat_o[`REG_CSR_RMM_FUND_OFFSET] <= rmm_fund;
                        wb_dat_o[`REG_CSR_BTM_FC_OFFSET+7:`REG_CSR_BTM_FC_OFFSET] <= btmfifo_count_o;
                        wb_dat_o[`REG_CSR_RMM_FC_OFFSET+7:`REG_CSR_RMM_FC_OFFSET] <= rmmfifo_count_o;
                    end
                    `ADDR_REG_BTF: begin
                        wb_dat_o[31:0] <= btmfifo_dat_o [31:0];
                    end
                    `ADDR_REG_BAF: begin
                        wb_dat_o[31:0] <= btmfifo_dat_o[63:32];
                        btmfifo_re_reg <= 1;
                    end
                    `ADDR_REG_RMM_ADDR: begin
                        wb_dat_o[31:0] <= rmm_addr_reg;
                    end
                    `ADDR_REG_RMM_LEN: begin
                        wb_dat_o[31:0] <= rmm_len_reg;
                    end
                    `ADDR_REG_RMM_DATA: begin
                        wb_dat_o[31:0] <= rmmfifo_dat_o;
                        rmmfifo_re_reg <= 1;
                    end
                endcase
            end
        end
    end // if (!rst_n_i)

// RMM logic
always @(posedge clk_sys_i) begin
    if ( rmm_idle ) begin
        if( aud_we_reg && !rmm_ff ) begin
            if(rmm_len_reg != 0) begin
                rmm_we_reg <= 1;
                rmmfifo_re_reg <= 1;
                rmm_data_i <= rmmfifo_dat_o;
                rmm_addr_reg_i <= rmm_addr_reg;
                rmm_addr_reg <= rmm_addr_reg+4;
                rmm_len_reg <= rmm_len_reg-1;
            end else begin
                aud_we_reg <= 0;
            end
        end else if ( aud_re_reg ) begin
            if(!rmm_idle_prev)
                rmmfifo_we_reg <= 1;
                rmmfifo_dat_i <= rmm_data_o;
            if(rmm_len_reg != 0) begin
                rmm_re_reg <= 1;
                rmmfifo_dat_i <= rmm_data_o;
                rmm_addr_reg_i <= rmm_addr_reg;
                rmm_addr_reg <= rmm_addr_reg+4;
                rmm_len_reg <= rmm_len_reg-1;            
            end else begin
                aud_re_reg <= 0;
            end
        end
    end else begin        
        rmm_we_reg <= 0;
        rmm_re_reg <= 0;
    end
    rmm_idle_prev <= rmm_idle;
end

// BTM logic
always @(posedge clk_sys_i) begin
    if (btm_rst) begin
        timer_reg <= 0;
    end else begin
        timer_reg <= timer_reg + 1;
    end
end

assign btmfifo_dat_i[63:32] = btm_addr_o;
assign btmfifo_dat_i[31] = btm_addrvalid_o;
assign btmfifo_dat_i[30:0] = timer_reg[30:0];

// FIFOs Logic
assign rmm_ff = (rmmfifo_count_o==`FIFO_LEN);
assign btm_ff = (btmfifo_count_o==`FIFO_LEN);
assign rmm_fe = (rmmfifo_count_o==0);
assign btm_fe = (btmfifo_count_o==0);
always@(posedge rmmfifo_we_d_reg)
    if(rmm_ff) rmm_fovf <= 1;
always@(posedge rmmfifo_re_d_reg)
    if(rmm_fe) rmm_fund <= 1;
always@(posedge btmfifo_we_d_reg)
    if(btm_ff) btm_fovf <= 1;
always@(posedge btmfifo_re_d_reg)
    if(btm_fe) btm_fund <= 1;
always@(posedge rmm_rst) begin
    rmm_fovf <= 0;
    rmm_fund <= 0;
end
always@(posedge btm_rst) begin
    btm_fovf <= 0;
    btm_fund <= 0;
end


always@(posedge clk_sys_i) begin
    if(aud_rst_reg) begin
        aud_md <= aud_md_tmp_reg;
    end else begin
        if(rmm_err) rmm_err_reg <= 1;
    end
end

always@(negedge rmm_idle) rmm_err_reg <= 0;
endmodule