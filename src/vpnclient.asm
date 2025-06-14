%include "common.inc"
%include "ioctls.inc"

%define IFNAMSIZ		16
%define	IFRSZ			40
%define	AF_INET			2
%define	AF_INET6		10
%define	SOCK_STREAM		1
%define	SOCK_DGRAM		2
%define	SOCK_RAW		3
%define	IFF_TUN			0x0001
%define	INADDR_ANY		0x00000000
%define SLEEPTIME		100

section		.data
	ifr:
		ifr_name		times IFNAMSIZ db 0
		ifr_ifru		times IFRSZ-IFNAMSIZ db 0
	rtentry:
		rt_pad1			times 8 db 0
		rt_dst			times 16 db 0
		rt_gateway		times 16 db 0
		rt_genmask		times 16 db 0
		rt_flags		times 2 db 0
		rt_pad2			times 2 db 0
		implicit1		times 4 db 0
		rt_pad3			times 8 db 0
		rt_tos			db 0
		rt_class		db 0
		rt_pad4			times 3 dw 0
		rt_metric		times 2 db 0
		implicit2		times 6 db 0
		rt_dev			times 8 db 0
		rt_mtu			times 8 db 0
		rt_window		times 8 db 0
		rt_irtt			times 2 db 0
		implicit3		times 6 db 0
	tunfpath		db "/dev/net/tun", 0x00
	tunaddr			db 192, 168, 0, 224
	TUNADDRSZ		equ $-tunaddr
	tungw			db 192, 168, 0, 224
	tunnetmask		db 255, 255, 255, 0
	rtmask			db 0, 0, 0, 0
	tuntitle		db "tun8", 0x00

section		.bss
	tunfd		resb 1
	sockfd		resb 1
section		.text
global		_start
bring_up_tun:
	; bring up new tun interface
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	xor	rdx, rdx
	xor	rdi, rdi
	xor	rsi, rsi
	xor	r8, r8
	mov	esi, [tuntitle]
	mov	dword [ifr_name], esi
	mov	byte [ifr_ifru], IFF_TUN
	mov	al, __NR_ioctl
	mov	dil, [tunfd]
	mov	esi, TUNSETIFF
	mov	edx, ifr
	syscall
	cmp	rax, 0
	jl	error
	xor	rax, rax
	mov	al, __NR_ioctl
	mov	dil, [sockfd]
	mov	byte [ifr_ifru], 0x01
	mov	esi, SIOCSIFFLAGS
	syscall
	cmp	rax, 0
	jl	error
	; set tun interface address and netmask
	push 	ifr+16
	push	16
	call	zeros
	; set address family word BEFORE inet addr
	mov	word [ifr_ifru], AF_INET
	; prepare registers to feed the inet addr into the offset ifreq chunk
	mov	eax, tunaddr
	mov	ebx, ifr_ifru+4
	mov	ecx, TUNADDRSZ
.loop:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc 	eax
	inc	ebx
	dec	ecx
	jz	.close
	jmp	.loop
.close:
	xor	eax, eax
	mov	al, __NR_ioctl
	mov	dil, [sockfd]
	mov	esi, SIOCSIFADDR
	mov	edx, ifr
	syscall
	cmp	rax, 0
	jl	error
	; set if netmask
	push	ifr+16
	push	16
	call	zeros
	mov	eax, tunnetmask
	mov	ebx, ifr_ifru+4
	mov	ecx, TUNADDRSZ
	mov	word [ifr_ifru], AF_INET
.loop2:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc	eax
	inc	ebx
	dec	ecx
	jz	.close2
	jmp	.loop2
.close2:
	xor	eax, eax
	mov	al, __NR_ioctl
	mov	esi, SIOCSIFNETMASK
	syscall
	cmp	rax, 0
	jl	error
	mov	rsp, rbp
	pop	rbp
	ret
set_routes:
	; perform a call to SIOCADDRT, routing all network traffic through the tunnel
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	xor	rdx, rdx
	xor	rdi, rdi
	xor	rsi, rsi
	xor	r8, r8
	mov	word [rt_dst], AF_INET
	mov	word [rt_gateway], AF_INET
	mov	word [rt_genmask], AF_INET
	mov	word [rt_metric], 100
	mov	eax, tungw
	mov	ebx, rt_gateway+4
	mov	ecx, TUNADDRSZ
.loop:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc	eax
	inc	ebx
	dec	ecx
	jz	.close
	jmp	.loop
.close:
	mov	eax, rtmask
	mov	ebx, rt_genmask+4
	mov	ecx, TUNADDRSZ
.loop2:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc	eax
	inc	ebx
	dec	ecx
	jz	.close2
	jmp	.loop2
.close2:
	mov	word [rt_flags], 0x01|0x02
	mov	qword [rt_dev], tuntitle
	xor	rax, rax
	mov	al, __NR_ioctl
	mov	dil, [sockfd]
	mov	esi, SIOCADDRT
	mov	edx, rtentry
	syscall
	cmp	rax, 0x00
	jl	error
	mov	rsp, rbp
	pop	rbp
	ret
_start:
	; get the tun fd and sock fd
	mov	al, __NR_open
	mov	edi, tunfpath
	mov	sil, 02
	syscall
	cmp	rax, 0
	jl	error
	mov	[tunfd], al
	mov	al, __NR_socket
	mov	edi, AF_INET
	mov	sil, SOCK_STREAM
	syscall
	cmp	rax, 0
	jl	error
	mov	[sockfd], al
	call 	bring_up_tun
	call	set_routes
	push	SLEEPTIME
	call	sleep
	; close the previously opened file descriptors
	mov	al, __NR_close
	mov	dil, [tunfd]
	xor	rsi, rsi
	xor	rdx, rdx
	syscall
	mov	al, __NR_close
	mov	dil, [sockfd]
	syscall
	jmp	exit
