library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity simple_reg is
  port (
    clock, wren : in std_logic;
    datain : in std_logic_vector(31 downto 0);
    dataout : out std_logic_vector(31 downto 0)
  );
end simple_reg;

architecture Behavioral of simple_reg is
  signal data_stored : std_logic_vector(31 downto 0) := x"00000000";
begin
  process(clock, wren, datain, data_stored)
  begin
    if rising_edge(clock) then
      if wren = '1' then
        data_stored <= datain;
      end if;
    end if;
    dataout <= data_stored;
  end process;
end Behavioral;
