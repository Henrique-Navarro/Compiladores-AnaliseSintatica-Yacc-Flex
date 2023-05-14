#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "hash_table.h"
HashTable* ht;
#define PRIME 31

int hash(char* key, int size) {
    int hash_value = 0;
    for (size_t i = 0; i < strlen(key); i++) {
        hash_value = (hash_value * PRIME + key[i]) % size;
    }
    return hash_value;
}

HashTable* create_hash_table(int size) {
    HashTable* ht = (HashTable*) malloc(sizeof(HashTable));
    ht->size = size;
    ht->table = (Node**) calloc(size, sizeof(Node*));
    return ht;
}

void insert_int(HashTable* ht, char* name, int value) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == INT_TYPE) {
            node->int_value = value;
            return;
        }
        node = node->next;
    }
    Node* new_node = (Node*) malloc(sizeof(Node));
    new_node->name = name;
    new_node->int_value = value;
    new_node->type = INT_TYPE;
    new_node->next = ht->table[index];
    ht->table[index] = new_node;
}

void insert_bool(HashTable* ht, char* name, int value) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == BOOL_TYPE) {
            node->bool_value = value;
            return;
        }
        node = node->next;
    }
    Node* new_node = (Node*) malloc(sizeof(Node));
    new_node->name = name;
    new_node->bool_value = value;
    new_node->type = BOOL_TYPE;
    new_node->next = ht->table[index];
    ht->table[index] = new_node;
}

Node* get_int(HashTable* ht, char* name) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == INT_TYPE) {
            return node;
        }
        node = node->next;
    }
    return NULL;
}

Node* get_bool(HashTable* ht, char* name) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == BOOL_TYPE) {
            return node;
        }
        node = node->next;
    }
    return NULL;
}

void set_int(HashTable* ht, char* name, int new_value) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == INT_TYPE) {
            node->int_value = new_value;
            return;
        }
        node = node->next;
    }
}

void set_bool(HashTable* ht, char* name, bool value) {
    int index = hash(name, ht->size);
    Node* node = ht->table[index];
    while (node != NULL) {
        if (strcmp(node->name, name) == 0 && node->type == BOOL_TYPE) {
            node->bool_value = value;
            return;
        }
        node = node->next;
    }
}


void print_hash_table(HashTable* ht) {
    printf("\nTabela de Símbolos\n");
    printf("----------------------------------\n");
    printf("%-10s | %-10s | %-10s\n", "Nome", "Valor", "Tipo");
    printf("----------------------------------\n");
    for (int i = 0; i < ht->size; i++) {
        Node* node = ht->table[i];
        while (node != NULL) {
            printf("%-10s | ", node->name);
            if (node->type == INT_TYPE) {
                printf("%-10d | %-10s\n", node->int_value, "inteiro");
            } else {
                printf("%-10s | %-10s\n", node->bool_value ? "true" : "false", "logico");
            }
            node = node->next;
        }
    }
}


void free_hash_table(HashTable* ht) {
    for (int i = 0; i < ht->size; i++) {
        Node* node = ht->table[i];
        while (node != NULL) {
            Node* temp = node;
            node = node->next;
            free(temp);
        }
    }
    free(ht->table);
    free(ht);
}