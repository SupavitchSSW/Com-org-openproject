.model tiny
org 100h

.data
;P1 variable
P1size dw 3
P1X db 25,25,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
P1Y db 14,15,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
nextMoveP1 db 25,14
directionP1 db 'w'        


;P2 variable
P2size dw 3
P2X db 50,50,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
P2Y db 10,9,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
nextMoveP2 db 50,10
directionP2 db '5'

c db 0
foodPos db 0,0
foodSpawn db 0
.code

setup:
    ;set text mode 80 x 25
    mov ax ,@data
    mov ds ,ax
    mov ah ,00h         
    mov al ,03h
    int 10h  
    
    ;hide cursor
    mov ch, 32
    mov ah, 1       
    int 10h
    
    call createWall

main:
    mov cx,0FFFFh
    delayloop:
    nop
    nop
    nop
    loop delayloop


    call createFood
    call getDirection
    call getNextMove
    call checkMoveP1
    call moveP1
    call printSnakeP1
    call checkMoveP2
    call moveP2
    call printSnakeP2
    

    jmp main
    
    
    
    
    
    
    
    
;==============================================
;                   FUNCTION
;==============================================

createFood:
    ;delay spawn time
    cmp foodSpawn,10
    je IFcreateFoodOUT
    inc foodSpawn
    ret
    IFcreateFoodOUT:
    mov foodSpawn,0
    
    ;get time sec->dh
    mov ah,2ch
    int 21h

    ;time + x % 78 +1 (1...79) 
    add [foodPos],dh        ;time + x
    mov dx, 0               ;mod
    mov al,[foodPos]        ;mod
    mov bx,78               ;mod
    div bx                  ;x % 78
    mov [foodPos],dl        ;x = mod
    add [foodPos],1         ;x + 1
    
    ;x + y % 22 +1 (1...23) 
    mov al,[foodPos]        
    add [foodPos+1],al      ;x + y
    mov dx, 0               ;mod
    mov al,[foodPos+1]      ;mod
    mov bx,22               ;mod
    div bx                  ;y % 22
    mov [foodPos+1],dl      ;y = mod
    add [foodPos+1],1       ;y + 1

    ;set curser positon
    mov dh, [foodPos+1]      ;set row (y)
    mov dl, [foodPos]        ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    ;print f
    mov ah,09h
    mov al,'F'
    mov bl,0Eh
    mov cx,1
    int 10h

    ret

createWall:
    ;print top
    mov dh, 0      ;set row (y)
    mov dl, 0     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    mov ah,09h
    mov al,'X'
    mov bl,07h
    mov cx,80
    int 10h
    
    ;print botton
    mov dh, 24      ;set row (y)
    mov dl, 0     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    mov ah,09h
    mov al,'X'
    mov bl,07h
    mov cx,80
    int 10h
    
    ;print left
    mov dh,0 ;y
    mov dl,0 ;x
    mov cx,25
    L1createWall:
    push cx
    ;set pos
    mov bh, 00h
    mov ah, 02h
    int 10h 
    ;print W
    mov ah,09h
    mov al,'X'
    mov bl,07h
    mov cx,1
    int 10h
    inc dh
    pop cx
    loop L1createWall
    
    ;print right
    mov dh,0 ;y
    mov dl,79 ;x
    mov cx,25
    L2createWall:
    push cx
    ;set pos
    mov bh, 00h
    mov ah, 02h
    int 10h 
    ;print W
    mov ah,09h
    mov al,'X'
    mov bl,07h
    mov cx,1
    int 10h
    inc dh
    pop cx
    loop L2createWall
    
    ret


getDirection:
    mov ah,0Bh              ;check input buffer
    int 21h
    cmp al,00h              ;if keypress
    jne IF1getDirectionOUT
    ret                     ;else return
    IF1getDirectionOUT:
    
    mov ah,7                ;get input to al
    int 21h
    
    ;P1
    cmp al,'w'              ;if input == w
    jne IFWgetDirectionOUT
    cmp directionP1,'s'     ;if directionP1 != s
    je IFWgetDirectionOUT
    mov directionP1,'w'     ;directionP1 = w
    IFWgetDirectionOUT:
    
    cmp al,'a'              ;if input == a
    jne IFAgetDirectionOUT
    cmp directionP1,'d'     ;if directionP1 != d
    je IFAgetDirectionOUT
    mov directionP1,'a'     ;directionP1 = w
    IFAgetDirectionOUT:
    
    cmp al,'s'              ;if input == s
    jne IFSgetDirectionOUT
    cmp directionP1,'w'     ;if directionP1 != w
    je IFSgetDirectionOUT
    mov directionP1,'s'     ;directionP1 = s
    IFSgetDirectionOUT:
    
    cmp al,'d'              ;if input == d
    jne IFDgetDirectionOUT
    cmp directionP1,'a'     ;if directionP1 != a
    je IFDgetDirectionOUT
    mov directionP1,'d'     ;directionP1 = d
    IFDgetDirectionOUT:
    
    ;P2
    cmp al,'8'              ;if input == 8
    jne IF8getDirectionOUT
    cmp directionP2,'5'     ;if directionP1 != 5
    je IF8getDirectionOUT
    mov directionP2,'8'     ;directionP1 = 8
    IF8getDirectionOUT:
    
    cmp al,'4'              ;if input == 4
    jne IF4getDirectionOUT
    cmp directionP2,'6'     ;if directionP1 != 6
    je IF4getDirectionOUT
    mov directionP2,'4'     ;directionP1 = 4
    IF4getDirectionOUT:
    
    cmp al,'5'              ;if input == 5
    jne IF5getDirectionOUT
    cmp directionP2,'8'     ;if directionP1 != 8
    je IF5getDirectionOUT
    mov directionP2,'5'     ;directionP1 = 5
    IF5getDirectionOUT:
    
    cmp al,'6'              ;if input == 6
    jne IF6getDirectionOUT
    cmp directionP2,'4'     ;if directionP1 != 4
    je IF6getDirectionOUT
    mov directionP2,'6'     ;directionP1 = 6
    IF6getDirectionOUT:
    ret
    

