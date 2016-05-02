library verilog;
use verilog.vl_types.all;
entity exmem is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        readdata2       : in     vl_logic_vector(15 downto 0);
        alures          : in     vl_logic_vector(15 downto 0);
        nextpc          : in     vl_logic_vector(15 downto 0);
        writereg        : in     vl_logic_vector(2 downto 0);
        regwrite        : in     vl_logic;
        memtoreg        : in     vl_logic;
        memread         : in     vl_logic;
        memwrite        : in     vl_logic;
        halt            : in     vl_logic;
        readdata2out    : out    vl_logic_vector(15 downto 0);
        aluresout       : out    vl_logic_vector(15 downto 0);
        nextpcout       : out    vl_logic_vector(15 downto 0);
        writeregout     : out    vl_logic_vector(2 downto 0);
        regwriteout     : out    vl_logic;
        memtoregout     : out    vl_logic;
        memreadout      : out    vl_logic;
        memwriteout     : out    vl_logic;
        haltout         : out    vl_logic;
        regdst          : in     vl_logic_vector(1 downto 0);
        regdstout       : out    vl_logic_vector(1 downto 0)
    );
end exmem;
