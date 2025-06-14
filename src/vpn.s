%define IFNAMSIZ		16
%define	IFRSZ			40
%define	AF_INET			2
%define	AF_INET6		10
%define	SOCK_STREAM		1
%define	SOCK_DGRAM		2
%define	SOCK_RAW		3
%define	IFF_TUN			0x0001
%define	INADDR_ANY		0x00000000
%define	SIOCADDRT		0x890B
%define	SIOCDELRT		0x890C
%define	SIOCRTMSG		0x890D
%define	SIOCGIFNAME		0x8910
%define	SIOCSIFLINK		0x8911
%define	SIOCGIFCONF		0x8912
%define	SIOCGIFFLAGS    	0x8913
%define	SIOCSIFFLAGS    	0x8914
%define	SIOCGIFADDR     	0x8915
%define	SIOCSIFADDR     	0x8916
%define	SIOCGIFDSTADDR  	0x8917
%define	SIOCSIFDSTADDR  	0x8918
%define	SIOCGIFBRDADDR  	0x8919
%define	SIOCSIFBRDADDR  	0x891A
%define	SIOCGIFNETMASK  	0x891B
%define	SIOCSIFNETMASK  	0x891C
%define	SIOCGIFMETRIC   	0x891D
%define	SIOCSIFMETRIC   	0x891E
%define	SIOCGIFMEM      	0x891F
%define	SIOCSIFMEM      	0x8920
%define	SIOCGIFMTU      	0x8921
%define	SIOCSIFMTU      	0x8922
%define	SIOCSIFNAME    		0x8923
%define	SIOCSIFHWADDR   	0x8924
%define	SIOCGIFENCAP    	0x8925
%define	SIOCSIFENCAP    	0x8926
%define	SIOCGIFHWADDR   	0x8927
%define	SIOCGIFSLAVE    	0x8929
%define	SIOCSIFSLAVE    	0x8930
%define	SIOCADDMULTI    	0x8931
%define	SIOCDELMULTI    	0x8932
%define	SIOCGIFINDEX    	0x8933
%define	SIOCSIFPFLAGS   	0x8934
%define	SIOCGIFPFLAGS  		0x8935
%define	SIOCDIFADDR     	0x8936
%define	SIOCSIFHWBROADCAST      0x8937
%define	SIOCGIFCOUNT    	0x8938
%define	TUNSETNOCSUM		1074025672
%define	TUNSETDEBUG		1074025673
%define	TUNSETIFF		1074025674
%define	TUNSETPERSIST		1074025675
%define	TUNSETOWNER		1074025676
%define	TUNSETLINK		1074025677
%define	TUNSETGROUP		1074025678
%define	TUNGETFEATURES		-2147199793
%define	TUNSETOFFLOAD		1074025680
%define	TUNSETTXFILTER		1074025681
%define	TUNGETIFF		-2147199790
%define	TUNGETSNDBUF		-2147199789
%define	TUNSETSNDBUF		1074025684
%define	TUNATTACHFILTER		1074812117
%define	TUNDETACHFILTER		1074812118
%define	TUNGETVNETHDRSZ		-2147199785
%define	TUNSETVNETHDRSZ		1074025688
%define	TUNSETQUEUE		1074025689
%define	TUNSETIFINDEX		1074025690
%define	TUNGETFILTER		-2146413349
%define	TUNSETVNETLE		1074025692
%define	TUNGETVNETLE		-2147199779
%define	TUNSETVNETBE		1074025694
%define	TUNGETVNETBE		-2147199777
%define	TUNSETSTEERINGEBPF	-2147199776
%define	TUNSETFILTEREBPF	-2147199775
%define	TUNSETCARRIER		1074025698
%define	TUNGETDEVNETNS		21731
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
	errmsg			db "An error occurred!", 0x0A
	ERRMSGSZ		equ $-errmsg
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
exit:
	xor	rax, rax
	xor	rdi, rdi
	mov	al, 60
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
zero_ifr:
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	mov	eax, ifr
	add	eax, 16
	mov	ecx, 24
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
	mov	al, 16
	mov	dil, [tunfd]
	mov	esi, TUNSETIFF
	mov	edx, ifr
	syscall
	cmp	rax, 0
	jl	error
	xor	rax, rax
	mov	al, 16
	mov	dil, [sockfd]
	mov	byte [ifr_ifru], 0x01
	mov	esi, SIOCSIFFLAGS
	syscall
	cmp	rax, 0
	jl	error
	; set tun interface address and netmask
	call	zero_ifr
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
	mov	al, 16
	mov	dil, [sockfd]
	mov	esi, SIOCSIFADDR
	mov	edx, ifr
	syscall
	cmp	rax, 0
	jl	error
	; set if netmask
	call	zero_ifr
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
	mov	al, 16
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
	mov	al, 16
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
	mov	al, 2
	mov	edi, tunfpath
	mov	sil, 02
	syscall
	cmp	rax, 0
	jl	error
	mov	[tunfd], al
	mov	al, 41
	mov	edi, AF_INET
	mov	sil, SOCK_STREAM
	syscall
	cmp	rax, 0
	jl	error
	mov	[sockfd], al
	call 	bring_up_tun
	call	set_routes
	; suspend program execution to check results
	xor	rax, rax
	xor	rdi, rdi
	mov	rsi, tuntitle
	mov	rdx, 10
	syscall
	; close the previously opened file descriptors
	mov	al, 3
	mov	dil, [tunfd]
	xor	rsi, rsi
	xor	rdx, rdx
	syscall
	mov	al, 3
	mov	dil, [sockfd]
	syscall
	jmp	exit
error:
	call	reperr
