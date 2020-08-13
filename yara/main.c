#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>

#include <yara.h>
#include <yara/compiler.h>

const char *RULES = \
    "rule A\n" \
    "{\n" \
        "strings:\n" \
            "$z = \"s\"\n" \
        "condition:\n" \
            "$z\n" \
    "}\n" \
    ;

void klee_make_symbolic(void *addr, size_t nbytes, const char *name) {

}

int main(int argc, char *argv[]) {
    //char data[1000] = {0,};
    YR_COMPILER* compiler = NULL;
    YR_RULES *rules = NULL;

    //FILE *f = fopen(argv[1], "r");
    //if (!f) {
    //    return 1;
    //}
    //size_t size = fread(data, 1, sizeof(data), f);
    //printf("%s %lu\n", data, size);
    //return 0;
    printf("%s\n", RULES);

    if (yr_initialize() != ERROR_SUCCESS) {
        return 0;
    }

    if (yr_compiler_create(&compiler) != ERROR_SUCCESS) {
        return 0;
    }

    //if (yr_compiler_add_string(compiler, RULES, NULL) == 0) {
    //    yr_compiler_get_rules(compiler, &rules);
    //} else {
    //    printf("error...\n");
    //}

    char v1[2];
    klee_make_symbolic(v1, sizeof(v1), "v1");
    v1[sizeof(v1) - 1] = 0;

    char v2[2];
    klee_make_symbolic(v2, sizeof(v2), "v2");
    v2[sizeof(v2) - 1] = 0;

    if (yr_compiler_define_integer_variable(compiler, "a", 0) != ERROR_SUCCESS) {
        return 1;
    }
    if (yr_compiler_define_integer_variable(compiler, v1, 0) != ERROR_SUCCESS) {
        return 1;
    }
    if (yr_compiler_define_integer_variable(compiler, v2, 0) != ERROR_SUCCESS) {
        return 1;
    }

    //yr_compiler_destroy(compiler);
    return 0;
}
