library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        addr            : in     vl_logic_vector(15 downto 0);
        writedata       : in     vl_logic_vector(15 downto 0);
        halt            : in     vl_logic;
        memwrite        : in     vl_logic;
        memread         : in     vl_logic;
        readdata        : out    vl_logic_vector(15 downto 0);
        err             : out    vl_logic;
        stall           : out    vl_logic
    );
end memory;
