; =============================================================================
; BareMetal -- a 64-bit OS written in Assembly for x86-64 systems
; ohnx was here
; Graphics includes
; =============================================================================
; Graphics setup
init_screen:
  mov rsi, 0x5080
	xor eax, eax
	lodsd				; VIDEO_BASE
	mov [os_VideoBase], rax
	xor eax, eax
	xor ecx, ecx

	lodsw				; VIDEO_X
	mov [os_VideoX], ax		; ex: 1024

	xor edx, edx
	mov cl, [font_width]
	div cx
	mov [os_Screen_Cols], ax

	lodsw				; VIDEO_Y
	mov [os_VideoY], ax		; ex: 768

	xor edx, edx
	mov cl, [font_height]
	div cx
	mov [os_Screen_Rows], ax

	lodsb				; VIDEO_DEPTH
	mov [os_VideoDepth], al

	xor eax, eax
	xor ecx, ecx
	mov ax, [os_VideoX]
	mov cx, [os_VideoY]
	mul ecx
	mov [os_Screen_Pixels], eax
	xor ecx, ecx
	mov cl, [os_VideoDepth]
	shr cl, 3
	mul ecx
	mov [os_Screen_Bytes], eax

	xor eax, eax
	xor ecx, ecx
	mov ax, [os_VideoX]
	mov cl, [font_height]
	mul cx
	mov cl, [os_VideoDepth]
	shr cl, 3
	mul ecx
	mov dword [os_Screen_Row_2], eax

	mov eax, 0x00FFFFFF
	mov [os_Font_Color], eax

	mov al, 1
	mov [os_VideoEnabled], al

	ret
; Includes
%include "graphics/font.asm"
%include "graphics/basic.asm"
