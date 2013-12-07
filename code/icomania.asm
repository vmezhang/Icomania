;------------MACRO-----------
PUSHREG macro 
	push ax
	push bx
	push cx
	push dx
endm

POPREG macro
	pop dx
	pop cx
	pop bx
	pop ax
endm

SHOWSTRING macro opr
	lea si, opr
	call print
endm

SETCORSOR macro ROW,COL
	mov dh,ROW
	mov dl,COL
	mov ah,02H
	int 10H
endm

RESETINPUT macro Ans
	mov Ans[1],0
endm

SETANSRIGHT macro
	mov is_true[0],1
endm

SETANSWRONG macro
	mov is_true[0],2
endm

RESETANSFG macro
	mov is_true[0],2
endm

SETRIGHTANSWER macro Ans
	lea si,Ans
	call setrightans
endm

FLASH_COLOR macro opr1, opr2
	; set font as yellow color
	mov bl, opr1
	call showcolor
	; delay
	call opr2
endm

CONTROL_SHOW macro opr1, opr2, opr3, opr4
	; color set as bl reg
	mov bl, opr1
	mov dl, opr2
	mov dh, opr3
	; show infor type
	mov si, offset opr4
	call control_color
endm

SHOW_SCORE macro opr0, opr1, opr2, opr3, opr4, opr5
	; show score
	CONTROL_SHOW 0eh, 25, 3, opr0
	call delay1
	CONTROL_SHOW 0bh, 31, 6, opr1
	CONTROL_SHOW 0bh, 31, 7, opr2
	CONTROL_SHOW 0bh, 31, 8, opr3
	CONTROL_SHOW 0bh, 31, 9, opr4
	CONTROL_SHOW 0bh, 31, 10, opr5
	call delay1
	; show loading
	call loading
endm

SHOWBM macro b
     LEA DX,b
     MOV AH,9
     INT 21H
endm

ADDRESS macro A,B
     LEA SI,A
     LEA BP,DS:B
endm
;---------END MACRO-----------

;---------CONST---------------
ENTER 				EQU 0DH
BACKSPACE 			EQU 08H
INPUT_CORSOR_ROW 	EQU 17
INPUT_CORSOR_COL 	EQU 26
OPTION_CORSOR_ROW 	EQU 20
OPTION_CORSOR_COL 	EQU 23
RIGHT 				EQU 1H
WRONG 				EQU 2H
DIDAS				EQU 1
;--------END CONST------------

stack segment
		s db 100 (?)
stack ends

