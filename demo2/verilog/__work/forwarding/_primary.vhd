library verilog;
use verilog.vl_types.all;
entity forwarding is
    port(
        idex_rs         : in     vl_logic_vector(2 downto 0);
        idex_rt         : in     vl_logic_vector(2 downto 0);
        exmem_rd        : in     vl_logic_vector(2 downto 0);
        memwb_rd        : in     vl_logic_vector(2 downto 0);
        exmem_regwrite  : in     vl_logic;
        memwb_regwrite  : in     vl_logic;
        forwarda        : out    vl_logic_vector(1 downto 0);
        forwardb        : out    vl_logic_vector(1 downto 0)
    );
end forwarding;
