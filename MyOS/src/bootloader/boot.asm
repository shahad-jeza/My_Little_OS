org 0x7C00 ;tell the complier where to look to find OS
bits 16 
%define ENDL 0x0D ,0x0A


jmp short start
nop


; FAT12 file system - for floppy disk - 
; file allocation table made of linked list
bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0E0h
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0F0h                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 29h
ebr_volume_id:              db 12h, 34h, 56h, 78h   ; serial number, value doesn't matter
ebr_volume_label:           db 'NANOBYTE OS'        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes



start:
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

