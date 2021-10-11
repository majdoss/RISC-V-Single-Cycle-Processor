library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity pc is
 port ( clk : in std_logic ;
	rst_n : in std_logic ;
	datain : in std_logic_vector (XLEN-1 downto 0);
	dataout : out std_logic_vector (XLEN-1 downto 0));
end pc;

architecture rtl of pc is

begin

 p1: process(clk,rst_n) 
  variable pc_out: std_logic_vector (XLEN-1 downto 0);
  begin
   -- reset is active low
   if (rst_n = '0') then 
     pc_out := (others => '0');
   elsif (rising_edge(clk)) then
     pc_out := datain;
   end if;
   dataout <= pc_out;
end process p1;

end architecture ;
