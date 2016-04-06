library verilog;
use verilog.vl_types.all;
entity memwb is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        memdata         : in     vl_logic_vector(15 downto 0);
        aludata         : in     vl_logic_vector(15 downto 0);
        memtoreg        : in     vl_logic;
        regwrite        : in     vl_logic;
        writereg        : in     vl_logic_vector(2 downto 0);
        halt            : in     vl_logic;
        memdataout      : out    vl_logic_vector(15 downto 0);
        aludataout      : out    vl_logic_vector(15 downto 0);
        memtoregout     : out    vl_logic;
        regwriteout     : out    vl_logic;
        writeregout     : out    vl_logic_vector(2 downto 0);
        haltout         : out    vl_logic
    );
end memwb;
