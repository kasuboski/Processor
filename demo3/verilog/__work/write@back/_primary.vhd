library verilog;
use verilog.vl_types.all;
entity writeback is
    port(
        memdata         : in     vl_logic_vector(15 downto 0);
        aludata         : in     vl_logic_vector(15 downto 0);
        memtoreg        : in     vl_logic;
        writebackdata   : out    vl_logic_vector(15 downto 0);
        err             : out    vl_logic
    );
end writeback;
