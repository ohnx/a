; the contents of this file get run when the kernel finishes starting up.
done_init:
	mov ax, [os_Screen_Rows]	; Display the "ready" message and reset cursor to bottom left
	sub ax, 1
	mov word [os_Screen_Cursor_Row], ax
	mov word [os_Screen_Cursor_Col], 0
	mov rsi, readymsg
	call os_output
do_nothing:
	hlt
	jmp do_nothing
