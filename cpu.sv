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
	.branch(branch),
	.ctrl(ex_mem_ctrl_out),
	.if_id_pc_out(if_id_pc_out),
	.ex_mem_pc_out(ex_mem_pc_out),
	.id_ex_sr1_out(ex_mem_sr1_out),
	.ex_mem_bradj_out(ex_mem_bradj_out),
	.mem_wb_mdr_out(mem_wdata),
	.pcmux_out(imem_address),
	.pcplus2_out(plus2_out)
);

ir1 ir11
();

decode id
();

ir2 ir22
();

ir3 ir33
();

ir4 ir44
();



endmodule : cpu