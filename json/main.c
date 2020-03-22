#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>

#include <json.h>

void klee_make_symbolic(void *addr, size_t nbytes, const char *name) {

}

#define KSIZE (1)

void lookup(json_object *o) {
    char *k = calloc(KSIZE + 1, 1);
    klee_make_symbolic(k, KSIZE + 1, "k");
    k[KSIZE] = '\0';
    json_object_object_get(o, k);
}

void test() {
    struct json_object *obj1 = json_object_new_object();
    for (unsigned i = 0; i < 4; i++) {
        char *k = malloc(KSIZE + 1);
        sprintf(k, "%c", 'a' + i);
        json_object_object_add(obj1, k, json_object_new_int(123));
        lookup(obj1);
    }
}

int main(int argc, char *argv[]) {
    test();
    return 0;
}
