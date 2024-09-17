library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_control_ULA is
end tb_control_ULA;

architecture Behavioral of tb_control_ULA is
    -- Sinais para o teste
    signal funct7 : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal ALUOp : std_logic_vector(1 downto 0);
    signal opcode_ULA : std_logic_vector(3 downto 0);
begin
    -- Instancia a UUT (Unidade Sob Teste)
    uut: entity work.control_ULA port map (
        funct7 => funct7,
        funct3 => funct3,
        ALUOp => ALUOp,
        opcode_ULA => opcode_ULA
    );

    -- Processo de testes
    process
    begin
        -- Teste para ALUOp = "00" (ADD)
        ALUOp <= "00";
        funct7 <= "0000000"; -- Não usado aqui
        funct3 <= "000";     -- Não usado aqui
        wait for 20 ns;
        assert opcode_ULA = "0000" report "Erro: Esperava ADD" severity error;
        
        -- Teste para ALUOp = "01", funct3 = "000" (SEQ)
        ALUOp <= "01";
        funct3 <= "000";
        wait for 20 ns;
        assert opcode_ULA = "1100" report "Erro: Esperava SEQ" severity error;
        
        -- Teste para ALUOp = "10", funct3 = "001" (SLL)
        ALUOp <= "10";
        funct3 <= "001";
        wait for 20 ns;
        assert opcode_ULA = "0101" report "Erro: Esperava SLL" severity error;

        -- Teste para ALUOp = "11", funct3 = "000", funct7 = "0000000" (ADD)
        ALUOp <= "11";
        funct7 <= "0000000";
        funct3 <= "000";
        wait for 20 ns;
        assert opcode_ULA = "0000" report "Erro: Esperava ADD (funct7=0)" severity error;

        -- Teste para ALUOp = "11", funct3 = "000", funct7 = "0100000" (SUB)
        funct7 <= "0100000"; -- Mudou para SUB
        wait for 20 ns;
        assert opcode_ULA = "0001" report "Erro: Esperava SUB" severity error;

        -- Teste para ALUOp = "10", funct3 = "101", funct7(5) = '0' (SRL)
        ALUOp <= "10";
        funct3 <= "101";
        funct7 <= "0000000"; -- bit(5) = 0
        wait for 20 ns;
        assert opcode_ULA = "0110" report "Erro: Esperava SRL" severity error;

        -- Teste para ALUOp = "10", funct3 = "101", funct7(5) = '1' (SRA)
        funct7 <= "0100000"; -- bit(5) = 1
        wait for 20 ns;
        assert opcode_ULA = "0111" report "Erro: Esperava SRA" severity error;

        -- E mais testes... (temos que cobrir tudo!)
        wait;
    end process;

end Behavioral;
