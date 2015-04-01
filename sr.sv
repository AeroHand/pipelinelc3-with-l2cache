import lc3b_types::*;

module sr
(
	input clk,

	// Incoming Registers	
	input lc3b_word sr_address_out,
	input lc3b_word sr_data_out,
	input lc3b_four sr_cs_out,
	input lc3b_word sr_npc_out,
	input lc3b_word sr_aluresult_out,
	input lc3b_word sr_ir_out,
	input lc3b_nzp sr_drid_out,
	
	// Store inputs
	input dr_valuemux_sel1,
	input dr_valuemux_sel2,
	input load_cc,

	// Outputs
	output lc3b_cc cccomp_out,
	output lc3b_word dr_valuemux_out
);

lc3b_word sr_address_out;
lc3b_word sr_data_out;
lc3b_cs sr_cs_out;
lc3b_word sr_npc_out;
lc3b_word sr_aluresult_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

mux4 dr_valuemux
(
	.sel1(dr_valuemux_sel1),
	.sel2(dr_valuemux_sel2),
	.a(sr_address_out),
	.b(sr_data_out),
	.c(sr_npc_out),
	.d(sr_aluresult_out),
	.f(dr_valuemux_out)
);

gencc gencc
(
	.in(dr_valuemux_out),
	.out(gencc_out)
);

register #(3) cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

comp cccomp
(
	.a(/* Destination Register */),
	.b(cc_out),
	.f(cccomp_out)
);


endmodule: sr