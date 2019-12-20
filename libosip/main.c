#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>
#include "klee/klee.h"

#include <osipparser2/osip_message.h>
#include <osipparser2/osip_parser.h>

int main(int argc, char *argv[]) {
    char *buf = NULL;

    if (argc < 2) {
        return 1;
    }

    size_t size = strtoul(argv[1], NULL, 10);
    buf = malloc(size);

    /* initialize input */
    if (argc == 3) {
        FILE *f = fopen(argv[2], "r");
        fread(buf, 1, size, f);
        fclose(f);
    } else {
        klee_make_symbolic(buf, size, "buf");
    }
    buf[size - 1] = 0;

    parser_init();

    int rc;
    osip_message_t *sip;

    rc = osip_message_init(&sip);
    if (rc != 0) { 
        fprintf(stderr, "cannot allocate\n"); 
        return -1; 
    }

    osip_message_parse(sip, (const char *)(buf), size);

    return 0;
}
