include ../Makefile.config

SRC=$(shell realpath ./m4-1.4.18)

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})

BUILD=$(CURDIR)/build
BUILD_GCOV=$(CURDIR)/build_gcov
TARGET=$(BUILD)/src/m4.bc
TARGET_GCOV=all-gcov

CONF_FLAGS=--disable-threads --with-included-regex --disable-largefile
export CFLAGS = -O1 -Xclang -disable-llvm-passes -g -rtlib=compiler-rt -D__NO_STRING_INLINES  -D_FORTIFY_SOURCE=0 -U__OPTIMIZE__

.PHONY: $(TARGET_GCOV)

$(SRC):
	tar xzf m4-1.4.18.tar.gz

$(BUILD): $(SRC)
	rm -rf $(BUILD) && mkdir $(BUILD)
	cd $(BUILD) ; CC=$(WLLVM) $(SRC)/configure $(CONF_FLAGS); cd -

$(BUILD_GCOV): $(SRC)
	rm -rf $(BUILD_GCOV) && mkdir $(BUILD_GCOV)
	cd $(BUILD_GCOV) ; CC=gcc CFLAGS="$(COVERAGE_CFLAGS)" LDFLAGS="$(COVERAGE_LDFLAGS)" $(SRC)/configure $(CONF_FLAGS); cd -

$(TARGET): $(BUILD)
	make -C $(BUILD) -j4
	$(EXTRACT_BC) $(BUILD)/src/m4 -o $@

$(TARGET_GCOV): $(BUILD_GCOV)
	make -C $(BUILD_GCOV) -j4

all: $(TARGET)

clean:
	rm -rf $(BUILD) $(BUILD_GCOV)
