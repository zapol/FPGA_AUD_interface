
/*
 *	AUD core register definitions
 */

// Control and Status Register
`define ADDR_REG_CSR                   5'h0
`define REG_CSR_MD_OFFSET 0
`define REG_CSR_MD 32'h00000001
`define REG_CSR_WE_OFFSET 1
`define REG_CSR_WE 32'h00000002
`define REG_CSR_RE_OFFSET 2
`define REG_CSR_RE 32'h00000004
`define REG_CSR_RST_OFFSET 3
`define REG_CSR_RST 32'h00000008
`define REG_CSR_IDLE_OFFSET 4
`define REG_CSR_IDLE 32'h00000010
`define REG_CSR_ERR_OFFSET 5
`define REG_CSR_ERR 32'h00000020
`define REG_CSR_BTM_FF_OFFSET 8
`define REG_CSR_BTM_FF 32'h00000100
`define REG_CSR_BTM_FOVF_OFFSET 9
`define REG_CSR_BTM_FOVF 32'h00000200
`define REG_CSR_BTM_FE_OFFSET 10
`define REG_CSR_BTM_FE 32'h00000400
`define REG_CSR_BTM_FUND_OFFSET 11
`define REG_CSR_BTM_FUND 32'h00000800
`define REG_CSR_RMM_FF_OFFSET 12
`define REG_CSR_RMM_FF 32'h00001000
`define REG_CSR_RMM_FOVF_OFFSET 13
`define REG_CSR_RMM_FOVF 32'h00002000
`define REG_CSR_RMM_FE_OFFSET 14
`define REG_CSR_RMM_FE 32'h00004000
`define REG_CSR_RMM_FUND_OFFSET 15
`define REG_CSR_RMM_FUND 32'h00008000
`define REG_CSR_BTM_FC_OFFSET 16
`define REG_CSR_BTM_FC 32'h00ff0000
`define REG_CSR_RMM_FC_OFFSET 24
`define REG_CSR_RMM_FC 32'hff000000

// BTM Timestamp FIFO
`define ADDR_REG_BTF                   5'h4
`define REG_BTF_BR_TSTAMP_OFFSET 0
`define REG_BTF_BR_TSTAMP 32'h7fffffff
`define REG_BTF_BR_VALID_OFFSET 31
`define REG_BTF_BR_VALID 32'h80000000

// BTM Branch Address FIFO
`define ADDR_REG_BAF                   5'h8

// RMM Address register
`define ADDR_REG_RMM_ADDR              5'hc

// RMM Length register
`define ADDR_REG_RMM_LEN               5'h10

// RMM Data FIFO
`define ADDR_REG_RMM_DATA              5'h14
