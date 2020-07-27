library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
  
entity calculoMatrix is
    Generic (
        N: natural := 32;    -- Data Width
        M: natural := 4;     -- Length matrix
        TEMP_AMB: natural := 0;
        TEMP_BORDER: natural := 0;
        NUM_ITERACIONES: natural := 5;
        LOGMxM: natural := 4 
    );
    Port ( 
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       cm_enable: in STD_LOGIC;
       result : out std_logic_vector (127 downto 0)
    );
end calculoMatrix;

architecture Behavioral of calculoMatrix is    
    -- counters
    signal counter_addr_value : std_logic_vector (LOGMxM-1 downto 0); 
    signal counter_addr_enable : std_logic;
    signal counter_addr_load : std_logic;
    signal counter_addr_end : std_logic;
    signal counter_it_enable : std_logic;
    signal counter_it_load : std_logic;
    signal counter_it_end : std_logic;
    signal counter_it_value: std_logic_vector(7 downto 0);
    -- matrix de celdas
    signal mc_enable : std_logic;
    signal mc_init_enabled : std_logic;
    signal mc_fin_enabled: std_logic;
    -- memory
    signal memory_enable: std_logic;
    signal memory_we: std_logic;
    signal memory_din : std_logic_vector (127 downto 0);
    signal memory_dout: std_logic_vector (127 downto 0);
    -- control machine
    signal cm_calcular : std_logic;
begin

mc_init_enabled <= counter_addr_enable and not memory_we;
mc_fin_enabled <= counter_addr_enable and memory_we;
result <= memory_din;
memory : entity work.memory 
    generic map (
        DATA_WIDTH => 128,
        ADDRESS_WIDTH => LOGMxM )
    port map (
        clk => clk,
        rst => rst,
        enable => memory_enable,
        address => counter_addr_value,
        we => memory_we,
        din => memory_din,  
        dout => memory_dout
    );

-- address
counter_addr : entity work.counter 
    generic map (
        BITS => LOGMxM,
        MAX_COUNT => (M*M)-1
    ) 
    port map (
        clk => clk,
        rst => rst,
        enable => counter_addr_enable,
        load => counter_addr_load,
        value => counter_addr_value,
        counter_end => counter_addr_end
    ); 

-- iteraciones
counter_it : entity work.counter 
    generic map (
        BITS => 8,
        MAX_COUNT => NUM_ITERACIONES
    ) 
    port map (
        clk => clk,
        rst => rst,
        enable => counter_it_enable,
        load => counter_it_load,
        value => counter_it_value,
        counter_end => counter_it_end
    ); 
MatrixDeCeldas: entity work.matrixDeCeldas
    generic map (
        N => N,                     -- Data Width
        M => M,                     -- Length matrix
        LOGMxM => LOGMxM,
        ambTemp => TEMP_AMB,        
        temp_borde => TEMP_BORDER
    )
    port map ( 
        clk => clk,
        rst => rst,
        enable => mc_enable,
        cm_calcular => cm_calcular,
        mc_address => counter_addr_value,
        -- set macrocelda
        mc_init_data => memory_dout,
        mc_init_enable => mc_init_enabled,
        -- get macrocelda
        mc_fin_enable => mc_fin_enabled,
        mc_fin_data => memory_din        
    );
 control_machine : entity work.control_machine
    port map (
        clk => clk,
        rst => rst,
        enable => cm_enable,
        matrixCalculo_end => counter_it_end, --counter_it_end, -- Control de la cantidad de iteraciones, viene de afuera
        matrix_enable => mc_enable,
        matrix_calcular => cm_calcular,  
        counter_addr_end =>  counter_addr_end,
        counter_addr_enable => counter_addr_enable,
        counter_addr_load => counter_addr_load,
        counter_it_end => counter_it_end,
        counter_it_enable => counter_it_enable,
        counter_it_load => counter_it_load,
        memory_enable => memory_enable,
        memory_we => memory_we 
    );
end Behavioral;
