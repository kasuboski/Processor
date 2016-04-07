library verilog;
use verilog.vl_types.all;
entity execute is
    port(
        readdata1       : in     vl_logic_vector(15 downto 0);
        readdata2       : in     vl_logic_vector(15 downto 0);
        immediate       : in     vl_logic_vector(15 downto 0);
        branchop        : in     vl_logic_vector(1 downto 0);
        aluop           : in     vl_logic_vector(3 downto 0);
        alusrc          : in     vl_logic;
        invsrc1         : in     vl_logic;
        invsrc2         : in     vl_logic;
        sub             : in     vl_logic;
        pc              : in     vl_logic_vector(15 downto 0);
        jump            : in     vl_logic;
        jumpreg         : in     vl_logic;
        branch          : in     vl_logic;
        nextpc          : out    vl_logic_vector(15 downto 0);
        alures          : out    vl_logic_vector(15 downto 0);
        passthrough     : in     vl_logic;
        reverse         : in     vl_logic;
        exmem_alures    : in     vl_logic_vector(15 downto 0);
        memwb_writeback : in     vl_logic_vector(15 downto 0);
        forwarda        : in     vl_logic_vector(1 downto 0);
        forwardb        : in     vl_logic_vector(1 downto 0);
        err             : out    vl_logic
    );
end execute;
