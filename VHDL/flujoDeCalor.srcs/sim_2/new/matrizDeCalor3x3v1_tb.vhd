library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.ARRAY_STD_LOGIC_VECTOR.ALL;

entity matrizDeCarlor3x3v1_tb is

end matrizDeCarlor3x3v1_tb;

architecture Behavioral of matrizDeCarlor3x3v1_tb is

   component flujoDeCalor is port ( in_tderecha  : in  ARRAY_STD_LOGIC_VECTOR_9;
            in_tsuperior : in  ARRAY_STD_LOGIC_VECTOR_9;
            in_tinferior : in  ARRAY_STD_LOGIC_VECTOR_9;
            in_tizquierda : in ARRAY_STD_LOGIC_VECTOR_9;
            clk_fc        : in STD_LOGIC;
            reset_fc      : in STD_LOGIC;
            out_tcelda    : out ARRAY_STD_LOGIC_VECTOR_9
            );
    end component;

    component tranferenciaACeldas is
        Port (
            clk     : in  STD_LOGIC;
            reset   : in  STD_LOGIC;
            dout    : out STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

    signal out_tcelda,in_tderecha,in_tsuperior,in_tinferior,in_tizquierda: ARRAY_STD_LOGIC_VECTOR_9;

    signal clk_fc,reset_fc:STD_LOGIC;
    signal dout: STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal fin: BOOLEAN;

begin

    CUT: flujoDeCalor port map(in_tderecha,in_tsuperior,in_tinferior,in_tizquierda,clk_fc,reset_fc,out_tcelda);
    CUT2: tranferenciaACeldas port map(clk_fc,reset_fc,dout);

    reloj: process -- Reloj de 50 MHz
       begin
          while not Fin loop -- mientras dure la simulacion ...
             clk_fc <= '0'; wait for 25 ns;
             clk_fc <= '1'; wait for 25 ns;
          end loop;
          wait; -- Fin de la simulacion
       end process;


    test: process begin
        reset_fc <= '1';
        wait for 10 us;
        for i IN 0 TO 8 loop
            in_tderecha(i)    <= "00000000000000000000000000000100";
            in_tizquierda(i)  <= "00000000000000000000000000001000";
            in_tsuperior(i)   <= "00000000000000000000000000001100";
            in_tinferior(i)   <= "00000000000000000000000000010000";
        end loop;
        wait for 10 us;
        reset_fc <= '0';
        wait for 1000 us;        
     end process;
    
end Behavioral;
