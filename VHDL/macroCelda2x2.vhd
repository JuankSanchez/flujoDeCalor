----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2017 16:16:32
-- Design Name: 
-- Module Name: matrixCelda2x2 - Behavioral
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

entity macroCelda2x2 is
    generic (
        N: natural := 32;    -- Data Width
        ambTemp: natural := 0
    );
    Port ( 
           clk :            in STD_LOGIC;
           rst :            in STD_LOGIC;
           enable :         in STD_LOGIC;
           mc_init_data :   in STD_LOGIC_VECTOR (127 downto 0);
           mc_init_enable : in std_logic;
           cm_calcular    : in std_logic;
           inData0 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData1 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData2 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData3 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData4 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData5 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData6 :        in STD_LOGIC_VECTOR (31 downto 0);
           inData7 :        in STD_LOGIC_VECTOR (31 downto 0);
           outData0 :       out STD_LOGIC_VECTOR (31 downto 0);
           outData1 :       out STD_LOGIC_VECTOR (31 downto 0);
           outData2 :       out STD_LOGIC_VECTOR (31 downto 0);
           outData3 :       out STD_LOGIC_VECTOR (31 downto 0);
           mc_fin_data :    out STD_LOGIC_VECTOR (127 downto 0)
           );
end macroCelda2x2;

architecture Behavioral of macroCelda2x2 is
signal outCelda0, outCelda1 ,outCelda2, outCelda3: std_logic_vector (31 downto 0); 
signal calcular: std_logic;
begin

calcular <= cm_calcular;

outData0 <= outCelda0;
outData1 <= outCelda1;
outData2 <= outCelda2;
outData3 <= outCelda3;

--process(initAddress,initEna)
--begin
--    if(initEna = '1') then
--         case initAddress is
--            when "00" => init_ctrl <= "0001";
--            when "01" => init_ctrl <= "0010";
--            when "10" => init_ctrl <= "0100";
--            when "11" => init_ctrl <= "1000";
--            when others => init_ctrl <= "0000";
--         end case;
--     else
--         init_ctrl <= "0000";
--     end if;
--end process;

mc_fin_data <= outCelda0 & outCelda1 & outCelda2 & outCelda3;

--outDataMem:process(initAddress,writeBack_ena,outCelda0,outCelda1,outCelda2,outCelda3)
--begin
--    if(writeBack_ena = '1') then
--         case initAddress is
--            when "00" => writeback_data <= outCelda0;
--            when "01" => writeback_data <= outCelda1;
--            when "10" => writeback_data <= outCelda2;
--            when "11" => writeback_data <= outCelda3;
--            when others => writeback_data <= outCelda0;
--         end case;
--     else
--         writeback_data <= x"00000000";
--     end if;
--end process;

CalculoDeCelda_0 : entity work.calculoDeCelda
generic map(N => N,ambTemp => ambTemp)
    port map ( 
        in_izq      => inData0,
        in_der      => outCelda1,
        in_aba      => outCelda2,
        in_arr      => inData1,
        in_ini      => mc_init_data(31 downto 0),
        init_ena    => mc_init_enable,
        calcular    => calcular,
        clk         => clk,
        rst         => rst,
        enable      => enable,
        out_calculo => outCelda0
        );
        
CalculoDeCelda_1 : entity work.calculoDeCelda
   generic map (N => N,ambTemp => ambTemp)
   port map ( 
        in_izq      => outCelda0,
        in_der      => inData3,
        in_aba      => outCelda3,
        in_arr      => inData2,
        in_ini      => mc_init_data(63 downto 32),
        init_ena    => mc_init_enable,
        calcular    => calcular,
        clk         => clk,
        rst         => rst,
        enable      => enable,
        out_calculo => outCelda1
        );
CalculoDeCelda_2 : entity work.calculoDeCelda
      generic map (N => N,ambTemp => ambTemp)
      port map ( 
        in_izq      => inData7,
        in_der      => outCelda3,
        in_aba      => inData6,
        in_arr      => outCelda0,
        in_ini      => mc_init_data(95 downto 64),
        init_ena    => mc_init_enable,        
        calcular    => calcular,
        clk         => clk,
        rst         => rst,
        enable      => enable,
        out_calculo => outCelda2
        );
    
CalculoDeCelda_3 : entity work.calculoDeCelda
         generic map (N => N,ambTemp => ambTemp)
       port map ( 
        in_izq      => outCelda2,
        in_der      => inData4,
        in_aba      => inData5,
        in_arr      => outCelda1,
        in_ini      => mc_init_data(127 downto 96),
        init_ena    => mc_init_enable,        
        calcular    => calcular,
        clk         => clk,
        rst         => rst,
        enable      => enable,
        out_calculo => outCelda3
         );
end Behavioral;