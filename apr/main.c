/**
 * apr tutorial sample code
 * http://dev.ariel-networks.com/apr/
 */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include <apr_general.h>
#include <apr_hash.h>
#include <apr_strings.h>

#ifdef KLEE
void klee_make_symbolic(void* p1, int i, char* p) {}
void klee_assume(int i) {}
void klee_open_merge() {}
void klee_close_merge() {}
#endif

unsigned int custom_hash(const char *char_key, apr_ssize_t *klen) {
    register size_t val = 0;
    register char ch;

    for (unsigned int i = 0; i < *klen; i++) {
        ch = char_key[i];
        val = (val << 7) + (val >> (sizeof(val) * 8 - 7)) + ch;
    }
    return val;
}

void symbolic_lookup(apr_hash_t *ht) {
    int *key = malloc(sizeof(*key));
    klee_make_symbolic(key, sizeof(*key), "key");
    const char *val = apr_hash_get(ht, key, sizeof(*key));
}

int main(int argc, const char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage...\n");
        return 1;
    }

    unsigned n = 0;
    sscanf(argv[1], "%u", &n);

    apr_initialize();

    apr_pool_t *mp;
    apr_hash_t *ht;
    apr_pool_create(&mp, NULL);
    ht = apr_hash_make(mp);

    for (unsigned int i = 0; i < n; i++) {
        //apr_pool_t *mp;
        //apr_hash_t *ht;
        //apr_pool_create(&mp, NULL);
        //ht = apr_hash_make_custom(mp, custom_hash);
        int* c = malloc(sizeof(*c));
        *c = i;
        apr_hash_set(ht, c, sizeof(*c),  "A");
        symbolic_lookup(ht);
    }

    //apr_pool_destroy(mp);
    //apr_terminate();
    return 0;
}
