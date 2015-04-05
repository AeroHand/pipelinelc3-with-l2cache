import lc3b_types::*;

module cache_datapath
(
	input clk,
	
	input lc3b_word mem_address,
	input write_one,
	input write_two,
	input dirty_one_in,
	input dirty_two_in,
	input write_dirty_one,
	input	write_dirty_two,
	input lru_write,
	input writemux_sel,
	input logic [1:0] mem_byte_enable,
	input lc3b_cache_size pmem_rdata,
	input lc3b_word mem_wdata,
	input pmem_write,
	output lc3b_cache_size pmem_wdata,
	output logic lru_out,
	output logic tag_match,
	output lc3b_word mem_rdata,
	output logic valid,
	output logic dirty,
	output logic tag_sel,
	output lc3b_word pmem_address

);

/* Internal Signals */
lc3b_cache_tag cache_tag;
lc3b_cache_index cache_index;
lc3b_cache_offset cache_offset;
lc3b_cache_tag tag_one_out;
lc3b_cache_tag tag_two_out;
logic high;
lc3b_word tag_extension;
logic dirty_one_out;
logic dirty_two_out;
logic valid_one_out;
logic valid_two_out;
logic [8:0] tagmux_out;
logic [1:0] tag_compare;

lc3b_imm4 ground;
assign ground = 4'b0000;

assign cache_tag = mem_address[15:7];
assign cache_index = mem_address[6:4];
assign cache_offset = mem_address[3:1];
assign tag_extension = {tagmux_out, cache_index, ground};

assign tag_match = tag_compare[1];

assign tag_sel = tag_compare[0];

assign high = 1'b1;



lc3b_cache_size data_one_out;
lc3b_cache_size data_two_out;
lc3b_cache_size datamux_out;
lc3b_cache_size writemux_out;
lc3b_cache_size write_calc_out;

data_write write_calc
(
	 .sel(cache_offset),
	 .selbyte(mem_byte_enable),
	 .in(datamux_out),
	 .newwrite(mem_wdata),
	 .out(write_calc_out)
);

compare_tag tagcomp
(
	 .a(tag_one_out),
	 .b(tag_two_out),
	 .c(cache_tag),
	 .out(tag_compare)
);

data_selector data_select
(
    .sel(cache_offset),
	 .in(datamux_out),
	 .out(mem_rdata)
);

array #(.width(9)) tag_one
(
	.clk(clk),
	.write(write_one),
	.index(cache_index),
	.in(cache_tag),
	.out(tag_one_out)
);

array #(.width(9)) tag_two
(
	.clk(clk),
	.write(write_two),
	.index(cache_index),
	.in(cache_tag),
	.out(tag_two_out)
);

array #(.width(128)) data_one
(
    .clk(clk),
	 .write(write_one),
	 .index(cache_index),
	 .in(writemux_out),
	 .out(data_one_out)
);

array #(.width(128)) data_two
(
    .clk(clk),
	 .write(write_two),
	 .index(cache_index),
	 .in(writemux_out),
	 .out(data_two_out)
);

array #(.width(1)) valid_one
(
    .clk(clk),
	 .write(write_one),
	 .index(cache_index),
	 .in(high),
	 .out(valid_one_out)
);

array #(.width(1)) valid_two
(
    .clk(clk),
	 .write(write_two),
	 .index(cache_index),
	 .in(high),
	 .out(valid_two_out)
);

array #(.width(1)) dirty_one_array
(
    .clk(clk),
	 .write(write_dirty_one),
	 .index(cache_index),
	 .in(dirty_one_in),
	 .out(dirty_one_out)
);

array #(.width(1)) dirty_two_array
(
    .clk(clk),
	 .write(write_dirty_two),
	 .index(cache_index),
	 .in(dirty_two_in),
	 .out(dirty_two_out)
);

array #(.width(1)) lru
(
    .clk(clk),
	 .write(lru_write),
	 .index(cache_index),
	 .in(!tag_compare[0]),
	 .out(lru_out)
);


mux2 #(.width(16)) addressmux
(
	 .sel(pmem_write),
	 .a(mem_address),
	 .b(tag_extension),
	 .f(pmem_address)
);

mux2 #(.width(9)) tagmux
(
    .sel(lru_out),
	 .a(tag_one_out),
	 .b(tag_two_out),
	 .f(tagmux_out)
);

mux2 #(.width(128)) datamux
(
    .sel(tag_compare[0]),
	 .a(data_one_out),
	 .b(data_two_out),
	 .f(datamux_out)
);

mux2 #(.width(128)) writedatamux
(
    .sel(lru_out),
	 .a(data_one_out),
	 .b(data_two_out),
	 .f(pmem_wdata)
);

mux2 #(.width(1)) validmux
(
    .sel(tag_compare[0]),
	 .a(valid_one_out),
	 .b(valid_two_out),
	 .f(valid)
);

mux2 #(.width(1)) dirtymux
(
    .sel(lru_out),
	 .a(dirty_one_out),
	 .b(dirty_two_out),
	 .f(dirty)
);

mux2 #(.width(128)) writemux
(
	 .sel(writemux_sel),
	 .a(pmem_rdata),
	 .b(write_calc_out),
	 .f(writemux_out)
);

endmodule : cache_datapath