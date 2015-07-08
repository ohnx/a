; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; Copyright (C) 2008-2015 Return Infinity -- see LICENSE.TXT
;
; Screen Output Functions
; =============================================================================

; -----------------------------------------------------------------------------
; os_pixel -- Put a pixel on the screen
;  IN:	EBX = Packed X & Y coordinates (YYYYXXXX)
;	EAX = Pixel Details (AARRGGBB)
; OUT:	All registers preserved
os_pixel:
	push rdi
	push rdx
	push rcx
	push rbx
	push rax

	push rax			; Save the pixel details
	mov rax, rbx
	shr eax, 16			; Isolate Y co-ordinate
	xor ecx, ecx
	mov cx, [os_VideoX]
	mul ecx				; Multiply Y by os_VideoX
	and ebx, 0x0000FFFF		; Isolate X co-ordinate
	add eax, ebx			; Add X
	mov rdi, [os_VideoBase]

	cmp byte [os_VideoDepth], 32
	je os_pixel_32

os_pixel_24:
	mov ecx, 3
	mul ecx				; Multiply by 3 as each pixel is 3 bytes
	add rdi, rax			; Add offset to pixel video memory
	pop rax				; Restore pixel details
	stosb
	shr eax, 8
	stosb
	shr eax, 8
	stosb
	jmp os_pixel_done

os_pixel_32:
	shl eax, 2			; Quickly multiply by 4
	add rdi, rax			; Add offset to pixel video memory
	pop rax				; Restore pixel details
	stosd

os_pixel_done:
	pop rax
	pop rbx
	pop rcx
	pop rdx
	pop rdi
	ret
; -----------------------------------------------------------------------------


; -----------------------------------------------------------------------------
; os_glyph_put -- Put a glyph on the screen at the cursor location
;  IN:	AL  = char to display
; OUT:	All registers preserved
os_glyph_put:
	push rdi
	push rsi
	push rdx
	push rcx
	push rbx
	push rax

	and eax, 0x000000FF
	sub rax, 0x20
	mov ecx, 12			; Font height
	mul ecx
	mov rsi, font_data
	add rsi, rax			; add offset to correct glyph

; Calculate pixel co-ordinates for character
	xor ebx, ebx
	xor edx, edx
	xor eax, eax
	mov ax, [os_Screen_Cursor_Row]
	mov cx, 12			; Font height
	mul cx
	mov bx, ax
	shl ebx, 16
	xor edx, edx
	xor eax, eax
	mov ax, [os_Screen_Cursor_Col]
	mov cx, 6			; Font width
	mul cx
	mov bx, ax

	xor eax, eax
	xor ecx, ecx			; x counter
	xor edx, edx			; y counter

nextline1:
	lodsb				; Load a line

nextpixel:
	cmp ecx, 6			; Font width
	je bailout			; Glyph row complete
	rol al, 1
	bt ax, 0
	jc os_glyph_put_pixel
	push rax
	mov eax, 0x00000000
	call os_pixel
	pop rax
	jmp os_glyph_put_skip

os_glyph_put_pixel:
	push rax
	mov eax, [os_Font_Color]
	call os_pixel
	pop rax
os_glyph_put_skip:
	add ebx, 1
	add ecx, 1
	jmp nextpixel

bailout:
	xor ecx, ecx
	sub ebx, 6			; column start
	add ebx, 0x00010000		; next row
	add edx, 1
	cmp edx, 12			; Font height
	jne nextline1

glyph_done:
	pop rax
	pop rbx
	pop rcx
	pop rdx
	pop rsi
	pop rdi
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; os_screen_scroll_graphics -- Scroll graphics
os_screen_scroll_graphics:
  xor esi, esi
	mov rdi, [os_VideoBase]
	mov esi, [os_Screen_Row_2]
	add rsi, rdi
	mov ecx, [os_Screen_Bytes]
	rep movsb
	jmp os_screen_scroll_done
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; os_screen_clear_graphics -- Clear screen
os_screen_clear_graphics:
	mov rdi, [os_VideoBase]
	xor eax, eax
	mov ecx, [os_Screen_Bytes]
	rep stosb
	jmp os_screen_clear_done
; -----------------------------------------------------------------------------

; =============================================================================
; EOF
