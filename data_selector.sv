import lc3b_types::*;

module data_selector
(
	 input lc3b_cache_offset sel,
    input lc3b_cache_size in,
    output logic [15:0] out
);

always_comb
begin
    case(sel)
			
			default:	out = in[15:0];
			3'b001:	out = in[31:16];
			3'b010:	out = in[47:32];
			3'b011:	out = in[63:48];
			3'b100:	out = in[79:64];
			3'b101:	out = in[95:80];
			3'b110:	out = in[111:96];
			3'b111:	out = in[127:112];
	 
	 endcase
end

endmodule : data_selector