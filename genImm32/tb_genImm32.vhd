library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_genImm32 is
end tb_genImm32;

architecture Behavioral of tb_genImm32 is
    signal instr : std_logic_vector(31 downto 0);
    signal imm32 : signed(31 downto 0);
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.genImm32
        port map (
            instr => instr,
            imm32 => imm32
        );

    -- Test process
    process
    begin
        -- Test 1: add t0, zero, zero (R-type)
        instr <= x"000002b3";
        wait for 1000 ns;
        report "R-type (add t0, zero, zero): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(0, 32))
            report "Fail: R-type (add t0, zero, zero)" severity error;

        -- Test 2: lw t0, 16(zero) (I-type)
        instr <= x"01002283";
        wait for 1000 ns;
        report "I-type (lw t0, 16(zero)): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(16#00000010#, 32))
            report "Fail: I-type (lw t0, 16(zero))" severity error;

        -- Test 3: addi t1, zero, -100 (I-type)
        instr <= x"f9c00313";
        wait for 1000 ns;
        report "I-type (addi t1, zero, -100): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(-100, 32))
            report "Fail: I-type (addi t1, zero, -100)" severity error;

        -- Test 4: xori t0, t0, -1 (I-type)
        instr <= x"fff2c293";
        wait for 1000 ns;
        report "I-type (xori t0, t0, -1): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(-1, 32))
            report "Fail: I-type (xori t0, t0, -1)" severity error;

        -- Test 5: addi t1, zero, 354 (I-type)
        instr <= x"16200313";
        wait for 1000 ns;
        report "I-type (addi t1, zero, 354): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(354, 32))
            report "Fail: I-type (addi t1, zero, 354)" severity error;

        -- Test 6: jalr zero, zero, 0x18 (I-type)
        instr <= x"01800067";
        wait for 1000 ns;
        report "I-type (jalr zero, zero, 0x18): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(16#00000018#, 32))
            report "Fail: I-type (jalr zero, zero, 0x18)" severity error;

        -- Test 7: srai t1, t2, 10 (I-type*)
        instr <= x"40a3d313";
        wait for 1000 ns;
        report "I-type* (srai t1, t2, 10): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(10, 32))
            report "Fail: I-type* (srai t1, t2, 10)" severity error;

        -- Test 8: lui s0, 2 (U-type)
        instr <= x"00002437";
        wait for 1000 ns;
        report "U-type (lui s0, 2): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(16#00002000#, 32))
            report "Fail: U-type (lui s0, 2)" severity error;

        -- Test 9: sw t0, 60(s0) (S-type)
        instr <= x"02542e23";
        wait for 1000 ns;
        report "S-type (sw t0, 60(s0)): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(60, 32))
            report "Fail: S-type (sw t0, 60(s0))" severity error;

        -- Test 10: bne t0, t0, main (SB-type)
        instr <= x"fe5290e3";
        wait for 1000 ns;
        report "SB-type (bne t0, t0, main): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(-32, 32))
            report "Fail: SB-type (bne t0, t0, main)" severity error;

        -- Test 11: jal rot (UJ-type)
        instr <= x"00c000ef";
        wait for 1000 ns;
        report "UJ-type (jal rot): imm32 = " & integer'image(to_integer(imm32));
        assert (imm32 = to_signed(12, 32))
            report "Fail: UJ-type (jal rot)" severity error;

        wait;
    end process;
end Behavioral;
