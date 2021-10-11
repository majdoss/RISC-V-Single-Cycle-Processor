library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity immgen is
    port (
        instruction : in std_logic_vector (XLEN-1 downto 0);
        immediate : out std_logic_vector (XLEN-1 downto 0));
end immgen;

architecture rtl of immgen is
    signal opcode : std_logic_vector (6 downto 0);
    signal i_type_immed : std_logic_vector (XLEN-1 downto 0);
    signal s_type_immed : std_logic_vector (XLEN-1 downto 0);
    signal b_type_immed : std_logic_vector (XLEN-1 downto 0);
    signal j_type_immed : std_logic_vector (XLEN-1 downto 0);
    signal u_type_immed : std_logic_vector (XLEN-1 downto 0);
begin

    opcode <= instruction(6 downto 0);

    i_type_immed <= (XLEN-1 downto XLEN-20 => instruction(31)) & instruction(31 downto 20);
    s_type_immed <= (XLEN-1 downto XLEN-20 => instruction(31)) & instruction(31 downto 25) & instruction(11 downto 7);
    b_type_immed <= (XLEN-1 downto XLEN-19 => instruction(31)) & instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
    j_type_immed <= (XLEN-1 downto XLEN-11 => instruction(31)) & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
    u_type_immed <= instruction(31 downto 12) & X"000";

    with opcode select
        immediate <=    i_type_immed when OPCODE_IMM | OPCODE_LOAD | OPCODE_JALR, -- arithmetic immed/logic immed/shift; load; jalr
                        s_type_immed when OPCODE_STORE, -- store
                        b_type_immed when OPCODE_BRANCH, -- branch
                        j_type_immed when OPCODE_JAL, -- jal
                        u_type_immed when OPCODE_LUI | OPCODE_AUIPC, -- lui or auipc
                        (others=>'0') when others;

end architecture;
