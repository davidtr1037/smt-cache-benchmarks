include ../Makefile.config

SRC_PATH=$(shell realpath ./apr-1.6.3)
BUILD=$(shell realpath ./build)

INCLUDES=-I $(SRC_PATH)/include -I $(BUILD)/include
DEFINES=
CFLAGS=$(INCLUDES) $(DEFINES) -O0 -DKLEE
LDFLAGS=
CONF_FLAGS=--disable-shared --disable-threads --disable-dso --disable-ipv6 --disable-lfs

all: $(BUILD)

$(SRC_PATH): apr-1.6.3.tar.gz
	tar -xf $^

TARGET=test_driver
BC_TARGET=test_driver.bc

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

$(BUILD): $(SRC_PATH)
	mkdir -p $(BUILD)
	cd $(BUILD); CC=$(WLLVM) CFLAGS="$(CFLAGS)" ../apr-1.6.3/configure $(CONF_FLAGS); cd -

$(BUILD)/.libs/libapr-1.a: $(BUILD)
	cd $(BUILD); make -C $(BUILD) -j4; cd -

$(TARGET): $(BUILD) int_apr_hashtable_x2.o $(BUILD)/.libs/libapr-1.a
	$(WLLVM) $(CFLAGS) $(LDFLAGS) int_apr_hashtable_x2.o $(BUILD)/.libs/libapr-1.a -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@

clean:
	rm -rf $(BUILD) $(TARGET) $(BC_TARGET) *.o *.bc *.ll
