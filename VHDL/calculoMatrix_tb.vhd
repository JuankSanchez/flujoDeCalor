----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2017 15:14:52
-- Design Name: 
-- Module Name: calculoMatrix_tb - Behavioral
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
use std.textio.all;
use ieee.std_logic_textio.all;
--use  work.pack_type_matrix.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculoMatrix_tb is
--  Port ( );
end calculoMatrix_tb;

architecture Behavioral of calculoMatrix_tb is
    
    signal rst : STD_LOGIC;
    signal cm_enable : STD_LOGIC;
    signal clk : std_logic := '0';
    signal result : std_logic_vector (127 downto 0);
    
begin

    CUT: entity work.calculoMatrix 
    generic map(
        N => 32,    -- Data Width
        M => 4,     -- Length matrix
        TEMP_AMB => 0,
        TEMP_BORDER => 0,
        NUM_ITERACIONES=> 5,        
        LOGMxM => 4 
)
    port map (
        clk,
        rst,
        cm_enable,
        result
        );
    
    clk <= not clk after 25ns;
    
    test: process 
        FILE file_matrix: TEXT open WRITE_MODE is "/home/gvodanovic/Project/flujoDeCalor/broken/flujoDeCalor/ramFile/matrix.txt"; 
        variable linea: line;
    begin
        rst <= '1';     
        cm_enable <= '0';
        wait for 100 ns;
        rst <= '0';     
        cm_enable <= '1';
        wait for 1275 ns;
        write(linea, string'("This is an example of formatted IO\n"));
        writeline(file_matrix, linea);
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;  
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 50 ns;          
        write(linea, result);
        writeline(file_matrix, linea);  
        wait for 5000 ns;
         
    end process;
end Behavioral;
