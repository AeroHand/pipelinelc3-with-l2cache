import lc3b_types::*;

module decode
(
	//inputs/outputs here
	input clk,

	input [15:0] regfilemux_out,
	input [15:0] instruction,
	
	input [2:0] destb,
	

	output lc3b_control_word  ctrl,
	input lc3b_control_word ctrlwb,
	output logic [15:0] sr1_out,
	output logic [15:0] sr2_out
);

lc3b_reg storemux_out;
lc3b_reg destmux_out;



//internal signals here

//modules here

control ctrl
(
	.opcode(instruction[15:12]),
	.useimm5(instruction[5]),
	.useJSR(instruction[11]),
	.shf_D(instruction[4]),
	.ctrl(ctrl)
);

regfile reg_file
(
	.clk(clk),
	.load(ctrlwb.load_regfile),
	.in(regfilemux_out),
	.src_a(instruction[8:6]), //sr1
	.src_b(storemux_out),
	.dest(destmux_out),
	.reg_a(sr1_out),
	.reg_b(sr2_out)
);

mux2 #(.width(3)) destmux
(
	.sel(ctrlwb.destmux_sel),
	.a(destb), //dest
	.b(3'b111),
	.f(destmux_out)
);

mux2 #(.width(3)) storemux
(
	.sel(ctrl.storemux_sel),
	.a(instruction[2:0]), //sr2
	.b(instruction[11:9]), //dest
	.f(storemux_out)
);



endmodule : decode