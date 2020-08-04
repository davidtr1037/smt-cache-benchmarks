#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include "sqlite3.h"
#include "klee/klee.h"


void klee_make_symbolic(void* p1, size_t i, const char* p) {}
void klee_assume(uintptr_t i) {}

int populate_db(sqlite3* db, int triggers_number) {
    char* sql = malloc(100);
    char *err_msg;
    if(sqlite3_exec(db, "CREATE TABLE tbl (a int, b int)", NULL, NULL, &err_msg)) {
      printf("ERROR creating table: %s\n", err_msg);
      return 1;
    }
      printf("Creating trigger t\n");
    if(sqlite3_exec(db, "CREATE TRIGGER t AFTER INSERT ON tbl BEGIN  insert into tbl values (1,2); END;", NULL, NULL, &err_msg)) {
      printf("ERROR: %s\n", err_msg);
      return 1;
    }
    for(int i = 1; i < triggers_number; i++) {
      printf("Creating trigger #%d\n", i);
      snprintf(sql, 100, "CREATE TRIGGER trig%d AFTER INSERT ON tbl BEGIN insert into tbl values(1,2); END;", i);
      if(sqlite3_exec(db, sql, NULL, NULL, &err_msg)) {
        printf("ERROR creating triggers: %s\n", err_msg);
        return 1;
      }
    }
    return 0;
 
}

void symbolic_create_trigger(sqlite3* db) {
    sqlite3_stmt *res;
    char *s = "create trigger   after insert on tbl begin insert into tbl values(1,2); end;";
    char *sql1 = malloc(strlen(s) + 1);
    klee_make_symbolic(sql1, strlen(s) + 1, "sql1");
    for(int i = 0; s[i] != '\0'; i++) {
      if(i == 15) {
        klee_assume(sql1[i] > 'a');
        klee_assume(sql1[i] < 'z');

      } else
        sql1[i] = s[i];
    }

    int rc = sqlite3_prepare_v2(db, sql1, -1, &res, 0);    
    if(rc != SQLITE_OK) {
      printf("Cannot create prepared statement!\n %s\n exiting\n", sqlite3_errmsg(db));
      exit(1);
    }

    if(sqlite3_step(res) != SQLITE_DONE) {
      printf("Failed to create symbolic trigger , %s\n", sqlite3_errmsg(db));
    }
    //sqlite3_finalize(res);
}

//char page_cache[2048*10 + 1];
#define sz 4400
#define N 4

int main(int argc, char** argv) {

    unsigned triggers_number = 20;
    if(argc >= 2) {
      sscanf(argv[argc - 1], "%u", &triggers_number);
    }
    void *page_cache = malloc(N*sz);
    //sqlite3_config(SQLITE_CONFIG_LOOKASIDE, 0, 0);
    sqlite3_config(SQLITE_CONFIG_PAGECACHE, page_cache, sz, N);
    sqlite3_config(SQLITE_CONFIG_LOOKASIDE, 80, 15);
//    sqlite3_soft_heap_limit(40000);


    sqlite3 *db;
    sqlite3_open(":memory:", &db);
    //sqlite3_db_config(db, SQLITE_DBCONFIG_LOOKASIDE, look_aside, 256,100);
    
    char *err_msg;
    if(sqlite3_exec(db, "PRAGMA journal_mode = OFF;", NULL, NULL, &err_msg)) {
      printf("ERROR creating pragma: %s\n", err_msg);
      return 1;
    }

    if(populate_db(db, triggers_number) != 0) return 1;

    for(int i = 0; i < 2; i++) {
      symbolic_create_trigger(db);
    }
    printf("END\n");

    //sqlite3_close(db);
    return 0;
}
