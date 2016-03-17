library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        cin             : in     vl_logic;
        op              : in     vl_logic_vector(3 downto 0);
        passthrough     : in     vl_logic;
        inva            : in     vl_logic;
        invb            : in     vl_logic;
        sign            : in     vl_logic;
        \Out\           : out    vl_logic_vector(15 downto 0);
        ofl             : out    vl_logic;
        zero            : out    vl_logic
    );
end alu;
