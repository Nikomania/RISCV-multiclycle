library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_XREG is
end tb_XREG;

architecture Behavioral of tb_XREG is
  signal clk, wren : std_logic := '0';
  signal rs1, rs2, rd : std_logic_vector(4 downto 0) := "00000";
  signal data : std_logic_vector(31 downto 0) := x"00000000" ;
  signal ro1, ro2 : std_logic_vector(31 downto 0) := x"00000000";
begin
  -- Instancia o UUT (Unidade em Teste)
  uut: entity work.XREGS port map (
    clk => clk,
    wren => wren,
    rs1 => rs1,
    rs2 => rs2,
    rd => rd,
    data => data,
    ro1 => ro1,
    ro2 => ro2
  );

	process
  begin
    -- Teste para inicializar valor
    clk <= '0';
    wren <= '1';
    rs1 <= "00101";
    rs2 <= "00010";
    rd <= "00101";
    data <= x"00BECAFE";

    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;

    assert (ro1 = x"00BECAFE")
    report "Error: Write value Test didn't pass!"
    severity failure;
    report "Write value Test: ro1=" & to_hstring(ro1) &
            " data=" & to_hstring(data) & " rs1=" & to_hstring(rs1) &
            " rd=" & to_hstring(rd);

    -- Teste para inicializar mais um outro valor
    wren <= '1';
    rs1 <= "00100";
    rs2 <= "00011";
    rd <= "00011";
    data <= x"0002FECA";

    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;

    assert (ro2 = x"0002FECA")
    report "Error: Write other value Test didn't pass!"
    severity failure;
    report "Write other value Test: ro2=" & to_hstring(ro2) &  --& " cond=" & std_logic'image(cond);
            " data=" & to_hstring(data) & " rs2=" & to_hstring(rs2) &
            " rd=" & to_hstring(rd);

    -- Teste para verificar o valor do registrador 5 e 3
    wren <= '0';
    rs1 <= "00011";
    rs2 <= "00101";
    rd <= "00011";
    data <= x"0032CAFE";

    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;

    assert (ro2 = x"00BECAFE" and ro1 = x"0002FECA")
    report "Error: Read values Test didn't pass!"
    severity failure;
    report "Read values Test:" & " rs1=" & to_hstring(rs1) & " ro1=" & to_hstring(ro1) &
           " rs2=" & to_hstring(rs2) & " ro2=" & to_hstring(ro2);

    -- Teste para verificar a não alteração do registrador 0
    wren <= '1';
    rs1 <= "00000";
    rs2 <= "00001";
    rd <= "00000";
    data <= x"00123456";

    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;

    assert (ro1 = x"00000000")
    report "Write value in 0 Test didn't pass!"
    severity failure;
    report "Write value in 0 Test:" & " rs1=" & to_hstring(rs1) & " ro1=" & to_hstring(ro1) &
           " rd=" & to_hstring(rd) & " data=" & to_hstring(data);
           
    -- Teste para ler outro valor sem mexer no clock
    wren <= '1';
    rs1 <= "00011";
    rs2 <= "00101";
    rd <= "00011";
    data <= x"000000FB";
    
    wait for 5 ns;
    assert (ro1 = x"0002FECA" and ro2 = x"00BECAFE")
    report "Write value in 0 Test didn't pass!"
    severity failure;
    report "Read value in 3 and 5 without clock Test:" &
    " rs1=" & to_hstring(rs1) & " ro1=" & to_hstring(ro1) &
    " rs2=" & to_hstring(rs2) & " ro2=" & to_hstring(ro2) &
           " rd=" & to_hstring(rd) & " data=" & to_hstring(data);
           
    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;
    
    -- Teste para verificar a alteração do registrador 3
    wren <= '0';
    rs1 <= "00011";
    rs2 <= "00000";
    rd <= "00000";
    data <= x"00123456";

    wait for 20 ns;
    clk <= '1';
    wait for 20 ns;
    clk <= '0';
    wait for 20 ns;

    assert (ro1 = x"000000FB")
    report "Write value in 3 Test didn't pass!"
    severity failure;
    report "Write value in 3 Test:" & " rs1=" & to_hstring(rs1) & " ro1=" & to_hstring(ro1) &
           " rd=" & to_hstring(rd) & " data=" & to_hstring(data);

    wait;
  end process;
end Behavioral;
