library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_ULA is
    Port (
        funct7 : in std_logic_vector(6 downto 0); -- utilizado quando ALUOp = 10
        funct3 : in std_logic_vector(2 downto 0); -- utilizado quando ALUOp = 10
        ALUOp : in std_logic_vector(1 downto 0); -- sinal de controle
        opcode_ULA : out std_logic_vector(3 downto 0) -- seleciona operação da ula
    );
end control_ULA;

architecture Behavioral of control_ULA is
begin
  process(funct7, funct3, ALUOp)
  begin
    case ALUOp is
      when "00" =>
        opcode_ULA <= "0000"; -- ADD
      when "01" =>  -- Type B
        case funct3 is
          when "000" =>
            opcode_ULA <= "1100"; -- SEQ
          when "001" =>
            opcode_ULA <= "1101"; -- SNE
          when "100" =>
            opcode_ULA <= "1000"; -- SLT
          when "101" =>
            opcode_ULA <= "1010"; -- SGE
          when "110" =>
            opcode_ULA <= "1001"; -- SLTU
          when "111" =>
            opcode_ULA <= "1011"; -- SGEU
          when others =>
            opcode_ULA <= "1110"; -- Doesn't exist
        end case;
      when "10" =>  -- Type I
        case funct3 is
          when "000" =>
            opcode_ULA <= "0000"; -- ADD
          when "001" =>
            opcode_ULA <= "0101"; -- SLL
          when "010" =>
            opcode_ULA <= "1000"; -- SLT
          when "011" =>
            opcode_ULA <= "1001"; -- SLTU
          when "100" =>
            opcode_ULA <= "0100"; -- XOR
          when "101" =>
            if funct7(5) = '0' then
              opcode_ULA <= "0110"; -- SRL
            else
              opcode_ULA <= "0111"; -- SRA
            end if;
          when "110" =>
            opcode_ULA <= "0011"; -- OR
          when "111" =>
            opcode_ULA <= "0010"; -- AND
          when others =>
            opcode_ULA <= "1110"; -- Doesn't exist
        end case;
      when "11" =>  -- Type R
        case funct3 is
          when "000" =>
              if funct7(5) = '0' then
                opcode_ULA <= "0000"; -- ADD
              else
                opcode_ULA <= "0001"; -- SUB
              end if;
          when "001" =>
            opcode_ULA <= "0101"; -- SLL
          when "010" =>
            opcode_ULA <= "1000"; -- SLT
          when "011" =>
            opcode_ULA <= "1001"; -- SLTU
          when "100" =>
            opcode_ULA <= "0100"; -- XOR
          when "101" =>
            if funct7(5) = '0' then
              opcode_ULA <= "0110"; -- SRL
            else
              opcode_ULA <= "0111"; -- SRA
            end if;
          when "110" =>
            opcode_ULA <= "0011"; -- OR
          when "111" =>
            opcode_ULA <= "0010"; -- AND
          when others =>
            opcode_ULA <= "1110"; -- Doesn't exist
        end case;
      when others =>
        opcode_ULA <= "1110"; -- Doesn't exist
    end case;
  end process;
end Behavioral;
