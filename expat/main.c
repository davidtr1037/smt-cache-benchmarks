#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <expat.h>

#define INPUT "<x>a</x>"

void klee_make_symbolic(void *p, size_t n, const char *name) {

}

void klee_assume(uintptr_t c) {

}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage..\n");
        return 1;
    }

    size_t size = strtoul(argv[1], NULL, 10);
    char *buffer = malloc(size);
    klee_make_symbolic(buffer, size, "buffer");
    //buffer[size - 1] = 0;

    XML_Parser p = XML_ParserCreate("iso-8859-1");
    XML_SetHashSalt(p, 17);

    if (XML_Parse(p, buffer, size, XML_FALSE) == XML_STATUS_ERROR) {
        return 1;
    }

    return 0;
}
