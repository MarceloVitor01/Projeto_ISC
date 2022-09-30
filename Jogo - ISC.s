.data
CHAR_POS: 	.half 16, 32
OLD_CHAR_POS:	.half 16, 32
CORD_SHOT:	.half 0, 0
.include "sprites/charUP.data"
.include "sprites/charD.data"
.include "sprites/charR.data"
.include "sprites/charL.data"
.include "sprites/mapa4.data"
.include "sprites/tileP.data"
.include "sprites/shotVer.data"
.include "sprites/shotHor.data"


.text
SETUP: 		la,  a0, mapa4
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		la t0, CHAR_POS
		la a0, charR
		mv s2, a0 # s2 endereco ultimo personagem usado
		lh a1, 0(t0)
		lh a2, 2(t0)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
GAME_LOOP:	call KEY2
		
		xori s0, s0, 1
		
		la t0, CHAR_POS
		mv a0, s2
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a3, s0
		call PRINT
		
		li t0, 0xFF200604
		sw s0, 0(t0)
		
		la t0, OLD_CHAR_POS
		
		la a0, tileP
		lh a1, 0(t0)
		lh a2, 2(t0)
		
		mv a3, s0
		xori a3, a3, 1
		call PRINT
		
		j GAME_LOOP
		
KEY2:		li t1,0xFF200000
		lw t0,0(t1)
		andi t0,t0,0x0001
   		beq t0,zero,FIM
  		lw t2,4(t1)
  		
	        li t0, 'w'
		beq t2, t0, CHAR_UP
		
		li t0, 'a'
		beq t2, t0, CHAR_ESQ
		
		li t0, 's'
		beq t2, t0, CHAR_DOWN
		
		li t0, 'd'
		beq t2, t0, CHAR_DIR
		
		li t0, 'k'
		beq t2, t0, DIR_SHOT
	
FIM:		ret

CHAR_ESQ: 	

		la t0, CHAR_POS
		la t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)
		
		 ## CHECAGEM DE COLISAO
		lh t1, 0(t0) # endereco X
		lh t5, 2(t0) # endereco Y      
		addi t1, t1, -16
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t5
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, REVERSE ####
		
		sh t1, 0(t0)
		la a0, charL
		mv s2, a0
		ret
		
CHAR_DIR: 	la t0, CHAR_POS
		la t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)

		la t0, CHAR_POS
		lh t1, 0(t0)
		addi t1, t1, 16 # endereco X
		
		## CHECAGEM DE COLISAO
		lh t5, 2(t0) # endereco Y      
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t5
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, REVERSE ####
		
		sh t1, 0(t0)
		lh a1, 0(t0)
		lh a2, 2(t0)
		
		la a0, charR
		mv s2, a0
		ret
		
CHAR_UP: 	la t0, CHAR_POS
		la t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)

		la t0, CHAR_POS
		lh t1, 2(t0)
		addi t1, t1, -16 #endereco Y
		
		## CHECAGEM DE COLISAO
		lh t5, 0(t0) # endereco X      
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t5
		li t3, 320
		mul t3, t3, t1
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, REVERSE ####
		
		sh t1, 2(t0)
		lh a1, 0(t0)
		lh a2, 2(t0)
		
		la a0, charUP
		mv s2, a0
		ret

CHAR_DOWN: 	la t0, CHAR_POS
		la t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)

		la t0, CHAR_POS
		lh t1, 2(t0)
		addi t1, t1, 16 # endereco Y
		## CHECAGEM DE COLISAO
		lh t5, 0(t0) # endereco X      
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t5
		li t3, 320
		mul t3, t3, t1
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, REVERSE 
		###
		sh t1, 2(t0)
		lh a1, 0(t0)
		lh a2, 2(t0)
		la a0, charD
		mv s2, a0
		ret
		
DIR_SHOT:	#la t0, charL
		#beq s2, t0, SHOT_ESQ
		
		la t0, charR
		beq s2, t0, SHOT_DIR
		
		#la t0, charUP
		#beq s2, t0, SHOT_UP
		
		#la t0, charD
		#beq s2, t0, SHOT_DOWN
		
SHOT_DIR:	la t0, CHAR_POS
		lh t1, 0(t0) # t1 = X
		lh t2, 2(t0) # t2 = Y
		addi t1, t1, 16
		
		la t3, CORD_SHOT  
		la a0, shotHor
		sh a1, 0(t3)
		sh a2, 2(t3)
		call PRINT
		j GAME_LOOP
		
		

		

		
		

#
#	a0 = endere�o imagem
#	a1 = x
#	a2 = y
#	a3 = frame (0 ou 1)
##
#
#	t0 = endereco do bitmap display
#	t1 = endereco da imagem
#	t2 = contador de linha
# 	t3 = contador de coluna
#	t4 = largura
#	t5 = altura
#
PRINT:		li t0,  0xFF0
		add t0, t0, a3
		slli t0, t0, 20
		
		add t0, t0, a1
		
		li t1, 320
		mul t1, t1, a2
		add t0, t0, t1
		
		addi t1, a0, 8
		
		mv t2, zero
		mv t3, zero
		
		lw t4, 0(a0)
		lw t5, 4(a0)
		
PRINT_LINHA:	lw t6, 0(t1)
		sw t6, 0(t0)
		
		addi t0, t0, 4
		addi t1, t1, 4
		
		addi t3, t3, 4
		blt t3, t4, PRINT_LINHA

		addi t0, t0, 320
		sub t0, t0, t4
		
		mv t3, zero
		addi t2, t2, 1
		bgt t5, t2, PRINT_LINHA
		
		ret
REVERSE:
		la t0, OLD_CHAR_POS
		la t1, CHAR_POS
		lh t2, 0(t0) #reverse X
		sh t2, 0(t1)
		
		lh t2, 2(t0) #reveser Y
		sh t2, 2(t0)
		j GAME_LOOP  
		
		

