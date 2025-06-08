ASMVPN Development Journey

DE \= Dead End (no good information)

ChatGPT: [https://chatgpt.com/share/68433d7f-7e88-8003-97d1-2391d21140e4](https://chatgpt.com/share/68433d7f-7e88-8003-97d1-2391d21140e4)  
ChatGPT: [https://chatgpt.com/share/68448686-47bc-8003-bc79-7d4c8a0ef90b](https://chatgpt.com/share/68448686-47bc-8003-bc79-7d4c8a0ef90b)

Day 1

* Figuring out how VPNs work  
  * [\[ELI5\] how do VPNs work? : r/explainlikeimfive](https://www.reddit.com/r/explainlikeimfive/comments/1831p22/eli5_how_do_vpns_work/)  
  * [How does OpenVPN work and why does anyone pay for a VPN? • r/VPN](https://www.reddit.com/r/OpenVPN/comments/6e6jwe/how_does_openvpn_work_and_why_does_anyone_pay_for/)  
  * [How VPNs really work. Under the hood | by Hussein Nasser | Medium](https://medium.com/@hnasr/how-vpns-really-work-a5da843d0eb3)  
  * [Routing all my internet traffic through a VPN : r/HomeServer](https://www.reddit.com/r/HomeServer/comments/17ph21x/routing_all_my_internet_traffic_through_a_vpn/) (DE)  
  * ChatGPT \- *“How do vpns tell your internet traffic to go through their tunnel instead of the normal route?”*  
* Figuring out how VPNs make virtual network interfaces  
  * [How can I create a virtual ethernet interface on a machine without a physical adapter? \- Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/152331/how-can-i-create-a-virtual-ethernet-interface-on-a-machine-without-a-physical-ad) (DE)  
  * [Virtual private network \- Wikipedia](https://en.wikipedia.org/wiki/Virtual_private_network) (DE)  
  * [1\. Network Interfaces](https://linuxjourney.com/lesson/network-interfaces) (DE)  
  * [Understanding and Configuring Linux Network Interfaces | Baeldung on Linux](https://www.baeldung.com/linux/network-interface-configure)  
  * [Network configuration \- ArchWiki](https://wiki.archlinux.org/title/Network_configuration) (DE)  
  * ChatGPT \- *“How would one interact with/create virtual network interfaces via glibc or the linux kernel api if programming in C?”*  
* Investigating /dev/net/tun  
  * [How does /dev/net/tun works? Do I get back what I write? \- Stack Overflow](https://stackoverflow.com/questions/59113098/how-does-dev-net-tun-works-do-i-get-back-what-i-write) (DE)  
  * [How to interface with the Linux tun driver \- Stack Overflow](https://stackoverflow.com/questions/1003684/how-to-interface-with-the-linux-tun-driver)  
  * [tuntap.txt](https://www.kernel.org/doc/Documentation/networking/tuntap.txt)  
* Refamiliarizing myself with linux syscalls  
  * [Linux System Call Table](https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#syscall-availability)  
  * ChatGPT \- *“How to pass mode\_t to an open syscall in asm?”*  
  * ChatGPT \- *“Where is network interface info stored on linux fs?”*  
  * ChatGPT \- *“Does the mode\_t argument in the open linux syscall have to map on to the current permissions of the file you are attempting to open?”*  
  * ChatGPT \- *“Linux open syscall puts \-19 in the al register\!”*  
* First try with ioctl  
  * [https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html\#section-3.2.2](https://www.nasm.us/xdoc/2.16.03/html/nasmdoc3.html#section-3.2.2)  
  * [Is there any difference between \#include \<linux/ioctl.h\> and \#include \<sys/ioctl.h\>?](https://unix.stackexchange.com/questions/701230/is-there-any-difference-between-include-linux-ioctl-h-and-include-sys-ioctl)  
  * [ioctl based interfaces — The Linux Kernel documentation](https://docs.kernel.org/driver-api/ioctl.html)  
  * ChatGPT \- *“ioctl causes an EFAULT error. How could this be?”*  
  * ChatGPT \- *“What is the relevance of ioctl's third argument?”*  
  * ChatGPT \- *“How would one pass such information in assembly language (i.e. without the struct ifreq at our disposal)?”*  
  * [what is the meaning of this macro \_IOR(MY\_MACIG, 0, int)? \- Stack Overflow](https://stackoverflow.com/questions/22496123/what-is-the-meaning-of-this-macro-iormy-macig-0-int)  
  * ChatGPT \- *“Is rel only used for lea instructions, or for other copying instructions like mov?”*  
* Bringing up a network interface with ioctl  
  * [Linux programmatically up/down an interface kernel \- Stack Overflow](https://stackoverflow.com/questions/5858655/linux-programmatically-up-down-an-interface-kernel)  
  * [ioctl() and changing network interface flags](https://www.linuxquestions.org/questions/linux-networking-3/ioctl-and-changing-network-interface-flags-751709/) (DE)  
  * [What happens when the network interface is "brought up" with ifconfig? \- Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/233560/what-happens-when-the-network-interface-is-brought-up-with-ifconfig)  
  * ChatGPT \- *“How to determine the numbers corresponding to the TUN family of ioctl flags?”*  
  * ChatGPT \- *“Where is the \_IOW macro declared in linux?”*  
  * ChatGPT \- *“Where can I find documentation for the various TUN family ioctl codes?”*  
  * ChatGPT \- *“where is AF\_INET defined?”*  
* Issues with Tun FD  
  * ["File descriptor in bad state" error while running ffmpeg on android device and selecting an input device \- Stack Overflow](https://stackoverflow.com/questions/12118382/file-descriptor-in-bad-state-error-while-running-ffmpeg-on-android-device-and) (DE)  
  * [Gentoo Forums :: View topic \- "File descriptor in bad state" with OpenVPN \[Solved\]](https://forums.gentoo.org/viewtopic-t-577249-start-0.html) (DE)  
  * ChatGPT \- *“File descriptor is in bad state”*  
  * [TUN Module Loaded but OpenVPN /dev/net/tun no such file or directory \- Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/501403/tun-module-loaded-but-openvpn-dev-net-tun-no-such-file-or-directory)  
  * [read from TUN/TAP : File descriptor in bad state (code=77) \- OpenVPN Support Forum](https://forums.openvpn.net/viewtopic.php?t=11369)  
  * ChatGPT \- *“File descriptor is in bad state with /dev/net/tun. How to fix\!”*  
  * ChatGPT \- *“When I try to open /dev/net/tun with open, it sends back a linux errno of \-2, despite my path being correct\!”*  
* Struggles with SIOSIFFLAGS  
  * [SIOCSIFFLAGS: Operation not permitted \- Super User](https://superuser.com/questions/1202077/siocsifflags-operation-not-permitted) (DE)  
  * [SIOCSIFFLAGS error : r/Kalilinux](https://www.reddit.com/r/Kalilinux/comments/18ksl9k/siocsifflags_error/) (DE)  
  * [What is SIOCSIFFLAGS?](https://www.linuxquestions.org/questions/linux-wireless-networking-41/what-is-siocsifflags-674992/)  
  * [netdevice(7) \- Linux manual page](https://man7.org/linux/man-pages/man7/netdevice.7.html)  
  * ChatGPT \- *“What would an effective call to ioctls() using SIOCSIFFLAGS look like in nasm 64-bit assembly look like?”*  
  * [ioctl() and changing network interface flags](https://www.linuxquestions.org/questions/linux-networking-3/ioctl-and-changing-network-interface-flags-751709/) (DE)  
  * [What is SIOCSIFFLAGS?](https://www.linuxquestions.org/questions/linux-wireless-networking-41/what-is-siocsifflags-674992/)  
  * ChatGPT \- *“Why is the nasm definition of a "word" two bytes, when general CS refers to a word as four bytes?”*  
* Late night work  
  * ChatGPT \- *“No matter what I try, my call to ioctl with SIOCSIFFLAGS always returns an errno of \-22\! Here is my code, what is the issue?* \<code\>*”*  
  * ChatGPT \- *“How can I better know what to put as the first argument for my various ioctl tun related calls? Is there documentation for this somewhere?”*  
  * ChatGPT \- *“How to use x with gdb with a memory offset?”*

Day 2  
	