library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity reg_file_tb is
end reg_file_tb;

architecture driver of reg_file_tb is
component reg_file
  port (   clk : in std_logic;
           rst : in std_logic;
           RegWrite : in std_logic;
           rs1 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rs2 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rd : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           regA : out std_logic_vector (XLEN-1 downto 0);
           regB : out std_logic_vector (XLEN-1 downto 0));
end component;

-- inputs
   signal tb_clk : std_logic := '0';
   signal tb_rst : std_logic := '0';
   signal tb_RegWrite : std_logic := '0';
   signal tb_rs1 : std_logic_vector (LOG2_XRF_SIZE-1 downto 0):= (others => '0');
   signal tb_rs2 : std_logic_vector (LOG2_XRF_SIZE-1 downto 0):= (others => '0');
   signal tb_rd : std_logic_vector (LOG2_XRF_SIZE-1 downto 0):= (others => '0');
   signal tb_datain : std_logic_vector (XLEN-1 downto 0):= (others => '0');

-- outputs
   signal tb_regA : std_logic_vector (XLEN-1 downto 0);
   signal tb_regB : std_logic_vector (XLEN-1 downto 0);

   constant ClockFrequency: integer := 100e6; --100MHz
   constant ClockPeriod: time := 1000ms / ClockFrequency;

begin
-- Instantiate the Unit Under Test (UUT)
  UUT: reg_file port map (  clk => tb_clk,
		            rst => tb_rst,
    		            RegWrite => tb_RegWrite,
		            rs1 => tb_rs1,
			    rs2 => tb_rs2,
    		            rd => tb_rd,
		            datain => tb_datain,
			    regA => tb_regA,
			    regB => tb_regB);

p1: process
  begin
    tb_clk <= '1';
    wait for ClockPeriod/2;  --for 10 ns signal is '0'.
    tb_clk <= '0';
    wait for ClockPeriod/2;  --for next 10 ns signal is '1'.
 end process p1;

  tb_rst <= '1';
  tb_RegWrite <= '1';
  tb_rs1 <= "00010";
  tb_rs2 <= "00011";
  tb_rd <= "01000";
  tb_datain <= "00000000000000000000110001000100";

end architecture;
