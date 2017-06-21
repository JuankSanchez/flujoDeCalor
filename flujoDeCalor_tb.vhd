----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.06.2017 16:36:34
-- Design Name: 
-- Module Name: flujoDeCalor_tb - Behavioral
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

entity flujoDeCalor_tb is

end flujoDeCalor_tb;

architecture Behavioral of flujoDeCalor_tb is

component flujoDeCalor is
    Port ( in_derecho: in STD_LOGIC_VECTOR (31 downto 0);
           in_superior: in STD_LOGIC_VECTOR (31 downto 0);
           in_inferior: in STD_LOGIC_VECTOR (31 downto 0);
           in_izquierdo: in STD_LOGIC_VECTOR (31 downto 0);
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           out_celda: out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal out_celda,in_derecho,in_superior,in_inferior,in_izquierdo: STD_LOGIC_VECTOR (31 downto 0);

signal clk,reset:STD_LOGIC;

signal fin: BOOLEAN;

begin

    CUT: flujoDeCalor port map(in_derecho,in_superior,in_inferior,in_izquierdo,clk,reset,out_celda);

    reloj: process -- Reloj de 50 MHz
       begin
          while not Fin loop -- mientras dure la simulacion ...
             clk <= '0'; wait for 25 ns;
             clk <= '1'; wait for 25 ns;
          end loop;
          wait; -- Fin de la simulacion
       end process;


    test: process begin
        reset <= '1';
        wait for 10 us;
        in_derecho      <= "00000000000000000000000000000001";
        in_izquierdo    <= "00000000000000000000000000000001";
        in_superior     <= "00000000000000000000000000000001";
        in_inferior     <= "00000000000000000000000000000001";
        wait for 10 us;
        reset <= '0';
        wait for 1000 us;        
     end process;
    
end Behavioral;
