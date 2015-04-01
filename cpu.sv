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
	
	input imem_resp,
	
	// Flip Flop Load for IR2
	input load_agex_npc,
	input load_agex_cs,
	input load_agex_ir,
	input load_agex_sr1,
	input load_agex_sr2,
	input load_agex_cc,
	input load_agex_drid

);



fetch if
(
	.clk(clk),
	.branch_out(,    //branched pc address
    .loadpc,
    .pc_out,       //pc address
	.pcplus2_out
);

ir1 ir11
(
    .clk,
    .load,

    .if_plus2_out,
    .imem_rdata,

    .if_id_pc_out,
    .if_id_instr_out
);

decode id
(	
    .clk,

	.regfilemux_out,
	.instruction,
	
	.destb,
	

	.adjtrap_out,
	.adjmux_out,
	.adj6_out,
	.ctrl,
	.ctrlwb,
	.sr1_out,
	.sr2_out
);

ir2 ir22
(
	.clk,
	
	//Loads
	
	
	//Inputs
	.agex_npc_in,
	.agex_cs_in,
	.agex_ir_in,
	.agex_sr1_in(sr1_out),
	.agex_sr2_in(sr2_out),
	.agex_cc_in,
	.agex_drid_in,
	
	//Outputs
	.agex_npc_out,
	.agex_cs_out,
	.agex_ir_out,
	.agex_sr1_out,
	.agex_sr2_out,
	.agex_cc_out,
	.agex_drid_out
);

agex agex

ir3 ir33
();

ir4 ir44
();



endmodule : cpu