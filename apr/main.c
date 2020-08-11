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

static void modify_hashtab(apr_hash_t *ht, int max_table_size)
{
    int *k = malloc(sizeof(int));
    *k=0;
    apr_hash_set(ht, k, sizeof(int), "FOO");

    for(int i = 1; i < max_table_size; i++) {
      int* key = malloc(sizeof(int));
      *key = i;
      apr_hash_set(ht, key, sizeof(int),  "Key value");
      printf("Inserted key %d\n", *key);
    }
}
void lookUp(apr_hash_t* ht,int key) {
    const char *val = apr_hash_get(ht, &key, sizeof(int));
    printf("val for \"key\" is %s\n", val);
}
/**
 * hash table sample code
 * @remark Error checks omitted
 */
unsigned SIZE = 20;
int main(int argc, const char *argv[])
{
    apr_pool_t *mp;
    apr_hash_t *ht;
        
    apr_initialize();
    apr_pool_create(&mp, NULL);
    ht = apr_hash_make(mp);

	  if(argc >= 2) {
    	sscanf(argv[argc-1], "%u", &SIZE);
  	}
    printf("Size %d\n", SIZE);
    modify_hashtab(ht, SIZE);
    int k = 0;
    printf("ht of 2 is %s\n", apr_hash_get(ht, &k, sizeof(k)));
    
    int key;
    klee_make_symbolic(&key, sizeof key, "key");
    lookUp(ht,key);
    
    int key1;
    klee_make_symbolic(&key1, sizeof key1, "key1");
    lookUp(ht,key1);
    
    //apr_pool_destroy(mp);

    //apr_terminate();
    return 0;
}
