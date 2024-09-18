library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    Port (
        clock         : in  std_logic;
        opcode        : in  std_logic_vector(6 downto 0);

        EscrevePCCond : out std_logic;
        EscrevePC     : out std_logic;
        IouD          : out std_logic;
        EscreveMem    : out std_logic;
        LeMem         : out std_logic;
        EscreveIR     : out std_logic;

        OrigPC        : out std_logic;
        ALUOp         : out std_logic_vector(1 downto 0);
        OrigAULA      : out std_logic_vector(1 downto 0);
        OrigBULA      : out std_logic_vector(1 downto 0);
        EscrevePCB    : out std_logic;
        EscreveReg    : out std_logic;
        Mem2Reg       : out std_logic_vector(1 downto 0)
    );
end control;

architecture Behavioral of control is
  type main_state_type is (Init, Fetch, Decode, Execute, Memory, WriteBack, Error);
  -- original types only help to calculate immediates, not execute instructions
  -- analysing only instructions from RISC-V ISA - Formatos and the instructions asked
  -- lw, sw, add, addi, sub, and, or, xor, slt, jal, jalr, auipc, lui, beq, bne
  -- i hope that other types, such as JType and SType, are correct, otherwise just rename as specific for the instructions implemented
  type instruction_type is (LOADType, SType, RType, IRType, auipc, lui, BType, JType, jalr, Error);

  signal main_state : main_state_type := Init;
  signal next_main_state : main_state_type;
  signal instruction : instruction_type;
begin

sync_proc : process(clock)
    begin
    if rising_edge(clock) then
        main_state <= next_main_state;
    end if;
end process sync_proc;

comb_proc : process(main_state, opcode, instruction)
  begin
    case main_state is
      when Init =>
        EscrevePCCond <= '0';
        EscrevePC     <= '0';
        IouD          <= '0';
        EscreveMem    <= '0';
        LeMem         <= '0';
        EscreveIR     <= '0';

        OrigPC        <= '0';
        ALUOp         <= "00";
        OrigAULA      <= "00";
        OrigBULA      <= "00";
        EscrevePCB    <= '0';
        EscreveReg    <= '0';
        Mem2Reg       <= "00";

        next_main_state <= Fetch;
      when Fetch =>
        EscrevePCCond <= '0';
        EscrevePC     <= '1';
        IouD          <= '0';
        EscreveMem    <= '0';
        LeMem         <= '1';
        EscreveIR     <= '1';

        OrigPC        <= '0';
        ALUOp         <= "00";
        OrigAULA      <= "10";
        OrigBULA      <= "01";
        EscrevePCB    <= '1';
        EscreveReg    <= '0';
        -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

        next_main_state <= Decode;
      when Decode =>
        EscrevePCCond <= '0';
        EscrevePC     <= '0';
        -- IouD          <= '0';  -- it doesn't matter, but maybe it could alter data register and that could be a problem (maybe doesn't matter)
        EscreveMem    <= '0';
        -- LeMem         <= '1';  -- it doesn't matter like IouD, but if i put ioud as 0, than this one should be 1 for the same reason
        EscreveIR     <= '0';

        -- OrigPC        <= '0';  -- it doesn't matter, not writting pc
        ALUOp         <= "00";  -- pre-calculating in case it's a jump or branch instruction
        OrigAULA      <= "00";  -- select pcback
        OrigBULA      <= "10";  -- select imm
        EscrevePCB    <= '0';
        EscreveReg    <= '0';
        -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

        next_main_state <= Execute;
      when Execute =>  -- TODO
        case instruction is
          when LOADType =>  -- ok
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            ALUOp         <= "00";
            OrigAULA      <= "01"; -- select A
            OrigBULA      <= "10"; -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "10";  -- it doesn't matter, not writting reg

            next_main_state <= Memory;
          when SType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            ALUOp         <= "00";
            OrigAULA      <= "01";
            OrigBULA      <= "10";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

            next_main_state <= Memory;
          when RType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            ALUOp         <= "11";
            OrigAULA      <= "01";
            OrigBULA      <= "00";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

            next_main_state <= WriteBack;
          when IRType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            ALUOp         <= "10";
            OrigAULA      <= "01"; -- select A
            OrigBULA      <= "10"; -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

            next_main_state <= WriteBack;
          when auipc =>
            ALUOp <= "00";
            next_main_state <= WriteBack;
          when lui =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            ALUOp         <= "00";
            OrigAULA      <= "11";  -- select 0
            OrigBULA      <= "10";  -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

            next_main_state <= WriteBack;
          when BType =>
            EscrevePCCond <= '1';
            EscrevePC     <= '0';
            -- IouD          <= '0';  -- it doesn't matter, but maybe it could alter data register and that could be a problem (maybe doesn't matter)
            EscreveMem    <= '0';
            -- LeMem         <= '1';  -- it doesn't matter like IouD, but if i put ioud as 0, than this one should be 1 for the same reason
            EscreveIR     <= '0';

            OrigPC        <= '1';  -- select previously calculated adress
            ALUOp         <= "01";  -- compare values to jump
            OrigAULA      <= "01";  -- select A
            OrigBULA      <= "00";  -- select B
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg
            
            next_main_state <= Fetch;
          when JType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '1';
            -- IouD          <= '0';  -- it doesn't matter, but maybe it could alter data register and that could be a problem (maybe doesn't matter)
            EscreveMem    <= '0';
            -- LeMem         <= '1';  -- it doesn't matter like IouD, but if i put ioud as 0, than this one should be 1 for the same reason
            EscreveIR     <= '0';

            OrigPC        <= '1';  -- it doesn't matter, not writting pc
            -- ALUOp         <= "00";  -- pre-calculating in case it's a jump or branch instruction
            -- OrigAULA      <= "00";  -- select pcback
            -- OrigBULA      <= "10";  -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "01";

            next_main_state <= Fetch;
          when jalr =>
            EscrevePCCond <= '0';
            EscrevePC     <= '1';
            -- IouD          <= '0';  -- it doesn't matter, but maybe it could alter data register and that could be a problem (maybe doesn't matter)
            EscreveMem    <= '0';
            -- LeMem         <= '1';  -- it doesn't matter like IouD, but if i put ioud as 0, than this one should be 1 for the same reason
            EscreveIR     <= '0';

            OrigPC        <= '0';  -- it doesn't matter, not writting pc
            ALUOp         <= "00";
            OrigAULA      <= "01";  -- select A
            OrigBULA      <= "10";  -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "01";

            next_main_state <= Fetch;
          when others =>
            next_main_state <= Error;
        end case;
      when Memory =>  -- TODO
        case instruction is
          when LOADType =>  -- ok
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            IouD          <= '1';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "00";
            -- OrigAULA      <= "01";
            -- OrigBULA      <= "10";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "10";  -- it doesn't matter, not writting reg

            next_main_state <= WriteBack;
          when SType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            IouD          <= '1';
            EscreveMem    <= '1';
            LeMem         <= '0';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "00";
            -- OrigAULA      <= "01";
            -- OrigBULA      <= "10";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '0';
            -- Mem2Reg       <= "00";  -- it doesn't matter, not writting reg

            next_main_state <= Fetch;
          when others =>
            next_main_state <= Error;
        end case;
      when WriteBack =>  -- TODO
        case instruction is
          when LOADType =>  -- ok
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '1';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "00";
            -- OrigAULA      <= "01";
            -- OrigBULA      <= "10";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "10";

            next_main_state <= Fetch;
          when IRType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "10";
            -- OrigAULA      <= "01"; -- select A
            -- OrigBULA      <= "10"; -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "00";

            next_main_state <= Fetch;
          when RType =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "11";
            -- OrigAULA      <= "01";
            -- OrigBULA      <= "00";
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "00"; 

            next_main_state <= Fetch;
          when lui =>
            EscrevePCCond <= '0';
            EscrevePC     <= '0';
            -- IouD          <= '0';
            EscreveMem    <= '0';
            -- LeMem         <= '1';
            EscreveIR     <= '0';

            -- OrigPC        <= '0';
            -- ALUOp         <= "00";
            -- OrigAULA      <= "11";  -- select 0
            -- OrigBULA      <= "10";  -- select imm
            -- EscrevePCB    <= '0';
            EscreveReg    <= '1';
            Mem2Reg       <= "00";

            next_main_state <= Fetch;
          when others =>
            next_main_state <= Error;
        end case;
      when Error =>
        EscrevePCCond <= '0';
        EscrevePC     <= '0';
        IouD          <= '0';
        EscreveMem    <= '0';
        LeMem         <= '0';
        EscreveIR     <= '0';

        OrigPC        <= '0';
        ALUOp         <= "00";
        OrigAULA      <= "00";
        OrigBULA      <= "00";
        EscrevePCB    <= '0';
        EscreveReg    <= '0';
        Mem2Reg       <= "00";

        next_main_state <= Error;
      when others =>
        next_main_state <= Error;
    end case;
  end process;

  process(main_state, opcode)
  begin
    if main_state = Decode then
      case opcode is
          when "0000011" =>
            instruction <= LOADType;
          when "0100011" =>
            instruction <= SType;  -- only sw
          when "0110011" =>
            instruction <= RType;
          when "0010011" =>
            instruction <= IRType;  -- like addi, slti, sltiu, xori, ori, andi
          when "0010111" =>
            instruction <= auipc;
          when "0110111" =>
            instruction <= lui;
          when "1100011" =>
            instruction <= BType;
          when "1101111" =>
            instruction <= JType; -- only jal
          when "1100111" =>
            instruction <= jalr;
          when others =>
            instruction <= Error;
        end case;
      end if;
  end process;
end Behavioral;
