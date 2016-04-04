library verilog;
use verilog.vl_types.all;
entity ifid is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pc              : in     vl_logic_vector(15 downto 0);
        addr            : in     vl_logic_vector(15 downto 0);
        pcout           : out    vl_logic_vector(15 downto 0);
        addrout         : out    vl_logic_vector(15 downto 0)
    );
end ifid;
