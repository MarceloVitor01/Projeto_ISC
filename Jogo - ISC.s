.data
CHAR_POS: 	.half 16, 32
OLD_CHAR_POS:	.half 16, 32
CORD_SHOT:	.half 0, 0
OLD_CORD_SHOT:	.half 0, 0
CORD_TIMER:     .half 176, 0
.include "data.data"

# TEMPO POR RODADA ~2 MINUTOS
### EFEITOS SONOROS PROMISSORES:
# MORTE INIMIGO: a2 = 124


# s0 = FRAME SWITCH
# s1 = TIMER
# s2 = ENDERECO ÚLTIMO PERSONAGEM USADO
# s3 = SWITCH TIRO
# s6 = SWITCH CHAR
# s7 / s4= RELOGIO
# s9 = CONTADOR DE CHAVES


# s6 = 0 CHAR BRANCO
# s6 = 1 CHAR VERMELHO
# s6 = 2 CHAR VERDE
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
		mv s2, a0 
		lh a1, 0(t0)
		lh a2, 2(t0)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		li s9, 2
		li s1, 176
		mv s3, zero
		
GAME_LOOP:	beq s9, zero, FIM_MAPA
		
		
		beq s7, s4, TIMER 
		mv s8, zero
		beq s1, zero, DERROTA
		
		li t0, 1
		li t1, 2
		li t2, 3
		li t3, 4

		beq s3, t0, SHOT_DIR
		beq s3, t1, SHOT_ESQ
		beq s3, t2, SHOT_UP
		beq s3, t3, SHOT_DOWN
		
		call KEY2
		

		
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
		
		addi s7, s7, 1
		
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
		
		li t0, 'r'
		beq t2, t0, RETRY
		
		
	
FIM:		ret
		

CHAR_ESQ:	la t0, CHAR_POS
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
		li  t6, 7
		beq t4, t6, CHAVE_VERMELHA
		bne t4, zero, REVERSE ####
		
		sh t1, 0(t0)
		li t6, 1
		beq s6, t6, SWITCH_VERMELHO_ESQ
		li t6, 2
		beq s6, t6, SWITCH_VERDE_ESQ
		
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
		
		## CHECAGEM DE COLISAO OU CHAVES
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
		
		li t6, 1
		beq s6, t6, SWITCH_VERMELHO_DIR
		li t6, 2
		beq s6, t6, SWITCH_VERDE_DIR
		
		la a0, charR
		mv s2, a0
		ret
		
CHAR_UP: 	la t0, CHAR_POS
		la t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)

		la t0, CHAR_POS
		lh t5, 2(t0)
		addi t5, t5, -16 #endereco Y
		
		## CHECAGEM DE COLISAO
		lh t1, 0(t0) # endereco X      
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t5
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, REVERSE ####
		
		sh t5, 2(t0)
		lh a1, 0(t0)
		lh a2, 2(t0)
		
		li t6, 1
		beq s6, t6, SWITCH_VERMELHO_UP
		li t6, 2
		beq s6, t6, SWITCH_VERDE_UP
		
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
		li t6, 58
		beq t6, t4, CHAVE_VERDE
		bne t4, zero, REVERSE 
		###
		sh t1, 2(t0)
		lh a1, 0(t0)
		lh a2, 2(t0)
		
		li t6, 1
		beq s6, t6, SWITCH_VERMELHO_DOWN
		li t6, 2
		beq s6, t6, SWITCH_VERDE_DOWN
		
		la a0, charD
		mv s2, a0
		ret
		
DIR_SHOT:	### EFEITO SONORO TIRO
		li a0, 70
		li a1, 1000
		li a2, 127
		li a3, 100
		li a7, 31
		ecall
		li a0, 1500
		li a7, 32
		ecall
		##############
		
		la t1, CHAR_POS  #### SET COORDENADA INICIAL TIRO
		la t6, CORD_SHOT
		lh t2, 0(t1)
		sh t2, 0(t6)
		lh t2, 2(t1)
		sh t2, 2(t6)
		################
		
		# CODIGOS DIR_SHOT
		# s3 = 0 TIRO NAO ATIVADO
		# s3 = 1 DIREITA
		# s3 = 2 ESQUERDA
		# s3 = 3 CIMA
		# s3 = 4 BAIXO
		############### 
		
		li t6, 1
		beq s6, t6, TESTE_TIRO_RED
		
		la t0, charL
		beq s2, t0, SHOT_ESQ
		
		la t0, charR
		beq s2, t0, SHOT_DIR
		
		
		la t0, charUP
		beq s2, t0, SHOT_UP
		
		la t0, charD
		beq s2, t0, SHOT_DOWN
		
		
