import lc3b_types::*;

module decode
(
	//inputs/outputs here
	input clk,

	input [15:0] regfilemux_out,
	input [15:0] instruction,
	
	input [2:0] destb,
	

	output logic [15:0] adjtrap_out,
	output logic [15:0] adjmux_out,
	output logic [15:0] alumux_out,
	output lc3b_control_word  ctrl,
	input lc3b_control_word ctrlwb,
	output logic [15:0] sr1_out,
	output logic [15:0] sr2_out
);

lc3b_reg storemux_out;
lc3b_reg destmux_out;
logic [15:0] zext4_out;
logic [15:0] sext6_out;
logic [15:0] sext5_out;
logic [15:0] adj11_out;
logic [15:0] adj9_out;
logic [15:0] adj6_out;



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

mux2 #(.width(16)) adjmux
(
	.sel(ctrl.adjmux_sel),
	.a(adj9_out),
	.b(adj11_out),
	.f(adjmux_out)
);

mux8 #(.width(16)) alumux
(
	.sel(ctrl.alumux_sel),
	.a(16'b0000000000000000),
	.b(adj6_out),
	.c(sext5_out),
	.d(sext6_out),
	.e(zext4_out),
	.g(16'b0000000000000000),
	.h(16'b0000000000000000),
	.i(16'b0000000000000000),
	.f(alumux_out)
);

adj #(.width(6)) adj6
(
	.in(instruction[5:0]), //offset6
	.out(adj6_out)
);

adj #(.width(9)) adj9
(
	.in(instruction[8:0]), //offset9
	.out(adj9_out)
);

adj #(.width(11)) adj11
(
	.in(instruction[10:0]), //offset11
	.out(adj11_out)
);

adjz #(.width(8)) adjtrap
(
	.in(instruction[7:0]), //trapvect8
	.out(adjtrap_out)
);

sext #(.width(5)) sext5
(
	.in(instruction[4:0]), //imm5
	.out(sext5_out)
);

sext #(.width(6)) sext6
(
	.in(instruction[5:0]), //offset6
	.out(sext6_out)
);

zext #(.width(4)) zext4
(
	.in(instruction[3:0]), //imm4
	.out(zext4_out)
);

endmodule : decode