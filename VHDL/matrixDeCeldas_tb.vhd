library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity matrixDeCeldas_tb is
    Generic (
    N: natural := 32;    -- Data Width
    M: natural := 4;     -- Length matrix
    LOGMxM: natural := 4;
    ambTemp: natural := 0;
    temp_borde: natural := 0
    );
end matrixDeCeldas_tb;

architecture Behavioral of matrixDeCeldas_tb is
signal clk :                STD_LOGIC := '0';
signal rst :                STD_LOGIC;
signal enable :             std_logic;
signal mc_address :         std_logic_vector(LOGMxM-1 downto 0);
signal cm_calcular:         std_logic;
-- set
signal mc_init_data :       std_logic_vector((4*N)-1 downto 0);
signal mc_init_enable :     std_logic;
-- get
signal mc_fin_enable :      std_logic;
signal mc_fin_data :        std_logic_vector((4*N)-1 downto 0);
begin
    CUT: entity work.matrixDeCeldas 
    generic map(
        N => 32,    -- Data Width
        M => 4,     -- Length matrix
        LOGMxM => 4,
        ambTemp => 0,
        temp_borde=> 0)
    port map (
        clk,
        rst,
        enable,
        mc_address,
        cm_calcular,
        mc_init_data,
        mc_init_enable,
        mc_fin_enable,
        mc_fin_data
        );
    clk <= not clk after 25ns;
    test: process 
    begin
        rst <= '1';     
        enable <= '0';
        wait for 100 ns;
        rst <= '0';     
        enable <= '1';
        mc_address <= x"4";
        mc_init_data <= x"00010000_00000000_00000000_00000000";
        mc_init_enable <= '1';
        mc_fin_enable <= '0';
        wait for 50 ns;
        mc_init_enable <= '0';        
    end process;
end Behavioral;