data segment
		;-----------------------share data-----------------------
		right_ans db 20,0,20 dup(0)		; right answer
		user_ans  db 20,0,20 dup(0)		; user's input
		is_true	  db 0 					; flag,1-true,2-false
		score     db 0 					; user's score
		ans_opt   db 16,0,16 dup(0)		; available char option for user
		newline	  db 0AH,0DH,'$'		; start with new line
		inputtips db 'Your answer: $'	; input tips
		frequency dw 556,495,556,589,661,742,833,556,589,661,556,589,661,742,495,661
		mus_freg  dw 590,554,522,554,3 dup (590)     ; frequency table
               	  dw 3 dup (554),590,652,652
                  dw 590,554,522,554,3 dup (590)
                  dw 3 dup (554),590,652,652
                  dw 3 dup (554),590,652,652,-1
     	mus_time  dw 6 dup (25),50                   ; beat table
                  dw 2 dup (25,25,50)
                  dw 6 dup (25),50   
                  dw 2 dup (25,25,50)
                  dw 12 dup (25),100
		;---------------------------wel---------------------------
		wel1 db 'x.x.x.x.x.x.x.x.x.x.x.x.x.x$'
		wel2 db '      .-. __ _ .-. $'
		wel3 db '      |  `  / \  | $'
		wel4 db "      /     '.()--\$"
		wel5 db "      |         '._/$"
		wel6 db '     _| O   _   O |_$'
		wel7 db "     =\    '-'    /=$"
		wel8 db "       '-._____.-'$"
		wel9 db ' *oOOo------------------*$' 
		wela db ' |                      |$' 
		welb db ' |     Icomania         |$'
		welc db ' |         come on !    |$' 
		weld db ' |                      |$' 
		wele db ' *------------------oOOo*$'
		welf db 'x.x.x.x.x.x.x.x.x.x.x.x.x.x$'
		
		; 10
		score10 db 'Your score Is : $'  
		score11 db '  #      ###$'
		score12 db '  #     #   #$'
		score13 db '  #     #   #$'
		score14 db '  #     #   #$'
		score15 db '  #      ###$'
		; -------------------------------------
		
		; 20
		score20 db 'Your score Is : $'  
		score21 db '####     ###$'
		score22 db '    #   #   #$'
		score23 db '#####   #   #$'
		score24 db '#       #   #$'
		score25 db ' ####    ###$'
		; -------------------------------------
		
		; 30
		score30 db 'Your score Is : $'  
		score31 db '####     ###$'
		score32 db '    #   #   #$'
		score33 db '#####   #   #$'
		score34 db '    #   #   #$'
		score35 db '####     ###$'
		; -------------------------------------
		
		; 40
		score40 db 'Your score Is : $'  
		score41 db '#   #    ###$'
		score42 db '#   #   #   #$'
		score43 db '#####   #   #$'
		score44 db '    #   #   #$'
		score45 db '    #    ###$'
		; -------------------------------------
		
		; 50
		score50 db 'Your score Is : $'  
		score51 db ' ####    ###$'
		score52 db '#       #   #$'
		score53 db '####    #   #$'
		score54 db '    #   #   #$'
		score55 db '####     ###$'
		; -------------------------------------
		
		; 60
		score60 db 'Your score Is : $'  
		score61 db ' ####    ###$'
		score62 db '#       #   #$'
		score63 db '#####   #   #$'
		score64 db '#   #   #   #$'
		score65 db ' ###     ###$'
		; -------------------------------------
		
		; 70
		score70 db 'Your score Is : $'  
		score71 db '####     ###$'
		score72 db '    #   #   #$'
		score73 db '    #   #   #$'
		score74 db '    #   #   #$'
		score75 db '    #    ###$'
		; -------------------------------------
		
		; 80
		score80 db 'Your score Is : $'  
		score81 db ' ###     ###$'
		score82 db '#   #   #   #$'
		score83 db '#####   #   #$'
		score84 db '#   #   #   #$'
		score85 db ' ###     ###$'
		; -------------------------------------
		
		; 90
		score90 db 'Your score Is : $'  
		score91 db ' ###     ###$'
		score92 db '#   #   #   #$'
		score93 db '#####   #   #$'
		score94 db '    #   #   #$'
		score95 db '####     ###$'
		; -------------------------------------

		inf1 db 'LOADING$'
		inf2 db '> %4$'
		inf3 db '>>>>> %20$'
		inf4 db '>>>>>>>>>> %40$'
		inf5 db '>>>>>>>>>>>>>>> %60$'
		inf6 db '>>>>>>>>>>>>>>>>>>>> %80$'
		inf7 db '>>>>>>>>>>>>>>>>>>>>>>>>> %100$'

		;---------------------------menu---------------------------
		menu1 db 'x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x$'
		menu2 db 's.s.s. *oOOo------------------* .s.s.s$'
		menu3 db 's.s.s. * 1.About game         * .s.s.s$' 
		menu4 db 's.s.s. * 2.Guess animal       * .s.s.s$' 
		menu5 db 's.s.s. * 3.Guess food         * .s.s.s$'
		menu6 db 's.s.s. * 4.Guess other        * .s.s.s$' 
		menu7 db 's.s.s. * 0.Exit               * .s.s.s$'
		menu8 db 's.s.s. *------------------oOOo* .s.s.s$'
		menu9 db 'x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x.x$'
		menua db 'Please choose:  $'
		
		;----------------------about game-------------------------
    	inc1  db '  When entering the game interface, players guess,$'
		inc2  db 'players guess it corresponds to the top of the screen $'
		inc3  db 'displays the English word according to the picture,$'  
    	inc4  db 'since if the guess will be on to the next picture,$'
		inc5  db 'and there will be scores of records;$'
		inc6  db "  If you guessed the game will prompt letters red,$"
		inc7  db 'during the next input, knowing enter the correct date,$'
		inc8  db "Of course, the game also has the use of props,$"
    	inc9  db "if each level you can achieve better results, $"
		inc10 db 'you can get a letter prompt ~ ~ ~ $'
		inc11 db "       --------Enjoy youself!---------"
    	bb    db '                                                 $'
	
    	m11   db "  @..@$" 
    	m12   db " (\--/)$"
    	m13   db "(.>__<.)$"
    	m14   db "^^^  ^^^$"
    	mb    db '                                          $' 
		
		;-----------------------animal---------------------------
		an1_key db "rabbit$"
		an1_1 db "...............................................$"
		an1_2 db " $"
		an1_3 db "               ,-.,-.$"
		an1_4 db "              (  (  ($"    
		an1_5 db "               \  )  ) _..-.._$"
		an1_6 db "              __)/ ,','       `.$"
		an1_7 db "            ,'     `.     ,--.  `.$"     
		an1_8 db "          ,?¡¥   @        .'    `   \$"
		an1_9 db "         (Y            (           ;''.$"
		an1_a db "          `--.____,     \          ,  ;$"
		an1_b db "          ((_ ,----' ,---'      _,'_,'$"
		an1_c db "              (((_,- (((______,-'$"
		an1_d db " $"
		an1_e db " $"
		an1_f db "...............................................$"
		
		an2_key db "lion$"
		an2_1 db "...............................................$"
		an2_2 db " $"
		an2_3 db " $"
		an2_4 db "                            ,%%%%%%%,$"
		an2_5 db "                          ,%%/\%%%%/\%,$"
		an2_6 db "                         ,%%%\c '' J/%%,$"
		an2_7 db "    %.                   %%%%/ d  b \%%%$"
		an2_8 db "    `%%.         __      %%%%    _  |%%%$"
		an2_9 db "     `%%      .-'  `'~-''`%%%%(=_Y_=)%%'  ~~~$"
		an2_a db "      //    .'     `.     `%%%%`\7/%%%'____$"
		an2_b db "     ((    /         ;      `%%%%%%%'____)))$"
		an2_c db "     `.`--'         ,'   _,`-._____`-,$"
		an2_d db " $"
		an2_e db " $"
		an2_f db "...............................................$"
		
		an3_key db "elephant$"
		an3_1 db "...............................................$"
		an3_2 db "                ___     _,.--.,_$"
		an3_3 db "             .-~   ~--'~-.   ._ '-.$"  
		an3_4 db "            /      ./_    Y    '-. \$" 
		an3_5 db "           Y       :~     !         Y$" 
		an3_6 db "           lq p    |     /         .|$" 
		an3_7 db "        _   \. .-, l    /          |j$"
		an3_8 db "       ()\___) |/   \_/';          !$"
		an3_9 db "        \._____.-~\  .  ~\.      ./$"
		an3_a db "                   Y_ Y_. 'vr'~  T$"
		an3_b db "                   (  (    |L    j$" 
		an3_c db "                   [nn[nn..][nn..]$"
		an3_d db "               ~~~~~~~~~~~~~~~~~~~~~~~$"
		an3_e db "        $"
		an3_f db "...............................................$"
		
		;-----------------------food--------------------------- 
		food1_key db "cake$"
		food1_1 db "...............................................$"
		food1_2 db "         $"
		food1_3 db "                    _,-.$"
		food1_4 db "                  .' _  \$"
		food1_5 db "               ,'  (_)  \_$"
		food1_6 db "            _.-|`-._      \''--._$"
		food1_7 db "          .' .-(=._ `-._   \''-. `.$"
		food1_8 db "         /  /  |   `=.  `-._\   \  \$"
		food1_9 db "        |  |    `-._  `=._  | .  |  |$"
		food1_a db "         \  \  ;' .,`--._ `=| ' /  /$"
		food1_b db "          `._``--..._____`--'-''_.'$"
		food1_c db "             `--.._________..--'$"
		food1_d db "         $"
		food1_e db "         $"
		food1_f db "...............................................$"
		
		food2_key db "cherry$"
		food2_1 db "...............................................$"
		food2_2 db "         $"
		food2_3 db "         $"
		food2_4 db "           __.--~~.,-.__$"
		food2_5 db "           `~-._.-(`-.__`-.$"
		food2_6 db "                   \    `~~'$"
		food2_7 db "              .--./ \$"
		food2_8 db "             /#   \  \.--.$"
		food2_9 db "             \    /  /#   \$"
		food2_a db "              '--'   \    /$"
		food2_b db "                      '--'$"
		food2_c db "         $"
		food2_d db "         $"
		food2_e db "         $"
		food2_f db "...............................................$"
		
		food3_key db "bread$"
		food3_1 db "...............................................$"
		food3_2 db "         $"
		food3_3 db "         $"
		food3_4 db "         $"
		food3_5 db "            _______$"
		food3_6 db "           /       )$"
		food3_7 db "          /_____   | ______$"
		food3_8 db "         (  '   ) / /    __\   _____$"
		food3_9 db "          |.  '| / |     \ |  /     ))$"
		food3_a db "          |____|/  |`-----'  /_____))$"
		food3_b db "                    `-----'  `------'$"
		food3_c db "         $"
		food3_d db "         $"
		food3_e db "         $"
		food3_f db "...............................................$"

		;-----------------------other--------------------------- 
		other1_key db "snoopy$"
		other1_1 db "...............................................$"
		other1_2 db "                    .----.$"
		other1_3 db "                 _.'__    `.$" 
		other1_4 db "             .--(#)(##)---/#\$"
		other1_5 db "           .' @          /###\$"
		other1_6 db "           :         ,   #####$"
		other1_7 db "            `-..__.-' _.-\###/$"
		other1_8 db "                  `;_:    `''$"
		other1_9 db "                .''''''`.$"
		other1_a db "               /,       ,\$"
		other1_b db "              //         \\$"
		other1_c db "              `-._______.-'$"
		other1_d db "              ___`. | .'___$"
		other1_e db "             (______|______)$"
		other1_f db "...............................................$"
		
		other2_key db "christmas$"
		other2_1 db "...............................................$"
		other2_2 db "           /`   `'.$"
		other2_3 db "          /   _..---;$"
		other2_4 db "          |  /__..._/  .--.-.$"
		other2_5 db "          |.'  e e | ___\_|/____$"
		other2_6 db "         (_)'--.o.--|    | |    |$"
		other2_7 db "        .-( `-' = `-|____| |____|$"
		other2_8 db "       /  (         |____   ____|$"
		other2_9 db "       |   (        |_   | |  __|$"
		other2_a db "       |    '-.--';/'/__ | | (  `|$"
		other2_b db "       |      '.   \    )'';--`\ /$"
		other2_c db "       \        ;   |--'    `;.-'$"
		other2_d db "       |`-.__ ..-'--'`;..--'`$"
		other2_e db " $"
		other2_f db "...............................................$"
		
		other3_key db "doctor$"
		other3_1 db "...............................................$"
		other3_2 db "                     .odbo.$"
		other3_3 db "                 .od88888888bo.$" 
		other3_4 db "             .od8888888888888888bo.$" 
		other3_5 db "         .od888888888888888888888888bo.$" 
		other3_6 db "      od88888888888888888888888888888888bo$" 
		other3_7 db "       `~888888888888888888888888888888~'$"
		other3_8 db "          `~888888888888888888888888~'|$"
		other3_9 db "             `~888888888888888888~'   |$"
		other3_a db "               |`~888888888888~'|     |$"
		other3_b db "               \   `~888888~'   /     A$"
		other3_c db "                `-_   `~~'   _-'      H$"
		other3_d db "                   `--____--'$"
		other3_e db "       $"
		other3_f db "...............................................$"
