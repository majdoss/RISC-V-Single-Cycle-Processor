library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity data_mem is
    port ( clk : in std_logic;
           reset_n : in std_logic;
           address : in std_logic_vector (ADDRLEN-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           ByteMask : in std_logic_vector (1 downto 0); -- "00" = byte; "01" = half-word; "10" = word
           SignExt_n : in std_logic; -- '0' = sign-extend; '1' = zero-extend
           MemWrite : in std_logic;
           MemRead : in std_logic;
           dataout : out std_logic_vector (XLEN-1 downto 0));
end data_mem;

architecture rtl of data_mem is
-- memory is byte addressable
type memory is array (0 to 2**(ADDRLEN)-1) of std_logic_vector (7 downto 0);
signal ram : memory := (others => (others => '0')); 

begin

 process(address, datain, MemWrite, MemRead, ByteMask, SignExt_n, clk, reset_n) is
 -- Initializing memory to all zeros;
 variable add: integer range 0 to 2**(ADDRLEN)-1;
 variable MSB : std_logic := '0';

  begin

   -- We assume a little-endian machine model
   add := to_integer(unsigned(address));

        if reset_n = '0' then
            ram <= (others => (others => '0'));
        elsif rising_edge(clk) and MemWrite = '1' and MemRead = '0' then
            case ByteMask is
                when "00" => 
                    ram(add) <= datain(7 downto 0);
                when "01" => 
                    ram(add) <= datain(7 downto 0);
                    ram(add+1) <= datain(15 downto 8);
                when "10" =>
                    ram(add) <= datain(7 downto 0);
                    ram(add+1) <= datain(15 downto 8);
                    ram(add+2) <= datain(23 downto 16);
                    ram(add+3) <= datain(31 downto 24);
                when others => null; -- Do nothing
            end case;
        elsif MemWrite = '0' and MemRead = '1' then
            case ByteMask is
                when "00" =>
                    if (SignExt_n = '0') then
                        MSB := ram(add)(7);
                    else
                        MSB := '0';
                    end if;
                    dataout <= (XLEN-1 downto XLEN-1-23=>MSB) & ram(add);
                when "01" =>
                    if (SignExt_n = '0') then
                        MSB := ram(add+1)(7);
                    else
                        MSB := '0';
                    end if;
                    dataout <= (XLEN-1 downto XLEN-1-15=>MSB) & ram(add+1) & ram(add);
                when "10" =>
                    dataout(7 downto 0) <= ram(add);
                    dataout(15 downto 8) <= ram(add+1);
                    dataout(23 downto 16) <= ram(add+2);
                    dataout(31 downto 24) <= ram(add+3);           
                when others => null;
            end case;
        else
        -- We can set dataout to 0 or we can choose to read since it is harmless
        -- We are reading garbage
        -- In our case we chose to set the output to 0
            dataout <= (others=>'0');
        end if;
 end process;
end architecture;
