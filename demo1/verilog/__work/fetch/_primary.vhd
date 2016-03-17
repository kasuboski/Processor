library verilog;
use verilog.vl_types.all;
entity fetch is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        halt            : in     vl_logic;
        nextpc          : in     vl_logic_vector(15 downto 0);
        pc2             : out    vl_logic_vector(15 downto 0);
        instr           : out    vl_logic_vector(15 downto 0);
        err             : out    vl_logic
    );
end fetch;
