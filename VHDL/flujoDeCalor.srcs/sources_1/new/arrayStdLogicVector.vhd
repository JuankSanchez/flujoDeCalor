library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ARRAY_STD_LOGIC_VECTOR is
    type ARRAY_STD_LOGIC_VECTOR_9 is array(0 to 8) of std_logic_vector(31 downto 0);
    type ARRAY_STD_LOGIC_VECTOR_16 is array(0 to 15) of std_logic_vector(31 downto 0);
end package ARRAY_STD_LOGIC_VECTOR;

--package ARRAY_STD_LOGIC_VECTOR_9 is
--    type ARRAY_STD_LOGIC_VECTOR_9 is array(0 to 8) of std_logic_vector(31 downto 0);
--end package ARRAY_STD_LOGIC_VECTOR_9;
