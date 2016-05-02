library verilog;
use verilog.vl_types.all;
entity fulladder_1 is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        cin             : in     vl_logic;
        p               : out    vl_logic;
        g               : out    vl_logic;
        s               : out    vl_logic
    );
end fulladder_1;
