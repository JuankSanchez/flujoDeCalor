----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2017 15:10:43
-- Design Name: 
-- Module Name: calculoMatrix - Behavioral
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
use work.ARRAY_STD_LOGIC_VECTOR_3.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculoMatrix is
    Generic (
        N: natural := 31  -- longitud de la celdas
    );
    Port ( 
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       enable: in STD_LOGIC;
       counter_it_aux_end: in STD_LOGIC; -- Sacar
       temp_const : in    STD_LOGIC_VECTOR (31 downto 0);
       inData0,inData1,inData2,inData3 : in    STD_LOGIC_VECTOR (31 downto 0);
       inData4,inData5,inData6,inData7 : in    STD_LOGIC_VECTOR (31 downto 0);
       outData0,outData1,outData2,outData3 :  out STD_LOGIC_VECTOR (31 downto 0)
    );
end calculoMatrix;

architecture Behavioral of calculoMatrix is

    signal address : std_logic_vector (1 downto 0); 
    signal counter_addr_enable : std_logic;
    signal counter_addr_load : std_logic;
    signal counter_addr_end : std_logic;
    signal counter_it_enable : std_logic;
    signal counter_it_load : std_logic;
    signal counter_it_end : std_logic;
    signal memory_enable: std_logic;
    signal memory_we: std_logic;
    signal calculoMatrix_enable : std_logic;
    signal whriteBack_enabled : std_logic;
    signal initEnabled: std_logic;
    signal conexion: ARRAY_STD_LOGIC_VECTOR_3;
    
    component calculoMatrix2x2 
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               address : in std_logic_vector (1 downto 0); 
               memory_we: in std_logic;
               memory_enable: in std_logic;
               initEnabled: in std_logic;
               whriteBack_enabled: in std_logic;
               calculoMatrix_enable : in std_logic;
               inData0,inData1,inData2,inData3 : in    STD_LOGIC_VECTOR (31 downto 0);
               inData4,inData5,inData6,inData7 : in    STD_LOGIC_VECTOR (31 downto 0);
               outData0,outData1,outData2,outData3 :  out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
begin

initEnabled <= counter_addr_enable and not memory_we;
whriteBack_enabled <= counter_addr_enable and memory_we;

counter_address : entity work.counter 
    generic map 
        (N => 2) 
    port map (
        clk => clk,
        rst => rst,
        enable => counter_addr_enable,
        load => counter_addr_load,
        address => address,
        counter_end => counter_addr_end
    ); 

counter_iteration : entity work.counter 
    generic map 
        (N => 4) 
    port map (
        clk => clk,
        rst => rst,
        enable => counter_it_enable,
        load => counter_it_load,
        address => "0000",
        counter_end => counter_it_end
    ); 

 control_machine : entity work.control_machine
    port map (
        clk => clk,
        rst => rst,
        enable => enable,
        matrixCeldaCalculo_end => counter_it_end, --counter_it_end, -- Control de la cantidad de iteraciones, viene de afuera
        matrixCelda_enable => calculoMatrix_enable,  
        counter_addr_end =>  counter_addr_end,
        counter_addr_enable => counter_addr_enable,
        counter_addr_load => counter_addr_load,
        counter_it_end => counter_it_end,
        counter_it_enable => counter_it_enable,
        counter_it_load => counter_it_load,
        memory_enable => memory_enable,
        memory_we => memory_we   
    );

    -- Recorrido por filas
    gen_fila: for fila in 0 to N-1 generate
    begin 
        -- Recorrido por columnas
        gen_columna: for columna in 0 to N-1 generate
            begin  
                -- esquina 0x0
                pos0x0: if (fila=0 and columna=0) generate 
                begin
                    x: component calculoMatrix2x2 Port map ( 
                        clk => clk,
                        rst => rst,
                        address => address, 
                        memory_we => memory_we,
                        memory_enable => memory_enable,
                        initEnabled => initEnabled,
                        whriteBack_enabled => whriteBack_enabled,
                        calculoMatrix_enable => calculoMatrix_enable,
                        inData0 => temp_const,
                        inData1 => temp_const,
                        inData2 => temp_const,
                        inData3 => izqder(N*fila+columna),
                        inData4 => inData4,
                        inData5 => inData5,
                        inData6 => inData6,
                        inData7 => temp_const,
                        outData0 => outData0,
                        outData1 => outData1,
                        outData2 => outData2,
                        outData3  => outData3  
                    );
                end generate;
                
               -- centro
               pos_nxn: if (fila>0 and columna<0) generate 
               begin
                  component calculoMatrix2x2 Port map ( 
                       clk => clk,
                       rst => rst,
                       address => address, 
                       memory_we => memory_we,
                       memory_enable => memory_enable,
                       initEnabled => initEnabled,
                       whriteBack_enabled => whriteBack_enabled,
                       calculoMatrix_enable => calculoMatrix_enable,
                       inData0 => izqder(N*fila+columna),
                       inData1 => temp_const,
                       inData2 => temp_const,
                       inData3 => izqder(N*fila+columna),
                       inData4 => inData4,
                       inData5 => inData5,
                       inData6 => inData6,
                       inData7 => temp_const,
                       outData0 => outData0,
                       outData1 => outData1,
                       outData2 => outData2,
                       outData3  => outData3  
                   );
                   
               end generate;
                
        end generate;
   end generate;
    
--    calculoMatrix2x2: entity work.calculoMatrix2x2
--    Port map ( 
--            clk => clk,
--            rst => rst,
--            address => address, 
--            memory_we => memory_we,
--            memory_enable => memory_enable,
--            initEnabled => initEnabled,
--            whriteBack_enabled => whriteBack_enabled,
--           calculoMatrix_enable => calculoMatrix_enable,
--           inData0 => inData0,
--           inData1 => inData1,
--           inData2 => inData2,
--           inData3 => inData3,
--           inData4 => inData4,
--           inData5 => inData5,
--           inData6 => inData6,
--           inData7 => inData7,
--           outData0 => outData0,
--           outData1 => outData1,
--           outData2 => outData2,
--           outData3  => outData3  
--    );
    
    
end Behavioral;
