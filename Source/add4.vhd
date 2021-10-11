library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;


entity add4 is
 port ( datain : in std_logic_vector (XLEN-1 downto 0);
	result : out std_logic_vector (XLEN-1 downto 0));
end add4;

architecture rtl of add4 is
begin

 result <= std_logic_vector(unsigned(datain) + 4);

-- If we want to limit the PC value to 1024, we can do this:

-- if (datain = "00000000000000000000001111111100") then
  -- result <= "00000000000000000000000000000000";
-- end if;

end architecture ;
