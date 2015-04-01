import lc3b_types::*;

module ir3
(
    input clk,
	
	// Load Register Signals
	input load_mem_npc,
	input load_mem_cs,
	input load_mem_ir,
	input load_mem_address,
	input load_mem_aluresult,
	input load_mem_cc,
	input load_mem_drid,
	
	// Load Register Contents
	input lc3b_word mem_address_in,
	input lc3b_eleven mem_cs_in,
	input lc3b_word mem_npc_in,
	input lc3b_nzp mem_cc_in,
	input lc3b_word mem_aluresult_in,
	input lc3b_word mem_ir_in,
	input lc3b_nzp mem_drid_in,
	
	// Output Register Contents
	output lc3b_word mem_address_out,
	output lc3b_eleven mem_cs_out,
	output lc3b_word mem_npc_out,
	output lc3b_nzp mem_cc_out,
	output lc3b_word mem_aluresult_out,
	output lc3b_word mem_ir_out,
	output lc3b_nzp mem_drid_out
	
    );

// Incoming Registers
register agex_npc
(
	.clk,
	.load(load_agex_npc),
	.in(agex_npc_in),
	.out(agex_npc_out)
);

register #(20) agex_cs
(
	.clk,
	.load(load_agex_cs),
	.in(agex_cs_in),
	.out(agex_cs_out)
);

register agex_ir
(
	.clk,
	.load(load_agex_ir),
	.in(agex_ir_in),
	.out(agex_ir_out)
);

register agex_sr1
(
	.clk,
	.load(load_agex_sr1),
	.in(agex_sr1_in),
	.out(agex_sr1_out)
);

register agex_sr2
(
	.clk,
	.load(load_agex_sr2),
	.in(agex_sr2_in),
	.out(agex_sr2_out)
);

register #(3) agex_cc
(
	.clk,
	.load(load_agex_cc),
	.in(agex_cc_in),
	.out(agex_cc_out)
);

register #(3) agex_drid
(
	.clk,
	.load(load_agex_drid),
	.in(agex_drid_in),
	.out(agex_drid_out)
);

endmodule : ir3