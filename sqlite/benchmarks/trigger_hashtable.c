#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "sqlite3.h"
#include "klee/klee.h"

#define SZ 4400
#define N 4
#define QUERY_MAX_SIZE (1000)

void klee_make_symbolic(void *p, size_t n, const char *name) {

}

void klee_assume(uintptr_t condition) {

}

int populate_db(sqlite3* db, const char *table_name, int triggers_number, const char *prefix, char start) {
    char *query = malloc(QUERY_MAX_SIZE);
    char *err_msg;
    snprintf(query, QUERY_MAX_SIZE, "CREATE TABLE %s (a int, b int)", table_name);
    if (sqlite3_exec(db, query, NULL, NULL, &err_msg)) {
        fprintf(stderr, "sqlite3_exec failed: %s\n", err_msg);
        return 1;
    }

    for (int i = 0; i < triggers_number; i++) {
        fprintf(stderr, "Creating trigger #%d\n", i);
        snprintf(query, QUERY_MAX_SIZE, "CREATE TRIGGER %s%c AFTER INSERT ON %s BEGIN INSERT INTO %s VALUES(1,2); END;", prefix, start + i, table_name, table_name);
        if (sqlite3_exec(db, query, NULL, NULL, &err_msg)) {
            fprintf(stderr, "sqlite3_exec failed: %s\n", err_msg);
            return 1;
        }
    }
    return 0;

}

void symbolic_create_trigger(sqlite3* db, const char *table_name, int triggers_number, const char *prefix, char start, char *name) {
    sqlite3_stmt *res;
    char *template = malloc(QUERY_MAX_SIZE);
    snprintf(template, QUERY_MAX_SIZE, "CREATE TRIGGER %s? AFTER INSERT ON %s BEGIN INSERT INTO %s VALUES(1,2); END;", prefix, table_name, table_name);

    size_t query_size = strlen(template) + 1;
    char *query = malloc(query_size);
    klee_make_symbolic(query, query_size, name);
    for (int i = 0; template[i] != '\0'; i++) {
        if (template[i] == '?') {
            //klee_assume(query[i] >= start);
            //klee_assume(query[i] < start + triggers_number);
            klee_assume(query[i] >= 'a');
            klee_assume(query[i] <= 'z');
        } else {
            query[i] = template[i];
        }
    }

    int rc = sqlite3_prepare_v2(db, query, -1, &res, 0);    
    if (rc != SQLITE_OK) {
        fprintf(stderr, "sqlite3_prepare_v2 failed: %s\n", sqlite3_errmsg(db));
        return;
    }

    if (sqlite3_step(res) != SQLITE_DONE) {
        fprintf(stderr, "sqlite3_step failed: %s\n", sqlite3_errmsg(db));
        return;
    }

    sqlite3_finalize(res);
}

int main(int argc, char** argv) {
    unsigned triggers_number = 20;
    if (argc >= 2) {
        sscanf(argv[argc - 1], "%u", &triggers_number);
    }

    void *page_cache = malloc(N*SZ);
    sqlite3_config(SQLITE_CONFIG_PAGECACHE, page_cache, SZ, N);
    sqlite3_config(SQLITE_CONFIG_LOOKASIDE, 80, 15);

    sqlite3 *db;
    sqlite3_open(":memory:", &db);

    char *err_msg;
    if (sqlite3_exec(db, "PRAGMA journal_mode = OFF;", NULL, NULL, &err_msg)) {
        fprintf(stderr, "failed to creating pragma: %s\n", err_msg);
        return 1;
    }

    if (populate_db(db, "T1", triggers_number, "trig1_", 'A') != 0) {
        return 1;
    }
    int bound = 3; 
    symbolic_create_trigger(db, "T1", bound, "trig1_", 'A', "sql1");
    symbolic_create_trigger(db, "T1", bound, "trig1_", 'A', "sql2");

    //if (populate_db(db, "T1", triggers_number, "trig1_", 'A') != 0) {
    //    return 1;
    //}
    //symbolic_create_trigger(db, "T1", 3, "trig1_", 'A', "sql1");
    //if (populate_db(db, "T2", triggers_number, "trig2_", 'a') != 0) {
    //    return 1;
    //}
    //symbolic_create_trigger(db, "T2", 3, "trig2_", 'A', "sql2");

    return 0;
}
