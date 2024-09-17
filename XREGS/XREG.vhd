library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity XREGS is -- banco de registradores do RISC-V
  generic (WSIZE : natural := 32); -- WSIZE é o tamanho da palavra do banco de registradores
  port (
    clk, wren : in std_logic; -- wren: habilitação de escrita (clk clock)
    rs1, rs2, rd : in std_logic_vector(4 downto 0); -- rs1, rs2: endereços dos registradores a serem lidos (rd escrito quando wren = 1)
    data : in std_logic_vector(WSIZE-1 downto 0); -- valor a ser escrito em rd quando wren = 1
    ro1, ro2 : out std_logic_vector(WSIZE-1 downto 0) -- saída de leitura dos registradores rs1 e rs2
  );
end XREGS;

architecture Behavioral of XREGS is
  type reg_array is array (31 downto 0) of std_logic_vector(WSIZE-1 downto 0);
  signal regs : reg_array := (others => (others => '0'));
begin
  process(clk, wren, rs1, rs2, rd, data, regs)
  begin
    if rising_edge(clk) then
      if wren = '1' then
        if rd /= "00000" then
          regs(to_integer(unsigned(rd))) <= data;
        end if;
      end if;
    end if;
  end process;
  
  ro1 <= regs(to_integer(unsigned(rs1)));
  ro2 <= regs(to_integer(unsigned(rs2)));
end Behavioral;