data ends

code segment
		assume cs:code, ds:data, ss:stack
start:
		mov ax, data
		mov ds, ax
		mov ax, stack
		mov ss, ax
		call welcome
		ADDRESS mus_freg, mus_time
     	call music

		mov ah, 01h 	;press any key to menu
		int 21h
		;call key_music
select:        
		call menu
		; choose
		mov ah, 01h
		int 21H
		call key_music

		cmp al, '1'
		jz about
		cmp al, '2'
		jz animal
		cmp al, '3'
		jz food
		cmp al, '4'
		jz other
		cmp al, '0'
		jz exit
		jmp select

about:        
		call dis_us
		mov ah, 01h
		int 21h
		jmp select
		
animal:   
		call play_an1
		call load
		call play_an2
		call load
		call play_an3
		call load
		jmp select
		
food:        
		call play_fo1
		call load
		call play_fo2
		call load
		call play_fo3
		call load
		jmp select
		
other:        
		call play_ot1
		call load
		call play_ot2
		call load
		call play_ot3
		call load
		
		jmp select

exit:
		call clear_screen
		mov ah, 4ch
		int 21h

;-------------Welcome--------------
welcome proc near
		; set cursor
		mov dh, 2
		mov dl, 23
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING wel1
		mov bl, 0bh        	 ; set color
		SHOWSTRING wel2
		SHOWSTRING wel3
		SHOWSTRING wel4
		SHOWSTRING wel5
		SHOWSTRING wel6
		SHOWSTRING wel7
		SHOWSTRING wel8
		SHOWSTRING wel9
		SHOWSTRING wela
		SHOWSTRING welb
		SHOWSTRING welc
		SHOWSTRING weld
		SHOWSTRING wele
		mov bl, 1110b        ; yellow color
		SHOWSTRING welf
		ret
