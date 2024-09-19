.data 
vet:	.word 15 63

.text                        	
	auipc a0, 2		# a0 <= 0x2000								# 1
	auipc a1, 2		# a1 <= 0x2004								# 2
	lui  s0, 2		# s0 <= 0x2000								# 3
	lw   s1, 0(s0)      	# s1 <= 15						# 4
	lw   s2, 4(s0)      	# s2 <= 63						# 5
	add  s3, s1, s2     	# s3 <= 78						# 6	
	sw   s3, 8(s0)      	# mem[0x2008] <= 78   # 7
	lw   a0, 8(s0)      	# a0 <= 78						# 8
	addi s4, zero, 0x7F0    # s4 <= 0x7F0				# 9
	addi s5, zero, 0x0FF    # s5 <= 0x0FF				# 10
	and  s6, s5, s4         # s6 <= 0x0F0				# 11
	or   s7, s5, s4         # s7 <= 0x7FF				# 12
	xor  s8, s5, s4         # x8 <= 0x70F				# 13
	addi t0, x0, -1		# t0 <= -1								# 14
	addi t1, x0, 1		# t1 <= 1									# 15
	slt  s0, t0, t1         # s0 <= 1						# 16
	slt  s1, t1, t0         # s1 <= 0						# 17
	sub  s2, t0, t1		# s2 <= -2								# 18
	sub  s3, t1, t0		# s3 <= 2									# 19
		
	jal  ra, testasub       # 									# 20
	jal  x0, next           # 									# 21
testasub:
	sub  t3, t0, t1         # t3 <= -2					# 22
	jalr x0, ra, 0          # 									# 23
next:
	addi t0, zero, -2       # t0 <= -2					# 24
beqsim: 
	addi t0, t0, 2          # t0 <= 0, 2				# 25
	beq  t0, zero, beqsim   # 									# 26
bnesim:
	addi t0, t0, -1         # t0 <= 1, 0				# 27
	bne  t0, zero, bnesim   # 									# 28
	
#
# Instrucoes do nucleo comum ^^^
#	

# GRUPO IMM

	ori  a0, zero, 0xFF     # a0 <= 0xFF				# 29
	andi a1, a0, 0xF0       # a1 <= 0xF0				# 30
	xori a2, a0, -1		# a2 <= 0xFFFFFF00				# 31
	ori  a3, a1, 0x7FF	# a3 <= 0x7FF						# 32

# GRUPO COMP
	addi t0, x0, -1		# t0 <= -1								# 33
	addi t1, x0, 1		# t1 <= 1									# 34
	slti s0, x0, -1		# s0 <= 0									# 35
	slti s1, x0, 1         	# s1 <= 1						# 36
	slti s2, t0, -1		# s2 <= 0									# 37
	sltu s3, t1, t0        	# s3 <= 1						# 38
	sltu s4, t0, t1        	# s4 <= 0						# 39
	sltiu s5, t1, -1	# s5 <= 1									# 40

# GRUPO SHIFT

	lui  t2, 0xFF000        # t2 <= 0xFF000000	# 41
	addi a0, x0, 4		# a0 <= 4									# 42
	srl  t3, t2, a0         # t3 <= 0x0FF00000	# 43
	sra  t4, t2, a0         # t4 <= 0xFFF00000	# 44
	sll  t5, t2, a0		# t5 <= 0x0FF00000				# 45

# GRUPO SHIFT Imm

	lui  t2, 0xFF000        # t2 <= 0xFF000000	# 46
	srli t3, t2, 4          # t3 <= 0x0FF00000	# 47
	srai t4, t2, 4          # t4 <= 0xFFF00000	# 48
	slli t5, t2, 4		# t5 <= 0xF0000000				# 49
	
# GRUPO BRANCH	
	
	addi t0, zero, 1	# t0 <= 1									# 50
bltadd:	
	addi t0, t0, -1         # t0 <= 0, -1				# 51
	blt  t0, zero, blton	# falha, salta				# 52
	j    bltadd		# 														# 53
blton:
	bge  t0, zero, bluton	# falha, salta				# 54
	addi t0, t0, 1		# t0 <= 0									# 55
	j blton			# 															# 56
bluton:
	bltu x0, t0, bgeuton    # falha, salta			# 57
	addi t0, t0, -1		# t0 <= -1								# 58
	j bluton																		# 59
bgeuton:
	addi t1, x0, 1000														# 60
	bgeu t1, t0, bgeuton												# 61
	bgeu t0, t1, FOI														# 62
	j bgeuton																		# 63
FOI:
	# encerra...

	
