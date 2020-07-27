--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity matrizCeldas is
    
--    generic (cantidadCeldas: integer range 0 to 8);
        
--    signal celdasOut: out std_logic_vector (31 downto 0);    
        
--    Port ( 
--        clk : in STD_LOGIC;
--        rst : in STD_LOGIC
--     );
--end matrizCeldas;

--architecture Behavioral of matrizCeldas is
       
--    component celda 
--        Port ( clk : in STD_LOGIC;
--               rst : in STD_LOGIC;
--               celda_out : out std_logic_vector (31 downto 0)
--        );
--    end component;
    
--begin

--    gen_matriz: for i in 0 to cantidadCeldas generate 
--    begin
--        gen_celda: for k in 0 to cantidadCeldas generate 
--        begin   
--            celda_i: if(i=5 or i=6 or i=9 or i=10)  generate begin 
--                ccelda: component celda port map(
--                    clk => clk,
--                    rst => rst,
--                    celda_out(i) => celdasOut(k-1)
--                );
--            end generate;
--       end generate;     
--    end generate;

--end Behavioral;