welcome endp

;-------------Menu--------------
menu proc near
		; set cursor
		mov dh, 4
		mov dl, 18
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING menu1
		mov bl, 0bh          ; set color
		SHOWSTRING menu2
		SHOWSTRING menu3
		SHOWSTRING menu4
		SHOWSTRING menu5
		SHOWSTRING menu6
		SHOWSTRING menu7
		SHOWSTRING menu8
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING menu9
		mov bl, 0bh          ; set color
		SHOWSTRING menua
		ret
menu endp

;-------------game parts---------------
play_an1 proc
	PUSHREG
	call dis_an1
	call showoption
an1_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz an1_ans_wrong	; wrong answer
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score	; compute score

	POPREG
	ret
an1_ans_wrong:
	call flash
	jmp an1_go	
play_an1 endp

play_an2 proc
	PUSHREG
	call dis_an2
	call showoption
an2_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz an2_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
an2_ans_wrong:
	call flash
	jmp an2_go	
play_an2 endp

play_an3 proc
	PUSHREG
	call dis_an3
	call showoption
an3_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz an3_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
an3_ans_wrong:
	call flash
	jmp an3_go
play_an3 endp

play_fo1 proc
	PUSHREG
	call dis_fo1
	call showoption
fo1_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz fo1_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
fo1_ans_wrong:
	call flash
	jmp fo1_go
play_fo1 endp

play_fo2 proc
	PUSHREG
	call dis_fo2
	call showoption
fo2_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz fo2_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
fo2_ans_wrong:
	call flash
	jmp fo2_go
play_fo2 endp

play_fo3 proc
	PUSHREG
	call dis_fo3
	call showoption
fo3_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz fo3_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
fo3_ans_wrong:
	call flash
	jmp fo3_go
play_fo3 endp

play_ot1 proc
	PUSHREG
	call dis_ot1
	call showoption
ot1_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz ot1_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
ot1_ans_wrong:
	call flash
	jmp ot1_go
play_ot1 endp

play_ot2 proc
	PUSHREG
	call dis_ot2
	call showoption
ot2_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz ot2_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
ot2_ans_wrong:
	call flash
	jmp ot2_go
play_ot2 endp

play_ot3 proc
	PUSHREG
	call dis_ot3
	call showoption
ot3_go:
	call user_input
	call judge

	mov al,is_true[0]
	cmp al,RIGHT
	jnz ot3_ans_wrong
	
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	call compute_score

	POPREG
	ret
ot3_ans_wrong:
	call flash
	jmp ot3_go
play_ot3 endp

;-------------game parts proc----------
; show about us
dis_us proc near
	; set cursor
	mov dh, 7
	mov dl, 18
	mov bh, 0
	mov ah, 2
	int 10h
	call clear_screen
	mov bl, 1110b        	; set font as yellow color
	call show_introduce
	ret
dis_us endp

; show pic an1
dis_an1 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING an1_1
		SHOWSTRING an1_2
		SHOWSTRING an1_3
		SHOWSTRING an1_4
		SHOWSTRING an1_5
		SHOWSTRING an1_6
		SHOWSTRING an1_7
		SHOWSTRING an1_8
		SHOWSTRING an1_9
		SHOWSTRING an1_a
		SHOWSTRING an1_b
		SHOWSTRING an1_c
		SHOWSTRING an1_d
		SHOWSTRING an1_e
		SHOWSTRING an1_f
		mov bl, 0bh         ; set color
		SETRIGHTANSWER an1_key
		ret
dis_an1 endp

