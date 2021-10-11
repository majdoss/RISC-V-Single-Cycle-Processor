library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package RISC_V_ISA_pkg is
    constant XLEN : natural := 32;
    constant ADDRLEN : natural := 10;
    constant LOG2_XRF_SIZE : natural := 5;

    -- ALU operations
    constant ALU_OP_ADD : std_logic_vector (3 downto 0) := "0000";
    constant ALU_OP_SUB : std_logic_vector (3 downto 0) := "1000";
    constant ALU_OP_AND : std_logic_vector (3 downto 0) := "0111";
    constant ALU_OP_OR : std_logic_vector (3 downto 0) := "0110";
    constant ALU_OP_XOR : std_logic_vector (3 downto 0) := "0100";
    constant ALU_OP_SLL : std_logic_vector (3 downto 0) := "0001";
    constant ALU_OP_SRL : std_logic_vector (3 downto 0) := "0101";
    constant ALU_OP_SRA : std_logic_vector (3 downto 0) := "1101";
    constant ALU_OP_SLT : std_logic_vector (3 downto 0) := "0010";
    constant ALU_OP_SLTU : std_logic_vector (3 downto 0) := "0011";

    -- branch conditions
    constant BR_COND_BEQ : std_logic_vector (2 downto 0) := "000";
    constant BR_COND_BNE : std_logic_vector (2 downto 0) := "001";
    constant BR_COND_BLT : std_logic_vector (2 downto 0) := "100";
    constant BR_COND_BGE : std_logic_vector (2 downto 0) := "101";
    constant BR_COND_BLTU : std_logic_vector (2 downto 0) := "110";
    constant BR_COND_BGEU : std_logic_vector (2 downto 0) := "111";

    -- opcodes used to generate immediates
    constant OPCODE_LUI : std_logic_vector (6 downto 0) := "0110111";
    constant OPCODE_AUIPC : std_logic_vector (6 downto 0) := "0010111";
    constant OPCODE_JAL : std_logic_vector (6 downto 0) := "1101111";
    constant OPCODE_JALR : std_logic_vector (6 downto 0) := "1100111";
    constant OPCODE_BRANCH : std_logic_vector (6 downto 0) := "1100011"; -- branch instruction
    constant OPCODE_LOAD : std_logic_vector (6 downto 0) := "0000011"; -- load instruction
    constant OPCODE_STORE : std_logic_vector (6 downto 0) := "0100011"; -- store instruction
    constant OPCODE_IMM : std_logic_vector (6 downto 0) := "0010011"; -- arithmetic immediate, logic immediate, or shift instruction
    constant OPCODE_RTYPE : std_logic_vector (6 downto 0) := "0110011"; -- R-Type arithmetic, logic, shift, and slt instructions
end package;
