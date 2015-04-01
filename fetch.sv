import lc3b_types::*;

module fetch
(
	input clk,
	
	input [15:0] branch_out,    //branched pc address
    input logic loadpc,
	output logic [15:0] pcplus2_out
);

lc3b_word pc_out;

mux2 #(.width(16)) pcmux
(
	.sel(ctrl.pcmux_sel),
	.a(pcplus2_out),
	.b(branch_out),
	.f(pcmux_out)
);

register pc
(
    .clk(clk),
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus2 plus2_unit
(
	.in(pc_out),
	.out(pcplus2_out)
);

endmodule : fetch