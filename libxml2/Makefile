include ../Makefile.config
SRC_PATH=$(shell realpath ./libxml2-2.9.8)

INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES)
LDFLAGS=-lm -lz

$(SRC_PATH): $(SRC_PATH).tar.gz
	tar -xf $^

BUILD_DIR=build

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR}; $(SRC_PATH)/configure --without-iconv CC=$(WLLVM) CFLAGS="-g"

$(BUILD_DIR)/.libs/libxml2.a: $(BUILD_DIR)
	make -C ${BUILD_DIR} -j4

$(TARGET): main.o $(BUILD_DIR)/.libs/libxml2.a 
	$(WLLVM) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda $(BUILD_DIR)
