library verilog;
use verilog.vl_types.all;
entity adder is
    generic(
        width           : integer := 16
    );
    port(
        aa              : in     vl_logic_vector;
        bb              : in     vl_logic_vector;
        ff              : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end adder;
