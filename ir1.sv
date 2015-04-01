//top level entity for ex/mem flip flops

module ir1
(
    //inputs/outputs here

    input clk,
    input load,

    input [15:0] if_plus2_out,
    input [15:0] imem_rdata,

    output logic [15:0] if_id_pc_out,
    output logic [15:0] if_id_instr_out
);

//internal signals here

//modules here

//make regfile outs negative edge triggered! and cc too

//need pc reg?

//neg vs. pos???????

flipflop_positive if_id_pc_ff
(
    .clk(clk),
    .load(load),
    .d(if_plus2_out),
    .q(if_id_pc_out)
);

flipflop_positive if_id_instr_ff
(
    .clk(clk),
    .load(load),
    .d(imem_rdata),
    .q(if_id_instr_out)
);

endmodule : ir1