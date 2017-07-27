----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.07.2017 09:57:37
-- Design Name: 
-- Module Name: tranferenciaACeldas - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tranferenciaACeldas is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        estado_out  : out std_logic_vector(1 downto 0);
        memoria_out : out std_logic_vector(1 downto 0);
        contador_out: out std_logic_vector(3 downto 0)
        --dout        : out STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end tranferenciaACeldas;

architecture Behavioral of tranferenciaACeldas is
    
    -- Estados>
    -- 0 = pasar datos de la memoria a las celdas
    -- 1 = calcular las celdas
    -- 2 = pasar los datos de la celdas a la memoria
    
    TYPE estados IS (ramACeldas, calcular, celdasARam);
    
    signal estado, nEstado: estados;
    signal sContador:std_logic_vector(3 downto 0);
    signal wea: STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal hab: std_logic_vector(1 downto 0);
    signal addra: STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal contador: std_logic_vector(3 downto 0);
    --signal estado  : estados;
    signal din : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
 --signal out_celda,in_derecho,in_superior,in_inferior,in_izquierdo: STD_LOGIC_VECTOR (31 downto 0);
   --signal clk,reset:STD_LOGIC;
    component blk_mem_gen_0 
        PORT (
            clka    : IN STD_LOGIC;
            ena     : IN STD_LOGIC;
            wea     : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            dina    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
    END component;
   
begin

    --habilitarMemo <= '1';
    ------------- Lower section: -----------------
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            contador <= "0000";
            estado <= ramACeldas;
        elsif clk = '1' AND clk'event THEN
            contador <=  contador+"0001";
            estado <= nEstado;
        end if;
    END PROCESS;
    ------------- Contador ------------------
    PROCESS (contador)
    BEGIN
         if(contador="1111") then
            contador <= "0000";
            CASE estado IS
                WHEN ramACeldas => nEstado <= calcular; 
                WHEN calcular => nEstado <= celdasARam;
                WHEN celdasARam => nEstado <= ramACeldas;
            END CASE;
         end if;
    END PROCESS;
    ------------- Maq. de Estado -----------------
    PROCESS (estado)
    BEGIN
        CASE estado IS
            WHEN ramACeldas =>
               wea <=  "1";
               hab <= "1"; 
            WHEN calcular =>
                hab <= "1";
            WHEN celdasARam =>
                wea <=  "0";
                hab <= "1";
            END CASE;
    END PROCESS;
    
    contador_out    <= contador;
    memoria_out     <= wea;
    estado_out      <= hab;
    
    --memoria: blk_mem_gen_0 port map(clk,habilitarMemo,wea,sContador,din,dout);
    --celdas: blk_mem_gen_0 port map(clk,habilitarMemo,wea,sContador,din,dout);

end Behavioral;
