include ../Makefile.config
SRC_PATH=$(shell realpath ./yaml-0.1.5)

INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES)
LDFLAGS=

$(SRC_PATH): $(SRC_PATH).tar.gz
	tar -xf $^

BUILD_DIR=build

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR}; $(SRC_PATH)/configure --enable-trace=no CC=$(WLLVM) CFLAGS="-g -fno-inline"

$(BUILD_DIR)/src/osipparser2/.libs/libosipparser2.a: $(BUILD_DIR)
	make -C ${BUILD_DIR} -j4

$(TARGET): main.o $(BUILD_DIR)/src/.libs/libyaml.a 
	$(WLLVM) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda $(BUILD_DIR)