SHOT_DIR:       li s3, 1  # instancia SHOT
		la t3, CORD_SHOT
		la t4, OLD_CORD_SHOT
		lh t1, 0(t3) # t1 = X
		sh t1, 0(t4)
		lh t2, 2(t3) # t2 = Y
		sh t2, 2(t4)
		addi t1, t1, 16
		
		
	
		sh t1, 0(t3) 
		sh t2, 2(t3) 
		
		## CHECAGEM COLISAO TIRO
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t2
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, FIM_SHOT
		#################
		
		la t3, CORD_SHOT
		la a0, shotHor
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		
		li a3, 1
		call PRINT
		
		
		la t1, CHAR_POS
		lh t2, 0(t1)
		la t3, OLD_CORD_SHOT
		lh t4, 0(t3)
		beq t2, t4, SHOT_DIR
		la a0, tileP
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		j GAME_LOOP
		
SHOT_ESQ:       li s3, 2  # instancia SHOT
		la t3, CORD_SHOT
		la t4, OLD_CORD_SHOT
		lh t1, 0(t3) # t1 = X
		sh t1, 0(t4)
		lh t2, 2(t3) # t2 = Y
		sh t2, 2(t4)
		addi t1, t1, -16
		
		
	
		sh t1, 0(t3) 
		sh t2, 2(t3) 
		
		## CHECAGEM COLISAO TIRO
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t2
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, FIM_SHOT
		#################
		
		la t3, CORD_SHOT
		la a0, shotHor
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		
		li a3, 1
		call PRINT
		
		
		la t1, CHAR_POS
		lh t2, 0(t1)
		la t3, OLD_CORD_SHOT
		lh t4, 0(t3)
		beq t2, t4, SHOT_ESQ
		la a0, tileP
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		j GAME_LOOP
		
SHOT_UP:        li s3, 3  # instancia SHOT
		la t3, CORD_SHOT
		la t4, OLD_CORD_SHOT
		lh t1, 0(t3) # t1 = X
		sh t1, 0(t4)
		lh t2, 2(t3) # t2 = Y
		sh t2, 2(t4)
		addi t2, t2, -16
		
		
	
		sh t1, 0(t3) 
		sh t2, 2(t3) 
		
		## CHECAGEM COLISAO TIRO
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t2
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, FIM_SHOT
		#################
		
		la t3, CORD_SHOT
		la a0, shotVer
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		
		li a3, 1
		call PRINT
		
		
		la t1, CHAR_POS
		lh t2, 2(t1)
		la t3, OLD_CORD_SHOT
		lh t4, 2(t3)
		beq t2, t4, SHOT_UP
		la a0, tileP
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		j GAME_LOOP

SHOT_DOWN:      li s3, 4  # instancia SHOT
		la t3, CORD_SHOT
		la t4, OLD_CORD_SHOT
		lh t1, 0(t3) # t1 = X
		sh t1, 0(t4)
		lh t2, 2(t3) # t2 = Y
		sh t2, 2(t4)
		addi t2, t2, 16
		
		
	
		sh t1, 0(t3) 
		sh t2, 2(t3) 
		
		## CHECAGEM COLISAO TIRO
		la a0, mapa4
		addi a0, a0, 8
		add a0, a0, t1
		li t3, 320
		mul t3, t3, t2
		add a0, a0, t3
		lb  t4, 0(a0)
		bne t4, zero, FIM_SHOT
		#################
		
		la t3, CORD_SHOT
		la a0, shotVer
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		
		li a3, 1
		call PRINT
		
		
		la t1, CHAR_POS
		lh t2, 2(t1)
		la t3, OLD_CORD_SHOT
		lh t4, 2(t3)
		beq t2, t4, SHOT_DOWN
		la a0, tileP
		lh a1, 0(t3)
		lh a2, 2(t3)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		j GAME_LOOP
		
	
							

FIM_SHOT: 	mv s3, zero
	  	la t0, OLD_CORD_SHOT
	  	la a0, tileP
	  	lh a1, 0(t0)
	  	lh a2, 2(t0)
	  	li a3, 0
	  	call PRINT
	  	li a3, 1
	  	call PRINT
	  	j GAME_LOOP
	  
	  

	  
		
		
		  
		 
		
		
		

		

		
		

