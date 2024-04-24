bits 16 ; tell NASM this is 16 bit code
org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00
boot:
    mov si,description ; point si register to description label memory location
    mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
.loop:
    lodsb
    or al,al ; is al == 0 ?
    jz .userInput  ; if (al == 0) jump to userInput label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp .loop

.userInput: 
    mov ah,0x0
    int 16h
    cmp al, '1'
    je .printOption1 ; if user input 1, jump to printOption1
    cmp al, '2'
    je .printOption2 ; if user input is 2, jump to printOption2
    cmp al, '3'
    je .printOption3 ; if user input is 3, jump to printOption3
    jmp .loop

.printOption1:
    mov si, option1
    jmp .printOption

.printOption2:
    mov si, option2
    jmp .printOption

.printOption3:
    mov si, option3
    jmp .printOption

.printOption: ; print the option that was loaded into si register
    mov ah,0x0e
    jmp .loop

halt:
    cli ; clear interrupt flag
    hlt ; halt execution

description: db "Press 1, 2 or 3 to display some text: ",0
option1: db "You selected the first option! ",0
option2: db "The second option was selected! ",0
option3: db "You chose the third option! ",0

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ; magic bootloader magic - marks this 512 byte sector bootable!