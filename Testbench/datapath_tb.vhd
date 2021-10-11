library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
use work.RV32I_pkg.all;

entity datapath_tb is
end datapath_tb ; 

architecture arch of datapath_tb is
    component datapath
        port (
            clk : in std_logic;
            rst_n : in std_logic
        );
    end component;

    signal tb_clk : std_logic := '0';
    signal tb_rst_n : std_logic := '1';
begin
    UUT: datapath port map (clk => tb_clk, rst_n => tb_rst_n);

    tb_rst_n <= '0' after 5ns, '1' after 10ns;

    process is
    begin
        wait for 20ns;
        for i in 1 to 5706 loop
            tb_clk <= '1';
            wait for 10ns;
            tb_clk <= '0';
            wait for 10ns;
        end loop;
        wait;
    end process;
end architecture ;
