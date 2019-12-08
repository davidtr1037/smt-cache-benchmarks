SRC=$(shell realpath ./m4-1.4.18)

export CFLAGS = -O1 -Xclang -disable-llvm-passes -g -rtlib=compiler-rt -D__NO_STRING_INLINES  -D_FORTIFY_SOURCE=0 -U__OPTIMIZE__

BUILD=./build
TARGET=$(BUILD)/src/m4.bc

$(SRC):
	tar xzf m4-1.4.18.tar.gz

$(BUILD): $(SRC)
	rm -rf $(BUILD) && mkdir $(BUILD)
	cd $(BUILD) ; CC=wllvm $(SRC)/configure --disable-threads --with-included-regex --disable-largefile; cd -

$(TARGET): $(BUILD)
	make -C $(BUILD) -j4
	extract-bc $(BUILD)/src/m4 -o $@

all: $(TARGET)

clean:
	rm -rf $(BUILD)
