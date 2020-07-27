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
use IEEE.NUMERIC_STD.ALL;

entity calculoDeCelda is
    generic (
        N: natural := 32;
        ambTemp: natural := 0
    );
    Port ( 
        in_izq      : in std_logic_vector (N-1 downto 0);
        in_der      : in std_logic_vector (N-1 downto 0);
        in_aba      : in std_logic_vector (N-1 downto 0);
        in_arr      : in std_logic_vector (N-1 downto 0);
        in_ini      : in std_logic_vector (N-1 downto 0);
        init_ena    : in std_logic;
        calcular    : in std_logic;
        clk         : in std_logic;
        rst         : in std_logic;
        enable      : in std_logic;
        out_calculo : out std_logic_vector (N-1 downto 0));
end calculoDeCelda;

architecture Behavioral of calculoDeCelda is
    signal  enableFF: std_logic;
    signal  suma,celda,celda_reg,celda_mux: std_logic_vector (31 downto 0);
    signal fuenteCalor,fuenteCalor_signal : std_logic;
    type ARRAY_STD_LOGIC_VECTOR_3 is array(0 to 3) of std_logic_vector(31 downto 0);
begin
        
-- combinacional calculos
suma <= std_logic_vector(signed(in_izq) + signed(in_der) + signed(in_aba) + signed(in_arr)); -- suma
celda <= "00" & suma(31 downto 2);

-- combinacional habilitar flip-flop
enableFF <= enable and (init_ena or (calcular and not fuenteCalor));
fuenteCalor_signal <= '0' when (std_logic_vector(to_unsigned(ambTemp,N)) = in_ini) else '1';

muxInitCelda:process (celda,in_ini,init_ena)
begin
    if init_ena = '1' then-- enable tendria que ser cero?
        celda_mux <= in_ini;
    else
        celda_mux <= celda;
    end if;
end process;    

--flip flop   
FFValorCelda:process (clk)
begin
   if clk'event and clk='1' then     
      if rst = '1' then
         celda_reg <= "00000000000000000000000000000000";
      elsif rst = '0' and enableFF = '1' then
            celda_reg <= celda_mux; 
      end if;
   end if;
end process;

--flip flop   
FFfuenteCalor:process (clk)
begin
   if clk'event and clk='1' then     
      if rst = '1' then
        fuenteCalor <= '0';
      elsif rst = '0' and init_ena = '1' then
        fuenteCalor <= fuenteCalor_signal;
      end if;
   end if;
end process;
out_calculo <= celda_reg;
    
end Behavioral;