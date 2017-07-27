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
use work.ARRAY_STD_LOGIC_VECTOR.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity flujoDeCalor is
    generic (
           N: natural := 31;
           cantidadCeldas: integer range 1 to 32 := 9   --nceldas=9 por defecto  
    );
    Port (
        clk: in  STD_LOGIC;
        rst: in  BOOLEAN
    );
end flujoDeCalor;
 
architecture Behavioral of flujoDeCalor is
    
    -- Estados>
    -- 0 = pasar datos de la memoria a las celdas
    -- 1 = calcular las celdas
    -- 2 = pasar los datos de la celdas a la memoria
    
    TYPE estados IS (ramACeldas, calcularTemperatura, celdasARam);
    
    -- ESTADO
    signal estado, estado_siguiente: estados;
    signal cambiaDeEstado: BOOLEAN;
    
    -- MEMORIA
    signal ena: STD_LOGIC;
    signal wea: STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal contador: std_logic_vector(3 downto 0);
    signal contador_reg: std_logic_vector(3 downto 0);    
    signal din : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal dout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    -- CELDAS
    signal calcular     : BOOLEAN;
    signal celdas       : ARRAY_STD_LOGIC_VECTOR_16;
    signal in_tderecha  : ARRAY_STD_LOGIC_VECTOR_16;
    signal in_tsuperior : ARRAY_STD_LOGIC_VECTOR_16;
    signal in_tinferior : ARRAY_STD_LOGIC_VECTOR_16;
    signal in_tizquierda: ARRAY_STD_LOGIC_VECTOR_16;
    signal out_tcelda   : ARRAY_STD_LOGIC_VECTOR_16;
    
    -- CONTROL  
    signal cuenta : BOOLEAN;
    
    --signal out_celda,in_derecho,in_superior,in_inferior,in_izquierdo: STD_LOGIC_VECTOR (31 downto 0);
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
    
    component calculoDeCelda 
        Port (  
            in_derecho  : in    STD_LOGIC_VECTOR (N downto 0);
            in_superior : in    STD_LOGIC_VECTOR (N downto 0);
            in_inferior : in    STD_LOGIC_VECTOR (N downto 0);
            in_izquierdo: in    STD_LOGIC_VECTOR (N downto 0);
            clk         : in    STD_LOGIC;
            reset       : in    BOOLEAN;
            habilitado  : in    BOOLEAN;
            out_celda   : out   STD_LOGIC_VECTOR (N downto 0)
        );
    end component;
begin  
     
     
    SYNC_PROC : process (clk)
    begin
        if rising_edge(clk) then
            if (rst) then
                contador_reg <= "0000";
                estado <= ramACeldas;
            else
                contador_reg <= contador;
                estado <= estado_siguiente;
            end if;
        end if;
    end process;

    -- generacion de se;ales de CONTROL
    COMBINACIONAL_SALIDA: process (estado)
    begin
         case (estado) is
            when ramACeldas =>
                wea <=  "0";
                ena <= '1';
                calcular <= false;
                cuenta <= true;
            when calcularTemperatura =>
                ena <= '0';
                calcular <= true;
                cuenta <= false;
            when celdasARam =>
                wea <=  "1";
                ena <= '1';
                calcular <= false;
                cuenta <= true;
         end case;
    end process;

    PROC_ESTADO_SIGUIENTE: process (estado, cambiaDeEstado)
    begin
         --estado_siguiente <= ramACeldas;
         case (estado) is
            when ramACeldas =>
                if (cambiaDeEstado) then
                    estado_siguiente <= calcularTemperatura;
                end if;
            when calcularTemperatura =>
                if (cambiaDeEstado) then
                    estado_siguiente <= celdasARam;
                end if;
             when celdasARam =>
                estado_siguiente <= ramACeldas;
         end case;
    end process; 
     
    PROC_CONTADOR: process (clk)
    begin
        if rising_edge(clk) then
            if (rst) then
                contador <= "0000";
            else
                if (cuenta) then
                   contador <= contador + 1;
                else
                    contador <= "0000";
                end if;
            end if;
        end if;
    end process;
    
--    PROC_CELDAS: PROCESS (contador_reg)
--    begin
--         if(estado=ramACeldas) then
--            celdas(to_integer(unsigned(contador_reg))) <= dout;
--         elsif(estado=celdasARam) then
--           din <= celdas(to_integer(unsigned(contador_reg)));
--        end if;
--    end process;
    PROC_CELDAS : process (clk)
    begin
        if rising_edge(clk) then
            if(estado=ramACeldas) then
                celdas(to_integer(unsigned(contador))) <= dout;
            elsif(estado=celdasARam) then
                din <= celdas(to_integer(unsigned(contador)));
            end if;
        end if;
    end process;    
    
    cambiaDeEstado <=  true when contador_reg="1111"  else false;
     
    memoria: blk_mem_gen_0 port map(
                    clka    => clk,
                    ena     => ena,
                    wea     => wea,
                    addra   => contador,
                    dina    => din,
                    douta   => dout);
            
        gen_cflujoCalor: for i in 0 to cantidadCeldas-1 generate 
        begin   
            celda_i: if(i=5 or i=6 or i=9 or i=10)  generate begin 
                celda: component calculoDeCelda port map(
                    in_derecho => celdas(i+1),
                    in_superior => celdas(i-4),
                    in_inferior => celdas(i+4),
                    in_izquierdo => celdas(i-1),
                    clk => clk,
                    reset => rst,
                    habilitado=>calcular,
                    out_celda => celdas(i)
                 );
            end generate;
    
        end generate;
     
     
     
     
     
     
     
     
     
     
     
     
