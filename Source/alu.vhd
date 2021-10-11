library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity alu is
    port ( inputA : in std_logic_vector (XLEN-1 downto 0);
       	   inputB : in std_logic_vector (XLEN-1 downto 0);
           ALUop : in std_logic_vector (3 downto 0);
           result : out std_logic_vector (XLEN-1 downto 0));
end alu;

architecture rtl of alu is
    
begin
 process(inputA,inputB,ALUop)
 begin
   case ALUop is

     when ALU_OP_ADD => result <= 
       std_logic_vector(signed(inputA)+ signed(inputB));
     when ALU_OP_SUB => result <= 
       std_logic_vector(signed(inputA)- signed(inputB));
     when ALU_OP_AND => result <= inputA and inputB;
     when ALU_OP_OR => result <= inputA or inputB;
     when ALU_OP_XOR => result <= inputA xor inputB;

     -- shift_right and shift_right can be used for SLL,SRL,SRA,SLA
     -- Unsigned = Logical, Signed = Arithmetic

     when ALU_OP_SLL => result <= 
       std_logic_vector(shift_left(unsigned(inputA), to_integer(unsigned(inputB(4 downto 0)))));
     when ALU_OP_SRL => result <= 
       std_logic_vector(shift_right(unsigned(inputA), to_integer(unsigned(inputB(4 downto 0)))));
     when ALU_OP_SRA => result <= 
       std_logic_vector(shift_right(signed(inputA), to_integer(unsigned(inputB(4 downto 0)))));

     when ALU_OP_SLT =>
       if (signed(inputA) < signed(inputB)) then
	 result(31 downto 1) <= (others=>'0');
         result(0) <= '1';
       else
	 result <= (others=>'0');
       end if;

     when ALU_OP_SLTU =>
       if (unsigned(inputA) < unsigned(inputB)) then
	 result(31 downto 1) <= (others=>'0');
         result(0) <= '1';
       else
	 result <= (others=>'0');
       end if;
     
     when others => result <= (others=>'0');

  end case;
 end process;

end architecture;