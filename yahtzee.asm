TITLE Program Template     (template.asm)

; Program Description:Yahtzee game
; Author:Ahmet KAYA-Burak BALTA
; Date Created:22.05.2015
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

string1 BYTE "Welcome to yahtzee game ",0
string BYTE "Order            ",0
string2 BYTE "Combination     ",0
string3 BYTE "Score           ",0
string4 BYTE "Ones            ",0
string5 BYTE "Twos            ",0
string6 BYTE "Threes          ",0
string7 BYTE "Fours           ",0
string8 BYTE "Fives           ",0
string9 BYTE "Sixes           ",0
string10 BYTE "3 of a kind     ",0
string11 BYTE "4 of a kind     ",0
string12 BYTE "Yahtzee         ",0
string13 BYTE "4 in a row      ",0
string14 BYTE "5 in a row      ",0
string15 BYTE "Anything        ",0
string16 BYTE "Die 1 :",0
string17 BYTE "Die 2 :",0
string18 BYTE "Die 3 :",0
string19 BYTE "Die 4 :",0
string20 BYTE "Die 5 :",0
string21 BYTE "Press enter to roll the dice ",0
string22 BYTE "Do you want to reroll the dice?(y|n|Y|N)",0
string23 BYTE "please press enter",0
string24 BYTE "please enter right character(y|Y|n|N)",0
string25 BYTE "How many dice do you want to reroll?",0
string26 BYTE "Which ones?",0
string27 BYTE "Choose the place that you want to fill:",0
string28 BYTE "this place has already filled.Please try to fill free one.",0
string29 BYTE "YOUR TOTAL SCORE :",0
string30 BYTE "Wrong input ...",0

order DWORD 12 dup(0)
score DWORD 12 dup(0)
dice  DWORD 5  dup(0)
count DWORD 1
count2 DWORD 0
control BYTE 12 dup(1)
sorteddice DWORD 5 dup(0)
dice2 DWORD 5 dup(0)
oness DWORD 0
twoss DWORD 0
threess DWORD 0
fourss DWORD 0
fivess DWORD 0
sixess DWORD 0
check BYTE 0
check2 BYTE 0
check3 BYTE 0
dicecheck DWORD 4 dup(0)
cntr DWORD 0




.code
main PROC

mov edx,offset string1 ; print welcome
call writestring
call crlf
call printscore ;print scoreboard  

l8:
  cmp count2,12 ;check whether game is over or not
  je l20    
  
  
  mov edx,offset string21  ;print preess enter to roll
  call writeString
  call readchar
  call crlf

  cmp al,13     ;check whether user press enter or not
  je l9
  mov edx,offset string23 ;if user do not press enter print error message
  call writeString
  call crlf
  jmp l8
  
  
l9:
   
   call rollDice ;roll the dice with random numbers

   call crlf
   

l10:
   cmp count,3 ; check number of the rerolling dice 
   jge l12
   mov edx,offset string22 ;print do you want to change the dice
   call writeString
   call readchar
   call crlf
   
   cmp al,89  ;ascýý code of  y
   je l11      ;check then if user press y or Y,program jumps l11 label
   cmp al,121 ;ascýý code of Y
   je l11

   cmp al,78 ;ascýý code of n
   je l12      ;check then if user press n or N,program jump l12 label
   cmp al,110 ;ascýý code of N
   je l12

   mov edx,offset string24 ;if user press none of them(y,Y,n,N),print error message 
   call writeString
   call crlf
   jmp l10