#
#	a0 = endereï¿½o imagem
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



CHAVE_VERMELHA:	# t1 = X t5 = Y
		
		li s6, 1
		la a0, tileA
		mv a1, t1
		mv a2, t5
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		la a0, charL_RED
		mv s2, a0
		la t6, OLD_CHAR_POS
		lh a1, 0(t6)
		lh a2, 2(t6)
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		
		li a0, 70
		li a1, 1000
		li a2, 0
		li a3, 100
		li a7, 31
		ecall
		li a0, 1500
		li a7, 32
		ecall
		
		#COORD_TILE_VERMELHO = (224,160)
		la a0 tile_vermelho
		li a1, 224
		li a2, 160
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
		j REVERSE

		
		

SWITCH_VERMELHO_ESQ:  la a0, charL_RED
		      mv s2, a0
		      li t6, 143
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERMELHO
		      ret
		      
SWITCH_VERMELHO_DIR:  la a0, charR_RED
		      mv s2, a0
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERMELHO
		      ret 		      		      		      

SWITCH_VERMELHO_UP:   la a0, charUP_RED
		      mv s2, a0
		      ret 		    		    
 
SWITCH_VERMELHO_DOWN: la a0, charD_RED
		      mv s2, a0
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERMELHO
		      ret

TESTE_TIRO_RED:	      la t0, charL_RED
		      beq s2, t0, SHOT_ESQ
		
		      la t0, charR_RED
		      beq s2, t0, SHOT_DIR
		
		
		     la t0, charUP_RED
		     beq s2, t0, SHOT_UP
		
		     la t0, charD_RED
		     beq s2, t0, SHOT_DOWN
		     
TESTE_VERMELHO:      la t0, CHAR_POS
		     lh t1, 0(t0)
		     
		     lh t2, 2(t0)
		     li t6, 384
                     add t4, t1, t2
                     beq t6, t4, FIM_VERMELHO
                     ret
                     
FIM_VERMELHO:	     #COORD (224,176)
		     la a0, borda
		     li a1, 224
		     li a2, 176
		     li a3, 0
		     call PRINT
		     li a3, 1
		     call PRINT
		     li s6, 0
		     
		     la a0, charD
		     li a1, 224
		     li a2, 160
		     li a3, 0
		     call PRINT
		     li a3, 1
		     call PRINT
		     mv s2, a0
		     
		     addi s9, s9, -1
		     j GAME_LOOP
		   
CHAVE_VERDE: 	     # t1 = X t5 = Y
		     li s6, 2
		     la a0, tileA
		     mv a1, t5
		     mv a2, t1
		     li a3, 0
                     call PRINT
		     li a3, 1
		     call PRINT
		    
		     
		     la a0, charD_GREEN
		     mv s2, a0
		     la t6, OLD_CHAR_POS
		     lh a1, 0(t6)
		     lh a2, 2(t6)
		     li a3, 0
		     call PRINT
		     li a3, 1
		     call PRINT
		     
		     li a0, 70
		     li a1, 1000
		     li a2, 0
		     li a3, 100
		     li a7, 31
		     ecall
		     li a0, 1500
		     li a7, 32
		     ecall
		     
		     #COORD_TILE_VERMELHO = (208,160)
		     la a0 tile_verde
		     li a1, 208
		     li a2, 160
		     li a3, 0
		     call PRINT
		     li a3, 1
		     call PRINT
		     j REVERSE
		     
SWITCH_VERDE_ESQ:     la a0, charL_GREEN
		      mv s2, a0
		      li t6, 143
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERDE
		      ret
	
SWITCH_VERDE_DIR:     la a0, charR_GREEN
		      mv s2, a0
		      li t6, 143
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERDE
		      ret
		    
SWITCH_VERDE_UP:      la a0, charUP_GREEN
		      mv s2, a0
		      li t6, 143
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERDE
		      ret
		      
SWITCH_VERDE_DOWN:    la a0, charD_GREEN
                      mv s2, a0
                      li t6, 143
		      lh t2, 2(t0)
		      bgt t2, t6, TESTE_VERDE
                      ret
		     
TESTE_VERDE:          la t0, CHAR_POS
		      lh t1, 0(t0)
		     
		      lh t2, 2(t0)
		      li t6, 33280
                      mul t4, t1, t2
                      beq t6, t4, FIM_VERDE
                      ret

