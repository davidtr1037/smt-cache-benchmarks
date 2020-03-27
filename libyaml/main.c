#include <yaml.h>

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

#define INPUT "0\x01$\x80\x00\x00\xff\x80\x80\xff" // "items:\n- A\n- B"

void klee_make_symbolic(void *addr, size_t nbytes, const char *name) {

}

void parse(yaml_parser_t* parser, unsigned char *buf, unsigned int size) {
    bool done = false;
    yaml_parser_set_input_string(parser, buf, size);
    yaml_token_t token;
    while (!done) {
        if (!yaml_parser_scan(parser, &token)) {
            //fprintf(stderr, "yaml_parser_parse failed\n");
            break;
        }

        if (token.type == YAML_STREAM_END_TOKEN) {
            done = true;
        }

        yaml_token_delete(&token);
    }
}

int main(int argc, char *argv[]) {
    yaml_parser_t parser;
    unsigned char *buf = NULL;

    if (argc < 2) {
        return 1;
    }

    unsigned int size = strtoul(argv[1], NULL, 10);
    buf = malloc(size);

    /* initialize input */
    if (argc == 3) {
        FILE *f = fopen(argv[2], "r");
        fread(buf, 1, size, f);
        fclose(f);
    } else {
        klee_make_symbolic(buf, size, "buf");
    }
    //memcpy(buf, INPUT, sizeof(INPUT) - 1);

    /* initialize parser */
    if (!yaml_parser_initialize(&parser)) {
        return 1;
    }
    parse(&parser, buf, size);
    yaml_parser_delete(&parser);

    return 0;
}