--   -- ena <= '0';
--   -- calcular <= false;
         
--    --habilitarMemo <= '1';
--    ------------- Lower section: -----------------
--    PROCESS (clk,rst)
--    BEGIN
--        IF rst THEN
--            nContador <= "0000";
--            estado   <= ramACeldas;
--        elsif clk = '1' AND clk'event THEN
--            nContador <= contador;
--            estado   <= nEstado;
--        end if;
--    END PROCESS;
                
--    ------------- Contador ------------------
--    PROCESS (contador,rst)
--    BEGIN
--        IF rst THEN
--            contador <= "0000";
--            nEstado <= ramACeldas;
--        else
----            --agregar fliflop a la se;al contador para sincronizar
----            contador <= contador+1;
----            if(estado=ramACeldas) then
----                celdas(to_integer(unsigned(nContador))) <= dout;
----                if(contador="1111") then
----                    nEstado <= calcularTemperatura; 
----                end if;
----            elsif(estado=celdasARam) then
----                din <= celdas(to_integer(unsigned(nContador)));
----                if(contador="1111") then
----                    nEstado <= ramACeldas;
----                end if;
----            end if;
--       CASE estado IS
--             WHEN ramACeldas =>
--            celdas(to_integer(unsigned(nContador))) <= dout;
--             if(contador="1111") then
--                 nEstado <= calcularTemperatura; 
--             end if;
--             WHEN calcularTemperatura =>

--             WHEN celdasARam =>
--            din <= celdas(to_integer(unsigned(nContador)));
--             if(contador="1111") then
--                 nEstado <= ramACeldas;
--             end if;
--             END CASE;
--         end if;
--    END PROCESS;
--    ------------- Maq. de Estado -----------------
--    PROCESS (estado)
--    BEGIN
--        CASE estado IS
--            WHEN ramACeldas =>
--                contador <= "0000";
--                wea <=  "0";
--                ena <= '1';
--                calcular <= false;
--                cuenta <= true;
--            WHEN calcularTemperatura =>
--                ena <= '0';
--                calcular <= true;
--                cuenta <= false;
--            WHEN celdasARam =>
--                contador <= "0000";
--                wea <=  "1";
--                ena <= '1';
--                calcular <= false;
--                cuenta <= true;
--            END CASE;
--    END PROCESS;
    
    
        
end Behavioral;

--entity flujoDeCalor is
--   Generic (
--        N: natural := 31;
--        cantidadCeldas: integer range 1 to 32 := 9   --nceldas=9 por defecto  
--   );
--   Port ( in_tderecha  : in  ARRAY_STD_LOGIC_VECTOR_9;
--          in_tsuperior : in  ARRAY_STD_LOGIC_VECTOR_9;
--          in_tinferior : in  ARRAY_STD_LOGIC_VECTOR_9;
--          in_tizquierda: in  ARRAY_STD_LOGIC_VECTOR_9;
--          clk_fc       : in  STD_LOGIC;
--          reset_fc     : in  STD_LOGIC;
--          out_tcelda   : out ARRAY_STD_LOGIC_VECTOR_9
--   );
--end flujoDeCalor;
 
--architecture Behavioral of flujoDeCalor is
--    component calculoDeCelda 
--        Port (  in_derecho  : in    STD_LOGIC_VECTOR (N downto 0);
--                in_superior : in    STD_LOGIC_VECTOR (N downto 0);
--                in_inferior : in    STD_LOGIC_VECTOR (N downto 0);
--                in_izquierdo: in    STD_LOGIC_VECTOR (N downto 0);
--                clk         : in    STD_LOGIC;
--                reset       : in    STD_LOGIC;
--                out_celda   : out   STD_LOGIC_VECTOR (N downto 0)
--        );
--    end component;
-- begin  
    
--   gen_cflujoCalor: for i in 0 to cantidadCeldas-1 generate
--   begin   
--        celda0: component calculoDeCelda port map(
--            in_derecho => in_tderecha(i),
--            in_superior => in_tsuperior(i),
--            in_inferior => in_tinferior(i),
--            in_izquierdo => in_tizquierda(i),
--            clk => clk_fc,
--            reset => reset_fc,
--            out_celda => out_tcelda(i)
--         );
--   end generate;
    
   
--   --celda:calculoDeCelda port map(in_derecho,in_superior,in_inferior,in_izquierdo,clk,reset,out_celda);
    
--end Behavioral;