getNextMove:
    
    ;P1
    cmp directionP1,'w'         ;if directionP1 == w
    jne IFWgetNextMoveOUT
    dec [nextMoveP1+1]          ;y--
    IFWgetNextMoveOUT:

    cmp directionP1,'a'         ;if directionP1 == a
    jne IFAgetNextMoveOUT
    dec [nextMoveP1]            ;x--
    IFAgetNextMoveOUT:
    
    cmp directionP1,'s'         ;if directionP1 == s
    jne IFSgetNextMoveOUT
    inc [nextMoveP1+1]          ;y++
    IFSgetNextMoveOUT:
    
    cmp directionP1,'d'         ;if directionP1 == d
    jne IFDgetNextMoveOUT
    inc [nextMoveP1]            ;x++
    IFDgetNextMoveOUT:
    
    ;P2
    cmp directionP2,'8'         ;if directionP1 == 8
    jne IF8getNextMoveOUT
    dec [nextMoveP2+1]          ;y--
    IF8getNextMoveOUT:

    cmp directionP2,'4'         ;if directionP1 == 4
    jne IF4getNextMoveOUT
    dec [nextMoveP2]            ;x--
    IF4getNextMoveOUT:
    
    cmp directionP2,'5'         ;if directionP1 == 5
    jne IF5getNextMoveOUT
    inc [nextMoveP2+1]          ;y++
    IF5getNextMoveOUT:
    
    cmp directionP2,'6'         ;if directionP1 == 6
    jne IF6getNextMoveOUT
    inc [nextMoveP2]            ;x++
    IF6getNextMoveOUT:
  
    ret

;nextMove,X,Y,size
moveP1:
    mov ah ,[nextMoveP1]      ;x
    mov al ,[nextMoveP1+1]    ;y
    mov cx,P1size
    mov si,0 
    LmoveP1:
        xchg ah,[P1X+si] 
        xchg al,[P1Y+si]
        inc si
        loop LmoveP1
    mov si,0    
    ret

moveP2:  
    mov ah ,[nextMoveP2]      ;x
    mov al ,[nextMoveP2+1]    ;y
    mov cx,P2size
    mov si,0 
    LmoveP2:
        xchg ah,[P2X+si] 
        xchg al,[P2Y+si]
        inc si
        loop LmoveP2
    mov si,0    
    ret

;print new H | B on old H | del T
;X,T,size
printSnakeP1:
    ;print Head
    ;set curser positon
    mov dh, [P1Y]      ;set row (y)
    mov dl, [P1X]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,09h
    mov al,'O'
    mov bl,0Bh
    mov cx,1
    int 10h
    
    ;print Body to old head
    ;set curser positon
    mov dh, [P1Y+1]      ;set row (y)
    mov dl, [P1X+1]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,09h
    mov al ,'O'
    mov bl ,3
    mov cx ,1
    int 10h
    
    mov si,P1size
    dec si
    ;set curser positon
    mov dh, [P1Y+si]      ;set row (y)
    mov dl, [P1X+si]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print tail
    mov ah,9h
    mov al ,' '
    mov bl ,0
    mov cx ,1
    int 10h
    
    ret
    
printSnakeP2:
    ;print Head
    ;set curser positon
    mov dh, [P2Y]      ;set row (y)
    mov dl, [P2X]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,9h
    mov al ,'O'
    mov bl ,0Ch
    mov cx ,1
    int 10h
    
    ;print Body to old head
    ;set curser positon
    mov dh, [P2Y+1]      ;set row (y)
    mov dl, [P2X+1]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,9h
    mov al ,'O'
    mov bl ,4
    mov cx ,1
    int 10h
    
    mov si,P2size
    dec si
    ;set curser positon
    mov dh, [P2Y+si]      ;set row (y)
    mov dl, [P2X+si]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,9h
    mov al ,' '
    mov bl ,0
    mov cx ,1
    int 10h
    
    ret
    
checkMoveP1:
    ;set curser positon
    mov dh, [nextMoveP1+1]      ;set row (y)
    mov dl, [nextMoveP1]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;read char at nextMove to al
    mov ah,08h
    int 10h
    
    cmp ah,0ch                  ;if nextmove == headP2
    je draw
    cmp ah,4                  ;if nextmove == bodyP2
    je P1_lost
    cmp ah,3                  ;if nextmove == bodyP1`
    je P1_lost
    cmp al,'X'                  ;if nextmove == wall
    je p1_lost                  
    cmp al,'F'                  ;if nextmove == food
    jne IFFoodcheckMoveP1       
    inc P1size                  ;inc size
    IFFoodcheckMoveP1:
    ret
    
checkMoveP2:
    ;set curser positon
    mov dh, [nextMoveP2+1]      ;set row (y)
    mov dl, [nextMoveP2]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;read char at nextMove to al
    mov ah,08h
    int 10h
    
    cmp ah,0Bh                  ;if nextmove == headP1
    je draw
    cmp ah,3                  ;if nextmove == bodyP1
    je P2_lost
    cmp ah,4                  ;if nextmove == bodyP2`
    je P2_lost
    cmp al,'X'                  ;if nextmove == wall
    je p2_lost                  
    cmp al,'F'                  ;if nextmove == food
    jne IFFoodcheckMoveP2       
    inc P2size                  ;inc size
    IFFoodcheckMoveP2:
    ret
    
    
draw:
P1_lost:
P2_lost:

    
end setup