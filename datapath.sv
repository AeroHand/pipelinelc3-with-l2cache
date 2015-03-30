import lc3b_types::*;

module datapath
(
    input logic clk,

    /* control signals */
    input logic pcmux_sel,
    input logic load_pc,
    input logic storemux_sel,
	 input logic load_ir,
	 input logic load_regfile,
	 input logic alumux_sel,
	 input lc3b_aluop aluop_sel,
	 input logic regfilemux_sel,
	 input logic load_cc,
	 input lc3b_word mem_rdata,
	 input logic marmux_sel,
	 input logic mdrmux_sel,
	 input logic load_mar,
	 input logic load_mdr,
    /* declare more ports here */
	 output logic branch_enable,
	 output lc3b_opcode opcodee,
	 output lc3b_word mem_wdata,
    output lc3b_word mem_address
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg storemux_out;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_offset6 offset66;
lc3b_offset9 offset99;
lc3b_word sr1_out;
lc3b_word sr2_out;
lc3b_word rgfmux_out;
lc3b_word aluop_out;
lc3b_word alumux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;

register pc
(
    .clk(clk),
    .load(load_pc),
    .in(pc_plus2_out),
    .out(pc_out)
);

plus2 p2
(
    .in(pc_out),
    .out(pc_plus2_out)
);

ir1 ir1
{
    .clk(clk),
	 .load_mar,
	 .load_mdr,
	 .load_data,
    .marin(pc_out),
	 .mdrin(mem_rdata),
    .dest(dest), 
	 .src1(sr1), 
	 .src2(sr2),
	 .offset6(offset66)
}

adj #(.width(6)) adj6
(
    .in(offset66),
    .out(adj6_out)
);

mux2 #(.width(3)) storemux
(
  .sel(storemux_sel),
  .a(sr1),
  .b(dest),
  .f(storemux_out)
);

regfile rgf
(
    .clk(clk),
    .load(load_regfile),
    .in(rgfmux_out),
    .src_a(storemux_out),
	 .src_b(sr2),
	 .dest(dest),
    .reg_a(sr1_out), 
	 .reg_b(sr2_out)
);

ir2 ir2
{
    .clk(clk),
    .load,
	 .adj6in(adj6_out),
	 .adj6out(adj6tomux),
    .src1(sr1_out), 
	 .src2(sr2_out),
	 .srout1(sr1fin),
	 .srout2(sr2fin)
}

mux2 alumux
(
  .sel(alumux_sel),
  .a(sr2fin),
  .b(adj6tomux),
  .f(alumux_out)
);

alu aluop_mod
(
    .aluop(aluop_sel),
    .a(sr1fin),
	 .b(alumux_out),
    .f(aluop_out)
);

//fetch state
mux4 pc_mux
(
    .sel(pcmux_sel),
    .a(plus2_out),
    
);
//decode state

//agex state

//mem state

//sr state

endmodule : datapath
