ccarm=mips-openwrt-linux-g++
all:
	g++ forward.cpp -o forward -static
	${ccarm} forward.cpp -o forwardarm   -static -lgcc_eh
#g++ forward.cpp aes.c -o forward -static
#	${ccarm} forward.cpp aes.c  -o forwardarm   -static -lgcc_eh
