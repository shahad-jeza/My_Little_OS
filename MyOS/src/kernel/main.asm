org 0x7C00 ;tell the complier where to look to find OS
bits 16 
%define ENDL 0x0D ,0x0A


	jmp main

;print string to the screen
; points to a string in ds:si , prints char till null
puts:
	push si
	push ax

.loop:
	lodsb
	or al,al ; is it null ? 
	jz .done ; jump if it's null
	mov ah , 0x0e
	mov bh,0
	int 0x10 ; interrupt to call the BIOS to print char
	jmp .loop
	
.done:
	pop ax
	pop si
	ret


main:

;memory segmntation >> real address = segment * 16 + offset
; regesters : 
; cs > currently running code segment 
;ds>data segment 
;ss>stack segment
; ES , FS , GS >> data segment

	;setup data segment : 
	mov ax , 0
	mov ds , ax
	mov es , ax
	;setup stack :
	mov ss , ax
	mov sp , 0x7C00 ; stack grows downward
	
	hlt ;stops the cpu tell the next instruction

	mov si , msg
	call puts

.halt:
	jmp .halt

msg : db 'HELLO WORLD !!!' , ENDL , 0 


times 510-($-$$) db 0 ;size of the system
dw 00AA55h

