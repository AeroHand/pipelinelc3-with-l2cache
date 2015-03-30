import lc3b_types::*;

module ir2
(
    input clk,
    input load,
    input lc3b_word src1, src2,
	 input lc3b_word adj6in,
	 output lc3b_word adj6out
	 output lc3b_word srout1,srout2
    );

lc3b_word r1,r2,adj6;
always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        r1 = src1;
		  r2 = src2;
		  adj6=adj6in;
    end
end

always_comb
begin
    srout1=r1;
	 srout2=r2;
	 adj6out=adj6;
end

endmodule : ir