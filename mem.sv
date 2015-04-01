import lc3b_types::*;

module mem
(
	input load_cc,
	input lc3b_word ex_mem_pc_out,
	input lc3b_word ex_mem_alu_out,
	input lc3b_word ex_mem_pc_out,
	input lc3b_reg mem_wb_dest_out,
	input lc3b_word wb_regfilemux_out,
	input lc3b_control_word ctrl,

	
	output lc3b_word marmux_out,
	output lc3b_word mdrmux_out,
	output logic branch_enable
);

lc3b_nzp gencc_out;
lc3b_reg cc_out;


mux2 marmux
(
	.sel(ctrl.marmux_sel),
	.a(ex_mem_alu_out),
	.b(ex_mem_pc_out),
	.f(marmux_out)
);

mux2 mdrmux
(
	.sel(ctrl.mdrmux_sel),
	.a(ex_mem_alu_out),
	.b(ex_mem_pc_out),
	.f(mdrmux_out)
);


gencc generate_cc
(
	.in(wb_regfilemux_out),
	.out(gencc_out)
);

register cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

comparator cccomp
(
	.condition_codes(cc_out), 
	.in_conditions(mem_wb_dest_out),
   .br_enable(branch_enable)
);