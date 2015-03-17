import lc3b_types::*;

module mp0
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

/* Instantiate MP 0 top level blocks here */
 
lc3b_opcode opcodeee;
logic pcmux_sell;
logic load_pcc;
logic load_irr;
logic load_regfilee;
logic load_marr;
logic load_mdrr;
logic load_ccc;
logic storemux_sell;
logic alumux_sell;
logic regfilemux_sell;
logic marmux_sell;
logic mdrmux_sell;
lc3b_aluop aluopp;
logic branch_enablee;

datapath dpth
(
    .clk,
    /* control signals */
    .pcmux_sel(pcmux_sell),
    .load_pc(load_pcc),
    .storemux_sel(storemux_sell),
	 .load_ir(load_irr),
	 .load_regfile(load_regfilee),
	 .alumux_sel(alumux_sell),
	 .aluop_sel(aluopp),
	 .regfilemux_sel(regfilemux_sell),
	 .load_cc(load_ccc),
	 .mem_rdata(mem_rdata),
	 .marmux_sel(marmux_sell),
	 .mdrmux_sel(mdrmux_sell),
	 .load_mar(load_marr),
	 .load_mdr(load_mdrr),
    /* declare more ports here */
	 .branch_enable(branch_enablee),
	 .opcodee(opcodeee),
	 .mem_wdata(mem_wdata),
    .mem_address(mem_address)
);

control ctrl
(
    .clk,
	 
	 /* Datapath controls */
	 .opcode(opcodeee),
	 .load_pc(load_pcc),
	 .load_ir(load_irr),
	 .load_regfile(load_regfilee),
	 .load_mar(load_marr),
	 .load_mdr(load_mdrr),
	 .load_cc(load_ccc),
	 .pcmux_sel(pcmux_sell),
	 .storemux_sel(storemux_sell),
	 .alumux_sel(alumux_sell),
	 .regfilemux_sel(regfilemux_sell),
	 .marmux_sel(marmux_sell),
	 .mdrmux_sel(mdrmux_sell),
	 .aluop(aluopp),
	 /* et cetera */
	 .branch_enable(branch_enablee),
    /* Memory signals */
	 .mem_resp(mem_resp),
	 .mem_read(mem_read),
	 .mem_write(mem_write),
	 .mem_byte_enable(mem_byte_enable)
);


endmodule : mp0
