
void print_string(const char *str) {
    while (*str != '\0') {
        unsigned char* video_memory = (unsigned char*)0xB8000;
        *video_memory = *str;
        video_memory += 2;
        str++;
    }
}

int simple_cmp(const char* str1, const char* str2)
{
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }
    return *(unsigned char*)str1 - *(unsigned char*)str2;
}