l11:
    inc count     ;increment count that is represenet number of the rolling dice
    call Randomize
  lW:
    mov edx,offset string25 ;print how many dice do you want to reroll?
    call writeString
    call readint   ;get an input from user
    cmp eax,0   ;check whether input is equal or less than or not 
    jle LF
    cmp eax,5 ;check whether input is grater than 5 or not
    jg LF
    jmp LR 
    LF:
       mov edx,offset string30 ;if input does not  exist between 1 and 5,print error message
       call writeString ;print wrong input
       call crlf
       jmp lW
    LR:  
    cmp eax,5 ;if input equals five,program does not want the number of the dice,directly all of dice is rolled
    jne l50
    call rollDice
    call crlf
    jmp l10
 l50:    
    
     mov edi,eax
  lr2:
     mov edx,offset string26 ;if input does nor equal 5,ask which dice is rerolled
     call writeString ;print which ones?
    
    l51:
       cmp edi,0
       jle l52
       
        mov eax,6
        call RandomRange
        inc eax
        mov esi,eax
        mov eax,0
        call checksame ;check whether  same dice number is entered or not 
        cmp eax,0
        jle lw1      ;check input control
        cmp eax,5
        jg lw1
        jmp lr3
      lw1:
          mov edx,offset string30 ;print wrong input
          call writeString
          call crlf
          jmp lr2
          
      lr3:
        mov ebx,eax
        dec ebx
        shl ebx,2
        mov dice[ebx],esi   ;new random number on dice which is wanted from user 
        mov eax,dice[ebx]
        dec edi
        jmp l51
    
     
    l52:
      mov edx,0
      mov ecx,4
      WHLS:
        mov dicecheck[edx],0
        add edx,type dicecheck
        loop WHLS
         mov cntr,0
      call crlf
      call printdice  ;print with new value of dice
      jmp l10
    

l12:
    mov eax,0
   lr6:
    mov edx,offset string27  
    call writeString  ;print  chhose the place that user want to fill 
    call readint
    cmp eax,0
    jle lw4         ;again input control,input shoul be 1-12 inclusively
    cmp eax,12   
    jg lw4
    jmp lr5
 lw4:
    mov edx,offset string30 
    call writeString     ;print wrong input 
    call crlf
    jmp lr6
   lr5:

    mov count,1 ;
    cmp eax,1
    jne l53
  
     cmp control[0],1 ;check whether  place of ones is filled or not 
     jne l54
     add count2,1
     call ones
     call printscore  
     jmp l8
    l54:
      mov edx,offset string28 ;if filled
      call writeString  ;print error message 
      call crlf
      jmp l12

   l53:
      cmp eax,2
      jne l55
      cmp control[1],1
      jne l56
      add count2,1
      call twos
      call printscore
      jmp l8
     l56:
      mov edx,offset string28
      call writeString
      call crlf
      jmp l12
    
   
    l55:
      cmp eax,3
      jne l57
      cmp control[2],1
      jne l58
      add count2,1
      call threes
      call printscore
      jmp l8
     l58:
      mov edx,offset string28
      call writeString
      call crlf
      jmp l12

    
    l57:
      cmp eax,4
      jne l59
      cmp control[3],1
      jne l60
      add count2,1
      call fours
      call printscore
      jmp l8
     l60:
      mov edx,offset string28
      call writeString
      call crlf
      jmp l12
      
    
    l59:
      cmp eax,5
      jne l61
      cmp control[4],1
      jne l62
      add count2,1
      call fives
      call printscore
      jmp l8
     l62:
       mov edx,offset string28
       call writeString
       call crlf
       jmp l12
    
    l61:
      cmp eax,6
      jne l63
      cmp control[5],1
      jne l64
      add count2,1
      call sixes
      call printscore
      jmp l8
     l64:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12
       
 
    l63:
      cmp eax,7
      jne l65
      cmp control[6],1
      jne l66
      add count2,1
      call threekind
      call printscore
      jmp l8
     l66:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12

    l65:
      cmp eax,8
      jne l67
      cmp control[7],1
      jne l68
      add count2,1
      call fourkind
      call printscore
      jmp l8
     l68:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12

    l67:
      cmp eax,9
      jne l69
      cmp control[8],1
      jne l70
      add count2,1
      call yahtzee

      call printscore
      jmp l8
     l70:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12
          
    l69:
      cmp eax,10
      jne l71
      cmp control[9],1
      jne l72
      add count2,1
      call fourrow

      call printscore
      jmp l8
     l72:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12
     

    l71:
      cmp eax,11
      jne l73
      cmp control[10],1
      jne l74
      add count2,1
      call fiverow

      call printscore
      jmp l8
     l74:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12
      

   l73:
     cmp eax,12
      jne l20
      cmp control[11],1
      jne l76
      add count2,1
      call anything

      call printscore
      jmp l8
     l76:
        mov edx,offset string28
        call writeString
        call crlf
        jmp l12
   
    
     
     