; show pic an2
dis_an2 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING an2_1
		SHOWSTRING an2_2
		SHOWSTRING an2_3
		SHOWSTRING an2_4
		SHOWSTRING an2_5
		SHOWSTRING an2_6
		SHOWSTRING an2_7
		SHOWSTRING an2_8
		SHOWSTRING an2_9
		SHOWSTRING an2_a
		SHOWSTRING an2_b
		SHOWSTRING an2_c
		SHOWSTRING an2_d
		SHOWSTRING an2_e
		SHOWSTRING an2_f
		mov bl, 0bh         ; set color
		SETRIGHTANSWER an2_key
		ret
dis_an2 endp

; show pic an3
dis_an3 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING an3_1
		SHOWSTRING an3_2
		SHOWSTRING an3_3
		SHOWSTRING an3_4
		SHOWSTRING an3_5
		SHOWSTRING an3_6
		SHOWSTRING an3_7
		SHOWSTRING an3_8
		SHOWSTRING an3_9
		SHOWSTRING an3_a
		SHOWSTRING an3_b
		SHOWSTRING an3_c
		SHOWSTRING an3_d
		SHOWSTRING an3_e
		SHOWSTRING an3_f
		mov bl, 0bh         ; set color
		SETRIGHTANSWER an3_key
		ret
dis_an3 endp

; show pic fo1
dis_fo1 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING food1_1
		SHOWSTRING food1_2
		SHOWSTRING food1_3
		SHOWSTRING food1_4
		SHOWSTRING food1_5
		SHOWSTRING food1_6
		SHOWSTRING food1_7
		SHOWSTRING food1_8
		SHOWSTRING food1_9
		SHOWSTRING food1_a
		SHOWSTRING food1_b
		SHOWSTRING food1_c
		SHOWSTRING food1_d
		SHOWSTRING food1_e
		SHOWSTRING food1_f
		mov bl, 0bh         ; set color
		SETRIGHTANSWER food1_key
		ret
dis_fo1 endp

; show pic fo2
dis_fo2 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING food2_1
		SHOWSTRING food2_2
		SHOWSTRING food2_3
		SHOWSTRING food2_4
		SHOWSTRING food2_5
		SHOWSTRING food2_6
		SHOWSTRING food2_7
		SHOWSTRING food2_8
		SHOWSTRING food2_9
		SHOWSTRING food2_a
		SHOWSTRING food2_b
		SHOWSTRING food2_c
		SHOWSTRING food2_d
		SHOWSTRING food2_e
		SHOWSTRING food2_f
		mov bl, 0bh        ; set color
		SETRIGHTANSWER food2_key
		ret
dis_fo2 endp

; show pic fo3
dis_fo3 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING food3_1
		SHOWSTRING food3_2
		SHOWSTRING food3_3
		SHOWSTRING food3_4
		SHOWSTRING food3_5
		SHOWSTRING food3_6
		SHOWSTRING food3_7
		SHOWSTRING food3_8
		SHOWSTRING food3_9
		SHOWSTRING food3_a
		SHOWSTRING food3_b
		SHOWSTRING food3_c
		SHOWSTRING food3_d
		SHOWSTRING food3_e
		SHOWSTRING food3_f
		mov bl, 0bh        ; set color
		SETRIGHTANSWER food3_key
		ret
dis_fo3 endp

; show pic ot1
dis_ot1 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING other1_1
		SHOWSTRING other1_2
		SHOWSTRING other1_3
		SHOWSTRING other1_4
		SHOWSTRING other1_5
		SHOWSTRING other1_6
		SHOWSTRING other1_7
		SHOWSTRING other1_8
		SHOWSTRING other1_9
		SHOWSTRING other1_a
		SHOWSTRING other1_b
		SHOWSTRING other1_c
		SHOWSTRING other1_d
		SHOWSTRING other1_e
		SHOWSTRING other1_f
		mov bl, 0bh        ; set color
		SETRIGHTANSWER other1_key
		ret
dis_ot1 endp

; show pic ot2
dis_ot2 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING other2_1
		SHOWSTRING other2_2
		SHOWSTRING other2_3
		SHOWSTRING other2_4
		SHOWSTRING other2_5
		SHOWSTRING other2_6
		SHOWSTRING other2_7
		SHOWSTRING other2_8
		SHOWSTRING other2_9
		SHOWSTRING other2_a
		SHOWSTRING other2_b
		SHOWSTRING other2_c
		SHOWSTRING other2_d
		SHOWSTRING other2_e
		SHOWSTRING other2_f
		mov bl, 0bh        ; set color
		SETRIGHTANSWER other2_key
		ret
dis_ot2 endp

; show pic ot3
dis_ot3 proc near
		; set cursor
		mov dh, 0
		mov dl, 16
		mov bh, 0
		mov ah, 2
		int 10h
		call clear_screen
		mov bl, 1110b        ; set font as yellow color
		SHOWSTRING other3_1
		SHOWSTRING other3_2
		SHOWSTRING other3_3
		SHOWSTRING other3_4
		SHOWSTRING other3_5
		SHOWSTRING other3_6
		SHOWSTRING other3_7
		SHOWSTRING other3_8
		SHOWSTRING other3_9
		SHOWSTRING other3_a
		SHOWSTRING other3_b
		SHOWSTRING other3_c
		SHOWSTRING other3_d
		SHOWSTRING other3_e
		SHOWSTRING other3_f
		mov bl, 0bh        ; set color
		SETRIGHTANSWER other3_key
		ret
