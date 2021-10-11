library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity branch_cmp is
    port (
        inputA : in std_logic_vector(XLEN-1 downto 0);
        inputB : in std_logic_vector(XLEN-1 downto 0);
        cond : in std_logic_vector(2 downto 0);
        result : out std_logic
    );
end branch_cmp;

architecture rtl of branch_cmp is
  signal res_beq : std_logic; -- equal
  signal res_bne : std_logic; -- not equal
  signal res_blt : std_logic; -- less than
  signal res_bge : std_logic; -- greater than or equal
  signal res_bltu : std_logic; -- less than unsigned
  signal res_bgeu : std_logic; -- greater than or equal unsigned
begin
    res_beq <= '1' when inputA = inputB else '0';
    res_bne <= '1' when inputA /= inputB else '0';
    res_blt <= '1' when signed(inputA) < signed(inputB) else '0';
    res_bge <= '1' when signed(inputA) >= signed(inputB) else '0';
    res_bltu <= '1' when unsigned(inputA) < unsigned(inputB) else '0';
    res_bgeu <= '1' when unsigned(inputA) >= unsigned(inputB) else '0';

    -- cond values match func3 field values for corresponding RV32I branch instructions
    with cond select
        result <=   res_beq when BR_COND_BEQ,
                    res_bne when BR_COND_BNE,
                    res_blt when BR_COND_BLT,
                    res_bge when BR_COND_BGE,
                    res_bltu when BR_COND_BLTU,
                    res_bgeu when BR_COND_BGEU,
                    '0' when others;

end architecture;
