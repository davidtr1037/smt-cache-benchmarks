SRC_PATH=$(shell realpath ./json-c/)

INCLUDES=-I $(SRC_PATH) -I ./build/
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES) -g
LDFLAGS=
CC=gcc
OPT=opt
LLVM_DIS=llvm-dis
WLLVM=wllvm
EXTRACT_BC=extract-bc

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c
	$(WLLVM) -c $(CFLAGS) -DTEST_SYMBOLIC $< -o $@

.PHONY: json_archive

json_archive: build
	#rm -rf build && mkdir build
	#cd build; $(SRC_PATH)/configure CC=$(WLLVM) CFLAGS="-g"
	make -C ./build -j4

$(TARGET): json_archive main.o
	$(WLLVM) $(CFLAGS) $(LDFLAGS) main.o ./build/.libs/libjson-c.a -o $@

$(BC_TARGET): $(TARGET) json_archive
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll
