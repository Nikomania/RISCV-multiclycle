library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_tb is
end control_tb;

architecture test of control_tb is
    -- Sinais para conectar à unidade multi_cicle_riscV
    signal clock    : std_logic := '0';
    signal opcode    : std_logic_vector(6 downto 0) := "0000011";
    signal EscrevePCCond : std_logic;
    signal EscrevePC     : std_logic;
    signal IouD          : std_logic;
    signal EscreveMem    : std_logic;
    signal LeMem         : std_logic;
    signal EscreveIR     : std_logic;

    signal OrigPC        : std_logic;
    signal ALUOp         : std_logic_vector(1 downto 0);
    signal OrigAULA      : std_logic_vector(1 downto 0);
    signal OrigBULA      : std_logic_vector(1 downto 0);
    signal EscrevePCB    : std_logic;
    signal EscreveReg    : std_logic;
    signal Mem2Reg       : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 3 ns;

begin
    -- Instância da multi_cicle_riscV
    uut: entity work.control
        port map (
            clock  => clock,
            opcode => opcode,
            EscrevePCCond => EscrevePCCond,
            EscrevePC     => EscrevePC,
            IouD          => IouD,
            EscreveMem    => EscreveMem,
            LeMem         => LeMem,
            EscreveIR     => EscreveIR,
            OrigPC        => OrigPC,
            ALUOp         => ALUOp,
            OrigAULA      => OrigAULA,
            OrigBULA      => OrigBULA,
            EscrevePCB    => EscrevePCB,
            EscreveReg    => EscreveReg,
            Mem2Reg       => Mem2Reg
        );

    -- Geração de estímulos
    stim_proc: process
    begin
        wait for 5 ns;
        report "Init:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);

        wait for CLK_PERIOD / 2;
		    clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        report "Fetch:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);

        wait for CLK_PERIOD / 2;
		    clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;
        
        report "Decode:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        report "Execute:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        report "Memory:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        report "Write back:" &
        " EscrevePCCond=" & std_logic'image(EscrevePCCond) &
        " EscrevePC=" & std_logic'image(EscrevePC) &
        " IouD=" & std_logic'image(IouD) &
        " EscreveMem=" & std_logic'image(EscreveMem) &
        " LeMem=" & std_logic'image(LeMem) &
        " EscreveIR=" & std_logic'image(EscreveIR) &
        " OrigPC=" & std_logic'image(OrigPC) &
        " ALUOp=" & to_hstring(ALUOp) &
        " OrigAULA=" & to_hstring(OrigAULA) &
        " OrigBULA=" & to_hstring(OrigBULA) &
        " EscrevePCB=" & std_logic'image(EscrevePCB) &
        " EscreveReg=" & std_logic'image(EscreveReg) &
        " Mem2Reg=" & to_hstring(Mem2Reg);
        
        clock <= '1';
        wait for CLK_PERIOD / 2;
        clock <= '0';
        wait for CLK_PERIOD / 2;

        wait;
    end process;

end architecture;
