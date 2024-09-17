library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ulaRV is
end tb_ulaRV;

architecture Behavioral of tb_ulaRV is
    signal opcode : std_logic_vector(3 downto 0);
    signal A, B : std_logic_vector(31 downto 0);
    signal Z : std_logic_vector(31 downto 0);
    signal cond : std_logic;
begin
    -- Instancia o UUT (Unidade em Teste)
    uut: entity work.ulaRV port map (
        opcode => opcode,
        A => A,
        B => B,
        Z => Z,
        cond => cond
    );

	process
    begin
        -- Teste para ADD pos
        opcode <= "0000"; -- Opcode para ADD
        A <= x"00000001";
        B <= x"0000000A";
        wait for 20 ns;
        report "ADD pos Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
        
        -- Teste para ADD zero
        opcode <= "0000"; -- Opcode para ADD
        A <= x"00000001";
        B <= x"FFFFFFFF";
        wait for 20 ns;
        report "ADD zero Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para ADD neg
        opcode <= "0000"; -- Opcode para ADD
        A <= x"00000001";
        B <= x"80000000";
        wait for 20 ns;
        report "ADD neg Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        -- Teste para SUB pos
        opcode <= "0001"; -- Opcode para SUB
        A <= x"00000005";
        B <= x"00000003";
        wait for 20 ns;
        report "SUB pos Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        -- Teste para SUB zero
        opcode <= "0001"; -- Opcode para SUB
        A <= x"00000005";
        B <= x"00000005";
        wait for 20 ns;
        report "SUB zero Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SUB neg
        opcode <= "0001"; -- Opcode para SUB
        A <= x"00000001";
        B <= x"0000000B";
        wait for 20 ns;
        report "SUB neg Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        -- Teste para AND
        opcode <= "0010"; -- Opcode para AND
        A <= x"0000010F";
        B <= x"000001F1";
        wait for 20 ns;
        report "AND Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        -- Teste para OR
        opcode <= "0011"; -- Opcode para OR
        A <= x"0000000F";
        B <= x"000000F0";
        wait for 20 ns;
        report "OR Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para XOR
        opcode <= "0100"; -- Opcode para XOR
        A <= x"0000000F";
        B <= x"000000F1";
        wait for 20 ns;
        report "XOR Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SLL
        opcode <= "0100"; -- Opcode para SLL
        A <= x"00000001"; -- Valor de exemplo para A
        B <= x"00000004"; -- Desloca por 4 bits
        wait for 20 ns;
        report "SLL Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SRL
        opcode <= "0101"; -- Opcode para SRL
        A <= x"80000001"; -- Valor de exemplo para A
        B <= x"00000004"; -- Desloca por 4 bits
        wait for 20 ns;
        report "SRL Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

		-- Teste para SRA pos
        opcode <= "0111"; -- Opcode para SRA
        A <= x"7FFFFFFF"; -- Valor de exemplo para A
        B <= x"00000010"; -- Desloca por 16 bits
        wait for 20 ns;
        report "SRA pos Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

		-- Teste para SRA zero
        opcode <= "0111"; -- Opcode para SRA
        A <= x"7FFFFFFF"; -- Valor de exemplo para A
        B <= x"0000001F"; -- Desloca por 31 bits
        wait for 20 ns;
        report "SRA zero Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        -- Teste para SRA neg
        opcode <= "0111"; -- Opcode para SRA
        A <= x"80000000"; -- Valor de exemplo para A
        B <= x"00000004"; -- Desloca por 4 bits
        wait for 20 ns;
        report "SRA neg Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SLT
        opcode <= "1000"; -- Opcode para SLT
        A <= x"80000004";
        B <= x"00000005";
        wait for 20 ns;
        report "SLT Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SLTU
        opcode <= "1001"; -- Opcode para SLTU
        A <= x"80000004";
        B <= x"00000005";
        wait for 20 ns;
        report "SLTU Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SGE
        opcode <= "1010"; -- Opcode para SGE
        A <= x"80000004";
        B <= x"00000005";
        wait for 20 ns;
        report "SGE Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SGEU
        opcode <= "1011"; -- Opcode para SGEU
        A <= x"80000004";
        B <= x"00000005";
        wait for 20 ns;
        report "SGEU Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SEQ
        opcode <= "1100"; -- Opcode para SEQ
        A <= x"80000004";
        B <= x"80000004";
        wait for 20 ns;
        report "SEQ Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);
               
        -- Teste para SNE
        opcode <= "1101"; -- Opcode para SNE
        A <= x"80000004";
        B <= x"80000003";
        wait for 20 ns;
        report "SNE Test: A=" & to_hstring(A) & " B=" & to_hstring(B) &
               " Z=" & to_hstring(Z) & " cond=" & std_logic'image(cond);

        wait;
    end process;

end Behavioral;
