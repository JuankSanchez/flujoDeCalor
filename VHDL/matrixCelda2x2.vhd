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

entity matrixCelda2x2 is
    Port ( 
           inData0 : in STD_LOGIC_VECTOR (31 downto 0);
           inData1 : in STD_LOGIC_VECTOR (31 downto 0);
           inData2 : in STD_LOGIC_VECTOR (31 downto 0);
           inData3 : in STD_LOGIC_VECTOR (31 downto 0);
           inData4 : in STD_LOGIC_VECTOR (31 downto 0);
           inData5 : in STD_LOGIC_VECTOR (31 downto 0);
           inData6 : in STD_LOGIC_VECTOR (31 downto 0);
           inData7 : in STD_LOGIC_VECTOR (31 downto 0);
           writeback_data : out STD_LOGIC_VECTOR (31 downto 0);
           outData0 : out STD_LOGIC_VECTOR (31 downto 0);
           outData1 : out STD_LOGIC_VECTOR (31 downto 0);
           outData2 : out STD_LOGIC_VECTOR (31 downto 0);
           outData3 : out STD_LOGIC_VECTOR (31 downto 0);
           initAddress : in STD_LOGIC_VECTOR (1 downto 0);
           initEna : in STD_LOGIC;
           writeBack_ena : in STD_LOGIC;
           initData : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ena : in STD_LOGIC
           );
end matrixCelda2x2;

architecture Behavioral of matrixCelda2x2 is
signal outCelda0, outCelda1 ,outCelda2, outCelda3: std_logic_vector (31 downto 0); 
signal calcular,fuenteCalor: std_logic;
signal init_ctrl: std_logic_vector(3 downto 0);
begin

calcular <= not initEna;

outData0 <= outCelda0;
outData1 <= outCelda1;
outData2 <= outCelda2;
outData3 <= outCelda3;

process(initAddress,initEna)
begin
    if(initEna = '1') then
         case initAddress is
            when "00" => init_ctrl <= "0001";
            when "01" => init_ctrl <= "0010";
            when "10" => init_ctrl <= "0100";
            when "11" => init_ctrl <= "1000";
            when others => init_ctrl <= "0000";
         end case;
     else
         init_ctrl <= "0000";
     end if;
end process;

outDataMem:process(initAddress,writeBack_ena,outCelda0,outCelda1,outCelda2,outCelda3)
begin
    if(writeBack_ena = '1') then
         case initAddress is
            when "00" => writeback_data <= outCelda0;
            when "01" => writeback_data <= outCelda1;
            when "10" => writeback_data <= outCelda2;
            when "11" => writeback_data <= outCelda3;
            when others => writeback_data <= outCelda0;
         end case;
     else
         writeback_data <= x"00000000";
     end if;
end process;

CalculoDeCelda_0 : entity work.calculoDeCelda
generic map(N => 32)
port map ( 
        in_izq  => inData0,
        in_der  => outCelda1,
        in_aba  => outCelda2,
        in_arr  => inData1,
        in_ini  => initData,
        init_ctrl => init_ctrl(0),
        calcular=> calcular,
        clk     => clk,
        rst     => rst,
        enable  => ena,
        out_calculo => outCelda0
        );
CalculoDeCelda_1 : entity work.calculoDeCelda
   generic map (N => 32)
   port map ( 
        in_izq  => outCelda0,
        in_der  => inData3,
        in_aba  => outCelda3,
        in_arr  => inData2,
        in_ini  => initData,
        init_ctrl => init_ctrl(1),
        calcular=> calcular,
        clk     => clk,
        rst     => rst,
        enable  => ena,
        out_calculo => outCelda1
        );
CalculoDeCelda_2 : entity work.calculoDeCelda
      generic map (N => 32)
      port map ( 
        in_izq  => inData7,
        in_der  => outCelda3,
        in_aba  => inData6,
        in_arr  => outCelda0,
        in_ini  => initData,
        init_ctrl => init_ctrl(2),
        calcular=> calcular,
        clk     => clk,
        rst     => rst,
        enable  => ena,
        out_calculo => outCelda2
        );
    
CalculoDeCelda_3 : entity work.calculoDeCelda
         generic map (N => 32)
       port map ( 
         in_izq  => outCelda2,
         in_der  => inData4,
         in_aba  => inData5,
         in_arr  => outCelda1,
         in_ini  => initData,
         init_ctrl => init_ctrl(3),
         calcular=> calcular,
         clk     => clk,
         rst     => rst,
         enable  => ena,
         out_calculo => outCelda3
         );
end Behavioral;