dis_ot3 endp

;-------------Clear Screen---------------
clear_screen proc near
		push ax
		push bx
		push cx
		push dx
			 
		mov ah, 06h
		mov al, 0   
		mov ch, 0   
		mov cl, 0   
		mov dh, 24  
		mov dl, 79  
		mov bh, 7  
		int 10h
		pop dx
		pop cx
		pop bx
		pop ax
		ret
clear_screen  endp
 
;--------------Print String------------
print proc near
		inc dh
		push dx
		push cx                
pnext:
		inc dl
		mov bh, 0
		mov ah, 02
		int 10h
		; show the char that si reg point to
		mov al, [si]
		mov bh, 0
		mov cx, 1
		mov ah, 09h
		int 10h        
		inc si
		cmp byte ptr [si], '$'
		jnz pnext
		pop cx
		pop dx                
		ret
print endp

;-------------Check Answer----------
judge proc near
	PUSHREG
	; reset is_true
	RESETANSFG

	lea si,right_ans
	lea di,user_ans

	xor cx,cx
	mov cl,right_ans[1]
	add cl,1
cmp_lop:
	mov ah,byte ptr [si+1]
	mov al,byte ptr [di+1]
	cmp ah,al
	jnz false
	inc si
	inc di
	loop cmp_lop
true:
	SETANSRIGHT
	jmp exit_judge
false:
	SETANSWRONG
	jmp exit_judge
exit_judge:
	POPREG
	ret
judge endp

;------------User Input-------------
user_input proc
	PUSHREG
new_input:
	;RESETANSFG
	call show_input_line
	; reset user_ans
	RESETINPUT user_ans

	lea bx,right_ans
	xor cx,cx
	mov cl,[bx+1]

	lea bx,user_ans
	mov si,0
	mov ch,0
lop_input:
	xor ax,ax
	mov ah,07H			; input,doesn't print char on screen
	int 21H
	
	cmp al,BACKSPACE	; press the Backspace key
	jz new_input

	cmp al,ENTER		; press the Enter key
	jz user_input_exit

	cmp al,'a'
	jb lop_input
	cmp al,'z'
	ja lop_input

	call key_music
	push ax
	mov dl,al 			; print char
	mov ah,02H
	int 21H

	mov ah,14
	mov al,' '
	mov bh,0
	int 10H
	pop ax

	; save the input
	mov byte ptr [bx+2+si],al
	inc ch
	mov byte ptr [bx+1],ch
	inc si

	cmp cl,ch
	jnz lop_input
user_input_exit:
	POPREG
	ret
user_input endp

;--------Set Right Answer--------------
setrightans proc
	PUSHREG
	mov cl,0
	mov di,0
set_loop:
	mov al,byte ptr [si]
	mov right_ans[di+2],al
	inc cl
	inc si
	inc di
	cmp al,'$'
	jnz set_loop

	dec cl
	mov right_ans[1],cl

	POPREG
	ret
setrightans endp

;------------Compute Score¬---------------
compute_score proc
	PUSHREG
	mov bx,offset score
	add byte ptr [bx],10
	POPREG
	ret
compute_score endp

;------------Show Input Line--------
show_input_line proc
	PUSHREG

	SETCORSOR INPUT_CORSOR_ROW,INPUT_CORSOR_COL

	mov dx,offset inputtips
	mov ah,09H
	int 21H

	lea bx,right_ans
	xor cx,cx
	mov cl,byte ptr [bx+1]
repet:
	mov dl,'_'
	mov ah,02H
	int 21H

	mov dl,' '
	mov ah,02H
	int 21H
	loop repet

	SETCORSOR INPUT_CORSOR_ROW,INPUT_CORSOR_COL+13

	POPREG
	ret
show_input_line endp

;------Color Control----------
showcolor proc near
	mov cl,right_ans[1]
	mov bh,0
	mov dh,INPUT_CORSOR_ROW
	mov dl,INPUT_CORSOR_COL+13-2
color:
	push cx
	mov dh,INPUT_CORSOR_ROW	; set cursor
	add dl,2
	mov ah,2
	int 10H
	
	mov ah,08 	; get char on the cursor
	int 10H

	mov cx,1 	; print char with new color
	mov ah,09
	int 10H

	pop cx
	dec cl
	jnz color
	ret
showcolor endp

;-------Flash Control--------
flash proc near
	; white
	FLASH_COLOR 0111b, delay1
	
	; black
	FLASH_COLOR 0000b, delay2
	
	; red
	FLASH_COLOR 1100b, delay1
	
	; black
	FLASH_COLOR 0000b, delay2
	
	; red
	FLASH_COLOR 1100b, delay1
	
	; black
	FLASH_COLOR 0000b, delay2
	
	; red
	FLASH_COLOR 1100b, delay1
	
	; black
	FLASH_COLOR 0000b, delay2
	
	; white
	FLASH_COLOR 0111b, delay1
	
	ret
flash endp

;---------delay 1--------
delay1 proc near
	push cx
	push bx
	mov bx, 1fffh
w1:
	mov cx, 07000h
w2:
	loop w2
	dec bx
	jnz w1
	pop bx
	pop cx
	
	ret	
delay1 endp

