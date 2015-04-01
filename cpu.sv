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
	


);
assign logic loadsignal=1'b1;

logic branch_enable;
lc3b_control_word  cntrl_word;
lc3b_word agex_mem_aluout;
lc3b_word agex_mem_pcout;
lc3b_reg agex_mem_destout;

lc3b_word pc_connect;
lc3b_control_word ctrl;


// Agex
lc3b_word agex_npc_out,
lc3b_twenty agex_cs_out,
lc3b_word agex_ir_out,
lc3b_word agex_sr1_out,
lc3b_word agex_sr2_out,
lc3b_nzp agex_cc_out,
lc3b_nzp agex_drid_out,
lc3b_word mem_address_in,
lc3b_eleven mem_cs_in,
lc3b_word mem_npc_in,
lc3b_nzp mem_cc_in,
lc3b_word mem_aluresult_in,
lc3b_word mem_ir_in,
lc3b_drid mem_drid_in

//IR 3
lc3b_word mem_address_out,
lc3b_eleven mem_cs_out,
lc3b_word mem_npc_out,
lc3b_nzp mem_cc_out,
lc3b_word mem_aluresult_out,
lc3b_word mem_ir_out,
lc3b_nzp mem_drid_out

fetch ifetch
(
	.clk(clk),
	.branch_out(),    //branched pc address
    .loadpc(ctrl.pcmux_sel),
	.pcplus2_out(pcplus2)
);

ir1 ir11
(
    .clk(clk),


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
	.sr2_out(sr2_out),
	.dr_out(dr_out)
);

ir2 ir22
(
	.clk,
	
	//Loads
	.load_agex_npc(loadsignal),
	.load_agex_cs(loadsignal),
	.load_agex_ir(loadsignal),
	.load_agex_sr1(loadsignal),
	.load_agex_sr2(loadsignal),
	.load_agex_cc(loadsignal),
	.load_agex_drid(loadsignal),
	
	//Inputs
	.agex_npc_in(pc_connect),
	.agex_cs_in(),
	.agex_ir_in(instr),
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
	.clk
	
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
	.clk,
	
	// Load Register Signals
	.load_mem_npc(loadsignal),
	.load_mem_cs(loadsignal),
	.load_mem_ir(loadsignal),
	.load_mem_address(loadsignal),
	.load_mem_aluresult(loadsignal),
	.load_mem_cc(loadsignal),
	.load_mem_drid(loadsignal),
	
	// Load Register Contents
	.mem_address_in(),
	.mem_cs_in(),
	.mem_npc_in(),
	.mem_cc_in(),
	.mem_aluresult_in(),
	.mem_ir_in(),
	.mem_drid_in(),
	
	// Output Register Contents
	.mem_address_out(ir3_addr_out),
	.mem_cs_out(ir3_cs_out),
	.mem_npc_out(ir3_npc_out),
	.mem_cc_out(),
	.mem_aluresult_out(ir3_alu_out),
	.mem_ir_out(ir3_ir_out),
	.mem_drid_out(ir3_drid_out)
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
(
    .clk,
	
	// Load Register Signals
	.load_sr_address(loadsignal),
	.load_sr_data(loadsignal),
	.load_sr_cs(loadsignal),
	.load_sr_npc(loadsignal),
	.load_sr_aluresult(loadsignal),
	.load_sr_ir(loadsignal),
	.load_sr_drid(loadsignal),
	
	// Load Register Contents
	.sr_address_in(ir3_addr_out),
	.sr_data_in(mem_wdata), // Correct?
	.sr_cs_in(ir3_cs_out[10:7]),
	.sr_npc_in(ir3_npc_out),
	.sr_aluresult_in(ir3_alu_out),
	.sr_ir_in(ir3_ir_out),
	.sr_drid_in(ir3_drid_out),
	
	// Output Register Contents
	.sr_address_out(),
	.sr_data_out(),
	.sr_cs_out(),
	.sr_npc_out(),
	.sr_aluresult_out(),
	.sr_ir_out(),
	.sr_drid_out()
);

sr sr
(
	.clk,
	
	// Incoming Registers	
	.sr_address_out,
	.sr_data_out,
	.sr_cs_out,
	.sr_npc_out,
	.sr_aluresult_out,
	.sr_ir_out,
	.sr_drid_out,
	
	// Store inputs
	.dr_valuemux_sel1,
	.dr_valuemux_sel2,
	.load_cc,

	// Outputs
	.lc3b_cc cccomp_out,
	.lc3b_word dr_valuemux_out
);

endmodule : cpu