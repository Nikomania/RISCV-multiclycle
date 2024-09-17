# RISCV-multiclycle

VHD implementation of the architecture RISCV

## Instructions that will be developed:

lw -> opcode = 0000011, funct3 = 010, funct7 = XXXXXXX, tipo I, imediato
sw -> opcode = 0100011, funct3 = 010, funct7 = XXXXXXX, tipo S, imediato
add -> opcode = 0110011, funct3 = 000, funct7 = 0000000, tipo R
addi -> opcode = 0010011, funct3 = 000, funct7 = XXXXXXX, tipo I, imediato
sub -> opcode = 0110011, funct3 = 000, funct7 = 0100000, tipo R
and -> opcode = 0110011, funct3 = 111, funct7 = 0000000, tipo R
or -> opcode = 0110011, funct3 = 110, funct7 = 0000000, tipo R
xor -> opcode = 0110011, funct3 = 100, funct7 = 0000000, tipo R
slt -> opcode = 0110011, funct3 = 010, funct7 = 0000000, tipo R
jal -> opcode = 1101111, funct3 = XXX, funct7 = XXXXXXX, tipo J, imediato
jalr -> opcode = 1100111, funct3 = 000, funct7 = XXXXXXX, tipo I, imediato
auipc -> opcode = 0010111, funct3 = XXX, funct7 = XXXXXXX, tipo U, imediato
lui -> opcode = 0110111, funct3 = XXX, funct7 = XXXXXXX, tipo U, imediato
beq -> opcode = 1100011, funct3 = 000, funct7 = XXXXXXX, tipo B, imediato
bne -> opcode = 1100011, funct3 = 001, funct7 = XXXXXXX, tipo B, imediato

## Program inserted in multi_cicle_riscV/instructions.txt:

0x00000093 = addi r0x1, r0x0, 0x0 -- inicializa 0
0x40008093 = addi r0x1, r0x1, 0x400 -- repete essa instrucao ate ter 0x2000 (8 vezes)
0x70400213 = addi r0x4, r0x0, 0x704
0x0040A223 = sw r0x4, 4(0x1)
0x12340137 = lui r0x02, 0x12340
0x0000A103 = lw r0x02, 0(r0x1)
0x0040A103 = lw r0x02, 4(r0x1)
0x00500193 = addi r0x3, r0x0, 0x5 -- inicializa 0
0x40310133 = sub r0x02, r0x02, r0x03

### Result expected:

0x000006ff -> 0x02
