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
        stall           : out    vl_logic;
        idex_writereg   : in     vl_logic_vector(2 downto 0);
        exmem_writereg  : in     vl_logic_vector(2 downto 0);
        memwb_writereg  : in     vl_logic_vector(2 downto 0);
        jalr            : in     vl_logic;
        willbranch      : in     vl_logic;
        ifid_pc         : in     vl_logic_vector(15 downto 0);
        idex_pc         : in     vl_logic_vector(15 downto 0);
        exmem_pc        : in     vl_logic_vector(15 downto 0);
        memwb_pc        : in     vl_logic_vector(15 downto 0);
        idex_regwrite   : in     vl_logic;
        exmem_regwrite  : in     vl_logic;
        memwb_regwrite  : in     vl_logic
    );
end hazard;
