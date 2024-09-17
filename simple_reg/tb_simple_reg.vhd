library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_simple_reg is
end tb_simple_reg;

architecture Behavioral of tb_simple_reg is
    -- Sinais para o teste
    signal clock : std_logic := '0';
    signal wren : std_logic := '1';
    signal datain : std_logic_vector(31 downto 0) := x"00000000";
    signal dataout : std_logic_vector(31 downto 0);
    
begin
    -- Instancia a UUT (Unidade Sob Teste)
    uut: entity work.simple_reg port map (
        clock => clock,
        wren => wren,
        datain => datain,
        dataout => dataout
    );

    -- Processo de teste
    process
    begin
        -- Inicialmente, dataout deve ser zero
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wren <= '0';
        wait for 10 ns;
        assert dataout = x"00000000" report "Erro: simple_reg não inicializou com 0" severity error;
        report "Init Test: wren=" & std_logic'image(wren) & " datain=" & to_hstring(datain) &
               " dataout=" & to_hstring(dataout);

        -- Teste: escrita habilitada, datain = x"0000000A"
        datain <= x"0000000A";
        wren <= '1';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wait for 10 ns;

        -- Verifica se o valor foi armazenado
        assert dataout = x"00000000" report "Erro: simple_reg não armazenou o valor correto" severity error;
        report "Write A Test: wren=" & std_logic'image(wren) & " datain=" & to_hstring(datain) &
               " dataout=" & to_hstring(dataout);
        
        -- Teste: escrita desabilitada, datain alterado (não deve mudar)
        datain <= x"0000000F";
        wren <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wait for 10 ns;

        -- Verifica se o valor continua o mesmo
        assert dataout = x"0000000A" report "Erro: simple_reg mudou o valor sem habilitação de escrita" severity error;
        report "Read A Test: wren=" & std_logic'image(wren) & " datain=" & to_hstring(datain) &
               " dataout=" & to_hstring(dataout);

        -- Teste: nova escrita, datain = x"12345678"
        datain <= x"12345678";
        wren <= '1';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wait for 10 ns;

        -- Verifica se o novo valor foi armazenado
        assert dataout = x"0000000A" report "Erro: simple_reg não armazenou o novo valor corretamente" severity error;
        report "Write again Test: wren=" & std_logic'image(wren) & " datain=" & to_hstring(datain) &
               " dataout=" & to_hstring(dataout);
               
        -- Teste: escrita desabilitada, datain alterado (não deve mudar)
        datain <= x"0000a00F";
        wren <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
        clock <= '0';
        wait for 10 ns;

        -- Verifica se o valor continua o mesmo
        assert dataout = x"12345678" report "Erro: simple_reg mudou o valor sem habilitação de escrita" severity error;
        report "Read 12345678 Test: wren=" & std_logic'image(wren) & " datain=" & to_hstring(datain) &
               " dataout=" & to_hstring(dataout);

        -- Teste finalizado
        wait;
    end process;

end Behavioral;
