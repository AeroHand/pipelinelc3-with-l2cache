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
assign load = ((!(ex_mem_ctrl_out.in_indirect) || indirect_reg_out) && !(ex_mem_ctrl_out.in_mem && !(mem_resp)) && imem_resp);

logic branch_enable;
lc3b_control_word  cntrl_word;
lc3b_word agex_mem_aluout;
lc3b_word agex_mem_pcout;
lc3b_reg agex_mem_destout;

lc3b_work pc_connect;

fetch ifetch
(
	.clk(clk),
	.branch_out(),    //branched pc address
    .loadpc(ctrl.pcmux_sel),
    .pc_out(pc_connect),       //pc address
	.pcplus2_out(pcplus2)
);

ir1 ir11
(
    .clk(clk),
    .load(load),

    .if_plus2_out(pcplus2),
    .imem_rdata(imem_rdata),

    .if_id_pc_out(pc_connect),
    .if_id_instr_out(instr)
);

decode id
(	
    .clk(clk),

	.regfilemux_out(regfilemux_out),
	.instruction(instr),
	
	.destb(agex_mem_destout),
	
	.ctrl(ctrl),
	.ctrlwb(cntrl_word),
	.sr1_out(sr1_out),
	.sr2_out(sr2_out)
);

ir2 ir22
(
	.clk,
	
	//Loads
	.load_agex_npc,
	.load_agex_cs,
	.load_agex_ir,
	.load_agex_sr1,
	.load_agex_sr2,
	.load_agex_cc,
	.load_agex_drid,
	
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
(
	//Inputs
	.agex_npc_out,
	.agex_cs_out,
	.agex_ir_out,
	.agex_sr1_out,
	.agex_sr2_out,
	.agex_cc_out,
	.agex_drid_out,
	
	// Address Generation Components
	.addr1mux_sel,
	.addr2mux_sel1,
	.addr2mux_sel2,
	.addressmux_sel,
	.lshf1_enable,
	.aluresultmux_sel,
	.sr2mux_sel,
	.lc3b_aluop aluop,
	
	// Outgoing Registers
	.mem_address_in,
	.mem_cs_in,
	.mem_npc_in,
	.mem_cc_in,
	.mem_aluresult_in,
	.mem_ir_in,
	.mem_drid_in
);

ir3 ir33
(
	// Load Register Signals
	.load_mem_npc,
	.load_mem_cs,
	.load_mem_ir,
	.load_mem_address,
	.load_mem_aluresult,
	.load_mem_cc,
	.load_mem_drid,
	
	// Load Register Contents
	.mem_address_in,
	.mem_cs_in,
	.mem_npc_in,
	.mem_cc_in,
	.mem_aluresult_in,
	.mem_ir_in,
	.mem_drid_in,
	
	// Output Register Contents
	.mem_address_out,
	.mem_cs_out,
	.mem_npc_out,
	.mem_cc_out,
	.mem_aluresult_out,
	.mem_ir_out,
	.mem_drid_out
);

mem mem_stage
(
	.load_cc(cntrl_word.load_cc),
	.ex_mem_alu_out(agex_mem_aluout),
	.ex_mem_pc_out(agex_mem_pcout),
	.mem_wb_dest_out(agex_mem_destout),
	.wb_regfilemux_out(regfilemux_out),
	.ctrl(cntrl_word),
	
	.marmux_out(mem_address),
	.mdrmux_out(mem_wdata),
	.branch_enable(branch_enable)
);

ir4 ir44
();



endmodule : cpu