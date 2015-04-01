import lc3b_types::*;

module control_rom
(
	input logic [3:0] opcode,
	input logic useimm5,
	input logic useJSR,
	input logic shf_D,
	output lc3b_control_word ctrl
);

logic shf_A;

//   89: assign resp_a = read_a | write_a;
assign shf_A = useimm5;

always_comb
	begin
		/* Default assignments */
		ctrl.opcode = opcode;
		ctrl.load_cc = 1'b0;
	    ctrl.load_regfile = 1'b0;
	    ctrl.load_mar = 1'b0;
	    ctrl.load_mdr = 1'b0;
	    ctrl.pcmux_sel = 3'b0;
	    ctrl.storemux_sel = 1'b0;
		 ctrl.destmux_sel = 1'b0;
	    ctrl.alumux_sel = 3'b0;
	    ctrl.regfilemux_sel = 3'b0;
	    ctrl.marmux_sel  =2'b0;
	    ctrl.mdrmux_sel = 1'b0;
	    ctrl.aluop = alu_add;
	    ctrl.mem_read = 1'b0;
	    ctrl.mem_write = 1'b0;
		ctrl.in_byte = 1'b0;
		ctrl.if_id_enable = 1'b1;
		ctrl.id_ex_enable = 1'b1;
		ctrl.ex_mem_enable = 1'b1;
		ctrl.mem_wb_enable = 1'b1;
		ctrl.in_branch = 1'b0;
		ctrl.in_indirect = 1'b0;
		ctrl.in_sti = 1'b0;
		ctrl.adjmux_sel = 1'b0;
		ctrl.in_mem = 1'b0;
		ctrl.in_st = 1'b0;
		ctrl.in_ld = 1'b0;
		ctrl.set_r7 = 1'b0;
		ctrl.in_lea = 1'b0;
		
		/* ... other defaults ... */
		/* Assign control signals based on opcode */
		case(opcode)
			op_add: 
				begin
					if(useimm5) ctrl.alumux_sel = 2;
					ctrl.aluop = alu_add;
					ctrl.load_regfile = 1;
					ctrl.load_cc = 1;
				end
			op_and: 
				begin
					if(useimm5) ctrl.alumux_sel = 2;
					ctrl.aluop = alu_and;
					ctrl.load_regfile = 1;
					ctrl.load_cc = 1;
				end
			op_not:
				begin
					ctrl.aluop = alu_not;
                	ctrl.load_regfile = 1;
                	ctrl.load_cc = 1;
				end
			op_ldr:
				begin
					ctrl.alumux_sel = 1;
	                ctrl.aluop = alu_add;
	                ctrl.load_mar = 1;
	                ctrl.mdrmux_sel = 1;
	                ctrl.load_mdr = 1;
	                ctrl.mem_read = 1;
	                ctrl.regfilemux_sel = 1;
	                ctrl.load_regfile = 1;
	                ctrl.load_cc = 1;
					ctrl.in_mem = 1;
					ctrl.in_ld = 1;
				end
			op_str:
				begin
					ctrl.alumux_sel = 1;
	                ctrl.aluop = alu_add;
						 ctrl.load_mar = 1;
	                ctrl.storemux_sel = 1;
	                ctrl.load_mdr = 1;
						 ctrl.mdrmux_sel = 3;
	                ctrl.mem_write = 1;
						 ctrl.in_mem = 1;
						 ctrl.in_st = 1;
				end
			op_br:
				begin
					ctrl.in_branch = 1'b1;
				end
		
			/* ... other opcodes ... */
			default: begin
				ctrl = 0; /* Unknown opcode, set control word to zero */
			end
		endcase
	end
endmodule : control_rom