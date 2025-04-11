#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Функция для получения "куска" строки (цифрового или текстового)
char* getChunk(const char* s, int slength, int* marker) {
    // Выделяем память для куска строки (+1 для нулевого символа)
    char* chunk = malloc(slength + 1);
    if (!chunk) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    int chunk_index = 0;
    char c = s[*marker];
    chunk[chunk_index++] = c;
    (*marker)++;

    // Если первый символ цифра, собираем все последующие цифры
    if (isdigit(c)) {
        while (*marker < slength) {
            c = s[*marker];
            if (!isdigit(c)) break;
            chunk[chunk_index++] = c;
            (*marker)++;
        }
    }
    // Иначе собираем все последующие нецифровые символы
    else {
        while (*marker < slength) {
            c = s[*marker];
            if (isdigit(c)) break;
            chunk[chunk_index++] = c;
            (*marker)++;
        }
    }

    chunk[chunk_index] = '\0'; // Завершаем строку нулевым символом
    return chunk;
}

// Функция сравнения строк по алгоритму Alphanum
int compareStrings(const void* a, const void* b) {
    const char* s1 = *(const char**)a;
    const char* s2 = *(const char**)b;

    // Сравниваем NULL-значения
    if (s1 == NULL && s2 == NULL) return 0; // Оба NULL — равны
    if (s1 == NULL) return -1; // NULL меньше любой строки
    if (s2 == NULL) return 1;  // Любая строка больше NULL

    int thisMarker = 0;
    int thatMarker = 0;
    int s1Length = strlen(s1);
    int s2Length = strlen(s2);

    // Сравниваем строки по "кусочкам"
    while (thisMarker < s1Length && thatMarker < s2Length) {
        char* thisChunk = getChunk(s1, s1Length, &thisMarker);
        char* thatChunk = getChunk(s2, s2Length, &thatMarker);

        int result = 0;

        // Если оба "куска" числовые, сравниваем их как числа
        if (isdigit(thisChunk[0]) && isdigit(thatChunk[0])) {
            int thisChunkLength = strlen(thisChunk);
            int thatChunkLength = strlen(thatChunk);

            // Сначала сравниваем длины чисел
            result = thisChunkLength - thatChunkLength;
            if (result == 0) {
                // Если длины равны, сравниваем посимвольно
                for (int i = 0; i < thisChunkLength; i++) {
                    result = thisChunk[i] - thatChunk[i];
                    if (result != 0) {
                        free(thisChunk);
                        free(thatChunk);
                        return result;
                    }
                }
            }
        }
        // Если хотя бы один "кусок" текстовый, сравниваем через strcmp
        else {
            result = strcmp(thisChunk, thatChunk);
        }

        // Освобождаем память после использования
        free(thisChunk);
        free(thatChunk);

        // Если результат сравнения не ноль, возвращаем его
        if (result != 0) return result;
    }

    // Если все "куски" равны, сравниваем длины строк
    return s1Length - s2Length;
}

int main() {
    // Исходный массив строк (может содержать NULL)
    const char* values[] = {
        "dazzle2", NULL, "dazzle10", "dazzle1", "dazzle2.7",
        "dazzle2.10", "2", "10", "1",
        "EctoMorph6", "EctoMorph62", "EctoMorph7", NULL
    };
    int count = sizeof(values) / sizeof(values[0]);

    // Создаем копию массива для сортировки
    const char** sorted = malloc(count * sizeof(const char*));
    if (!sorted) {
        fprintf(stderr, "Memory allocation failed\n");
        return EXIT_FAILURE;
    }
    memcpy(sorted, values, count * sizeof(const char*));

    // Сортируем массив строк с использованием функции сравнения
    qsort(sorted, count, sizeof(const char*), compareStrings);

    // Выводим отсортированный массив
    for (int i = 0; i < count; i++) {
        if (sorted[i] == NULL) {
            printf("NULL ");
        } else {
            printf("%s ", sorted[i]);
        }
    }
    printf("\n");

    // Освобождаем память
    free(sorted);
    return 0;
}