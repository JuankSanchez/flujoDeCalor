library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    Generic (
        BITS : integer := 2;
        MAX_COUNT: integer := 2
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           load: in STD_LOGIC;
           value : out STD_LOGIC_VECTOR ((BITS-1) downto 0);
           counter_end : out std_logic);
end counter;

architecture Behavioral of counter is
--constant maxCount: std_logic_vector(BITS-1 downto 0):=(others => '1');
signal counter_end_signal:STD_LOGIC;
begin
    counter_end <= '1' when unsigned(value) = MAX_COUNT else '0';

    process (clk)
    variable cnt : integer range 0 to ((2**BITS) - 1);
    begin
       if clk='1' and clk'event then
         if rst='1' then
             cnt := 0;
         elsif load='1' then
             cnt := 0;
         elsif enable='1' then
             if cnt = MAX_COUNT then
                cnt := 0;
             elsif counter_end = '0' then
                cnt := cnt + 1;
             end if;
         end if;
     end if;
    
     value <= std_logic_vector(to_unsigned(cnt,BITS));
     
--     if clk='1' and clk'event then
--         if (cnt = 0) and load = '0' then  -- Mejorar
--             counter_end <= '1';
--         else 
--             counter_end <= '0';
--         end if;
--     end if;
 end process;  
    
    
--    begin
--        if clk='1' and clk'event then
--            if rst='1' then
--                cnt := 0;
--            elsif enable='1' then
--                if load='1' then
--                    cnt := 0;
--                elsif counter_end_signal = '0' then
--                    cnt := cnt + 1;
--                end if;
--            end if;
--        end if;
--        value <= std_logic_vector(to_unsigned(cnt,BITS));
        
--        if clk='1' and clk'event then
--            --if (std_logic_vector(to_unsigned(cnt,BITS)) = maxCount) and load = '0' then  -- Mejorar
--            if (cnt = MAX_COUNT) then  -- Mejorar
--                counter_end_signal <= '1';                
--            else
--                counter_end_signal <= '0';
--            end if;
--        end if;
--    end process;

end Behavioral;
