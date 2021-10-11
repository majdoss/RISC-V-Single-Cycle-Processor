library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
use work.RV32I_pkg.all;

entity control is
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
end control ; 

architecture arch of control is
    signal opcode : std_logic_vector (6 downto 0);
    signal funct3 : std_logic_vector (2 downto 0);
    signal funct7 : std_logic_vector (6 downto 0);
    signal branch_instr : std_logic;
    signal jump_instr : std_logic;
begin

  opcode <= instruction (6 downto 0);
  funct3 <= instruction (14 downto 12);
  funct7 <= instruction (31 downto 25);

  branch_instr <= '1' when opcode = OPCODE_BRANCH else '0';
  jump_instr <= '1' when ((opcode = OPCODE_JAL) or (opcode = OPCODE_JALR)) else '0';

  PCSrc <= (branch_instr and BranchCond) or jump_instr;

  Jump <= jump_instr;

  process (opcode, funct3, funct7) is
  begin

    Lui <= '0';
    RegWrite <= '0';
    ALUSrc1 <= '0';
    ALUSrc2 <= '0';
    ALUOp <= (others=>'0');
    MemWrite <= '0';
    MemRead <= '0';
    MemToReg <= '0';

    case opcode is
      when OPCODE_LUI =>
        Lui <= '1';
        RegWrite <= '1';
        ALUSrc1 <= '1';
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;

      when OPCODE_AUIPC | OPCODE_JAL =>
        RegWrite <= '1';
        ALUSrc1 <= '1';
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;

      when OPCODE_JALR =>
        RegWrite <= '1';
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;

      when OPCODE_BRANCH =>
        ALUSrc1 <= '1';
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;

      when OPCODE_LOAD =>
        RegWrite <= '1';
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;
        MemRead <= '1';
        MemToReg <= '1';

      when OPCODE_STORE =>
        ALUSrc2 <= '1';
        ALUOp <= ALU_OP_ADD;
        MemWrite <= '1';

      when OPCODE_IMM =>
        RegWrite <= '1';
        ALUSrc2 <= '1';
        if funct3 = "101" then -- SRLI/SRAI
          ALUOp <= funct7(5) & funct3;
        else
          ALUOp <= '0' & funct3;
        end if;

      when OPCODE_RTYPE =>
        RegWrite <= '1';
        ALUOp <= funct7(5) & funct3;

      when others =>
        null;
        
    end case;
  end process;

end architecture ;
