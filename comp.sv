import lc3b_types::*;

module comp
(
    input lc3b_nzp in1,
	 input lc3b_reg in2,
	 output logic out
);

always_comb
begin

	 if ((in1[2]&in2[2]) || (in1[1]&in2[1]) || (in1[0]&in2[0]))
	   out=1;		  
	 else
	   out=0;
  		
end

endmodule : comp