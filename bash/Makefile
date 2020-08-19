include ../Makefile.config

SRC=$(shell realpath ./bash-5.0)
BUILD=$(shell realpath ./build)
TARGET=$(BUILD)/bash
BC_TARGET=$(BUILD)/bash.bc

CONF_FLAGS=--disable-nls --disable-largefile --enable-minimal-config --without-bash-malloc
CFLAGS=-g

.PHONY: all

$(SRC): bash.patch
	tar xzf bash-5.0.tar.gz
	patch -p1 < $<

$(BUILD): $(SRC)
	mkdir $(BUILD)
	cd $(BUILD) ; $(SRC)/configure CC=$(WLLVM) CFLAGS=$(CFLAGS) $(CONF_FLAGS); cd -

bash: $(BUILD)
	make -C $(BUILD) -j4

$(BC_TARGET): bash
	$(EXTRACT_BC) $(TARGET)

all: $(BC_TARGET)

clean:
	rm -rf $(SRC) $(BUILD)
