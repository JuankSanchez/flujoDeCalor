library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Behavioral of counter_tb is

component counter is
    Generic (BITS : integer := 3; MAX_COUNT: integer := 5);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           load: in STD_LOGIC;
           value : out STD_LOGIC_VECTOR ((BITS-1) downto 0)
          );
end component;

signal clk: std_logic := '0';
signal rst,enable,load : std_logic;
signal value : std_logic_vector(2 downto 0);

begin

    CUT: counter generic map (BITS => 3,MAX_COUNT => 5) port map(clk,rst,enable,load,value);

    clk <= not clk after 25ns;

     test: process begin
           rst <= '1';
           enable <= '0';
           load <= '1';
           wait for 100 ns;
           rst <= '0';
           enable <= '1';
           load <= '1';
           wait for 100 ns;
           load <= '0';           
           wait for 1000 ns;
           load <= '1';
           wait for 50 ns;
           load <= '0';           
           wait for 1000 ns;
       end process;

end Behavioral;
