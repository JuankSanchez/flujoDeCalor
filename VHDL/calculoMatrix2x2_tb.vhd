library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculoMatrix2x2_tb is
end calculoMatrix2x2_tb;

architecture Behavioral of calculoMatrix2x2_tb is

component calculoMatrix2x2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable: in STD_LOGIC;
           calculoMatrix2x2_end : in STD_LOGIC;
           inData0,inData1,inData2,inData3 : in    STD_LOGIC_VECTOR (31 downto 0);
           inData4,inData5,inData6,inData7 : in    STD_LOGIC_VECTOR (31 downto 0);
           outData0,outData1,outData2,outData3 :  out STD_LOGIC_VECTOR (31 downto 0)
    );
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
signal rst : STD_LOGIC;
signal enable : STD_LOGIC;
signal clk : std_logic := '0';
signal calculoMatrix2x2_end : STD_LOGIC;



begin

CUT: calculoMatrix2x2 port map (
    clk,
    rst,
    enable,
    calculoMatrix2x2_end,
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
    outData3);

clk <= not clk after 25ns;

test: process begin
    rst <= '1';     
    enable <= '0';
    wait for 100 ns;
    rst <= '0';     
    enable <= '1';
    calculoMatrix2x2_end <= '0';
    inData0 <= x"0001_0000";
    inData1 <= x"0000_0000";
    inData2 <= x"0000_0000";
    inData3 <= x"0002_0000";
    inData4 <= x"0002_0000";
    inData5 <= x"0003_0000";
    inData6 <= x"0003_0000";
    inData7 <= x"0001_0000";
    wait for 500 ns;
    calculoMatrix2x2_end <= '1';
    wait for 1500 ns;
   
end process;

end Behavioral;