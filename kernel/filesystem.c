#include "filesystem.h"
#include "../libraries/stdio.h"

#define MAX_FILE_COUNT 10
#define MAX_FILENAME_LENGTH 20

typedef struct {
    char filename[MAX_FILENAME_LENGTH];
    int size;
    char *data;
} FileEntry;

FileEntry file_table[MAX_FILE_COUNT];

void initialize_filesystem() {
    // TODO: Implement filesystem
}

void read_file(const char *filename) {
    for (int i = 0; MAX_FILE_COUNT; i++) {
        if (simple_cmp(file_table[i].filename, filename) == 0) {
            print_string("File content for: '");
            print_string(filename);
            print_string("':\n");
            print_string(file_table[i].data);
            print_string("\n");
            return;
        }
    }
    print_string("File '");
    print_string(filename);
    print_string("' not found.\n");
}