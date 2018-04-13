.model tiny
org 100h

.data
;P1 variable
P1size dw 3
P1X db 25,25,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
P1Y db 10,11,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
nextMoveP1 db 25,10
directionP1 db 'w'        


;P2 variable
P2size dw 3
P2X db 50,50,50,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
P2Y db 12,11,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
nextMoveP2 db 50,12
directionP2 db '5'

c db 0

.code

setup:
    ;set text mode 80 x 25
    mov ax ,@data
    mov ds ,ax
    mov ah ,00h         
    mov al ,03h
    int 10h  

    

main:

;mp c,4
;   jne out
;   inc P1size
;   out:
;   inc c

    call getDirection
    call getNextMove
    call moveP1
    call printSnakeP1
    call moveP2
    call printSnakeP2
    

    jmp main
    
    
    
    
    
    
    
    
;==============================================
;                   FUNCTION
;==============================================

;w(119)a(97)s(115)d(100) | 8(56)4(52)5(53)6(54)   
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
    mov dh, 0      ;set row (y)
    mov dl, 0     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,0ah
    mov al ,directionP1
    mov bh ,00h
    mov bl ,00h
    mov cx ,1
    int 10h
    
    mov dh, 0      ;set row (y)
    mov dl, 1     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,0ah
    mov al ,directionP2
    mov bh ,00h
    mov bl ,00h
    mov cx ,1
    int 10h
    
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
    mov ah,0ah
    mov al ,'H'
    mov bh ,00h
    mov bl ,00h
    mov cx ,1
    int 10h
    
    ;print Body to old head
    ;set curser positon
    mov dh, [P1Y+1]      ;set row (y)
    mov dl, [P1X+1]     ;set col (x)
    mov bh, 00h
    mov ah, 02h
    int 10h 
    
    ;print O
    mov ah,0ah
    mov al ,'B'
    mov bh ,00h
    mov bl ,00h
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
    
    ;print O
    mov ah,0ah
    mov al ,' '
    mov bh ,00h
    mov bl ,00h
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
    mov ah,0ah
    mov al ,'H'
    mov bh ,00h
    mov bl ,00h
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
    mov ah,0ah
    mov al ,'B'
    mov bh ,00h
    mov bl ,00h
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
    mov ah,0ah
    mov al ,' '
    mov bh ,00h
    mov bl ,00h
    mov cx ,1
    int 10h
    
    ret
    
    
end setup