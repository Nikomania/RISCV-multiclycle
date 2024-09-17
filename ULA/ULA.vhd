library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ulaRV is
    Port (
        opcode : in std_logic_vector(3 downto 0);
        A, B : in std_logic_vector(31 downto 0);
        Z : out std_logic_vector(31 downto 0);
        cond : out std_logic
    );
end ulaRV;

architecture Behavioral of ulaRV is
begin
    process(opcode, A, B)
    begin
        case opcode is
            when "0000" => -- ADD
                Z <= std_logic_vector(signed(A) + signed(B));
                cond <= '0';
                
            when "0001" => -- SUB
                Z <= std_logic_vector(signed(A) - signed(B));
                cond <= '0';
                
            when "0010" => -- AND
                Z <= A and B;
                cond <= '0';
                
            when "0011" => -- OR
                Z <= A or B;
                cond <= '0';
                
            when "0100" => -- XOR
                Z <= A xor B;
                cond <= '0';
                
            when "0101" => -- SLL
                Z <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
                
            when "0110" => -- SRL
                Z <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
                
            when "0111" => -- SRA
                Z <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B(4 downto 0)))));
                cond <= '0';
                
            when "1000" => -- SLT
                if signed(A) < signed(B) then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when "1001" => -- SLTU
                if unsigned(A) < unsigned(B) then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when "1010" => -- SGE
                if signed(A) >= signed(B) then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when "1011" => -- SGEU
                if unsigned(A) >= unsigned(B) then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when "1100" => -- SEQ
                if A = B then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when "1101" => -- SNE
                if A /= B then
                    Z <= x"00000001";
                    cond <= '1';
                else
                    Z <= x"00000000";
                    cond <= '0';
                end if;
                
            when others =>
                Z <= x"00000000";
                cond <= '0';
        end case;
    end process;
end Behavioral;
