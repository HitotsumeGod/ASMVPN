#include <sys/socket.h>
#include <net/route.h>

int main(void) {

	struct rtentry route;
	struct sockaddr dst, gate, mask;
	char *abso = "absolute";
	
	dst.sa_family = AF_INET;
	dst.sa_data[0] = 0xFA;
	dst.sa_data[13] = 0xFA;
	gate.sa_family = AF_INET;
	gate.sa_data[0] = 0xFA;
	gate.sa_data[13] = 0xFA;
	mask.sa_family = AF_INET;
	mask.sa_data[0] = 0xFA;
	mask.sa_data[13] = 0xFA;
	
	route.rt_pad1 = 0xF1;
	route.rt_dst = dst;
	route.rt_gateway = gate;
	route.rt_genmask = mask;
	route.rt_flags = 0x01;
	route.rt_pad2 = 0xF2;
	route.rt_pad3 = 0xF3F3F3F3F3F3F3F3;
	route.rt_tos = 0xC0;
	route.rt_class = 0xC0;
	route.rt_pad4[0] = 0xF4;
	route.rt_pad4[1] = 0xF4;
	route.rt_pad4[2] = 0xF4;
	route.rt_metric = 0x06;
	route.rt_dev = abso;
	route.rt_mtu = 0x07;
	route.rt_window = 0x08;
	route.rt_irtt = 0x09;
done:
	return 0;

}
