
/*
 *	AUD core register definitions
 */

// Status Register
`define AUD_SR_IDLE		0	// Ram access sequence finished
`define AUD_SR_WFF		1	// Write Fifo Full
`define AUD_SR_WFU		2	// Write Fifo Underrun
`define AUD_SR_RFO		3	// Read Fifo Overflow
`define AUD_SR_RFE		4	// Read Fifo Empty

// Control Register
`define AUD_CR_MD		0	// AUD mode (0 for Branch Trace Mode, 1 for RAM Monitor Mode)
`define AUD_CR_EN		1	// Enable data transmission/collection will be automatically reset when transaction is finished (rising edge of AUD_SR_IDLE)

