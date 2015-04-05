import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(
    /* Input and output port declarations */
	 
	 input clk,

    /* Datapath controls */

	input lru_out,
	input mem_read,
	input mem_write,
	input tag_match,
	input valid,
	input dirty,
	input tag_sel,
	output logic write_one,
	output logic write_two,
	output logic dirty_one_in,
	output logic dirty_two_in,
	output logic mem_resp,
	output logic lru_write,
	output logic writemux_sel,
	output logic write_dirty_one,
	output logic write_dirty_two,
    

    /* Memory signals */

   input pmem_resp,
   output logic pmem_read,
   output logic pmem_write
);

enum int unsigned {
    /* List of states */
	 check,
	 get,
	 store,
	 read_write
} state, next_state;

always_comb
begin : state_actions

    /* Default output assignments */
	 
	write_one = 1'b0;
	write_two = 1'b0;
	dirty_one_in = 1'b0;
	dirty_two_in = 1'b0;
	write_dirty_one = 1'b0;
	write_dirty_two = 1'b0;
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	mem_resp = 1'b0;
	lru_write = 1'b0;
	writemux_sel = 1'b0;
	 
    /* Actions for each state */
	 
	case(state)
        
	check: begin
	
	if(tag_match && valid && (mem_read || mem_write)) 
		begin
			lru_write = 1;
			mem_resp = 1;
			
			if (mem_write == 1)
				begin
					writemux_sel = 1;
				
					if(tag_sel == 0) 
						begin
							write_one = 1;
							write_dirty_one = 1;
							dirty_one_in = 1;
						end
						
					else 
						begin
							write_two = 1;
							write_dirty_two = 1;
							dirty_two_in = 1;
						end
				end
		end
	end
		  
	get: begin
				
		pmem_read = 1;
		
		if(pmem_resp == 1)
			begin
			
				if(lru_out == 0)
					write_one = 1;
				else
					write_two = 1;
			end
	end
		  
	store: begin
	
		pmem_write = 1;
		
		if(lru_out == 0)
			begin
			
				write_dirty_one = 1;
				dirty_one_in = 0;
		
			end
			else
				begin
				
					write_dirty_two = 1;
					dirty_two_in = 0;
					
				end
		end
		  
	read_write: begin
	
		mem_resp = 1;
		lru_write = 1;
		
		if (mem_write == 0)
			begin
			
				write_one = 1;
				write_dirty_one = 1;
				dirty_one_in = 1;
				
			end
				
		else
			begin
				
				writemux_sel = 1;
		
				if(tag_sel == 1)
					begin
					
						write_two = 1;
						write_dirty_two = 1;
						dirty_two_in = 1;
				
					end
			end
	end
		    
        default: /* Do nothing */;

    endcase
end

always_comb
begin : next_state_logic
    
	 /* Next state information and conditions (if any)
     * for transitioning between states */
	 
	 next_state = state;
	 
    case(state)
        
	check: begin
		  
		if(tag_match && valid && (mem_read || mem_write))
			next_state = check;
		else if(mem_read || mem_write) begin
		
			if(dirty == 1)
				next_state = store;
			else
				next_state = get;
		
			end
	
	end
		  
	store: begin
				
	if(pmem_resp == 0)
		next_state = store;
	else
		next_state = get;
				
	end
		  
	get: begin
	
		if(pmem_resp == 0)
			next_state = get;
		else
			next_state = read_write;
			
	end
		  
	read_write: begin

		next_state = check;
	
	end

	default: /* Do nothing */;

	endcase


end

always_ff @(posedge clk)
begin: next_state_assignment

    /* Assignment of next state on clock edge */
	 
	 state <= next_state;
	 
end

endmodule : cache_control