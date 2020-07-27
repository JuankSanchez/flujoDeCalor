library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_tb is
--  Port ( );
end memory_tb;

architecture Behavioral of memory_tb is

component memory is
    Generic (DATA_WIDTH : integer := 32;
         ADDRESS_WIDTH: integer := 2);
Port ( clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       enable : in STD_LOGIC;
       address : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
       we : in STD_LOGIC;
       din : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
       dout : inout STD_LOGIC_VECTOR (DATA_WIDTH -1  downto 0));
end component;

signal clk : std_logic := '0' ;
signal rst, enable,we : std_logic;
signal address : std_logic_vector (1 downto 0);
signal din, dout : std_logic_vector (31 downto 0);

begin
CUT: memory generic map (DATA_WIDTH => 32, ADDRESS_WIDTH => 2) port map (clk,rst,enable,address,we,din,dout);

clk <= not clk after 25ns;

test: process begin
    rst <= '1';
    enable <= '0';
    we <= '0';         
    wait for 100 ns;
    rst <= '0';
    enable <= '1';
    we <= '0';
    
    address <= "00";
    din <= x"00000000"; 
    wait for 50 ns;
    address <= "01";
    din <= x"00000001"; 
    wait for 50 ns;
    address <= "10";
    din <= x"00000010"; 
    wait for 50 ns;
    address <= "11";
    din <= x"00000011"; 
    wait for 50 ns;
    we <= '0';
    address <= "00";
    wait for 50 ns;
    address <= "01";
    wait for 50 ns;
    address <= "10";
    wait for 50 ns;
    address <= "11";
    wait for 50 ns;       
end process;
       
end Behavioral;
