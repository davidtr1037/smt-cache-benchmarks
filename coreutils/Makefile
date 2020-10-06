include ../Makefile.config

SRC=$(shell realpath ./coreutils-8.31)

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})

BUILD=$(CURDIR)/build

CONF_FLAGS=
CFLAGS="-g"

$(SRC):
	tar xJf coreutils-8.31.tar.xz

$(BUILD): $(SRC)
	rm -rf $(BUILD) && mkdir $(BUILD)
	cd $(BUILD) ; CC=$(WLLVM) $(SRC)/configure $(CONF_FLAGS) CFLAGS=$(CFLAGS); cd -

all: $(BUILD)
	make -C $(BUILD) -j4
	$(shell ./extract_bc.sh)

clean:
	rm -rf $(BUILD)
