library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_machine is
    Port ( 
        clk : in std_logic;
        rst : in std_logic;
        counter_end: in std_logic;
        calculoCelda_end: in std_logic;
        counter_enable : out std_logic;
        counter_load: out std_logic;
        memory_enable : out std_logic;
        memory_we : out std_logic
        );
end control_machine;

architecture Behavioral of control_machine is
    type estados is (ramACeldas, calcularTemperatura, celdasARam);
    signal estado, estado_siguiente : estados;
    
    signal counter_load_signal,counter_load_reg : std_logic;
    signal counter_enable_signal : std_logic;
    signal memory_enable_signal, memory_we_signal: std_logic;
    
    begin
SYNC_PROC: process (clk)
begin
    if (clk'event and clk = '1') then
        if (rst = '1') then
            estado <= ramACeldas;
            counter_enable <= '0';
            counter_load <= '1'; 
            memory_enable <= '0';
            memory_we <= '0';    
        else
            estado <= estado_siguiente;
            counter_enable <= counter_enable_signal;
            counter_load <= counter_load_signal; 
            memory_enable <= memory_enable_signal;
            memory_we <= memory_we_signal;    
        end if;
    end if;
end process;

--MOORE State-Machine - Outputs based on state only
OUTPUT_DECODE: process (estado)
begin
    case (estado) is
        when ramACeldas =>
            counter_enable_signal <= '1';
            counter_load_signal <= '0'; 
            memory_enable_signal <= '1';
            memory_we_signal <= '0';                   
        when calcularTemperatura =>
            counter_enable_signal <= '0';
            counter_load_signal <= '1'; 
            memory_enable_signal <= '0';
            memory_we_signal <= '0';
        when celdasARam =>
            counter_enable_signal <= '1';
            counter_load_signal <= '0'; 
            memory_enable_signal <= '1';
            memory_we_signal <= '1';   
    end case;
end process;

-- Counter_load lleva una latencia de un clock extra para que se lea la posicion 0 de la memoria
process (clk)
begin
    if (clk'event and clk = '1') then
        counter_load_reg <= counter_load_signal;
    end if;
end process;

NEXT_STATE_DECODE: process (estado, counter_end, calculoCelda_end) 
begin
   estado_siguiente <= estado;  --default is to stay in current state
   case (estado) is
      when ramACeldas =>
         if (counter_end = '1') and (calculoCelda_end = '0') then
            estado_siguiente <= calcularTemperatura;
         end if;
      when calcularTemperatura =>
         if (counter_end = '0') and (calculoCelda_end = '1') then
            estado_siguiente <= celdasARam;
         end if;
      when celdasARam =>
         if (counter_end = '1') and (calculoCelda_end = '0') then
         estado_siguiente <= ramACeldas;
         end if;
      when others =>
         estado_siguiente <= ramACeldas;
      end case;
end process;


end Behavioral;

