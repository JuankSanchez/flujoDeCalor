--constant Message1 : String(1 to 19) := "hold time violation";
--signal Letter1 : character;
--signal Message2 : string(1 to 10);
--. . .
--Message2 <= "Not" & Letter1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity memory is
    Generic (DATA_WIDTH : integer := 32;
             ADDRESS_WIDTH: integer := 2);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
           we : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
           dout : inout STD_LOGIC_VECTOR (DATA_WIDTH -1  downto 0));
end memory;

architecture Behavioral of memory is

type RamType is array (((2 ** ADDRESS_WIDTH) - 1) downto 0) of std_logic_vector (DATA_WIDTH - 1 downto 0);

impure function InitRamFromFile (RamFileName : in string) 
    return RamType is FILE RamFile : text is in RamFileName;
    variable RamFileLine : line; variable RAM : RamType;
begin 
    for I in RamType'range 
        loop readline (RamFile, RamFileLine); 
            read (RamFileLine, RAM(I)); 
        end loop;
    return RAM;
end function;

signal RAM : RamType := InitRamFromFile("/home/gvodanovic/Project/flujoDeCalor/broken/flujoDeCalor/ramFile/ram.data");
    
--signal RAM : RamType := (x"00000003",x"00000002",x"00000001",x"00000000");
signal read_address : STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
begin

    process (clk,rst,read_address)
    begin
            if (rst = '1') then
                dout <= (others => '0');
            else
                if (clk'event and clk = '1') then
                    if (enable = '1') then
                        if (we = '1') then
                            RAM(to_integer(unsigned(address))) <= din;
                        end if;
                        read_address <= address; --El address de salida se actualiza unicamente si enable esta en 1, sino se mantiene el anterior
                    end if;
                end if;
            dout <= RAM(to_integer(unsigned(read_address)));
            end if;
    end process;
end Behavioral;
