library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity mux2to1_tb is
end mux2to1_tb;

architecture rtl of mux2to1_tb is

    component mux2to1
        port (
            sel : in std_logic;
            input0 : in std_logic_vector (XLEN-1 downto 0);
            input1 : in std_logic_vector (XLEN-1 downto 0);
            output : out std_logic_vector (XLEN-1 downto 0)
        );
    end component;

    signal tb_sel : std_logic := '0';
    signal tb_input0 : std_logic_vector (XLEN-1 downto 0) := X"AAAAAAAA";
    signal tb_input1 : std_logic_vector (XLEN-1 downto 0) := X"BBBBBBBB";
    signal tb_output : std_logic_vector (XLEN-1 downto 0);
begin

    UUT : mux2to1 port map (sel => tb_sel, input0 => tb_input0, input1 => tb_input1, output => tb_output);
    tb_sel <= '1' after 10 ns, '0' after 20 ns, '1' after 30 ns, '0' after 40 ns;

end architecture;
