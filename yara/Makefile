include ../Makefile.config

SRC_PATH=$(shell realpath ./yara-master)
BUILD_DIR=build

INCLUDES=-I $(SRC_PATH)/libyara/include
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES) -g
LDFLAGS=-lm -lpthread

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c
	$(WLLVM) -c $(CFLAGS) -DTEST_SYMBOLIC $< -o $@

$(SRC_PATH):
	unzip yara-master.zip

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${SRC_PATH}; ./bootstrap.sh; cd -
	cd ${BUILD_DIR}; $(SRC_PATH)/configure --without-crypto CC=$(WLLVM) CFLAGS="-g"; cd -

$(BUILD_DIR)/libyara/.libs/libyara.a: $(BUILD_DIR)
	make -C $(BUILD_DIR) -j4

$(TARGET): $(BUILD_DIR)/libyara/.libs/libyara.a main.o
	$(WLLVM) $(CFLAGS) $(LDFLAGS) -L$(KLEE_BUILD)/lib/ main.o $(BUILD_DIR)/libyara/.libs/libyara.a -o $@

$(BC_TARGET): $(TARGET)
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll
