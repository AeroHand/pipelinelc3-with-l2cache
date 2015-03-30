import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    input clk,
	 
	 /* Datapath controls */
	 input lc3b_opcode opcode,
	 output logic load_pc,
	 output logic load_ir,
	 output logic load_mar,
	 output logic load_mdr,
	 output logic load_cc,
	 output logic pcmux_sel,
	 output logic storemux_sel,
	 output logic alumux_sel,
	 output logic regfilemux_sel,
	 output logic marmux_sel,
	 output logic mdrmux_sel,
	 output lc3b_aluop aluop,
	 /* et cetera */
	 input logic branch_enable,
    /* Memory signals */
	 input mem_resp,
	 output logic mem_read,
	 output logic mem_write,
	 output lc3b_mem_wmask mem_byte_enable
	 
);

enum int unsigned {
    fetch1,
	 fetch2,
	 fetch3,
	
} state, next_state;

always_comb
begin : state_actions
	/* Default assignments */
	load_pc = 1'b0;
	load_ir = 1'b0;
	load_regfile = 1'b0;
	
	load_mar = 1'b0;
	load_mdr = 1'b0;
  
	/* et cetera (see Appendix E) */
	case(state)
		fetch1: begin
			/* MAR <= PC */
			marmux_sel = 1;
			load_mar = 1;

			/* PC <= PC + 2 */
			pcmux_sel = 0;
			load_pc = 1;
		end
		
		fetch2: begin
			/* Read memory */
			mem_read = 1;
			mdrmux_sel = 1;
			load_mdr = 1;
		end
		fetch3: begin
			/* Load IR */
			load_ir = 1;
		end
		
		default: /* Do nothing */;
	
	endcase
end

always_comb
begin : next_state_logic
        next_state = state;
	case(state)
		fetch1: begin
			next_state = fetch2;
		end
		fetch2: begin
		  if(mem_resp == 1'b1)
				next_state = fetch3;  
		end
		fetch3: begin
			next_state = fetch1;
		end
		
		
		default: begin
		   /* Do nothing */;
		end  
	endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 state <= next_state;
end

endmodule : control


