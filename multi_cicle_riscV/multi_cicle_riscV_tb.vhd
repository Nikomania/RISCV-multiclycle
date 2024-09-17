library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multi_cicle_riscV_tb is
end multi_cicle_riscV_tb;

architecture test of multi_cicle_riscV_tb is
    -- Sinais para conectar à unidade multi_cicle_riscV
    signal clock    : std_logic := '0';

    constant CLK_PERIOD : time := 50 ns;

begin
    -- Instância da multi_cicle_riscV
    uut: entity work.multi_cicle_riscV
        port map (
            main_clock    => clock
        );

    -- Geração de estímulos
    stim_proc: process
    begin
    	-- init control signals
    	wait for CLK_PERIOD / 2;
        
		clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        wait;
    end process;

end architecture;
