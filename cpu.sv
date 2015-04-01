import lc3b_types::*;

module cpu
(
	input clk,

	output logic [15:0] mem_address,
	output logic [15:0] mem_wdata,
	input [15:0] mem_rdata,
	
	output logic mem_read,
	output logic mem_write,
	output logic [1:0] mem_byte_enable,
	
	input mem_resp,
	
	output logic [15:0] imem_address,
	output logic [15:0] imem_wdata,
	input [15:0] imem_rdata,
	
	output logic imem_read,
	output logic imem_write,
	output logic [1:0] imem_byte_enable,
	
	input imem_resp

);



fetch if
(
	.clk(clk),

);

ir1 ir11
(
);

decode id
(
);

ir2 ir22
();

ir3 ir33
();

ir4 ir44
();



endmodule : cpu