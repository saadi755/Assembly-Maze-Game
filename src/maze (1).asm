[org 0x0100]
jmp start
; --- Data Section ---
playerPos:  dw 2160         
direction:  dw 0            
finishPos:  dw 164          
wallChar:   dw 0x1E23       
playerChar: dw 0x0E2A       
emptyChar:  dw 0x0720       
; --- Subroutines ---
clrscr:
    push es
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, [emptyChar]
    mov cx, 2000
    rep stosw
    pop es
    ret
draw_maze:
    push es
    mov ax, 0xb800
    mov es, ax
    mov ax, [wallChar]
    
    mov di, 0 
    mov cx, 80 
    rep stosw          
    
    mov di, 3840 
    mov cx, 80 
    rep stosw       
    
    mov cx, 10
    mov di, 160
draw_v: 
    mov [es:di], ax 
    add di, 160 
    loop draw_v
    
    mov cx, 15
    mov di, 300
draw_v2: 
    mov [es:di], ax 
    add di, 160 
    loop draw_v2
    mov cx, 40
    mov di, 1600
    rep stosw
    mov di, [finishPos]
    mov word [es:di], 0x4746
    pop es
    ret
; --- MEDIUM PACE DELAY ---
delay:
    push cx
    push dx
    mov dx, 0x0010          ; Changed from 0x0040 for a medium pace
d_outer:
    mov cx, 0xFFFF          
d_inner:
    loop d_inner
    dec dx
    jnz d_outer
    pop dx
    pop cx
    ret
; --- Game States ---
exit_game:
    mov ax, 0x4c00
    int 0x21
stop_move:
    mov word [direction], 0 
    jmp render
win_screen:
    call clrscr
    mov ax, 0x2020          
    mov cx, 2000
    xor di, di
    rep stosw
    jmp exit_game
lose_screen:
    call clrscr
    mov ax, 0x4020          
    mov cx, 2000
    xor di, di
    rep stosw
    jmp exit_game
collision:
    mov ax, 0xb800
    mov es, ax
    mov di, dx
    
    cmp dx, 160             
    jb lose_screen          
    
    cmp dx, 3840            
    jae lose_screen         
    mov ax, [es:di]
    cmp ah, 0x1E            
    je stop_move
    
    cmp di, [finishPos]
    je win_screen
    mov di, [playerPos]
    mov word [es:di], 0x0720
    mov [playerPos], dx
    jmp render
start:
    call clrscr
    call draw_maze
game_loop:
    mov ah, 1
    int 0x16                
    jz move_player          
    
    mov ah, 0
    int 0x16                
    cmp ah, 0x48
    je set_up
    cmp ah, 0x50
    je set_down
    cmp ah, 0x4B
    je set_left
    cmp ah, 0x4D
    je set_right
    cmp al, 27
    je exit_game
    jmp move_player
set_up:    
    mov word [direction], 1 
    jmp move_player
set_down:  
    mov word [direction], 2 
    jmp move_player
set_left:  
    mov word [direction], 3 
    jmp move_player
set_right: 
    mov word [direction], 4 
    jmp move_player
move_player:
    mov dx, [playerPos]
    mov bx, [direction]
    
    cmp bx, 1 
    je go_up
    cmp bx, 2 
    je go_down
    cmp bx, 3 
    je go_left
    cmp bx, 4 
    je go_right
    jmp render              
go_up:    
    sub dx, 160 
    jmp collision
go_down:  
    add dx, 160 
    jmp collision
go_left:  
    sub dx, 2   
    jmp collision
go_right: 
    add dx, 2   
    jmp collision
render:
    mov di, [playerPos]
    mov ax, [playerChar]
    mov [es:di], ax
    call delay
    jmp game_loop
