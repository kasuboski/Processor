library verilog;
use verilog.vl_types.all;
entity idex is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        readdata1       : in     vl_logic_vector(15 downto 0);
        readdata2       : in     vl_logic_vector(15 downto 0);
        immediate       : in     vl_logic_vector(15 downto 0);
        jump            : in     vl_logic;
        jumpreg         : in     vl_logic;
        branch          : in     vl_logic;
        branchop        : in     vl_logic_vector(1 downto 0);
        memread         : in     vl_logic;
        memwrite        : in     vl_logic;
        memtoreg        : in     vl_logic;
        aluop           : in     vl_logic_vector(3 downto 0);
        alusrc          : in     vl_logic;
        invsrc1         : in     vl_logic;
        invsrc2         : in     vl_logic;
        sub             : in     vl_logic;
        passthrough     : in     vl_logic;
        reverse         : in     vl_logic;
        writereg        : in     vl_logic_vector(2 downto 0);
        readdata1out    : out    vl_logic_vector(15 downto 0);
        readdata2out    : out    vl_logic_vector(15 downto 0);
        immediateout    : out    vl_logic_vector(15 downto 0);
        jumpout         : out    vl_logic;
        jumpregout      : out    vl_logic;
        branchout       : out    vl_logic;
        branchopout     : out    vl_logic_vector(1 downto 0);
        memreadout      : out    vl_logic;
        memwriteout     : out    vl_logic;
        memtoregout     : out    vl_logic;
        aluopout        : out    vl_logic_vector(3 downto 0);
        alusrcout       : out    vl_logic;
        invsrc1out      : out    vl_logic;
        invsrc2out      : out    vl_logic;
        subout          : out    vl_logic;
        passthroughout  : out    vl_logic;
        reverseout      : out    vl_logic;
        writeregout     : out    vl_logic_vector(2 downto 0)
    );
end idex;
