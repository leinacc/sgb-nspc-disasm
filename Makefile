all: initialSPC.bin

build/initial.o: code/initial.s
	wla-spc700 -o $@ $<

initialSPC.bin: build/initial.o
	wlalink -S linkfile $@
