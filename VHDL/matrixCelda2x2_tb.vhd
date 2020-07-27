library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrixCelda2x2_tb is
end matrixCelda2x2_tb;

architecture Behavioral of matrixCelda2x2_tb is

component matrixCelda2x2 is
    Port ( 
           inData0 : in STD_LOGIC_VECTOR (31 downto 0);
           inData1 : in STD_LOGIC_VECTOR (31 downto 0);
           inData2 : in STD_LOGIC_VECTOR (31 downto 0);
           inData3 : in STD_LOGIC_VECTOR (31 downto 0);
           inData4 : in STD_LOGIC_VECTOR (31 downto 0);
           inData5 : in STD_LOGIC_VECTOR (31 downto 0);
           inData6 : in STD_LOGIC_VECTOR (31 downto 0);
           inData7 : in STD_LOGIC_VECTOR (31 downto 0);
           outData0 : out STD_LOGIC_VECTOR (31 downto 0);
           outData1 : out STD_LOGIC_VECTOR (31 downto 0);
           outData2 : out STD_LOGIC_VECTOR (31 downto 0);
           outData3 : out STD_LOGIC_VECTOR (31 downto 0);
           initAddress : in STD_LOGIC_VECTOR (1 downto 0);
           initEna : in STD_LOGIC;
           initData : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ena : in STD_LOGIC);
end component;

signal inData0 : STD_LOGIC_VECTOR (31 downto 0);
signal inData1 : STD_LOGIC_VECTOR (31 downto 0);
signal inData2 : STD_LOGIC_VECTOR (31 downto 0);
signal inData3 : STD_LOGIC_VECTOR (31 downto 0);
signal inData4 : STD_LOGIC_VECTOR (31 downto 0);
signal inData5 : STD_LOGIC_VECTOR (31 downto 0);
signal inData6 : STD_LOGIC_VECTOR (31 downto 0);
signal inData7 : STD_LOGIC_VECTOR (31 downto 0);
signal outData0 : STD_LOGIC_VECTOR (31 downto 0);
signal outData1 : STD_LOGIC_VECTOR (31 downto 0);
signal outData2 : STD_LOGIC_VECTOR (31 downto 0);
signal outData3 : STD_LOGIC_VECTOR (31 downto 0);
signal initAddress : STD_LOGIC_VECTOR (1 downto 0);
signal initEna : STD_LOGIC;
signal borde : STD_LOGIC;
signal initData : STD_LOGIC_VECTOR (31 downto 0);
signal rst : STD_LOGIC;
signal ena : STD_LOGIC;
signal clk : std_logic := '0' ;


begin

CUT: matrixCelda2x2 port map (
    inData0,
    inData1,
    inData2,
    inData3,
    inData4,
    inData5,
    inData6,
    inData7,
    outData0,
    outData1,
    outData2,
    outData3,
    initAddress,
    initEna,
    initData,
    clk,
    rst,
    ena);

clk <= not clk after 25ns;

test: process begin
    rst <= '1';     
    ena <= '0';
    wait for 100 ns;
    rst <= '0';     
    ena <= '1';
    initEna <= '1';
    inData0 <= x"0001_0000";
    inData1 <= x"0001_0000";
    inData2 <= x"0001_0000";
    inData3 <= x"0001_0000";
    inData4 <= x"0001_0000";
    inData5 <= x"0001_0000";
    inData6 <= x"0001_0000";
    inData7 <= x"0001_0000";
    wait for 50 ns;
    initAddress  <= "00";
    initData <= x"0009_0000";
    wait for 50 ns;
    initAddress  <= "01";
    initData <= x"0000_0000";
    wait for 50 ns;
    initAddress  <= "10";
    initData <= x"0000_0000";    
    wait for 50 ns;
    initAddress  <= "11";
    initData <= x"0000_0000";
    wait for 50 ns;
    initEna <= '0';
    wait for 250 ns;
end process;

end Behavioral;
