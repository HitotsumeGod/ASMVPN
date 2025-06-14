CC=gcc
AS=nasm
LD=ld
DBG=gdb
DIS=objdump
CPY=objcopy
X=xxd
GR=grep
SRC=src
UTILS=$(SRC)/utils
BUILD=build
PROG=$(BUILD)/ab
OBJ=$(BUILD)/vpn.o
SRS=$(SRC)/vpn.s

$(PROG): $(OBJ)
	$(LD) -o $@ $^ 
$(OBJ): $(SRS) $(BUILD)
	$(AS) -f elf64 -o $@ $<
$(BUILD):
	if ! [ -d $(BUILD) ]; then		\
		mkdir $(BUILD);			\
	fi
tuns: $(UTILS)/tuns.c
	$(CC) -S -o $@.s $< -masm=intel -fno-asynchronous-unwind-tables
debug: $(SRS) $(BUILD)
	$(AS) -f elf64 -o $(OBJ) $< -g
	$(LD) -o $(PROG) $(OBJ)
	$(DBG) $(PROG)
dump: $(PROG)
	$(DIS) -d $< 
bdump: $(PROG)
	$(CPY) -j .text $^ $(BUILD)/text.bin
	$(X) -b $(BUILD)/text.bin | $(GR) -v "00000000 00000000 00000000 00000000 00000000 00000000" 
clean:
	rm -rf $(BUILD)
	rm -rf *.s