l20: 
   call crlf
   mov edi,0
   mov esi,0
   mov eax,0
  l77:
    cmp edi,12
    jge l75
    add eax,score[esi] ;calculate total score en of the program
    add edi,1
    add esi,type score
    jmp l77
  l75:
     mov edx,offset string29
     call writeString  ;print your total score end of the program
     call writedec    ;print total score from eax



   
   
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;rollDice proc rolls the all dice
rollDice PROC
    mov edi,0
    call Randomize
    mov edx,offset string16 ;print die 1 :
    call writeString
                  
    mov  eax,6                 
    call RandomRange
    inc eax
    call writedec 
    mov dice[edi],eax
    add edi,type dice
    call crlf

    mov edx,offset string17 ;print die 2 :
    call writeString
                   
    mov  eax,6                  
    call RandomRange
    inc eax
    call writedec
    mov dice[edi],eax
    add edi,type dice
    call crlf

    mov edx,offset string18 ;print die 3 :
    call writeString
                  
    mov  eax,6                 
    call RandomRange
    inc eax
    call writedec
    mov dice[edi],eax
    add edi,type dice
    call crlf

    mov edx,offset string19 ;print die 4
    call writeString
                
    mov  eax,6                  
    call RandomRange
    inc eax
    call writedec
    mov dice[edi],eax
    add edi,type dice
    call crlf
    
    mov edx,offset string20 ;print die 5 :
    call writeString
                  
    mov  eax,6                  
    call RandomRange
    inc eax
    call writedec
    mov dice[edi],eax   ;get the number to dice array
    add edi,type dice
    call crlf
   
    ret

rollDice ENDP

;printdice proc prints all dice after rerolling process
printdice PROC
   mov esi,0
   mov eax,0
   mov edx,offset string16
   call writestring
   mov eax,dice[esi]
   call writedec
   add esi,type dice
   call crlf

   mov edx,offset string17
   call writestring
   mov eax,dice[esi]
   call writedec
   add esi,type dice
   call crlf

   mov edx,offset string18
   call writestring
   mov eax,dice[esi]
   call writedec
   add esi,type dice
   call crlf

   mov edx,offset string19
   call writestring
   mov eax,dice[esi]
   call writedec
   add esi,type dice
   call crlf

   mov edx,offset string20
   call writestring
   mov eax,dice[esi]
   call writedec
   add esi,type dice
   call crlf
   
   ret

printdice ENDP

;ones proc calculate number of the 1's on dice and write place of one 
ones PROC
  mov control[0],0  ;sign as place of one is filled
  mov edi,5
  mov esi,0
  mov edx,0 
  mov ecx,5
  l78:
    cmp edi,0
    jle l79
    cmp dice[esi],1
    jne l80
    add edx,1
   l80:
     add esi,type dice
     add edi,-1
     loop l78
  l79:
    dec eax
    mov ebx,eax
    mov score[ebx],edx ;get the score to score array

  ret
ones ENDP

;twos proc calculate number of the 2's on dice,calculates the score  and write place of two 
twos PROC
    mov control[1],0 ;sign as place of two is filled
    mov edi,5
    mov esi,0
    mov edx,0
    mov ecx,5

    l81:
      cmp edi,0
      jle l82
      cmp dice[esi],2
      jne l83
      add edx,1
     l83:
       add esi,type dice 
       add edi,-1
       loop l81
     l82:
       dec eax
       mov ebx,eax
       shl ebx,2
       shl edx,1
       mov score[ebx],edx

   ret
twos ENDP


;threes proc calculate number of the 3's on dice,calculates score and write place of three 
threes PROC
   mov control[2],0 ;sign as place of three is filled
   mov edi,5
   mov esi,0
   mov edx,0
   mov ecx,5

   l84:
     cmp edi,0
     jle l85
     cmp dice[esi],3
     jne l86
     add edx,1
    l86:
      add esi,type dice
      add edi,-1
      loop l84

    l85:
       
       dec eax
       mov ebx,eax
       shl ebx,2
       imul edx,3
       mov score[ebx],edx

   ret
threes ENDP


