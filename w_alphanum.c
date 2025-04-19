#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>
#include <wctype.h>

// Функция для получения "куска" строки (цифрового или текстового)
wchar_t* getChunk(const wchar_t* s, int slength, int* marker) {
    // Выделяем память для куска строки (+1 для нулевого символа)
    wchar_t* chunk = malloc((slength + 1) * sizeof(wchar_t));
    if (!chunk) {
        fwprintf(stderr, L"Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }

    int chunk_index = 0;
    wchar_t c = s[*marker];
    chunk[chunk_index++] = c;
    (*marker)++;

    // Если первый символ цифра, собираем все последующие цифры
    if (iswdigit(c)) {
        while (*marker < slength) {
            c = s[*marker];
            if (!iswdigit(c)) break;
            chunk[chunk_index++] = c;
            (*marker)++;
        }
    } 
    // Иначе собираем все последующие нецифровые символы
    else {
        while (*marker < slength) {
            c = s[*marker];
            if (iswdigit(c)) break;
            chunk[chunk_index++] = c;
            (*marker)++;
        }
    }

    chunk[chunk_index] = L'\0'; // Завершаем строку нулевым символом
    return chunk;
}

// Функция сравнения строк по алгоритму Alphanum
int compareStrings(const void* a, const void* b) {
    const wchar_t* s1 = *(const wchar_t**)a;
    const wchar_t* s2 = *(const wchar_t**)b;

    // Сравниваем NULL-значения
    if (s1 == NULL && s2 == NULL) return 0; // Оба NULL — равны
    if (s1 == NULL) return -1; // NULL меньше любой строки
    if (s2 == NULL) return 1;  // Любая строка больше NULL

    int thisMarker = 0;
    int thatMarker = 0;
    int s1Length = wcslen(s1);
    int s2Length = wcslen(s2);

    // Сравниваем строки по "кусочкам"
    while (thisMarker < s1Length && thatMarker < s2Length) {
        wchar_t* thisChunk = getChunk(s1, s1Length, &thisMarker);
        wchar_t* thatChunk = getChunk(s2, s2Length, &thatMarker);

        int result = 0;

        // Если оба "куска" числовые, сравниваем их как числа
        if (iswdigit(thisChunk[0]) && iswdigit(thatChunk[0])) {
            int thisChunkLength = wcslen(thisChunk);
            int thatChunkLength = wcslen(thatChunk);

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
        // Если хотя бы один "кусок" текстовый, сравниваем через wcscmp
        else {
            result = wcscmp(thisChunk, thatChunk);
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
    const wchar_t* values[] = {
        L"dazzle2", NULL, L"dazzle10", L"dazzle1", L"dazzle2.7", 
        L"dazzle2.10", L"2", L"10", L"1", 
        L"EctoMorph6", L"EctoMorph62", L"EctoMorph7", NULL
    };
    int count = sizeof(values) / sizeof(values[0]);

    // Создаем копию массива для сортировки
    const wchar_t** sorted = malloc(count * sizeof(const wchar_t*));
    if (!sorted) {
        fwprintf(stderr, L"Memory allocation failed\n");
        return EXIT_FAILURE;
    }
    memcpy(sorted, values, count * sizeof(const wchar_t*));

    // Сортируем массив строк с использованием функции сравнения
    qsort(sorted, count, sizeof(const wchar_t*), compareStrings);

    // Выводим отсортированный массив
    for (int i = 0; i < count; i++) {
        if (sorted[i] == NULL) {
            fwprintf(stdout, L"NULL ");
        } else {
            fwprintf(stdout, L"%ls ", sorted[i]);
        }
    }
    fwprintf(stdout, L"\n");

    // Освобождаем память
    free(sorted);
    return 0;
}
