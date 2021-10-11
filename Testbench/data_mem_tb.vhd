library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity data_mem_tb is
end data_mem_tb;

architecture driver of data_mem_tb is
component data_mem
  port (   clk : in std_logic;
           reset_n : in std_logic;
           address : in std_logic_vector (ADDRLEN-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           ByteMask : in std_logic_vector (1 downto 0); -- "00" = byte; "01" = half-word; "10" = word
           SignExt_n : in std_logic; -- '0' = sign-extend; '1' = zero-extend
           MemWrite : in std_logic;
           MemRead : in std_logic;
           dataout : out std_logic_vector (XLEN-1 downto 0));
end component;

-- inputs
   signal tb_clk : std_logic := '0';
   signal tb_reset_n : std_logic := '1';
   signal tb_address : std_logic_vector (ADDRLEN-1 downto 0):= (others => '0');
   signal tb_datain : std_logic_vector (XLEN-1 downto 0):= (others => '0');
   signal tb_ByteMask: std_logic_vector (1 downto 0):= (others => '0');
   signal tb_SignExt_n : std_logic := '0';
   signal tb_MemWrite : std_logic := '0';
   signal tb_MemRead : std_logic := '0';
-- outputs
   signal tb_dataout : std_logic_vector (XLEN-1 downto 0);

   constant ClockFrequency: integer := 100e6; --100MHz
   constant ClockPeriod: time := 1000ms / ClockFrequency;

begin
-- Instantiate the Unit Under Test (UUT)
  UUT: data_mem port map (  
			    clk => tb_clk,
			    reset_n => tb_reset_n,
			    address => tb_address,
		            datain => tb_datain,
                            ByteMask => tb_ByteMask,
			    SignExt_n => tb_SignExt_n,
    		            MemWrite => tb_MemWrite,
		            MemRead => tb_MemRead,
			    dataout => tb_dataout );

    process is
    begin
        wait for 20 ns;
        tb_MemWrite <= '1';
        tb_MemRead <= '0';
        tb_ByteMask <= "10"; -- simulate SW instruction
        tb_SignExt_n <= '0';
        wait for 0 ns;
        for i in 0 to 10 loop
            tb_address <= std_logic_vector(to_unsigned((4*i)+400, tb_address'length));
            tb_datain <= std_logic_vector(to_unsigned((100*i)+1000, tb_datain'length));
            wait for 0 ns;
            tb_clk <= '1';
            wait for ClockPeriod/2;
            tb_clk <= '0';
            wait for ClockPeriod/2;
        end loop;

        wait for 20 ns;
        tb_MemWrite <= '0';
        tb_MemRead <= '1';
        tb_ByteMask <= "00"; -- simulate LBU instruction
        tb_SignExt_n <= '1';
        wait for 0 ns;
        for i in 0 to 40 loop
            tb_address <= std_logic_vector(to_unsigned(i+400, tb_address'length));
            wait for 0 ns;
            tb_clk <= '1';
            wait for ClockPeriod/2;
            tb_clk <= '0';
            wait for ClockPeriod/2;
        end loop;

        wait;
        
    end process;

end architecture;