;fours proc calculate number of the 4's on dice,calculates score and write place of four 
fours PROC
   mov control[3],0 ;sign as place of three is filled
   mov edi,5
   mov esi,0
   mov edx,0
   mov ecx,5

   l87:
      cmp edi,0
      jle l88 
      cmp dice[esi],4
      jne l89
      add edx,1
     l89:
       add esi,type dice
       add edi,-1
       loop l87
   
    l88:      
       dec eax
       mov ebx,eax
       shl ebx,2
       imul edx,4
       mov score[ebx],edx
   

   ret
fours ENDP

;fives proc calculate number of the 5's on dice,calculate score  and write place of five
fives PROC
   mov control[4],0 ;sign as place of three is filled
   mov edi,5
   mov esi,0
   mov edx,0
   mov ecx,5

   l90:
      cmp edi,0
      jle l91
      cmp dice[esi],5
      jne l92
      add edx,1
     l92:
       add esi,type dice
       add edi,-1
       loop l90
   
   l91:
      dec eax
      mov ebx,eax
      shl ebx,2
      imul edx,5
      mov score[ebx],edx

   ret
fives ENDP

;sixes proc calculate number of the 6's on dice,calculates score and write place of six 
sixes PROC
   mov control[5],0 ;sign as place of six is filled
   mov edi,5
   mov esi,0
   mov edx,0
   mov ecx,5

   l93:
     cmp edi,0
     jle l94
     cmp dice[esi],6
     jne l95
     add edx,1
    l95:
       add esi,type dice
       add edi,-1
       loop l93

    l94:
        dec eax
        mov ebx,eax
        shl ebx,2
        imul edx,6
        mov score[ebx],edx
   

   ret
sixes ENDP

;if three of a kind situation exists,calculate the score and write score array in place of threekind
threekind PROC
  mov control[6],0 ;sign as place of threekind  is filled
  call pairs  ;according to output of this proc,determine whether  three of a kind situation is exist or not
  dec eax
  mov ebx,eax
  shl ebx,2
   
  cmp check3,3
  jl l96
   mov check3,0
   mov edx,0
   mov ecx,5
   mov edi,0
   mov esi,0
  l98:
   cmp edi,5
   jge l97
      add edx,dice[esi]
      add esi,type dice
      add edi,1
      loop l98
   l97:
      mov score[ebx],edx
      jmp l103
  l96:
     mov score[ebx],0
  l103:
  ret

threekind ENDP

;if four of a kind situation exists,calculate the score and write score array in place of fourkind
fourkind PROC 
  
  mov control[7],0 ;sign as place of fourkind is filled
  call pairs  ;according to output of this proc,determine whether  four of a kind situation is exist or not
  dec eax
  mov ebx,eax
  shl ebx,2

  l99:
     cmp check3,6
     jl l100
     mov check3,0
     mov edx,0
     mov ecx,5
     mov edi,0
     mov esi,0
   l101:
      cmp edi,5
      jge l102
      add edx,dice[esi]
      add esi,type dice
      add edi,1
      loop l101
     l102:
        mov score[ebx],edx
        jmp l104
  l100:
      mov score[ebx],0

  l104:
 ret

fourkind ENDP

;check whether yahtzee situation exists or not,if exists score set as 50 
yahtzee PROC
   mov control[8],0 ;sign as place of yahtzee is filled
   mov edx,dice[0]
   mov edi,5
   mov esi,0
   mov ecx,0
    
   WHLE:
   cmp edx,dice[esi]
   je L1
   jmp L2
   L1:
   add ecx,1
   L2:
   add esi,type dice
   add edi,-1
   cmp edi,0
   jg WHLE

   dec eax
   mov ebx,eax
   shl ebx,2
   
   cmp ecx,5
   je L3
   jmp L4
   L3:
   mov score[ebx],50
   L4:
 
   ret
yahtzee ENDP

;if four in a row situation exist score will be set as 20
fourrow PROC
   mov control[9],0 ;sign as place of fourrow is filled
   dec eax
   mov ebx,eax
   shl ebx,2

  call numbers  ;according to output of this proc determine whether four in a row situation exists or not 
  ;mov cl,check
  cmp check,1
  je LS
  jmp LN
  LS:
  mov score[ebx],20
  jmp LB 
  LN:
  mov score[ebx],0
  LB:
   
  ret

fourrow ENDP 
 