;---------delay 2------------
delay2 proc near
	push cx
	push bx
	mov bx, 1fffh
wait3:
	mov cx, 010ffh
wait4:
	loop wait4
	dec bx
	jnz wait3
	pop bx
	pop cx
	
	ret
delay2 endp

;--------Show Option---------
showoption proc
	PUSHREG

	call setopt
	; set cursor
	SETCORSOR OPTION_CORSOR_ROW,OPTION_CORSOR_COL
	; show
	lea si,ans_opt[2]

	mov cx,16
print_lop:
	mov dl,byte ptr [si]
	mov ah,02H
	int 21H

	mov dl,' '
	mov ah,02H
	int 21H
	inc si
	loop print_lop

	POPREG
	ret
showoption endp

;-------Print Options---------
setopt proc
	PUSHREG

	; reset ans_opt
	lea bx,ans_opt[2]
	mov si,bx
	mov cx,16
reset_lop:
	mov byte ptr [si],0
	inc si
	loop reset_lop
	
	lea si,right_ans[2]
	lea di,ans_opt[2]

	; arrange right answer
	xor cx,cx
	mov cl,right_ans[1]
set_rightans_opt:
	mov dl,byte ptr [si]
	sub dl,20H
reproduce:
	xor bx,bx
	call randnum

	cmp byte ptr [di+bx],0
	jnz reproduce			; not find avaiable position,find again

	; arrange the random char
	mov byte ptr [di+bx],dl
	inc si
	loop set_rightans_opt

	; arrange the random char
	mov cx,16
set_rand_opt:

	cmp byte ptr [di],0
	jnz p_next

	call randchar
	mov byte ptr [di],bl
p_next:
	inc di
	loop set_rand_opt
	
	POPREG
	ret
setopt endp

;---------Rand Number Producer-------
; the result with 0-15,saved in bl reg
randnum proc
	push ax
	push cx
	push dx

	or bl,30H
	call rand

	mov al,bl
	mul bl
	and ax,01F0H
	mov cl,4
	shr ax,cl

	mov dl,10H
	div dl
	mov bl,ah

	pop dx
	pop cx
	pop ax
	ret
randnum endp

;----------Rand Char Producer-------
; the result with a-z,saved in bl reg
randchar proc
	push ax
	push cx
	push dx

	or bl,30H
	call rand

	mov al,bl
	mul bl
	and ax,01F0H
	mov cl,4
	shr ax,cl

	mov dl,26
	div dl
	mov dl,ah
	add dl,41H
	mov bl,dl

	pop dx
	pop cx
	pop ax
	ret
randchar endp

;---------Random Producer----------
; the result with 0-100,saved in bl reg
rand proc 
	push ax
	push cx
	push dx

	sti
	mov ah,0
	int 1AH

	mov ax,dx
	and ah,3
	mov dl,101
	div dl
	mov bl,ah 

	call delay2
	pop dx
	pop cx
	pop ax
	ret
rand endp

;---------Show Loading process---
load proc
	PUSHREG
	call clear_screen
	mov bl,score[0]
	cmp bl,10
	jz score_10_jmp
	jmp cmp_20
score_10_jmp:
	SHOW_SCORE score10, score11, score12, score13, score14, score15
	POPREG
	ret
cmp_20:
	cmp bl,20
	jz score_20_jmp
	jmp cmp_30
score_20_jmp:
	SHOW_SCORE score20, score21, score22, score23, score24, score25
	POPREG
	ret
cmp_30:
	cmp bl,30
	jz score_30_jmp
	jmp cmp_40
score_30_jmp:
	SHOW_SCORE score30, score31, score32, score33, score34, score35
	POPREG
	ret
cmp_40:
	cmp bl,40
	jz score_40_jmp
	jmp cmp_50
score_40_jmp:
	SHOW_SCORE score40, score41, score42, score43, score44, score45
	POPREG
	ret
cmp_50:
	cmp bl,50
	jz score_50_jmp
	jmp cmp_60
score_50_jmp:
	SHOW_SCORE score50, score51, score52, score53, score54, score55
	POPREG
	ret
cmp_60:
	cmp bl,60
	jz score_60_jmp
	jmp cmp_70
score_60_jmp:
	SHOW_SCORE score60, score61, score62, score63, score64, score65
	POPREG
	ret
cmp_70:
	cmp bl,70
	jz score_70_jmp
	jmp cmp_80
score_70_jmp:
	SHOW_SCORE score70, score71, score72, score73, score74, score75
	POPREG
	ret
cmp_80:
	cmp bl,80
	jz score_80_jmp
	jmp cmp_90
score_80_jmp:
	SHOW_SCORE score80, score81, score82, score83, score84, score85
	POPREG
	ret
cmp_90:
	cmp bl,90
	jz score_90_jmp
score_90_jmp:
	SHOW_SCORE score90, score91, score92, score93, score94, score95
	POPREG
	ret
load endp

;--------loading control-----------
loading proc near
	; show green LOADING
	CONTROL_SHOW 1010b, 34, 15, inf1
	call delay1
	
	; show processing line 4%~100%
	CONTROL_SHOW 0eh, 25, 17, inf2
	call delay1
	call delay1
	CONTROL_SHOW 0eh, 25, 17, inf3
	call delay1
	call delay1
	CONTROL_SHOW 0eh, 25, 17, inf4
	call delay1
	call delay1
	CONTROL_SHOW 0eh, 25, 17, inf5
	call delay1
	call delay1
	CONTROL_SHOW 0eh, 25, 17, inf6
	call delay1
	call delay1
	CONTROL_SHOW 0eh, 25, 17, inf7
	call delay_1
	call delay_1
	call delay_1
	call delay_1
	
	; press any key to continue
	;mov ah, 01h
	;int 21h
	
	ret
