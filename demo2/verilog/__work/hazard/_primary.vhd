library verilog;
use verilog.vl_types.all;
entity hazard is
    port(
        idex_memread    : in     vl_logic;
        idex_rt         : in     vl_logic_vector(2 downto 0);
        ifid_rs         : in     vl_logic_vector(2 downto 0);
        ifid_rt         : in     vl_logic_vector(2 downto 0);
        ifid_write      : out    vl_logic;
        pcwrite         : out    vl_logic;
        stall           : out    vl_logic
    );
end hazard;
