library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_left_one is
    Port (
        A : in signed(31 downto 0);
        Z : out std_logic_vector(31 downto 0)
    );
end shift_left_one;

architecture Behavioral of shift_left_one is
begin
    process(A)
    begin
        Z <= std_logic_vector(shift_left(A, 1));
    end process;
end Behavioral;
