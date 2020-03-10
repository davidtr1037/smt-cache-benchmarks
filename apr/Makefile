include ../Makefile.config

SRC_PATH=$(shell realpath ./apr-1.6.3)
BUILD=$(shell realpath ./build)
BUILD_GCOV=$(shell realpath ./build_gcov)

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
TARGET_GCOV=test_driver_gcov

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

%.gcov.o: %.c $(SRC_PATH)
	$(CC) -c $(CFLAGS) $(COVERAGE_CFLAGS) $< -o $@

$(BUILD): $(SRC_PATH)
	mkdir -p $(BUILD)
	cd $(BUILD); CC=$(WLLVM) CFLAGS="$(CFLAGS)" $(SRC_PATH)/configure $(CONF_FLAGS); cd -

$(BUILD_GCOV): $(SRC_PATH)
	rm -rf $(BUILD_GCOV) && mkdir $(BUILD_GCOV)
	cd $(BUILD_GCOV); $(SRC_PATH)/configure CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" $(CONF_FLAGS); cd -

$(BUILD)/.libs/libapr-1.a: $(BUILD)
	cd $(BUILD); make -C $(BUILD) -j4; cd -

$(TARGET): $(BUILD) main.o $(BUILD)/.libs/libapr-1.a
	$(WLLVM) $(CFLAGS) $(LDFLAGS) main.o $(BUILD)/.libs/libapr-1.a -o $@

$(TARGET_GCOV): $(BUILD_GCOV) main.gcov.o
	make -C $(BUILD_GCOV) -j4
	$(CC) $(CFLAGS) $(COVERAGE_CFLAGS) $(LDFLAGS) $(COVERAGE_LDFLAGS) main.gcov.o $(BUILD_GCOV)/.libs/libapr-1.a -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@

clean:
	rm -rf $(BUILD) $(TARGET) $(BC_TARGET) $(TARGET_GCOV) *.o *.bc *.ll
