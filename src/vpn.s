; IMPORTANT NOTES
section		.data
	errmsg			db "An error occurred!", 0x0A
	errmsgsz		equ $-errmsg
	tunfpath		db "/dev/net/tun", 0x00
	tuniaddr		db 192, 168, 4, 174
	tunnetmask		db 255, 255, 255, 0
	tuniaddrsz		equ 4
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
	SIOCGIFBRDADDR  	equ 0x8919
	SIOCSIFBRDADDR  	equ 0x891A
	SIOCGIFNETMASK  	equ 0x891B
	SIOCSIFNETMASK  	equ 0x891C
	SIOCGIFMETRIC   	equ 0x891D
	SIOCSIFMETRIC   	equ 0x891E
	SIOCGIFMEM      	equ 0x891F
	SIOCSIFMEM      	equ 0x8920
	SIOCGIFMTU      	equ 0x8921
	SIOCSIFMTU      	equ 0x8922
	SIOCSIFNAME     	equ 0x8923
	SIOCSIFHWADDR   	equ 0x8924
	SIOCGIFENCAP    	equ 0x8925
	SIOCSIFENCAP    	equ 0x8926
	SIOCGIFHWADDR   	equ 0x8927
	SIOCGIFSLAVE    	equ 0x8929
	SIOCSIFSLAVE    	equ 0x8930
	SIOCADDMULTI    	equ 0x8931
	SIOCDELMULTI    	equ 0x8932
	SIOCGIFINDEX    	equ 0x8933
	SIOCSIFPFLAGS   	equ 0x8934
	SIOCGIFPFLAGS   	equ 0x8935
	SIOCDIFADDR     	equ 0x8936
	SIOCSIFHWBROADCAST      equ 0x8937
	SIOCGIFCOUNT    	equ 0x8938
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
	mov	dl, errmsgsz
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
	zifrl:
	mov	byte [eax], 0x00
	inc	eax
	dec	ecx
	jz	zifrend
	jmp	zifrl
	zifrend:
	mov	rsp, rbp
	pop	rbp
	ret
bring_up_tun:
	;bring up new tun interface
	push	rbp
	mov	rbp, rsp
	xor	rax, rax
	xor	rcx, rcx
	xor	rdx, rdx
	xor	rdi, rdi
	xor	rsi, rsi
	xor	r8, r8
	mov	esi, [tuntitle]
	mov	dword [ifr], esi
	mov	byte [ifr+16], IFF_TUN
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
	mov	byte [ifr+16], 0x01
	mov	esi, SIOCSIFFLAGS
	syscall
	cmp	rax, 0
	jl	error
	; set tun interface address and netmask
	call	zero_ifr
	; set address family word BEFORE inet addr
	mov	word [ifr+16], AF_INET
	; prepare registers to feed the inet addr into the offset ifreq chunk
	mov	eax, tuniaddr
	mov	ebx, ifr+20
	mov	ecx, tuniaddrsz
	tunaddrl:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc 	eax
	inc	ebx
	dec	ecx
	jz	tunaddrcl
	jmp	tunaddrl
	tunaddrcl:
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
	mov	ebx, ifr+20
	mov	ecx, tuniaddrsz
	mov	word [ifr+16], AF_INET
	tunmaskl:
	mov	r8b, [eax]
	mov	byte [ebx], r8b
	inc	eax
	inc	ebx
	dec	ecx
	jz	tunmaskcl
	jmp	tunmaskl
	tunmaskcl:
	xor	eax, eax
	mov	al, 16
	mov	esi, SIOCSIFNETMASK
	syscall
	cmp	rax, 0
	jl	error
	mov	rsp, rbp
	pop	rbp
	ret
_start:
	;get the tun fd and sock fd
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
	jmp	exit
error:
	call	reperr
