%include "calls.inc"

section		.data
	timespec:
		tv_sec			dq 0
		tv_nsec			dq 0
	errmsg			db "An error occurred!", 0x0A
	ERRMSGSZ		equ $-errmsg
section		.text
exit:
	xor	rax, rax
	xor	rdi, rdi
	mov	al, __NR_exit
	syscall
reperr:
	push	rbp
	mov	rsp, rbp
	xor	rax, rax
	xor	rdi, rdi
	xor	rsi, rsi
	xor	rdx, rdx
	inc	al
	inc	dil
	mov	esi, errmsg
	mov	dl, ERRMSGSZ
	syscall
	jmp	exit
zeros:
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	mov	eax, [rbp+24]
	mov	ecx, [rbp+16]
.loop:
	mov	byte [eax], 0x00
	inc	eax
	dec	ecx
	jz	.close
	jmp	.loop
.close:
	mov	rsp, rbp
	pop	rbp
	ret
sleep:
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rdi, rdi
	mov	r8, [rbp+16]
	mov	qword [tv_sec], r8
	mov	al, __NR_nanosleep
	mov	edi, timespec
	syscall
	cmp	rax, 0
	jl	error
	mov	rsp, rbp
	pop	rbp
	ret
error:
	call	reperr