loading endp

;--------Color Control------------
control_color proc near    
	mov di, 0
color_1: 
	inc dl
	mov ah, 2
	int 10h 
	
	mov ah, 09
	mov al, [si]
	inc si
	mov bh, 0
	mov cx, 01
	int 10h
	cmp byte ptr[si], '$'
	jne color_1
	ret
control_color endp

;----Play sound when key pressed--------
key_music proc near
    push ax
    push bx
    push si
    cmp al,'1'
    jb exitw
    cmp al,'9'
    jbe make_sound

    cmp al,  'a' 
    jb  exitw
    cmp al,  'z'
    ja  exitw  
make_sound:
    and al, 0fh 
    shl al, 1 
    mov bl, al 
    lea si, frequency[bx]         
    call musick   
exitw:
pop si
    pop bx
    pop ax
    ret
key_music endp

;--------play pressed key sound-------
musick proc near 
   push ax 
   push cx 
   push dx 

   in al, 61h 
   or al, 3 
   out 61h, al 

   mov al, 0b6h 
   out 43h, al 
   mov dx, 12h 
   mov ax, 348ch 
   div word ptr [si] 
   out 42h, al 

   mov al, ah 
   out 42h, al 

   in al, 61h 
   mov ah, al 
   or al, 3 
   out 61h, al 

   mov cx, 3314 
   push ax 
@waitf1: 
   in al, 61h 
   and al, 10h 
   cmp al, ah 
   jz @Waitf1 
   mov ah, al 
   loop @Waitf1 
   pop ax 
   call delay2 
   mov al, ah 
   out 61h, al 

   pop dx 
   pop cx 
   pop ax 
   out 61h, al 
   ret 
musick endp 

;--------Background music-------------
gensound proc near
     push ax
     push bx
     push cx
     push dx
     push di

     mov al, 0b6H
     out 43h, al
     mov dx, 12h
     mov ax, 348ch
     div di
     out 42h, al

     mov al, ah
     out 42h, al

     in al, 61h
     mov ah, al
     or al, 3
     out 61h, al
wait1:
     mov cx, 3390
     call waitf
;d1:
     dec bx
     jnz wait1

     mov al, ah
     out 61h, al

     pop di
     pop dx
     pop cx
     pop bx
     pop ax
     ret 
gensound endp

;--------Used in gensound proc--------
waitf proc near
      push ax
waitf1:
      in al,61h
      and al,10h
      cmp al,ah
      je waitf1
      mov ah,al
      loop waitf1
      pop ax
      ret
waitf endp

;---------Music Interface-------
music proc near
      xor ax, ax
freg:
      mov di, [si]
      cmp di, 0FFFFH
      je end_mus
      mov bx, ds:[bp]
      call delay_1
      call gensound
      add si, 2
      add bp, 2
      jmp freg
end_mus:
      ret
music endp

;---------delay_1--------
delay_1 proc near
  push cx
  push bx
  mov bx, 1fffh
wait_1:
  mov cx, 700h
wait_2:
  loop wait_2
  dec bx
  jnz wait_1
  pop bx
  pop cx
  ret 
delay_1 endp

;-----Show about game---------
show_introduce proc near
	PUSHREG
	mov dh, 4       
	mov dl, 23
	mov bh, 0
	mov ah, 2
	int 10h

	mov bl, 1110b       
	call clear_screen
	SHOWSTRING inc1
	call show_frog
	call delay1

	SHOWSTRING inc2
	call hide_frog
	call delay1

	SHOWSTRING inc3
	call show_frog
	call delay1

	SHOWSTRING inc4
	call hide_frog
	call delay1

	SHOWSTRING inc5
	call show_frog
	call delay1

	SHOWSTRING inc6
	call hide_frog
	call delay1

	SHOWSTRING inc7
	call show_frog
	call delay1

	SHOWSTRING inc8
	call hide_frog
	call delay1

	SHOWSTRING inc9
	call show_frog
	call delay1

	SHOWSTRING inc10
	call hide_frog
	call delay1

	SHOWSTRING inc11
	call show_frog
	call delay1
	POPREG
	ret
show_introduce endp

;--------Show Forg----------------
show_frog proc near
    push dx
    push bx
    push ax

    mov dh, 15       
	mov dl, 2
	mov bh, 0
	mov ah, 2
	int 10h
	mov bl, 0bh        
	SHOWSTRING m11	
	SHOWSTRING m12
	SHOWSTRING m13
	SHOWSTRING m14

	pop ax
	pop bx
	pop dx
	ret 
show_frog endp

;----------Hide Frog---------------
hide_frog proc near
	PUSHREG
	push si
	mov bh, 0
 	mov bl, 0bh
	mov ah, 11
	int 10h
	mov cx, 8
	mov dh, 15
	mov dl, 2                                
hidebc1:
	lea si, mb
	call print
	loop hidebc1
	pop si
	POPREG
	ret	
hide_frog endp

code ends
		end start