#ifndef HASH_TABLE_H
#define HASH_TABLE_H

typedef enum {INT_TYPE, BOOL_TYPE} Type;

typedef struct node {
    char* name;
    int int_value;
    int bool_value;
    Type type;
    struct node* next;
} Node;

typedef struct {
    int size;
    Node** table;
} HashTable;

extern HashTable* ht;

HashTable* create_hash_table(int size);
void insert_int(HashTable* ht, char* name, int value);
void insert_bool(HashTable* ht, char* name, int value);
Node* get_int(HashTable* ht, char* name);
Node* get_bool(HashTable* ht, char* name);
void set_int(HashTable* ht, char* name, int new_value);
void set_bool(HashTable* ht, char* name, bool new_value);
void free_hash_table(HashTable* ht);
void print_hash_table(HashTable* ht);

#endif
