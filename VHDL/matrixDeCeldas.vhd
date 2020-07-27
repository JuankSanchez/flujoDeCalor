--library IEEE;
--use IEEE.STD_LOGIC_1164.all;

--package pack_type_matrix is
--    constant N: natural := 4;
--    type MATRIX_SIGNALS is array(0 to N-1,0 to N-1,0 to 3) of std_logic_vector(31 downto 0);
--end package pack_type_matrix;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.pack_type_matrix.all;

entity matrixDeCeldas is
    Generic (
        N: natural := 32;    -- Data Width
        M: natural := 4;     -- Length matrix
        LOGMxM: natural := 4;
        ambTemp: natural := 0;
        temp_borde: natural := 0
    );
    Port ( 
        clk :               in STD_LOGIC;
        rst :               in STD_LOGIC;
        enable :            in std_logic;
        mc_address :        in std_logic_vector(LOGMxM-1 downto 0);
        cm_calcular :       in std_logic;
        -- set
        mc_init_data :      in std_logic_vector((4*N)-1 downto 0);
        mc_init_enable :    in std_logic;
        -- get
        mc_fin_enable :     in std_logic;
        mc_fin_data :       out std_logic_vector((4*N)-1 downto 0)
);
end matrixDeCeldas;

architecture Behavioral of matrixDeCeldas is
    type MATRIX_SIGNALS is array(0 to M-1,0 to M-1,0 to 3) of std_logic_vector(N-1 downto 0);
    signal s: MATRIX_SIGNALS;
    type MATRIX_OUTDATA is array (0 to (M*M)-1) of std_logic_vector ((4*N)-1 downto 0);
    signal o: MATRIX_OUTDATA;
    signal deco_output: STD_LOGIC_VECTOR ((M*M)-1 downto 0);
    signal deco_output_signal: STD_LOGIC_VECTOR ((M*M)-1 downto 0);
