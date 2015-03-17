library verilog;
use verilog.vl_types.all;
entity comp is
    port(
        in1             : in     vl_logic_vector(2 downto 0);
        in2             : in     vl_logic_vector(2 downto 0);
        \out\           : out    vl_logic
    );
end comp;
