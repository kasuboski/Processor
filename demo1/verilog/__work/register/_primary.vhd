library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        width           : integer := 16
    );
    port(
        \in\            : in     vl_logic_vector;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \out\           : in     vl_logic_vector
    );
end \register\;
