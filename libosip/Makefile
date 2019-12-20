include ../Makefile.config
SRC_PATH=$(shell realpath ./libosip2-5.0.0/)

INCLUDES=-I $(KLEE_PATH)/include -I $(SRC_PATH)/include
DEFINES=

COVERAGE_CFLAGS=-fprofile-arcs -ftest-coverage
COVERAGE_LDFLAGS=-lgcov --coverage

CFLAGS=$(INCLUDES) $(DEFINES)
LDFLAGS=

$(SRC_PATH): $(SRC_PATH).tar.gz
	tar -xf $^

BUILD_DIR=build
GCOV_BUILD_DIR=build_gcov

TARGET=test_driver
TARGET_GCOV=test_driver_gcov
BC_TARGET=test_driver.bc

%.o: %.c $(SRC_PATH)
	$(WLLVM) -c $(CFLAGS) $< -o $@

%.gcov.o: %.c $(SRC_PATH)
	$(CC) -c $(CFLAGS) $(COVERAGE_CFLAGS) $< -o $@

$(GCOV_BUILD_DIR): $(SRC_PATH)
	rm -rf ${GCOV_BUILD_DIR} && mkdir ${GCOV_BUILD_DIR}
	cd ${GCOV_BUILD_DIR}; $(SRC_PATH)/configure --enable-trace=no CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)"; cd -

$(BUILD_DIR): $(SRC_PATH)
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR}; $(SRC_PATH)/configure --enable-trace=no CC=$(WLLVM) CFLAGS="-g -fno-inline"

$(GCOV_BUILD_DIR)/src/osipparser2/.libs/libosipparser2.a: $(GCOV_BUILD_DIR)
	make -C ${GCOV_BUILD_DIR} -j4

$(BUILD_DIR)/src/osipparser2/.libs/libosipparser2.a: $(BUILD_DIR)
	make -C ${BUILD_DIR} -j4

$(TARGET_GCOV): main.gcov.o $(GCOV_BUILD_DIR)/src/osipparser2/.libs/libosipparser2.a
	$(CC) $(CFLAGS) $(LDFLAGS) $(COVERAGE_CFLAGS) $(COVERAGE_LDFLAGS) -L$(KLEE_BUILD)/lib/ $^ -o $@ -lkleeRuntest

$(TARGET): main.o $(BUILD_DIR)/src/osipparser2/.libs/libosipparser2.a 
	$(WLLVM) $(CFLAGS) $(LDFLAGS) -L$(KLEE_BUILD)/lib/ $^ -o $@ -lkleeRuntest

$(BC_TARGET): $(TARGET) 
	$(EXTRACT_BC) $< -o $@
	$(OPT) -mem2reg $@ -o $@
	$(LLVM_DIS) $@

clean:
	rm -rf $(TARGET) $(TARGET_GCOV) $(BC_TARGET) *.o *.bc *.ll *.gcno *.gcda ${BUILD_DIR} ${GCOV_BUILD_DIR}

col-klee-out-%:
	rm -rf $@
	klee -max-instructions=4136455057 -no-output -search=dfs -pta-target=osip_message_parse:45 -use-pta-mode=$(@:col-klee-out-%=%) -output-dir=$@ -compute-colours -create-unique-as=1 -use-strong-updates=0 test_driver.bc 20

%.colours: col-klee-out-%
	cat $</colours | sort -u -k 1,2 > $@

%.transitions: col-klee-out-%
	awk '{print $0}' $</*.colourTransitions | sort |  datamash -g1 count 1 > $@

colours: static.colours symbolic.colours
transitions: static.transitions symbolic.transitions
