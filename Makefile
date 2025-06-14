AS=nasm
LD=ld
DBG=gdb
DIS=objdump
X=xxd
GR=grep
SRC=src
DEPS=$(SRC)/include
UTILS=$(SRC)/utils
BUILD=build

all: client server
client: $(BUILD)/cab
server: $(BUILD)/sab
$(BUILD)/cab: $(SRC)/vpnclient.asm $(BUILD)
	$(AS) -f elf64 -o $(BUILD)/vpnclient.o $< -i $(DEPS)
	$(LD) -o $@ $(BUILD)/vpnclient.o
$(BUILD)/sab: $(SRC)/vpnserver.asm $(BUILD)
	$(AS) -f elf64 -o $(BUILD)/vpnserver.o $< -i $(DEPS)
	$(LD) -o $@ $(BUILD)/vpnserver.o
debug: $(BUILD)/cab $(BUILD)
	$(DBG) $<
dump: $(BUILD)/cab
	$(DIS) -d $< 
bdump: $(BUILD)/cab
	$(X) -b $< | $(GR) -v "00000000 00000000 00000000 00000000 00000000 00000000" 
clean:
	rm -rf $(BUILD)
$(BUILD):
	if ! [ -d $(BUILD) ]; then		\
		mkdir $(BUILD);			\
	fi
