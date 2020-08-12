#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <expat.h>

#define INPUT "<x>a</x>"

void klee_make_symbolic(void *p, size_t n, const char *name) {

}

void klee_assume(uintptr_t c) {

}

int main() {
    int z;
    klee_make_symbolic(&z, sizeof(z), "z");

    char buffer[7];
    klee_make_symbolic(buffer, sizeof(buffer), "buffer");
    buffer[sizeof(buffer) - 1] = 0;
    //buffer[0] = '<';
    //buffer[1] = 'x';
    //buffer[2] = '>';
    //buffer[3] = '<';
    //buffer[4] = '/';
    //buffer[5] = 'x';
    //buffer[6] = '>';
    //buffer[4] = '<';
    //buffer[5] = '/';
    //buffer[6] = 'x';
    //buffer[7] = '>';
    //klee_assume(buffer[1] >= 'a');
    //klee_assume(buffer[1] <= 'b');

    //if (z) {
    //    printf("z...\n");
    //}

    XML_Parser p = XML_ParserCreate(NULL);
    XML_SetHashSalt(p, 17);

    if (XML_Parse(p, buffer, sizeof(buffer) - 1, XML_FALSE) == XML_STATUS_ERROR) {
        return 1;
    }

    return 0;
}
