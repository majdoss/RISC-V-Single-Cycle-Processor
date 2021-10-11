library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity reg_file is
    port ( clk : in std_logic;
           rst_n : in std_logic;
           RegWrite : in std_logic;
           rs1 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rs2 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rd : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           regA : out std_logic_vector (XLEN-1 downto 0);
           regB : out std_logic_vector (XLEN-1 downto 0));
end reg_file;

architecture rtl of reg_file is

type regfile is array (0 to 2**(LOG2_XRF_SIZE)-1) of std_logic_vector (XLEN-1 downto 0);

begin
    
  process(clk, rst_n, RegWrite, rs1, rs2, rd, datain) is
   variable reg : regfile := (X"00000000", X"00000000", X"00000400", others => (others=>'0'));

   begin
     if (rst_n = '0') then
        reg := (X"00000000", X"00000000", X"00000400", others => (others=>'0'));  -- initializes sp (x2) to data memory address 1024
     elsif (rising_edge(clk)) and (RegWrite = '1') and rd /= "00000" then
        reg(to_integer(unsigned(rd))) := datain;
     end if;
        regA <= reg(to_integer(unsigned(rs1)));
        regB <= reg(to_integer(unsigned(rs2)));
  end process;

end architecture;
