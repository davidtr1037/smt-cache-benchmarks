include ../Makefile.config

SRC_PATH=$(shell realpath ./expat-2.2.9)

BUILD=build
INCLUDES=-I $(KLEE_SRC)/include -I $(SRC_PATH)/include -I $(SRC_PATH) -I $(BUILD)
DEFINES=

CFLAGS=$(INCLUDES) $(DEFINES) -g
LDFLAGS=-lm -lz

$(SRC_PATH): $(SRC_PATH).tar.bz2
	tar -xjf $^

CONF_FLAGS=

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD): $(SRC_PATH)
	mkdir -p $(BUILD)
	cd $(BUILD); $(SRC_PATH)/configure $(CONF_FLAGS) CC=$(WLLVM) CFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"; cd -

$(BUILD)/lib/.libs/libexpat.a: $(BUILD)
	make -C $(BUILD) -j4

$(TARGET): main.o $(BUILD)/lib/.libs/libexpat.a
	$(WLLVM) $(CFLAGS) $(LDFLAGS) $^ -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(BC_TARGET) *.o *.bc *.ll $(BUILD)
