library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity control_tb is
end control_tb;

architecture rtl of control_tb is

    component control
        port (
          instruction : in std_logic_vector (XLEN-1 downto 0);
          BranchCond : in std_logic; -- BR. COND. SATISFIED = 1; NOT SATISFIED = 0
          Jump : out std_logic;
          Lui : out std_logic;
          PCSrc : out std_logic;
          RegWrite : out std_logic;
          ALUSrc1 : out std_logic;
          ALUSrc2 : out std_logic;
          ALUOp : out std_logic_vector (3 downto 0);
          MemWrite : out std_logic;
          MemRead : out std_logic;
          MemToReg : out std_logic
        ) ;
      end component ; 

      signal tb_instruction : std_logic_vector (XLEN-1 downto 0) := (others=>'0');
      signal tb_BranchCond : std_logic := '0';
      signal tb_Jump : std_logic;
      signal tb_Lui : std_logic;
      signal tb_PCSrc : std_logic;
      signal tb_RegWrite : std_logic;
      signal tb_ALUSrc1 : std_logic;
      signal tb_ALUSrc2 : std_logic;
      signal tb_ALUOp : std_logic_vector (3 downto 0);
      signal tb_MemWrite : std_logic;
      signal tb_MemRead : std_logic;
      signal tb_MemToReg : std_logic;

begin

    UUT : control port map ( instruction => tb_instruction, 
			     BranchCond => tb_BranchCond, 
			     Jump => tb_Jump, 
			     Lui => tb_Lui, 
			     PCSrc => tb_PCSrc, 
                             RegWrite => tb_RegWrite, 
			     ALUSrc1 => tb_ALUSrc1, 
			     ALUSrc2 => tb_ALUSrc2, 
			     ALUOp => tb_ALUOp, 
			     MemWrite => tb_MemWrite,
                             MemRead => tb_MemRead, 
			     MemToReg => tb_MemToReg );

    process is
    begin
        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_LUI;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_AUIPC;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_JAL;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_JALR;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_BRANCH;
        wait for 10 ns;

        tb_BranchCond <= '1';
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_LOAD;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_STORE;
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_IMM;

        for i in 0 to 7 loop
            tb_instruction(14 downto 12) <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        tb_instruction(14 downto 12) <= "101";
        tb_instruction(30) <= '1';
        wait for 10 ns;

        tb_instruction <= (XLEN-1 downto 7=>'0') & OPCODE_RTYPE;

        for i in 0 to 7 loop
            tb_instruction(14 downto 12) <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        tb_instruction(30) <= '1';
        tb_instruction(14 downto 12) <= "000";
        wait for 10 ns;

        tb_instruction(14 downto 12) <= "101";
        wait for 10 ns;


        wait;
    end process;

end architecture;
