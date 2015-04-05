import lc3b_types::*;

module cache
(
    input clk,
    output lc3b_word pmem_address,
	 input lc3b_cache_size pmem_rdata,
	 output lc3b_cache_size pmem_wdata,
	 input lc3b_word mem_wdata,
	 output lc3b_word mem_rdata,
	 input lc3b_word mem_address,
	 input mem_read,
	 input mem_write,
	 input lc3b_mem_wmask mem_byte_enable,
	 output mem_resp,
	 output pmem_read,
	 output pmem_write,
	 input pmem_resp
);

logic write_one;
logic write_two;
logic write_dirty_one;
logic write_dirty_two;
logic dirty_one_in;
logic dirty_two_in;
logic lru_out;
logic tag_match;
logic lru_write;
logic writemux_sel;
logic valid;
logic dirty;
logic tag_sel;

/* Instantiate MP 0 top level blocks here */

cache_datapath cache_datapath
(
    .clk(clk),
	 .mem_byte_enable(mem_byte_enable),
	 .mem_address(mem_address),
	 .pmem_rdata(pmem_rdata),
	 .mem_wdata(mem_wdata),
	 .pmem_write(pmem_write),
	 .pmem_address(pmem_address),
	 .pmem_wdata(pmem_wdata),
	 .mem_rdata(mem_rdata),
	 .write_one(write_one),
	 .write_two(write_two),
	 .write_dirty_one(write_dirty_one),
	 .write_dirty_two(write_dirty_two),
	 .dirty_one_in (dirty_one_in),
	 .dirty_two_in(dirty_two_in),
	 .lru_write(lru_write),
	 .writemux_sel(writemux_sel),
	 .lru_out(lru_out),
	 .tag_match(tag_match),
	 .valid(valid),
	 .dirty(dirty),
	 .tag_sel(tag_sel)
);

cache_control cache_control
(
    .clk(clk),
	 .lru_out(lru_out),
	 .mem_read(mem_read),
	 .mem_write(mem_write),
	 .pmem_resp(pmem_resp),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
	 .mem_resp(mem_resp),
	 .tag_match(tag_match),
	 .valid(valid),
	 .dirty(dirty),
	 .tag_sel(tag_sel),
	 .write_one(write_one),
	 .write_two(write_two),
	 .write_dirty_one(write_dirty_one),
	 .write_dirty_two(write_dirty_two),
	 .dirty_one_in (dirty_one_in),
	 .dirty_two_in(dirty_two_in),
	 .lru_write(lru_write),
	 .writemux_sel(writemux_sel)
);

endmodule : cache