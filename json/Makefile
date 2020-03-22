include ../Makefile.config

SRC_PATH=$(shell realpath ./json-c-master)
BUILD_DIR=build

INCLUDES=-I $(SRC_PATH) -I ${BUILD_DIR}
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES) -g
LDFLAGS=

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c
	$(WLLVM) -c $(CFLAGS) -DTEST_SYMBOLIC $< -o $@

$(SRC_PATH): $(SRC_PATH).zip
	unzip $^

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${SRC_PATH}; ./autogen.sh; cd -
	cd ${BUILD_DIR}; $(SRC_PATH)/configure CC=$(WLLVM) CFLAGS="-g"; cd -

$(BUILD_DIR)/.libs/libjson-c.a: $(BUILD_DIR)
	make -C $(BUILD_DIR) -j4

$(TARGET): main.o $(BUILD_DIR)/.libs/libjson-c.a 
	$(WLLVM) $(CFLAGS) $(LDFLAGS) -L$(KLEE_BUILD)/lib/ $^ -o $@

$(BC_TARGET): $(TARGET)
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll
