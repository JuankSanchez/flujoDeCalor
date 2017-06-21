----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.06.2017 15:51:56
-- Design Name: 
-- Module Name: flujoDeCalor - Behavioral
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


entity flujoDeCalor is
    Port ( in_derecho: in STD_LOGIC_VECTOR (31 downto 0);
           in_superior: in STD_LOGIC_VECTOR (31 downto 0);
           in_inferior: in STD_LOGIC_VECTOR (31 downto 0);
           in_izquierdo: in STD_LOGIC_VECTOR (31 downto 0);
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           out_celda: out STD_LOGIC_VECTOR (31 downto 0));
end flujoDeCalor;

architecture Behavioral of flujoDeCalor is
component calculoDeCelda is
    Port ( in_derecho: in STD_LOGIC_VECTOR (31 downto 0);
           in_superior: in STD_LOGIC_VECTOR (31 downto 0);
           in_inferior: in STD_LOGIC_VECTOR (31 downto 0);
           in_izquierdo: in STD_LOGIC_VECTOR (31 downto 0);
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           out_celda: out STD_LOGIC_VECTOR (31 downto 0));
end component;

--signal out_celda,in_derecho,in_superior,in_inferior,in_izquierdo: STD_LOGIC_VECTOR (31 downto 0);

--signal clk,reset:STD_LOGIC;

begin
    
    celda:calculoDeCelda port map(in_derecho,in_superior,in_inferior,in_izquierdo,clk,reset,out_celda);
    
end Behavioral;
