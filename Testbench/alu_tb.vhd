library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity alu_tb is
end alu_tb;

architecture driver of alu_tb is
component alu
port (     inputA : in std_logic_vector (XLEN-1 downto 0);
       	  inputB : in std_logic_vector (XLEN-1 downto 0);
           ALUop : in std_logic_vector (3 downto 0);
           result : out std_logic_vector (XLEN-1 downto 0));
end component;

-- inputs
   signal tb_inputA : std_logic_vector (XLEN-1 downto 0):= (others => '0');
   signal tb_inputB : std_logic_vector (XLEN-1 downto 0):= (others => '0');
   signal tb_ALUop : std_logic_vector (3 downto 0):= (others => '0');
-- outputs
   signal tb_result : std_logic_vector (XLEN-1 downto 0);

begin
-- Instantiate the Unit Under Test (UUT)
  UUT: alu port map (  inputA => tb_inputA,
		       inputB => tb_inputB,
    		       ALUop => tb_ALUop,
		       result => tb_result);

  tb_ALUop <= ALU_OP_ADD after 10ns,
	      ALU_OP_SUB after 20ns,
              ALU_OP_AND after 40ns,
              ALU_OP_OR after 50ns,
              ALU_OP_XOR after 60ns,
              ALU_OP_SLL after 70ns,
              ALU_OP_SRL after 80ns,
              ALU_OP_SRA after 90ns,
              ALU_OP_SLT after 100ns,
              ALU_OP_SLTU after 110ns;

  tb_inputA <= "00000000000000001110010010110101" after 10ns,
  "11111100000000001111000000000100" after 20ns,
  "00000000001110001111000000000100" after 30ns,
  "11111111100000001111000000000100" after 40ns;
  tb_inputB <= "00000000000000000010110101001010" after 10ns,
  "11111111111100001111000000000100" after 20ns,
  "00000000000000000000000000000110" after 40ns;

end architecture;
