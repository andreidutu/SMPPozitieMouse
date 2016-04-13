org 100h
;Macro print cu 4 parametrii
print macro x, y, attrib, sdat
LOCAL   s_dcl, skip_dcl, s_dcl_end ; folosim local pentru a nu avea erori in cod de tipul duplicat
    pusha
    mov dx, cs
    mov es, dx
    mov ah, 13h
    mov al, 1
    mov bh, 0
    mov bl, attrib
    mov cx, offset s_dcl_end - offset s_dcl
    mov dl, x ; pune in dl valoarea lui X
    mov dh, y ; pune in dh valoarea lui y
    mov bp, offset s_dcl
    int 10h ; apel de rutina
    popa
    jmp skip_dcl ; jump la sfarsit pentru a iesii din macro
    s_dcl DB sdat ; declarare variabila
    s_dcl_end DB 0 ; declarare variabila
    skip_dcl:    
endm

curatare_ecran macro
    pusha ; face push in coada in ordinea asta AX CX DX BX SP BP SI DI
    mov ax, 0600h
    mov bh, 0000_1111b
    mov cx, 0 ; iteratorul
    mov dh, 24 ; rand
    mov dl, 79 ; coloana
    int 10h ; apel de rutina
    popa ; reverse la push a in ordine inversa
endm

print_space macro num
    pusha ; face push in coada in ordinea asta AX CX DX BX SP BP SI DI
    mov ah, 9
    mov al, ' '
    mov bl, 0000_1111b
    mov cx, num
    int 10h ; apel de rutina
    popa ; reverse la push a in ordine inversa
endm


jmp start

curX dw 0 ; declarare
curY dw 0 ; declarare
curB dw 0 ; declarare


start:
mov ax, 1003h ;  dezactive licarire mouse 
mov bx, 0        
int 10h

; hide text cursor:
mov ch, 32
mov ah, 1
int 10h


; reset mouse and get its status:
mov ax, 0
int 33h
cmp ax, 0
jne ok
print 1,1,0010_1110b, " Nu e mouse :O "
jmp stop

ok:
curatare_ecran

print 7,9,0010_1010b," Poti incerca si modul external -> RUN                "
print 13,11,0011_1111b," Pentru a inchie aplicatia apasa ambele click-uri deodata"

; display mouse cursor:
mov ax, 1
int 33h

verifica_cerere_iesire:
mov ax, 3
int 33h
cmp bx, 3  ; both buttons
je  hide
cmp cx, curX
jne print_xy
cmp dx, curY
jne print_xy
cmp bx, curB
jne print_buttons


print_xy:
print 0,0,0000_1111b,"x="
mov ax, cx
call print_ax
print_space 4
print 0,1,0000_1111b,"y="
mov ax, dx
call print_ax
print_space 4
mov curX, cx
mov curY, dx
jmp verifica_cerere_iesire

print_buttons:
print 0,2,0000_1111b,"btn="
mov ax, bx
call print_ax
print_space 4
mov curB, bx
jmp verifica_cerere_iesire



hide:
mov ax, 2  ; ascunde cursorul mouse-ului
int 33h

curatare_ecran

print 1,1,1010_0000b," hardware must be free!      elibereaza mouse-ul "

stop:
mov ah, 1
mov ch, 0
mov cl, 8
int 10h

print 4,7,0000_1010b," press any key.... "
mov ah, 0
int 16h

ret


print_ax proc
cmp ax, 0
jne print_ax_r
    push ax
    mov al, '0'
    mov ah, 0eh
    int 10h
    pop ax
    ret 
print_ax_r:
    pusha
    mov dx, 0
    cmp ax, 0
    je pn_done
    mov bx, 10
    div bx    
    call print_ax_r
    mov ax, dx
    add al, 30h
    mov ah, 0eh
    int 10h    
    jmp pn_done
pn_done:
    popa  
    ret  
endp