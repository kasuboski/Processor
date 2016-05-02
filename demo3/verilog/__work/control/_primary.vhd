library verilog;
use verilog.vl_types.all;
entity control is
    port(
        instr           : in     vl_logic_vector(4 downto 0);
        func            : in     vl_logic_vector(1 downto 0);
        regdst          : out    vl_logic_vector(1 downto 0);
        regwrite        : out    vl_logic;
        whichimm        : out    vl_logic_vector(1 downto 0);
        toext           : out    vl_logic;
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
        err             : out    vl_logic
    );
end control;
