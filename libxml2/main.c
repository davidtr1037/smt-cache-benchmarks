#include <stdio.h>
#include <string.h>

#include <libxml/tree.h>
#include <libxml/xmlmemory.h>
#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/parserInternals.h>
#include <libxml/xmlerror.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/entities.h>
#include <libxml/encoding.h>
#include <libxml/valid.h>
#include <libxml/xmlIO.h>
#include <libxml/globals.h>
#include <libxml/uri.h>

void klee_make_symbolic(void *addr, size_t nbytes, const char *name) {

}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage..\n");
        return 1;
    }

    size_t size = strtoul(argv[1], NULL, 10);
    char *s = malloc(size);
    printf("input size = %lu\n", size);

    /* initialize input */
    if (argc == 3) {
        FILE *f = fopen(argv[2], "r");
        fread(s, 1, size, f);
        fclose(f);
    } else {
        klee_make_symbolic(s, size, "buf");
    }
    s[size - 1] = '\0';

    LIBXML_TEST_VERSION;
    xmlInitParser();
    htmlParserCtxtPtr ctxt = htmlCreateMemoryParserCtxt(s, size);
    if (ctxt == NULL) {
        return 1;
    }

    htmlDefaultSAXHandlerInit();
    if (ctxt->sax != NULL) {
        memcpy(ctxt->sax, &htmlDefaultSAXHandler, sizeof(xmlSAXHandlerV1));
    }

    htmlParseDocument(ctxt);

    return 0;
}
