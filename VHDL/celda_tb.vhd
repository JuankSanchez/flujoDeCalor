----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2017 06:42:07 PM
-- Design Name: 
-- Module Name: celda_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity celda_tb is
--  Port ( );
end celda_tb;

architecture Behavioral of celda_tb is

component calculoDeCelda is
    Port (
        in_izq  : in std_logic_vector (31 downto 0);
        in_der  : in std_logic_vector (31 downto 0);  
        in_aba  : in std_logic_vector (31 downto 0);
        in_arr  : in std_logic_vector (31 downto 0);
        in_ini  : in std_logic_vector (31 downto 0);
        init_ctrl   : in std_logic;
        calcular    : in std_logic;
        borde       : in std_logic;
        clk         : in std_logic;
        rst         : in std_logic;
        enable      : in std_logic;
        out_calculo: out std_logic_vector (31 downto 0)
    );
end component;

signal clk : std_logic := '1';
signal rst : std_logic;
signal enable,calcular,init_ctrl,borde: std_logic;
signal out_calculo :    std_logic_vector (31 downto 0);
signal in_der  :    STD_LOGIC_VECTOR (31 downto 0);
signal in_arr :    STD_LOGIC_VECTOR (31 downto 0);
signal in_aba :    STD_LOGIC_VECTOR (31 downto 0);
signal in_izq:    STD_LOGIC_VECTOR (31 downto 0);
signal in_ini:          STD_LOGIC_VECTOR (31 downto 0);

begin

CUT : calculoDeCelda port map (in_izq,in_der,in_aba,in_arr,in_ini,init_ctrl,calcular,borde,clk,rst,enable,out_calculo);

clk <= not clk after 25ns;

test: process begin
    rst <= '1';
    init_ctrl <= '0';
    borde <= '0';
    calcular <= '0';
    wait for 200 ns; 
    rst <= '0';
    in_der  <= x"00001000";
    in_arr <= x"00002000";
    in_aba <= x"00003000";
    in_izq<= x"00004000";  
    enable <= '1';
    in_ini <= x"00008000";
    init_ctrl <= '1';
    wait for 50 ns;
    init_ctrl <= '0';
    wait for 150 ns;
    calcular <= '1';
    wait for 50 ns;
    in_der  <= x"00004000";
    in_arr <= x"00002000";
    in_aba <= x"00002000";
    in_izq<= x"00004000";  
    wait for 1500 ns;

end process;

end Behavioral;
