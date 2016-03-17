library verilog;
use verilog.vl_types.all;
entity groupcla is
    port(
        p               : in     vl_logic_vector(3 downto 0);
        g               : in     vl_logic_vector(3 downto 0);
        cin             : in     vl_logic;
        c               : out    vl_logic_vector(3 downto 0);
        pg              : out    vl_logic;
        gg              : out    vl_logic
    );
end groupcla;
