import lc3b_types::*;

module data_write
(
	 input lc3b_cache_offset sel,
	 input logic [1:0] selbyte,
    input lc3b_cache_size in,
	 input lc3b_word newwrite,
    output lc3b_cache_size out
);

always_comb
begin
	case(selbyte)
	
	2'b01: begin
			case(sel)
				3'b111:	out = {in[127:120], newwrite[7:0], in[111:0]};
				3'b110:	out = {in[127:104], newwrite[7:0], in[95:0]};
				3'b101:	out = {in[127:88], newwrite[7:0], in[79:0]};
				3'b100:	out = {in[127:72], newwrite[7:0], in[63:0]};
				3'b011:	out = {in[127:56], newwrite[7:0], in[47:0]};
				3'b010:	out = {in[127:40], newwrite[7:0], in[31:0]};
				3'b001:	out = {in[127:24], newwrite[7:0], in[15:0]};
				default:	out = {in[127:8], newwrite[7:0]};
			endcase
		end
	
		2'b10: begin
			case(sel)
				3'b111:	out = {newwrite[15:8], in[119:0]};
				3'b110:	out = {in[127:112], newwrite[15:8], in[103:0]};
				3'b101:	out = {in[127:96], newwrite[15:8], in[87:0]};
				3'b100:	out = {in[127:80], newwrite[15:8], in[71:0]};
				3'b011:	out = {in[127:64], newwrite[15:8], in[55:0]};
				3'b010:	out = {in[127:48], newwrite[15:8], in[39:0]};
				3'b001:	out = {in[127:32], newwrite[15:8], in[23:0]};
				default:	out = {in[127:16], newwrite[15:8], in[7:0]};
			endcase
		end
		
		2'b11: begin
			case(sel)
				3'b111:	out = {newwrite, in[111:0]};
				3'b110:	out = {in[127:112], newwrite, in[95:0]};
				3'b101:	out = {in[127:96], newwrite, in[79:0]};
				3'b100:	out = {in[127:80], newwrite, in[63:0]};
				3'b011:	out = {in[127:64], newwrite, in[47:0]};
				3'b010:	out = {in[127:48], newwrite, in[31:0]};
				3'b001:	out = {in[127:32], newwrite, in[15:0]};
				default:	out = {in[127:16], newwrite};
			endcase
		end
		
		default:	out = in;
		
	endcase
end

endmodule : data_write