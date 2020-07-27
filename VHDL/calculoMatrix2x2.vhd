library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.all;

entity calculoMatrix2x2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           address : in std_logic_vector (1 downto 0); 
           memory_we: in std_logic;
           memory_enable: in std_logic;
           initEnabled: in std_logic;
           whriteBack_enabled: in std_logic;
           --calculoMatrix2x2_end : in STD_LOGIC;
           calculoMatrix_enable : in std_logic;
           RAM
           inData0,inData1,inData2,inData3 : in    STD_LOGIC_VECTOR (31 downto 0);
           inData4,inData5,inData6,inData7 : in    STD_LOGIC_VECTOR (31 downto 0);
           outData0,outData1,outData2,outData3 :  out STD_LOGIC_VECTOR (31 downto 0)
    );
end calculoMatrix2x2;

architecture Behavioral of calculoMatrix2x2 is

--IN signal address : std_logic_vector (1 downto 0); 
--IN signal counter_enable : std_logic;
--signal counter_load : std_logic;
--signal counter_end : std_logic;
--IN signal memory_enable: std_logic;
--IN signal memory_we: std_logic;
--IN signal calculoMatrix_enable : std_logic;
--IN signal initEnabled: std_logic;
--IN signal whriteBack_enabled: std_logic;
signal memory_din : std_logic_vector (31 downto 0);
signal memory_dout: std_logic_vector (31 downto 0);
begin

--initEnabled <= counter_enable and not memory_we;
--whriteBack_enabled <= counter_enable and memory_we;


matrixCelda2x2 : entity work.matrixCelda2x2
    port map (
         inData0 => inData0,
         inData1 => inData1,
         inData2 => inData2,
         inData3 => inData3,
         inData4 => inData4,
         inData5 => inData5,
         inData6 => inData6,
         inData7 => inData7,
         writeback_data => memory_din,
         outData0 => outData0,
         outData1 => outData1,
         outData2 => outData2,
         outData3 => outData3,
         initAddress => address,
         initEna => initEnabled, --habilitar lectura 
         writeBack_ena => whriteBack_enabled,
         initData => memory_dout,
         clk => clk,
         rst => rst,
         ena => calculoMatrix_enable);

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
        din => memory_din,  -- Falta implementar
        dout => memory_dout
--        name => name
    );
 

end Behavioral;
