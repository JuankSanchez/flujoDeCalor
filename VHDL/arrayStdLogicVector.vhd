library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package MATRIX is
    type MATRIX_SIGNALS is array(0 to 2,0 to 2,0 to 3) of std_logic_vector(31 downto 0);
end package MATRIX;