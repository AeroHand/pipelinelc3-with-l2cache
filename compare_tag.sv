import lc3b_types::*;

module compare_tag
(
    input lc3b_cache_tag a,
	 input lc3b_cache_tag b,
	 input lc3b_cache_tag c,
    output logic [1:0] out
);

always_comb
begin

    if (a == c)
        out = 2'b10;
    else if (b == c)
        out = 2'b11;
	 else
	     out = 2'b00;

end

endmodule : compare_tag