begin
    decoder: entity work.NbitDecoder 
        Generic map(C_INPUT_SIZE => LOGMxM)
        Port map (
            input   => mc_address,
            output  => deco_output
        );
    deco_output_signal <= deco_output when mc_init_enable = '1' else (others => '0');  
    mc_fin_data <= o(to_integer(unsigned(mc_address))) when mc_fin_enable = '1' else (others => '0');
    
    rows:for f in 0 to M-1 generate
        colums:for c in 0 to M-1 generate  
        ----------------CORNERS------------------
        -- esquina superior izquierda
        cornerUpLefg:if f=0 and c=0 generate 
            signal init_ena : std_logic;
            begin  
                M_0_0: entity work.macroCelda2x2 Port map ( 
                    clk => clk,
                    rst => rst,
                    enable => enable,
                    mc_init_data => mc_init_data,
                    mc_init_enable => init_ena,
                    cm_calcular => cm_calcular,
                    inData0 => std_logic_vector(to_unsigned(temp_borde,N)),
                    inData1 => std_logic_vector(to_unsigned(temp_borde,N)),
                    inData2 => std_logic_vector(to_unsigned(temp_borde,N)),
                    inData3 => s(0,1,0),--m010,
                    inData4 => s(0,1,2),
                    inData5 => s(1,0,1),
                    inData6 => s(1,0,0),
                    inData7 => std_logic_vector(to_unsigned(temp_borde,N)),
                    outData0 => s(0,0,0),
                    outData1 => s(0,0,1),
                    outData2 => s(0,0,2),
                    outData3  => s(0,0,3),
                    mc_fin_data => o((c*M)+f)  
                );
                init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate cornerUpLefg;
                        
        -- esquina superior derecha
        cornerUpRight:if f=0 and c=M-1 generate 
            signal init_ena : std_logic;
            begin  
            M_0_2: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(0,c-1,1),
                inData1 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData2 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData3 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData4 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData5 => s(1,c,1),
                inData6 => s(1,c,0),
                inData7 => s(0,c-1,3),
                outData0 => s(0,c,0),
                outData1 => s(0,c,1),
                outData2 => s(0,c,2),
                outData3 => s(0,c,3),  
                mc_fin_data => o((c*M)+f)  
            );      
            init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate cornerUpRight;

        -- esquina inferior izquierda
        cornerDownLeft:if f=M-1 and c=0 generate 
            signal init_ena : std_logic;
            begin  
            M_2_0: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData1 => s(f-1,0,2),
                inData2 => s(f-1,0,3),
                inData3 => s(f,1,0),
                inData4 => s(f,1,2),
                inData5 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData6 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData7 => std_logic_vector(to_unsigned(temp_borde,N)),
                outData0 => s(f,0,0),
                outData1 => s(f,0,1),
                outData2 => s(f,0,2),
                outData3 => s(f,0,3),  
                mc_fin_data => o((c*M)+f)  
            );
            init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate cornerDownLeft;                                
        
        -- esquina inferior derecha
        cornerDownRight:if f=M-1 and c=M-1 generate 
            signal init_ena : std_logic;
            begin  
            M_2_2: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(f,c-1,1),
                inData1 => s(f-1,c,2),
                inData2 => s(f-1,c,3),
                inData3 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData4 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData5 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData6 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData7 => s(f,c-1,3),
                outData0 => s(f,c,0),
                outData1 => s(f,c,1),
                outData2 => s(f,c,2),
                outData3 => s(f,c,3),  
                mc_fin_data => o((c*M)+f)  
            );
            init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate cornerDownRight; 
        
        ----------------BORDERS------------------
        
        -- borde superior
        borderUp:if f=0 and c>0 and c<M-1 generate
            signal init_ena : std_logic;
            begin  
            M_0_1: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(0,c-1,1),
                inData1 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData2 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData3 => s(0,c+1,0),
                inData4 => s(0,c+1,2),
                inData5 => s(1,c,1),
                inData6 => s(1,c,0),
                inData7 => s(0,c-1,3),
                outData0 => s(0,c,0),
                outData1 => s(0,c,1),
                outData2 => s(0,c,2),
                outData3  => s(0,c,3),  
                mc_fin_data => o((c*M)+f) 
               ); 
               init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate borderUp;
                    
        -- borde izquierdo
        borderLeft:if f>0 and f<M-1 and c=0 generate 
            signal init_ena : std_logic;
            begin  
            M_1_0: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData1 => s(f-1,0,2),
                inData2 => s(f-1,0,3),
                inData3 => s(f,1,0),
                inData4 => s(f,1,2),
                inData5 => s(f+1,0,1),
                inData6 => s(f+1,0,0),
                inData7 => std_logic_vector(to_unsigned(temp_borde,N)),
                outData0 => s(f,0,0),
                outData1 => s(f,0,1),
                outData2 => s(f,0,2),
                outData3 => s(f,0,3),  
                mc_fin_data => o((c*M)+f)  
               );
               init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate borderLeft;

        -- borde derecho
        borderRight:if f>0 and f<M-1 and c=M-1 generate
            signal init_ena : std_logic;
            begin  
            M_1_2: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(f,c-1,1),
                inData1 => s(f-1,c,2),
                inData2 => s(f-1,c,3),
                inData3 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData4 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData5 => s(f+1,c,1),
                inData6 => s(f+1,c,0),
                inData7 => s(f,c-1,3),
                outData0 => s(f,c,0),
                outData1 => s(f,c,1),
                outData2 => s(f,c,2),
                outData3 => s(f,c,3),  
                mc_fin_data => o((c*M)+f) 
                ); 
                init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate borderRight;
        
        -- borde inferior
        borderDown:if f=M-1 and c>0 and c<M-1 generate 
            signal init_ena : std_logic;
            begin  
            M_2_1: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(f,c-1,1),
                inData1 => s(f-1,c,2),
                inData2 => s(f-1,c,3),
                inData3 => s(f,c+1,0),
                inData4 => s(f,c+1,2),
                inData5 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData6 => std_logic_vector(to_unsigned(temp_borde,N)),
                inData7 => s(f,c-1,3),
                outData0 => s(f,c,0),
                outData1 => s(f,c,1),
                outData2 => s(f,c,2),
                outData3 => s(f,c,3),  
                mc_fin_data => o((c*M)+f) 
           );
           init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate borderDown;                        

        ----------------CENTER------------------
        
        -- centro
        center:if f>0 and f<M-1 and c>0 and c<M-1 generate 
            signal init_ena : std_logic;
            begin  
            M_1_1: entity work.macroCelda2x2 Port map ( 
                clk => clk,
                rst => rst,
                enable => enable,
                mc_init_data => mc_init_data,
                mc_init_enable => init_ena,
                cm_calcular => cm_calcular,
                inData0 => s(f,c-1,1),
                inData1 => s(f-1,c,2),
                inData2 => s(f-1,c,3),
                inData3 => s(f,c+1,0),
                inData4 => s(f,c+1,2),
                inData5 => s(f+1,c,1),
                inData6 => s(f+1,c,0),
                inData7 => s(f,c-1,3),
                outData0 => s(f,c,0),
                outData1 => s(f,c,1),
                outData2 => s(f,c,2),
                outData3 => s(f,c,3),  
                mc_fin_data => o((c*M)+f) 
                );
                init_ena <= '1' when (deco_output_signal(M*c+f)= '1') else '0';
        end generate center;                        
                                        
       end generate colums;
end generate rows;
end Behavioral;
