import lc3b_types::*;

module array #(parameter width = 128)
(
    input clk,
    input write,
    input lc3b_cache_index index,
    input [width-1:0] in,
    output logic [width-1:0] out
);

logic [width-1:0] data [7:0];

/* Initialize array */
initial
begin
    for (int a = 0; a < $size(data); a++)
    
	 begin
        data[a] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        data[index] = in;
    end
end

assign out = data[index];

endmodule : array