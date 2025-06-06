section		.data
	ifr:
        	ifname 		db "tun69", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        	ifr_flags	db IFF_TUN
	SIOCADDRT	equ 0x890B
	SIOCDELRT	equ 0x890C
	SIOCRTMSG	equ 0x890D
	SIOCGIFNAME	equ 0x8910
	SIOCSIFLINK	equ 0x8911
	SIOCGIFCONF	equ 0x8912
	TUNSETIFF	equ 1074025674
	IFF_TUN		equ 0x0001
	IFNAMSIZ	equ 16
	tunfpath	db "/dev/net/tun"
section		.bss
	tunfd		resb 1
section		.text
global		_start
exit:
	xor	rax, rax
	xor	rdi, rdi
	mov	al, 60
	syscall
tunup:
	;bring up new tun interface
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rdi, rdi
	xor	rsi, rsi
	mov	al, 16
	mov	dil, [tunfd]
	mov	esi, TUNSETIFF
	lea	rdx, [rel ifr]
	syscall
	mov	rsp, rbp
	pop	rbp
	ret
_start:
	;get the tun fd
	mov	al, 2
	mov	edi, tunfpath
	mov	sil, 02
	syscall
	mov	[tunfd], al
	call 	tunup
	jmp	exit
