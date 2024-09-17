library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity genImm32 is
    Port ( instr : in std_logic_vector(31 downto 0);
           imm32  : out signed(31 downto 0));
end genImm32;

architecture Behavioral of genImm32 is
    type instr_format_type is (R_type, I_type, I_type_star, S_type, SB_type, U_type, UJ_type);
    signal instr_format : instr_format_type;
    signal opcode       : std_logic_vector(6 downto 0);
    signal funct3       : std_logic_vector(2 downto 0);
begin

    -- Extract opcode and funct3 fields
    opcode <= instr(6 downto 0);
    funct3 <= instr(14 downto 12);

    -- Determine instruction format
    process(opcode, funct3)
    begin
        case opcode is
            when "0110011" => -- R-type
                instr_format <= R_type;
            when "0010011" => -- I-type and I_type_star
                if funct3 = "101" then
                    instr_format <= I_type_star;
                else
                    instr_format <= I_type;
                end if;
            when "0000011" | "1100111" => -- Load I-type and JALR I-type
                instr_format <= I_type;
            when "0100011" => -- S-type
                instr_format <= S_type;
            when "1100011" => -- SB-type
                instr_format <= SB_type;
            when "1101111" => -- UJ-type
                instr_format <= UJ_type;
            when "0110111" => -- U-type
                instr_format <= U_type;
            when others =>
                instr_format <= R_type; -- Default to R-type
        end case;
    end process;

    -- Generate immediate value based on instruction format
    process(instr_format, instr)
    begin
        case instr_format is
            when R_type =>
                imm32 <= (others => '0');
            when I_type =>
                imm32 <= resize(signed(instr(31 downto 20)), 32);
            when I_type_star =>
                imm32 <= resize(signed(instr(24 downto 20)), 32);
            when S_type =>
                imm32 <= resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32);
            when SB_type =>
                imm32 <= resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), 32);
            when U_type =>
                imm32 <= resize(signed(instr(31 downto 12) & x"000"), 32);
            when UJ_type =>
                imm32 <= resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), 32);
            when others =>
                imm32 <= (others => '0'); -- Default case
        end case;
    end process;

end Behavioral;
