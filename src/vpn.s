section		.data
	tunfpath		db "/dev/net/tun", 0x00
	tunlink			db "127.0.0.1"
	tuntitle		dd "tun8"
	ifr			times 40 db 0
	AF_INET			equ 2
	AF_INET6		equ 10
	SOCK_STREAM		equ 1
	SOCK_DGRAM		equ 2
	SOCK_RAW		equ 3
	IFF_TUN			equ 0x0001
	SIOCADDRT		equ 0x890B
	SIOCDELRT		equ 0x890C
	SIOCRTMSG		equ 0x890D
	SIOCGIFNAME		equ 0x8910
	SIOCSIFLINK		equ 0x8911
	SIOCGIFCONF		equ 0x8912
	SIOCGIFFLAGS    	equ 0x8913
	SIOCSIFFLAGS    	equ 0x8914
	SIOCGIFADDR     	equ 0x8915
	SIOCSIFADDR     	equ 0x8916
	SIOCGIFDSTADDR  	equ 0x8917
	SIOCSIFDSTADDR  	equ 0x8918
	TUNSETNOCSUM		equ 1074025672
	TUNSETDEBUG		equ 1074025673
	TUNSETIFF		equ 1074025674
	TUNSETPERSIST		equ 1074025675
	TUNSETOWNER		equ 1074025676
	TUNSETLINK		equ 1074025677
	TUNSETGROUP		equ 1074025678
	TUNGETFEATURES		equ -2147199793
	TUNSETOFFLOAD		equ 1074025680
	TUNSETTXFILTER		equ 1074025681
	TUNGETIFF		equ -2147199790
	TUNGETSNDBUF		equ -2147199789
	TUNSETSNDBUF		equ 1074025684
	TUNATTACHFILTER		equ 1074812117
	TUNDETACHFILTER		equ 1074812118
	TUNGETVNETHDRSZ		equ -2147199785
	TUNSETVNETHDRSZ		equ 1074025688
	TUNSETQUEUE		equ 1074025689
	TUNSETIFINDEX		equ 1074025690
	TUNGETFILTER		equ -2146413349
	TUNSETVNETLE		equ 1074025692
	TUNGETVNETLE		equ -2147199779
	TUNSETVNETBE		equ 1074025694
	TUNGETVNETBE		equ -2147199777
	TUNSETSTEERINGEBPF	equ -2147199776
	TUNSETFILTEREBPF	equ -2147199775
	TUNSETCARRIER		equ 1074025698
	TUNGETDEVNETNS		equ 21731
	IFNAMSIZ		equ 16
section		.bss
	tunfd		resb 1
	sockfd		resb 1
section		.text
global		_start
exit:
	xor	rax, rax
	xor	rdi, rdi
	mov	al, 60
	syscall
zero_ifr:
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	mov	eax, ifr
	add	eax, 16
	mov	ecx, 40
	zifrl:
	mov	byte [ifr], 0x00
	dec	ecx
	jz	zifrend
	jmp	zifrl
	zifrend:
	mov	rsp, rbp
	pop	rbp
	ret
tunup:
	;bring up new tun interface
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rdi, rdi
	xor	rsi, rsi
	mov	esi, [tuntitle]
	mov	dword [ifr], esi
	mov	byte [ifr+16], IFF_TUN
	mov	al, 16
	mov	dil, [tunfd]
	mov	esi, TUNSETIFF
	mov	edx, ifr
	syscall
	mov	al, 16
	mov	dil, [sockfd]
	mov	byte [ifr+16], 0x41
	mov	esi, SIOCSIFFLAGS
	mov	edx, ifr
	syscall
	mov	rsp, rbp
	pop	rbp
	ret
tunaddr:
	;set tun interface address
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rdi, rdi
	xor	rsi, rsi
	xor	rdx, rdx
	call	zero_ifr
	mov	al, 16
	mov	dil, [sockfd]
	mov	esi, SIOCSIFADDR
	mov	edx, ifr
	syscall
	mov	rsp, rbp
	pop	rbp
	ret
_start:
	;get the tun fd and sock fd
	mov	al, 2
	mov	edi, tunfpath
	mov	sil, 02
	syscall
	mov	[tunfd], al
	mov	al, 41
	mov	edi, AF_INET
	mov	sil, SOCK_STREAM
	syscall
	mov	[sockfd], al
	call 	tunup
	call	tunaddr
	jmp	exit
