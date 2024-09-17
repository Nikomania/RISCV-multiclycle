library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity mem_rv is
  generic (
    WSIZE : natural := 32;
    ADDRSIZE : natural := 12
  );
  port (
    clock    : in std_logic;
    we       : in std_logic; -- write enable
    re       : in std_logic; -- read enable
    address  : in std_logic_vector(ADDRSIZE-1 downto 0); -- 12-bit address
    datain   : in std_logic_vector(WSIZE-1 downto 0); -- 32-bit input data
    dataout  : out std_logic_vector(WSIZE-1 downto 0) -- 32-bit output data
  );
end mem_rv;

architecture RTL of mem_rv is
  constant mem_size : natural := 2 ** ADDRSIZE;
  constant mem_instr_size : natural := 2 ** (ADDRSIZE-1);
  type mem_type is array (0 to mem_size - 1) of std_logic_vector(WSIZE-1 downto 0);
  
  -- Initializing RAM from an external file
  impure function init_mem return mem_type is
    file text_file : text open read_mode is "instructions.txt";  -- Arquivo de instruções
    file text_file2 : text open read_mode is "data.txt";  -- Arquivo de instruções
    variable text_line : line;
    variable mem_content : mem_type;
  begin
    for i in 0 to mem_instr_size - 1 loop
      if (not endfile(text_file)) then
        readline(text_file, text_line);
        hread(text_line, mem_content(i));  -- Ler o arquivo de texto com instruções
      end if;
    end loop;

    for i in mem_instr_size to mem_size - 1 loop
      if (not endfile(text_file2)) then
        readline(text_file2, text_line);
        hread(text_line, mem_content(i));  -- Ler o arquivo de texto com dados
      end if;
    end loop;
    return mem_content;
  end function;

  signal mem : mem_type := init_mem;
  signal addr_int : integer;
  
begin
  addr_int <= to_integer(unsigned(address));  -- Converte o endereço de std_logic_vector para inteiro
  dataout <= mem(addr_int) when (we = '0' and re = '1') else X"00000000";

  -- Processo de leitura e escrita sincronizado com o clock
  process(clock, we, re, addr_int, address, datain, mem)
  begin
    if rising_edge(clock) then
      if we = '1' and re = '0' then  -- Escrita habilitada
        mem(addr_int) <= datain;
      end if;
    end if;
  end process;

end RTL;
