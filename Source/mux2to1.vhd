library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity mux2to1 is
    port (
	    sel : in std_logic;
        input0 : in std_logic_vector (XLEN-1 downto 0);
        input1 : in std_logic_vector (XLEN-1 downto 0);
        output : out std_logic_vector (XLEN-1 downto 0)
);
end mux2to1;

architecture rtl of mux2to1 is
begin
    output <= input0 when sel = '0' else 
              input1 when sel = '1' else
              (others=>'0');
end architecture;
