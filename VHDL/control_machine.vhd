library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_machine is
    Port ( 
        clk : in std_logic;
        rst : in std_logic;
        enable : in std_logic;
        matrixCalculo_end: in std_logic;
        matrix_enable: out std_logic;  
        matrix_calcular: out std_logic;      
        counter_addr_end: in std_logic;
        counter_addr_enable : out std_logic;
        counter_addr_load: out std_logic;
        counter_it_end: in std_logic;
        counter_it_enable : out std_logic;
        counter_it_load: out std_logic;
        memory_enable : out std_logic;
        memory_we : out std_logic
        );
end control_machine;

architecture Behavioral of control_machine is
    type estados is (ramACeldas, calcularTemperatura, celdasARam,fin);
    signal estado, estado_siguiente : estados;
    attribute fsm_encoding : string;
    attribute fsm_encoding of estado : signal is "sequential";
    attribute fsm_encoding of estado_siguiente : signal is "sequential";
    
    signal counter_addr_load_signal : std_logic;
    signal counter_it_load_signal: std_logic;
    signal counter_addr_ena_signal : std_logic;
    signal counter_it_ena_signal : std_logic;
    signal memory_enable_signal, memory_we_signal: std_logic;
    signal matrixCelda_enable_signal : std_logic;
    signal martix_calcular_signal: std_logic;
    
begin

SYNC_PROC: process (clk)
begin
    if (clk'event and clk = '1') then
        if (rst = '1') then
            estado <= ramACeldas;
            counter_addr_enable <= '0';
            counter_addr_load <= '1'; 
            counter_it_enable <= '0';
            counter_it_load <= '1';
            memory_enable <= '0';
            memory_we <= '0';    
            matrix_enable <= '0';
            matrix_calcular <= '0';
        elsif (enable = '1') then
            estado <= estado_siguiente;
            counter_addr_enable <= counter_addr_ena_signal;
            counter_addr_load <= counter_addr_load_signal; 
            counter_it_enable <= counter_it_ena_signal;
            counter_it_load <= counter_it_load_signal; 
            memory_enable <= memory_enable_signal;
            memory_we <= memory_we_signal;  
            matrix_enable <= matrixCelda_enable_signal;
            matrix_calcular <= martix_calcular_signal;  
        end if;
    end if;
end process;

--MOORE State-Machine - Outputs based on state only
OUTPUT_DECODE: process (estado)
begin
    case (estado) is
        when ramACeldas =>
            counter_addr_ena_signal <= '1';
            counter_addr_load_signal <= '0';
            counter_it_ena_signal <= '0';
            counter_it_load_signal <= '1';            
            memory_enable_signal <= '1';
            memory_we_signal <= '0';     
            matrixCelda_enable_signal <= '1';    
            martix_calcular_signal <= '0';          
        when calcularTemperatura =>
            counter_addr_ena_signal <= '0';
            counter_addr_load_signal <= '1';
            counter_it_ena_signal <= '1';
            counter_it_load_signal <= '0'; 
            memory_enable_signal <= '0';
            memory_we_signal <= '0';
            matrixCelda_enable_signal <= '1';
            martix_calcular_signal <= '1';
        when celdasARam =>
            counter_addr_ena_signal <= '1';
            counter_addr_load_signal <= '0';
            counter_it_ena_signal <= '0';
            counter_it_load_signal <= '1'; 
            memory_enable_signal <= '1';
            memory_we_signal <= '1';  
            matrixCelda_enable_signal <= '0';
            martix_calcular_signal <= '0';
        when fin => 
            counter_addr_ena_signal <= '0';
            counter_addr_load_signal <= '0';
            counter_it_ena_signal <= '0';
            counter_it_load_signal <= '0'; 
            memory_enable_signal <= '0';
            memory_we_signal <= '0';  
            matrixCelda_enable_signal <= '0';
            martix_calcular_signal <= '0';
        when others => 
            counter_addr_ena_signal <= '0';
            counter_addr_load_signal <= '0';
            counter_it_ena_signal <= '0';
            counter_it_load_signal <= '0'; 
            memory_enable_signal <= '0';
            memory_we_signal <= '0';  
            matrixCelda_enable_signal <= '0';  
            martix_calcular_signal <= '0';          
    end case;
end process;

NEXT_STATE_DECODE: process (counter_addr_end, matrixCalculo_end,estado) 
begin
   estado_siguiente <= estado;  --default is to stay in current state
   case (estado) is
      when ramACeldas =>
         if (counter_addr_end = '1') then
            estado_siguiente <= calcularTemperatura;
         end if;
      when calcularTemperatura =>
         if (matrixCalculo_end = '1') then
            estado_siguiente <= celdasARam;
         end if;
      when celdasARam =>
         if (counter_addr_end = '1') then
            estado_siguiente <= fin;
         end if;
      when others =>
         estado_siguiente <= fin;
      end case;
end process;


end Behavioral;