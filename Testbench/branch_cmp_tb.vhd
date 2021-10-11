library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity branch_cmp_tb is
end branch_cmp_tb;

architecture driver of branch_cmp_tb is
component branch_cmp
port (     inputA : in std_logic_vector (XLEN-1 downto 0);
       	   inputB : in std_logic_vector (XLEN-1 downto 0);
           cond : in std_logic_vector (2 downto 0);
           result : out std_logic);
end component;

-- inputs
   signal tb_inputA : std_logic_vector (XLEN-1 downto 0):= (others => '0');
   signal tb_inputB : std_logic_vector (XLEN-1 downto 0):= (others => '0');
   signal tb_cond : std_logic_vector (2 downto 0):= (others => '0');
-- outputs
   signal tb_result : std_logic;

begin
-- Instantiate the Unit Under Test (UUT)
  UUT: branch_cmp port map (  inputA => tb_inputA,
		       inputB => tb_inputB,
    		       cond => tb_cond,
		       result => tb_result);

  tb_cond <= BR_COND_BEQ after 10ns,
             BR_COND_BNE after 20ns,
             BR_COND_BLT after 30ns,
             BR_COND_BGE after 40ns,
             BR_COND_BLTU after 50ns,
             BR_COND_BGEU after 60ns;

  tb_inputA <= "00000000000000001110010010110101" after 10ns,
  "00000000000000001111000000000000" after 20ns;
  tb_inputB <= "00000000000000000010110101001010" after 10ns,
  "00000000000000000000000000000110" after 20ns;

end architecture;
