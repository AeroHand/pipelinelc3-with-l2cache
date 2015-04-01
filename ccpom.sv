import lc3b_types::*;

module comp
(
    input lc3b_nzp in1,
	 input lc3b_reg in2,
	 output logic out
);

always_comb
begin
	 if (in1[2]==1)
	   begin
	     if (in2<0)
		    out=1
		  else
		    out=0
      end		  
	 if (in1[1]==1)
	   begin
	     if (in2==0)
		    out=1
		  else
		    out=0
      end    
	 if (in1[0]==1)
	   begin
	     if (in2>0)
		    out=1
		  else
		    out=0
      end
end

endmodule : comp