FIM_VERDE:            #COORD (208,176)
		      la a0, borda
		      li a1, 208
		      li a2, 176
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      li s6, 0
		     
		      la a0, charD
		      li a1, 208
		      li a2, 160
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      mv s2, a0
		      
		      addi s9, s9, -1
		      j GAME_LOOP		                    
		     	      
FIM_MAPA:             #COORD PORTA (304,144)  (304,160)
		      la a0, tileP
		      li a1, 304
		      li a2, 144
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
		      la a0, tileP
		      li a1, 304
		      li a2, 160
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
		      la t1, OLD_CHAR_POS
		      lh a1, 0(t1)
		      lh a2, 2(t1)
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
LOOP_FINAL:	      la t0, CHAR_POS
		      la t2, OLD_CHAR_POS
		      lh t3, 0(t0)
		      sh t3, 0(t2)
		      lh t3, 2(t0)
		      sh t3, 2(t2)
		     
                      lh t1, 0(t0)
		      addi t1, t1, 16
		      sh t1, 0(t0)
		      
		      la a0, charR
		      xori s0, s0, 1  
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
		      
		      li t6, 288
		      li a0, 100
		      li a7, 32
		      ecall
		      bne a1, t6, LOOP_FINAL
		      
		      
		      
		      		      
END_GAME: 	      #(208,160)
		      la a0, tileP
		      li a1, 208
		      li a2, 160
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
		      
		      
		      #(224,160)
		      la a0, tileP
		      li a1, 224
		      li a2, 160
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
		      
		      
		      #(304,160)
		      la a0, tileP
		      li a1, 304
		      li a2, 160
		      li a3, 0
		      call PRINT
		      li a3, 1
		      call PRINT
		      
	
		      li t0, 0xFF200604
		      li s0, 0
		      sw s0, 0(t0)
		      
		      
		      la a0, vitoria
		      li a1, 0
		      li a2, 0
		      li a3, 1
		      call PRINT
		      
		      xori s0, s0, 1
		      li t0, 0xFF200604
		      sw s0, 0(t0)
		      
		      
		      
KEY_FINAL:            li t1,0xFF200000
		      lw t0,0(t1)
		      andi t0,t0,0x0001
   		      beq t0,zero,KEY_FINAL
  		      lw t2,4(t1)
  		      
  		      li t1, 'r'		      
   		      beq t1, t2, RETRY
   		      
   		      li t1, 'q'
   		      beq t1, t2, QUIT


RETRY:               la t0, CHAR_POS
		     li t1, 16
		     sh t1, 0(t0)
		     li t1, 32
		     sh t1, 2(t0)
		     
		     la t0, OLD_CHAR_POS
		     li t1, 16
		     sh t1, 0(t0)
		     li t1, 32
		     sh t1, 2(t0)
		     
		     la t0, CORD_TIMER
		     li t1, 176
		     sh t1, 0(t0)
		     mv t1, zero
		     sh t1, 2(t0)
		     
		     j SETUP

TIMER:	             mv s8, ra
		     la a0, tile_TIMER
		     la t0, CORD_TIMER
		     lh a1, 0(t0)
		     lh a2, 2(t0)
		     li a3, 0
		     call PRINT
		     li a3, 1
		     call PRINT
		     
		     la t0, CORD_TIMER
		     lh t1, 0(t0)
		     addi t1, t1, -4
		     sh t1, 0(t0)
		     
		     addi s1, s1, -4
		     addi s4, s4, 25
		 
		     jr s8

DERROTA:	      li t0, 0xFF200604
		      li s0, 0
		      sw s0, 0(t0)
		      
		      
		      la a0, derrota
		      li a1, 0
		      li a2, 0
		      li a3, 1
		      call PRINT
		      
		      xori s0, s0, 1
		      li t0, 0xFF200604
		      sw s0, 0(t0)
		      j KEY_FINAL
		      
QUIT:		      li t0, 0xFF200604
		      li s0, 1
		      sw s0, 0(t0)
		      
		      
		      la a0, fundoP
		      li a1, 0
		      li a2, 0
		      li a3, 0
		      call PRINT
		      
		      xori s0, s0, 1
		      li t0, 0xFF200604
		      sw s0, 0(t0)
		      
		      li a7, 10
		      ecall		     
		 
		     
		     
		                 


	      	 
		      
		      
		    		      
		      
