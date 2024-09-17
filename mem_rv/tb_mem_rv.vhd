library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mem_rv is
end tb_mem_rv;

architecture test of tb_mem_rv is
    -- Sinais para conectar à unidade mem_rv
    signal clock    : std_logic := '0';
    signal we       : std_logic := '0';
    signal re       : std_logic := '0';
    signal address  : std_logic_vector(11 downto 0);
    signal datain   : std_logic_vector(31 downto 0);
    signal dataout  : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 1 ns;

begin
    -- Instância da mem_rv
    uut: entity work.mem_rv
        port map (
            clock    => clock,
            we       => we,
            re       => re,
            address  => address,
            datain   => datain,
            dataout  => dataout
        );

    -- Geração de estímulos
    stim_proc: process
    begin
        -- 1. Testar escrita na Memoria (endereços de dados 2048 a 2055)
        we <= '1';  -- Habilita escrita
        re <= '0';  -- Desabilita Leitura
        for i in 2048 to 2055 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de escrita
            datain <= std_logic_vector(to_unsigned(i + 1000, 30)) & "00";  -- Valor a ser escrito
            clock <= '0';
            wait for CLK_PERIOD / 2;
            clock <= '1';
            wait for CLK_PERIOD / 2;
            report "Escrevendo: Endereço = " & to_hstring(address) &
                   ", Dado = " & to_hstring(datain);
        end loop;

        -- 2. Testar leitura da Memoria (endereços de dados 2048 a 2055) (sem clock)
        we <= '0';  -- Desabilita escrita
        re <= '1';  -- Habilita Leitura
        for i in 2048 to 2055 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de leitura
            wait for CLK_PERIOD / 2;
            report "Lendo: Endereço = " & to_hstring(address) &
                   ", Dado Lido = " & to_hstring(dataout);
        end loop;

        -- 3. Testar leitura da área de código (endereços 0 a 10) -- Instruções carregadas de arquivo
        we <= '0';  -- Desabilita escrita
        re <= '1';  -- Habilita Leitura
        for i in 0 to 10 loop
            address <= std_logic_vector(to_unsigned(i, 12));  -- Endereço de leitura (área de código)
            clock <= '0';
            wait for CLK_PERIOD / 2;
            clock <= '1';
            wait for CLK_PERIOD / 2;
            report "Lendo Instrução: Endereço = " & to_hstring(address) &
                   ", Dado Lido = " & to_hstring(dataout);
        end loop;

        wait;
    end process;

end architecture;
