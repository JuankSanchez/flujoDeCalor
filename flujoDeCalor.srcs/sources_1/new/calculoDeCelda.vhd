----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.06.2017 15:53:43
-- Design Name: 
-- Module Name: calculoDeCelda - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED;
use IEEE.NUMERIC_STD.ALL;

entity calculoDeCelda is
    generic (N: natural := 31);
    Port ( in_derecho   : in STD_LOGIC_VECTOR (N downto 0);
           in_superior  : in STD_LOGIC_VECTOR (N downto 0);
           in_inferior  : in STD_LOGIC_VECTOR (N downto 0);
           in_izquierdo : in STD_LOGIC_VECTOR (N downto 0);
           clk          : in STD_LOGIC;
           reset        : in BOOLEAN;
           habilitado   : in BOOLEAN;
           out_celda    : out STD_LOGIC_VECTOR (N downto 0));
end calculoDeCelda;

architecture Behavioral of calculoDeCelda is
signal  celda,
        suma,
        celda_reg,
        derecho_reg,
        izquierdo_reg,superior_reg,
        inferior_reg: STD_LOGIC_VECTOR (31 downto 0);
begin
    --flip flop   
    process (clk)
    begin
       if habilitado and clk'event and clk='1' then
          if reset then
             derecho_reg <= "00000000000000000000000000000000";
             izquierdo_reg <= "00000000000000000000000000000000";
             superior_reg <= "00000000000000000000000000000000";
             inferior_reg <= "00000000000000000000000000000000";
          else
             derecho_reg <= in_derecho;
             izquierdo_reg <= in_izquierdo;
             superior_reg <= in_superior;
             inferior_reg <= in_inferior;
          end if;
       end if;
    end process;
    
    -- calculos
    suma <= std_logic_vector(signed(derecho_reg) + signed(izquierdo_reg) + signed(superior_reg) + signed(inferior_reg)); -- suma
    celda <= "00" & suma(31 downto 2);
        
    --flip flop   
    process (clk)
    begin
       if clk'event and clk='1' then
          if reset then
             celda_reg <= "00000000000000000000000000000000";
          else
             celda_reg <= celda;
          end if;
       end if;
    end process;
    
    out_celda <= celda_reg;
    
end Behavioral;
