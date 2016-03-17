library verilog;
use verilog.vl_types.all;
entity shifter_1 is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        op              : in     vl_logic_vector(2 downto 0);
        sh              : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end shifter_1;
