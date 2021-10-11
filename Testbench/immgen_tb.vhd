library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity immgen_tb is
end immgen_tb;

architecture driver of immgen_tb is
component immgen
  port ( instruction : in std_logic_vector (XLEN-1 downto 0);
         immediate : out std_logic_vector (XLEN-1 downto 0));
end component;

-- inputs
   signal tb_instruction : std_logic_vector (XLEN-1 downto 0):= (others => '0');
-- outputs
   signal tb_immediate : std_logic_vector (XLEN-1 downto 0);

begin
-- Instantiate the Unit Under Test (UUT)
  UUT: immgen port map (  instruction => tb_instruction,
			  immediate => tb_immediate);

  tb_instruction <= X"00880793" after 10ns, --I-type: addi x15,x16,8
		    X"011807B3" after 20ns, --R-type: add x15,x16,x17
		    X"00F82423" after 30ns, --S-type: sw x15,8(x16)
		    X"00208463" after 40ns, --B-type: beq x1,x2,8
		    X"00008737" after 50ns, --U-type: lui x14,8
		    X"0080006F" after 60ns; --J-type: jal x0,8

end architecture;
