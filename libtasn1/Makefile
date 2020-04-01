include ../Makefile.config
SRC_PATH=$(shell realpath ./libtasn1-4.6/)

INCLUDES=-I $(SRC_PATH)/lib -I $(SRC_PATH)/gl -I $(SRC_PATH)/src -I $(KLEE_SRC)/include 
DEFINES=

COVERAGE_CFLAGS=-fprofile-arcs -ftest-coverage
COVERAGE_LDFLAGS=-lgcov --coverage

CFLAGS=$(INCLUDES) $(DEFINES)
LDFLAGS=

BUILD_DIR=build
GCOV_BUILD_DIR=build_gcov

TARGET=test_driver
TARGET_GCOV=test_driver_gcov
BC_TARGET=test_driver.bc

$(SRC_PATH):
	wget -qO- https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.6.tar.gz | tar xz

%.o: %.c $(SRC_PATH)
	$(WLLVM) -g -c $(CFLAGS) $< -o $@

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR}; $(SRC_PATH)/configure CC=$(WLLVM) CFLAGS="-g -fno-inline"; cd -

$(BUILD_DIR)/lib/.libs/libtasn1.a: $(BUILD_DIR)
	make -C ${BUILD_DIR} -j4

$(TARGET): main.o $(BUILD_DIR)/lib/.libs/libtasn1.a $(BUILD_DIR)/gl/.libs/libgnu.a
	$(WLLVM) -g $(CFLAGS) $(LDFLAGS) -L$(KLEE_BUILD)/lib/ $^ -o $@

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(TARGET_GCOV) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda ${BUILD_DIR} ${GCOV_BUILD_DIR}
