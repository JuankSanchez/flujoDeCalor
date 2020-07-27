library IEEE;
use ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 


entity NbitDecoder is
Generic
(
    C_INPUT_SIZE: integer := 4
);
Port
(
    input   : in  STD_LOGIC_VECTOR (C_INPUT_SIZE-1 downto 0);
    output  : out STD_LOGIC_VECTOR ((2**C_INPUT_SIZE)-1 downto 0)
);
end NbitDecoder;

architecture Behavioral of NbitDecoder is
signal int : integer;
begin        
    decoder: for i in 0 to ((2**C_INPUT_SIZE)-1) generate
        process (input)
        begin
            if ((i + 1) = to_integer(unsigned(input)) and i<(2**C_INPUT_SIZE)-1) then
                output(i) <= '1';
            else
                output(i) <= '0';             
           end if;
        end process;
    end generate;

end Behavioral;