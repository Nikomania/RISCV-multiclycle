library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_1_2 is
  port (
    s : in std_logic;
    d0 : in std_logic_vector(31 downto 0);
    d1 : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0)
  );
end mux_1_2;

architecture Behavioral of mux_1_2 is
begin
  process(s, d0, d1)
  begin
    if s = '0' then
      o <= d0;
    else
      o <= d1;
    end if;
  end process;
end Behavioral;
