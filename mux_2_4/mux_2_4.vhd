library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_4 is
  port (
    s : in std_logic_vector(1 downto 0);
    d0 : in std_logic_vector(31 downto 0);
    d1 : in std_logic_vector(31 downto 0);
    d2 : in std_logic_vector(31 downto 0);
    d3 : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0)
  );
end mux_2_4;

architecture Behavioral of mux_2_4 is
begin
  process(s, d0, d1, d2, d3)
  begin
    case s is 
      when "00" =>
        o <= d0;
      when "01" =>
        o <= d1;
      when "10" =>
        o <= d2;
      when "11" =>
        o <= d3;
      when others =>
        o <= (others => '0');
    end case;
  end process;
end Behavioral;
