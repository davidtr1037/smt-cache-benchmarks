#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <libgen.h>

#include <libtasn1.h>
#include "klee/klee.h"

void klee_make_symbolic(void *addr, size_t nbytes, const char *name) {

}

void run(unsigned int buf_size, char *def, char *ktest) {
    int result;
    asn1_node definitions = NULL;
    asn1_node element = NULL;
    char error[ASN1_MAX_ERROR_DESCRIPTION_SIZE];
    unsigned char *buf = NULL;

    result = asn1_parser2tree(def, &definitions, error);
    if (result != ASN1_SUCCESS) {
        printf("asn1_parser2tree: %s\n", error);
        return;
    }

    result = asn1_create_element(definitions, "Protocol.Message", &element);
    if (result != ASN1_SUCCESS) {
        printf("asn1_create_element: %s\n", error);
        return;
    }

    fprintf(stderr, "buffer size = %u\n", buf_size);
    buf = malloc(buf_size);

    /* initialize input */
    if (ktest) {
        FILE *f = fopen(ktest, "r");
        fread(buf, 1, buf_size, f);
        fclose(f);
    } else {
        klee_make_symbolic(buf, buf_size, "buf");
    }
    //memcpy(buf, INPUT, sizeof(INPUT) - 1);

    result = asn1_der_decoding(&element, buf, buf_size, error);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        return 1;
    }

    char def_path[PATH_MAX] = {0,};
    strcpy(def_path, argv[1]);
    unsigned int k = strtoul(argv[2], NULL, 10);
    if (argc == 4) {
        run(k, def_path, argv[3]);
    } else {
        run(k, def_path, NULL);
    }

    return 0;
}
