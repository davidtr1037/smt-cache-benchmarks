include ../Makefile.config

SQL_LITE_DIR := $(CURDIR)/sqlite-3.21
BUILD=build

CC=wllvm
AC_FLAGS := -g 

objects := $(wildcard benchmarks/*.c)
objects := $(notdir $(objects:.c=.bc))

SQL_OPTIONS := -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_DEFAULT_MEMSTATUS=0 -DSQLITE_MAX_EXPR_DEPTH=0 -DSQLITE_OMIT_DECLTYPE -DSQLITE_OMIT_DEPRECATED -DSQLITE_OMIT_PROGRESS_CALLBACK -DSQLITE_OMIT_SHARED_CACHE -O1 -Xclang -disable-llvm-passes -g -D__NO_STRING_INLINES

.PHONY: all

all: $(BUILD) $(BUILD)/test_driver.bc

$(BUILD)/sqlite3: $(BUILD)/sqlite3.o $(BUILD)/shell.o
	$(CC) -o $@ $^

$(BUILD)/shell.o: sqlite-3.21/shell.c sqlite-3.21/sqlite3.h 
	$(CC) $(SQL_OPTIONS) -c -o $@ $<

$(BUILD)/sqlite3.o: sqlite-3.21/sqlite3.c sqlite-3.21/sqlite3.h 
	$(CC) $(SQL_OPTIONS) -c -o $@ $<

$(BUILD)/sqlite3.bc: sqlite-3.21/sqlite3.c sqlite-3.21/sqlite3.h 
	$(CC) -emit-llvm $(AC_FLAGS) $(SQL_OPTIONS) -c -o $@ $<

$(BUILD)/%.bc: benchmarks/%.c sqlite-3.21/sqlite3.h
	$(CC) -emit-llvm -c $(AC_FLAGS) -I$(SQL_LITE_DIR) -I$(KLEE_SRC)/include -o $@ $<

$(BUILD)/test_driver.bc: $(BUILD)/trigger_hashtable.bc $(BUILD)/sqlite3.bc
	$(LINK) -o $@ $^

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)
