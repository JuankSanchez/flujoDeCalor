library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ARRAY_STD_LOGIC_VECTOR.ALL;

entity fsm_mem_celdas_tb is

end fsm_mem_celdas_tb;

architecture Behavioral of fsm_mem_celdas_tb is

    component flujoDeCalor is
        Port (
            clk: in  STD_LOGIC;
            rst: in  BOOLEAN
        );
    end component;

    --signal out_tcelda,in_tderecha,in_tsuperior,in_tinferior,in_tizquierda: ARRAY_STD_LOGIC_VECTOR_9;

    signal clk_fc:STD_LOGIC;
    --signal reset_fc: BOOLEAN;
    --signal out_contador: STD_LOGIC_VECTOR(3 DOWNTO 0);
    --signal out_memoria,out_estado: STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal reset_fc,fin: BOOLEAN;

begin

    CUT: flujoDeCalor port map(clk_fc,reset_fc);
    --CUT: flujoDeCalor port map(in_tderecha,in_tsuperior,in_tinferior,in_tizquierda,clk_fc,reset_fc,out_tcelda);
    --CUT2: tranferenciaACeldas port map(clk_fc,reset_fc,dout);

    reloj: process -- Reloj de 50 MHz
       begin
          while not Fin loop -- mientras dure la simulacion ...
             clk_fc <= '0'; wait for 25 ns;
             clk_fc <= '1'; wait for 25 ns;
          end loop;
          wait; -- Fin de la simulacion
       end process;

    test: process begin
        reset_fc <= true; --'1';
        wait for 275 ns;
--        for i IN 0 TO 8 loop
--            in_tderecha(i)    <= "00000000000000000000000000000100";
--            in_tizquierda(i)  <= "00000000000000000000000000001000";
--            in_tsuperior(i)   <= "00000000000000000000000000001100";
--            in_tinferior(i)   <= "00000000000000000000000000010000";
--        end loop;
        wait for 10 us;
        reset_fc <= false; --'0';
        wait for 1000 us;        
     end process;
    
end Behavioral;