;if five in a row situation exist score will be set as 30
fiverow PROC
  mov control[10],0 ;sign as place of fiverow is filled
  dec eax
  mov ebx,eax
  shl ebx,2

  call numbers  ;according to output of this proc determine whether four in a row situation exists or not
  mov cl,check2
  cmp cl,1
  je LS
  jmp LN
  LS:
  mov score[ebx],30
  jmp LB 
  LN:
  mov score[ebx],0
  LB:

  
  
  ret
  
fiverow ENDP
;this proc adds value of all dice and set to place of anything
anything PROC
  mov control[11],0 ;sign as place of anthing is filled
  dec eax
  mov ebx,eax
  shl ebx,2

  mov ecx,0
  mov edi,0
  mov esi,0
  WHLE:
  add ecx,dice[esi]
  add esi,type dice
  add edi,1
  cmp edi,5
  jl WHLE

  mov score[ebx],ecx

  ret

anything ENDP


;this proc prints score board  starting of the program and after updating score part
printscore PROC
   mov edx,offset string
   call writestring
   mov al,9h
   call writechar

   mov edx,offset string2
   call writestring
   call writechar

   mov edx,offset string3
   call writestring
   call crlf
   mov edx,offset string15
   push edx
   mov edx,offset string14
   push edx
   mov edx,offset string13
   push edx
   mov edx,offset string12
   push edx
   mov edx,offset string11
   push edx
   mov edx,offset string10
   push edx
   mov edx,offset string9
   push edx
   mov edx,offset string8
   push edx
   mov edx,offset string7
   push edx
   mov edx,offset string6
   push edx
   mov edx,offset string5
   push edx
   mov edx,offset string4
   push edx

   mov ebx,1
   mov edi,0
   mov ecx,12

   l1:
      mov order[edi],ebx
      mov eax,order[edi]
      call writedec
      mov al,9h
      call writechar
      mov al,9h
      call writechar
      mov al,9h
      call writechar
      pop edx
      call writestring
      mov al,9h
      call writechar
   
   
      mov eax,score[edi]
      call writedec
      add edi,type score
      inc ebx
      call crlf
      loop l1 
   
   call crlf
 
   ret
   
printscore ENDP


;determine whether  four in row and five in a row situations exists or not 
numbers PROC 
  mov ecx,0
  mov oness,ecx
  mov twoss,ecx
  mov threess,ecx
  mov fourss,ecx
  mov fivess,ecx
  mov sixess,ecx

  mov edi,0
  mov esi,0
  WHLE: ;.WHILE edi < 5
    
   cmp dice[esi],1 
   je L1           
   jmp LA1
   L1:
   inc oness        
   LA1:

   cmp dice[esi],2 
   je L2           
   jmp LA2
   L2:
   inc twoss        
   LA2:
  
   cmp dice[esi],3 
   je L3           
   jmp LA3
   L3:
   LA3:

  
   
   cmp dice[esi],4 
   je L4           
   jmp LA4
   L4:
   inc fourss        
   LA4:

   

   cmp dice[esi],5 
   je L5          
   jmp LA5
   L5:
   inc fivess        
   LA5:

   
   cmp dice[esi],6 
   je L6          
   jmp LA6
   L6:
   inc  sixess       
   LA6:
  

   inc edi
   add esi,type dice
   cmp edi,5
   jl WHLE
   
   
   mov ecx,oness
   cmp ecx,0
   jg LGO1
   jmp LAS1
   LGO1:
   mov ecx,twoss
   cmp ecx,0
   jg LGT1
   jmp LAS1
   LGT1:
   mov ecx,threess
   cmp ecx,0
   jg LGTH1
   jmp LAS1
   LGTH1:
   mov ecx,fourss
   cmp ecx,0
   jg LGF1
   jmp LAS1
   LGF1:
   mov check,1
   LAS1:
   ;.IF oness > 0 && twoss > 0 && threess > 0 && fourss > 0
   ; mov check,1
   ;.ENDIF

   mov ecx,fivess
   cmp ecx,0
   jg LGO2
   jmp LAS2
   LGO2:
   mov ecx,twoss
   cmp ecx,0
   jg LGT2
   jmp LAS2
   LGT2:
   mov ecx,threess
   cmp ecx,0
   jg LGTH2
   jmp LAS2
   LGTH2:
   mov ecx,fourss
   cmp ecx,0
   jg LGF2
   jmp LAS2
   LGF2:
   mov check,1
   LAS2:

   ;.IF fivess > 0 && twoss > 0 && threess > 0 && fourss > 0
   ; mov check,1
   ;.ENDIF
   mov ecx,fivess
   cmp ecx,0
   jg LGO3
   jmp LAS3
   LGO3:
   mov ecx,sixess
   cmp ecx,0
   jg LGT3
   jmp LAS3
   LGT3:
   mov ecx,threess
   cmp ecx,0
   jg LGTH3
   jmp LAS3
   LGTH3:
   mov ecx,fourss
   cmp ecx,0
   jg LGF3
   jmp LAS3
   LGF3:
   mov check,1
   LAS3:

   ;.IF fivess > 0 && sixess > 0 && threess > 0 && fourss > 0
   ;mov check,1
   ;.ENDIF
   
   mov ecx,oness
   cmp ecx,1
   je LGO4
   jmp LAS4
   LGO4:
   mov ecx,twoss
   cmp ecx,1
   je LGT4
   jmp LAS4
   LGT4:
   mov ecx,threess
   cmp ecx,1
   je LGTH4
   jmp LAS4
   LGTH4:
   mov ecx,fourss
   cmp ecx,1
   je LGF4
   jmp LAS4
   LGF4:
   mov ecx,fivess
   cmp ecx,1
   je LGFI4
   jmp LAS4
   LGFI4:
   mov check2,1
   LAS4:

;   .IF oness == 1 && twoss == 1 && threess == 1 && fourss == 1 && fivess == 1
 ;   mov check2,1
  ; .ENDIF
   
    mov ecx,sixess
   cmp ecx,1
   je LGO5
   jmp LAS5
   LGO5:
   mov ecx,twoss
   cmp ecx,1
   je LGT5
   jmp LAS5
   LGT5:
   mov ecx,threess
   cmp ecx,1
   je LGTH5
   jmp LAS5
   LGTH5:
   mov ecx,fourss
   cmp ecx,1
   je LGF5
   jmp LAS5
   LGF5:
   mov ecx,fivess
   cmp ecx,1
   je LGFI5
   jmp LAS5
   LGFI5:
   mov check2,1
   LAS5:

   ;.IF sixess == 1 && twoss == 1 && threess == 1 && fourss == 1 && fivess == 1
    ;mov check2,1
   ;.ENDIF

   ret

numbers ENDP

;determine whether  four in a kind and three in a kind situations exists or not 
pairs PROC
  mov check3,0
  mov esi,0 
  mov edi,0
  WHLE1:   	
cmp esi,0	
jne L1	
jmp LA1	
L1:	
mov ecx,dice[0]	
cmp ecx,dice[esi]	
je LADD	
jmp LA1	
LADD:	
add check3,1	
LA1:
    cmp esi,0
	jne L2	
jmp LA2	
L2:	
cmp esi,4	
jne L3	
jmp LA2
L3:	
mov ebx,dice[4]	
cmp ebx,dice[esi]	
je LES2	
jmp LA2	
LES2:	
add check3,1	
LA2:	
        cmp esi,4
	jne L4	
jmp LA3	
L4:	
cmp esi,8	
jne L5	
jmp LA3	
L5:	
mov ebx,dice[8]	
cmp ebx,dice[esi]	
je LES3	
jmp LA3	
LES3:	
add check3,1	
LA3:
       cmp esi,8	
jne L6	
jmp LA4	
L6:	
cmp esi,12	
jne L7	
jmp LA4	
L7:	
mov ebx,dice[12]	
cmp ebx,dice[esi]	
je LES4	
jmp LA4	
LES4:	
add check3,1	
LA4:
   add esi,type dice
   cmp esi,20   
   jl WHLE1
 ret
pairs ENDP


checksame PROC
L2:
call readint
mov edx,0
mov ecx,4
WHLE:
  
  cmp eax,dicecheck[edx] 
  je L3
  jmp L4
  L3:
  push edx
  mov edx,offset string30
  call writestring
  pop edx
  jmp L2
  L4:
  add edx, type dicecheck
  loop WHLE
  mov edx,cntr
  mov dicecheck[edx],eax
  add cntr, type dicecheck
 ret

checksame ENDP
  
END main


