library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multi_cicle_riscV is
	port(
    	main_clock : in std_logic
    );
end multi_cicle_riscV;

architecture Behavioral of multi_cicle_riscV is
component genImm32 port (
	instr : in std_logic_vector(31 downto 0);
    imm32  : out signed(31 downto 0)
);
end component;

component ulaRV port (
    opcode : in std_logic_vector(3 downto 0);
    A, B : in std_logic_vector(31 downto 0);
    Z : out std_logic_vector(31 downto 0);
    cond : out std_logic
);
end component;

component XREGS port ( -- banco de registradores do RISC-V
    clk, wren : in std_logic; -- wren: habilitação de escrita (clk clock)
    rs1, rs2, rd : in std_logic_vector(4 downto 0); -- rs1, rs2: endereços dos registradores a serem lidos (rd escrito quando wren = 1)
    data : in std_logic_vector(31 downto 0); -- valor a ser escrito em rd quando wren = 1
    ro1, ro2 : out std_logic_vector(31 downto 0) -- saída de leitura dos registradores rs1 e rs2
);
end component;

component mem_rv port (
    clock    : in std_logic;
    we       : in std_logic; -- write enable
    re       : in std_logic; -- read enable
    address  : in std_logic_vector(11 downto 0); -- 12-bit address
    datain   : in std_logic_vector(31 downto 0); -- 32-bit input data
    dataout  : out std_logic_vector(31 downto 0) -- 32-bit output data
);
end component;

component control_ULA port (
	  funct7 : in std_logic_vector(6 downto 0); -- utilizado quando ALUOp = 10
    funct3 : in std_logic_vector(2 downto 0); -- utilizado quando ALUOp = 10
    ALUOp : in std_logic_vector(1 downto 0); -- sinal de controle
    opcode_ULA : out std_logic_vector(3 downto 0) -- seleciona operação da ula
);
end component;

component control port (
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
end component;

component simple_reg port (
  	clock, wren : in std_logic;
  	datain : in std_logic_vector(31 downto 0);
  	dataout : out std_logic_vector(31 downto 0)
);
end component;

component mux_1_2 port (
  	s : in std_logic;
    d0 : in std_logic_vector(31 downto 0);
    d1 : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0)
);
end component;

component mux_2_4 port (
  	s : in std_logic_vector(1 downto 0);
    d0 : in std_logic_vector(31 downto 0);
    d1 : in std_logic_vector(31 downto 0);
    d2 : in std_logic_vector(31 downto 0);
    d3 : in std_logic_vector(31 downto 0);
    o : out std_logic_vector(31 downto 0)
);
end component;
-- SB -> B register signal
-- SIR -> IR register signal
signal SPC, SOrigPCMux, SIouDMux, SPCBack : std_logic_vector(31 downto 0); -- 12 bits
signal SSaidaULA, SA, SB, Smem_ram, SIR, Sdata_register, SMem2RegMux, Sro1, Sro2, SOrigAULAMux, SOrigBULAMux, SULA : std_logic_vector(31 downto 0);
signal SgenImm : signed(31 downto 0);
signal SZero, SEscrevePCCond, SEscrevePC, SIoud, SEscreveMem, SLeMem, SEscreveIR, SEscreveReg, SEscrevePCB, SOrigPC : std_logic;
signal SMem2Reg, SOrigAULA, SOrigBULA, SALUOp : std_logic_vector(1 downto 0);
signal ScontrolULA : std_logic_vector(3 downto 0);

begin
  PC : simple_reg port map (
    clock => main_clock,
    wren => SEscrevePC or (SEscrevePCCond and SZero),
    datain => SOrigPCMux, -- std_logic_vector(x"0000" & "00" & SOrigPCMux(13 downto 0)) -- 2 bits more because it'll be later shifted right by 2 (index by word)
    dataout => SPC
  );
	
  IouDMux : mux_1_2 port map (
    s => SIouD,
    d0 => SPC,
    d1 => SSaidaULA, -- std_logic_vector(x"0000" & "00" & SSaidaULA(13 downto 0))
    o => SIouDMux
  );

  mem_ram : mem_rv port map (
    clock => main_clock,
    we => SEscreveMem,
    re => SLeMem,
    address => SIouDMux(13 downto 2),
    datain => SB,
    dataout => Smem_ram
  );

  IR : simple_reg port map (  -- instr register
    clock => main_clock,
    wren => SEscreveIR,
    datain => Smem_ram,
    dataout => SIR
  );

  data_register : simple_reg port map (  -- Registrador de Dado de Memória
    clock => main_clock,
    wren => '1',
    datain => Smem_ram,
    dataout => Sdata_register
  );

  Mem2RegMux : mux_2_4 port map (
    s => SMem2Reg,
    d0 => SSaidaULA,
    d1 => SPC,
    d2 => Sdata_register,
    d3 => x"00000000", -- no idea
    o => SMem2RegMux
  );

  genImm : genImm32 port map (
    instr => SIR,
    imm32 => SgenImm
  );

  Regs : XREGS port map (
    clk => main_clock,
    wren => SEscreveReg,
    rs1 => SIR(19 downto 15),
    rs2 => SIR(24 downto 20),
    rd => SIR(11 downto 7),
    data => SMem2RegMux,
    ro1 => Sro1,
    ro2 => Sro2
  );

  PCBack : simple_reg port map (
    clock => main_clock,
    wren => SEscrevePCB,
    datain => SPC,
    dataout => SPCBack
  );

  A : simple_reg port map (
    clock => main_clock,
    wren => '1',
    datain => Sro1,
    dataout => SA
  );

  B : simple_reg port map (
    clock => main_clock,
    wren => '1',
    datain => Sro2,
    dataout => SB
  );

  OrigAULAMux : mux_2_4 port map (
    s => SOrigAULA,
    d0 => SPCBack,
    d1 => SA,
    d2 => SPC,
    d3 => x"00000000",  -- no idea
    o => SOrigAULAMux
  );

  OrigBULAMux : mux_2_4 port map (
    s => SOrigBULA,
    d0 => SB,
    d1 => x"00000004",
    d2 => STD_LOGIC_VECTOR(SgenImm),
    d3 => STD_LOGIC_VECTOR(SgenImm),  -- don't know what to put here
    o => SOrigBULAMux
  );

  controlULA : control_ULA port map (
    funct7 => SIR(31 downto 25),
    funct3 => SIR(14 downto 12),
    ALUOp => SALUOp,
    opcode_ULA => ScontrolULA
  );

  ULA : ulaRV port map (
    opcode => ScontrolULA,
    A => SOrigAULAMux,
    B => SOrigBULAMux,
    Z => SULA,
    cond => SZero
  );

  SaidaUla : simple_reg port map (
    clock => main_clock,
    wren => '1',
    datain => SULA,
    dataout => SSaidaULA
  );

  OrigPCMux : mux_1_2 port map (
    s => SOrigPC,
    d0 => SULA,
    d1 => SSaidaULA,
    o => SOrigPCMux
  );

  control_unity : control port map (
    clock => main_clock,
    opcode => SIR(6 downto 0),
    EscrevePCCond => SEscrevePCCond,
    EscrevePC => SEscrevePC,
    IouD => SIoud,
    EscreveMem => SEscreveMem,
    LeMem => SLeMem,
    EscreveIR => SEscreveIR,
    OrigPC => SOrigPC,
    ALUOp => SALUOp,
    OrigAULA => SOrigAULA,
    OrigBULA => SOrigBULA,
    EscrevePCB => SEscrevePCB,
    EscreveReg => SEscreveReg,
    Mem2Reg => SMem2Reg
  );
end Behavioral;
