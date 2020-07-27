library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity celda is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           in_derecho  : in    STD_LOGIC_VECTOR (31 downto 0);
           in_superior : in    STD_LOGIC_VECTOR (31 downto 0);
           in_inferior : in    STD_LOGIC_VECTOR (31 downto 0);
           in_izquierdo: in    STD_LOGIC_VECTOR (31 downto 0);
           celda_out : out std_logic_vector (31 downto 0)
    );
end celda;

architecture Behavioral of celda is

signal address : std_logic_vector (1 downto 0); 
signal counter_enable : std_logic;
signal counter_load : std_logic;
signal counter_end : std_logic;
signal memory_enable: std_logic;
signal memory_we: std_logic;
signal calculoCelda_end : std_logic;
signal calculoCelda_enable : std_logic;
signal memory_din : std_logic_vector (31 downto 0);
signal memory_dout: std_logic_vector (31 downto 0);
begin

muxWriteMem: process (in_derecho,in_izquierdo,in_superior,in_inferior,address) 
begin
    case (address) is
          when "00" => memory_din <= in_derecho;
          when "01" => memory_din <= in_izquierdo;
          when "10" => memory_din <= in_superior;
          when "11" => memory_din <= in_inferior;
          when others => memory_din <= in_derecho;
       end case;    
end process;

counter_0 : entity work.counter 
    generic map 
        (N => 2) 
    port map (
        clk => clk,
        rst => rst,
        enable => counter_enable,
        load => counter_load,
        address => address,
        counter_end => counter_end
    ); 

memory_0 : entity work.memory 
    generic map (
        DATA_WIDTH => 32,
        ADDRESS_WIDTH => 2 )
    port map (
        clk => clk,
        rst => rst,
        enable => memory_enable,
        address => address,
        we => memory_we,
        din => memory_din,
        dout => memory_dout
    );
 
 control_machine_0 : entity work.control_machine
    port map (
        clk => clk,
        rst => rst,
        counter_end => counter_end,
        calculoCelda_end => calculoCelda_end,
        calculoCelda_enable => calculoCelda_enable,
        counter_enable => counter_enable,
        counter_load => counter_load,
        memory_enable => memory_enable,
        memory_we => memory_we    
    );
end Behavioral;
