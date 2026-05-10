[org 0x0100]
jmp start
; --- Data Section ---
playerPos:  dw 2160         ; Starting position (bottom-ish area)
finishPos:  dw 164          ; Goal position (top row)
wallChar:   dw 0x1E23       ; Blue background, '#' character
playerChar: dw 0x0E2A       ; Yellow foreground, '*' character
goalChar:   dw 0x4746       ; Red background, 'F' for Finish
emptyChar:  dw 0x0720       ; Black background, Space
; --- Maze Layout (1 = Wall, 0 = Path) ---
; This is a simple 5x5 representation for logic; 
; the code below draws a more complete border.
; --------------------
clrscr:
    push es
    push ax
    push cx
    push di
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, [emptyChar]
    mov cx, 2000
    cld
    rep stosw
    pop di
    pop cx
    pop ax
    pop es
    ret
draw_maze:
    push es
    mov ax, 0xb800
    mov es, ax
    
    ; Draw Top and Bottom Borders
    mov cx, 80
    mov di, 0
    mov ax, [wallChar]
    rep stosw
    
    mov cx, 80
    mov di, 3840            ; Last row
    rep stosw
    
    ; Draw some internal obstacles
    mov word [es:1000], ax
    mov word [es:1002], ax
    mov word [es:1004], ax
    mov word [es:2000], ax
    mov word [es:2002], ax
    
    ; Draw Goal
    mov di, [finishPos]
    mov ax, [goalChar]
    mov [es:di], ax
    
    pop es
    ret
start:
    call clrscr
    call draw_maze
    mov ax, 0xb800
    mov es, ax
game_loop:
    ; 1. Render Player
    mov di, [playerPos]
    mov ax, [playerChar]
    mov [es:di], ax
    ; 2. Wait for Input
    mov ah, 0
    int 0x16
    ; 3. Store current pos to clear it later
    mov bx, [playerPos]
    ; 4. Calculate potential new position
    mov dx, bx              ; Use DX to hold "next" position
    cmp ah, 0x48            ; Up
    je pre_up
    cmp ah, 0x50            ; Down
    je pre_down
    cmp ah, 0x4B            ; Left
    je pre_left
    cmp ah, 0x4D            ; Right
    je pre_right
    cmp al, 27              ; ESC
    je exit_game
    jmp game_loop
pre_up:    sub dx, 160 | jmp check_collision
pre_down:  add dx, 160 | jmp check_collision
pre_left:  sub dx, 2   | jmp check_collision
pre_right: add dx, 2   | jmp check_collision
check_collision:
    ; 5. Collision Detection
    mov di, dx
    mov ax, [es:di]         ; Look at what is currently at the next spot
    
    cmp ah, 0x1E            ; Is it a blue wall?
    je game_loop            ; If yes, ignore move
    
    cmp di, [finishPos]     ; Did we hit the goal?
    je win_screen
    ; 6. Execute Move
    mov di, [playerPos]
    mov ax, [emptyChar]
    mov [es:di], ax         ; Clear old spot
    mov [playerPos], dx     ; Update to new spot
    jmp game_loop
win_screen:
    call clrscr
    ; Simple win display: screen turns green
    mov ax, 0x2020
    mov cx, 2000
    xor di, di
    rep stosw
    jmp exit_game
exit_game:
    mov ax, 0x4c00
    int 0x21
