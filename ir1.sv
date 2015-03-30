import lc3b_types::*;

module ir1
(
    input clk,
	 input logic load_mar, load_mdr,load_data
    input lc3b_word marin,mdrin,
	 
    //output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    
	 output lc3b_offset6 offset6,
    //output lc3b_offset9 offset9
);

lc3b_word data;
lc3b_word mar;
lc3b_word mdr;

always_ff @(posedge clk)
begin
    if (load_mar == 1)
    begin
        mar = marin;
    end
	 
	 if (load_mdr == 1)
    begin
        mdr = mdrin;
    end
	 
	 if (load_data == 1)
	 begin
	     data=mdr;
	 end	  
end

always_comb
begin
    //opcode = lc3b_opcode'(data[15:12]);

    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];

    offset6 = data[5:0];
    //offset9 = data[8:0];
end

endmodule : ir