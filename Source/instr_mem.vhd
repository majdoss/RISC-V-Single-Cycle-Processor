library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity instr_mem is
 port ( address : in std_logic_vector (ADDRLEN-1 downto 0);
	dataout : out std_logic_vector (XLEN-1 downto 0));
end instr_mem ;

architecture rtl of instr_mem is
-- Instruction memory is byte addressable .
type memory is array (0 to 2**(ADDRLEN)-1) of std_logic_vector (7 downto 0);

begin

 process (address) is
-- Initialized the instruction memory to
-- A recursive fibonacci sequence program
	variable rom : memory := (
        X"B3", X"02", X"00", X"00", X"13", X"03", X"B0", X"00", 
        X"97", X"03", X"00", X"10", X"93", X"83", X"83", X"FF", 
        X"63", X"DE", X"62", X"00", X"13", X"85", X"02", X"00", 
        X"EF", X"00", X"C0", X"01", X"23", X"A0", X"A3", X"00", 
        X"93", X"83", X"43", X"00", X"93", X"82", X"12", X"00", 
        X"6F", X"F0", X"9F", X"FE", X"13", X"05", X"A0", X"00", 
        X"73", X"00", X"00", X"00", X"13", X"01", X"41", X"FF", 
        X"23", X"20", X"11", X"00", X"23", X"22", X"A1", X"00", 
        X"13", X"0E", X"10", X"00", X"63", X"44", X"AE", X"00", 
        X"6F", X"00", X"40", X"02", X"13", X"05", X"F5", X"FF", 
        X"EF", X"F0", X"5F", X"FE", X"23", X"24", X"A1", X"00", 
        X"03", X"25", X"41", X"00", X"13", X"05", X"E5", X"FF", 
        X"EF", X"F0", X"5F", X"FD", X"83", X"25", X"81", X"00", 
        X"33", X"05", X"B5", X"00", X"83", X"20", X"01", X"00", 
        X"13", X"01", X"C1", X"00", X"67", X"80", X"00", X"00", 
        others => (others=>'0'));

   variable add: integer range 0 to (2**(ADDRLEN)-1);

 begin
 -- We assume a little-endian machine model
  add := to_integer(unsigned(address));
  dataout(7 downto 0) <= rom(add);
  dataout(15 downto 8) <= rom(add + 1);
  dataout(23 downto 16) <= rom(add + 2);
  dataout(31 downto 24) <= rom(add + 3);
end process ;

end architecture ;
