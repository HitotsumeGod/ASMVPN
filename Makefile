AS=nasm
LD=ld
DBG=gdb
DIS=objdump
SRC=src
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
debug: $(SRS) $(BUILD)
	$(AS) -f elf64 -o $(OBJ) $< -g
	$(LD) -o $(PROG) $(OBJ)
	$(DBG) $(PROG)
dump: $(PROG)
	$(DIS) -d $< 
clean:
	rm -rf $(BUILD)
