library verilog;
use verilog.vl_types.all;
entity decode is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        instr           : in     vl_logic_vector(15 downto 0);
        pc              : in     vl_logic_vector(15 downto 0);
        writebackdata   : in     vl_logic_vector(15 downto 0);
        writeregin      : in     vl_logic_vector(2 downto 0);
        regwritein      : in     vl_logic;
        readdata1       : out    vl_logic_vector(15 downto 0);
        readdata2       : out    vl_logic_vector(15 downto 0);
        immediate       : out    vl_logic_vector(15 downto 0);
        jump            : out    vl_logic;
        jumpreg         : out    vl_logic;
        branch          : out    vl_logic;
        branchop        : out    vl_logic_vector(1 downto 0);
        memread         : out    vl_logic;
        memwrite        : out    vl_logic;
        memtoreg        : out    vl_logic;
        aluop           : out    vl_logic_vector(3 downto 0);
        alusrc          : out    vl_logic;
        invsrc1         : out    vl_logic;
        invsrc2         : out    vl_logic;
        sub             : out    vl_logic;
        halt            : out    vl_logic;
        passthrough     : out    vl_logic;
        reverse         : out    vl_logic;
        writereg        : out    vl_logic_vector(2 downto 0);
        regwrite        : out    vl_logic;
        rs              : out    vl_logic_vector(2 downto 0);
        rt              : out    vl_logic_vector(2 downto 0);
        err             : out    vl_logic
    );
end decode;
