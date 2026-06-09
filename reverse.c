#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/*
 * reverse.c
 * Simple utility to read lines from stdin or a file and print them
 * in reverse order. The program supports the following invocations:
 *   ./reverse
 *   ./reverse input.txt
 *   ./reverse input.txt output.txt
 *
 * Implementation notes:
 * - We read each line using `getline` (or a portable replacement on
 *   Windows) into a dynamically allocated string, storing pointers in
 *   a resizable array. After input is complete, we print the stored
 *   lines in reverse order and free memory.
 * - This approach is simple and correct for files that fit in memory.
 *   For extremely large files this could exhaust memory; see README.md
 *   for discussion and alternatives.
 * - All error messages are printed to stderr with the exact strings
 *   required by the assignment.
 */

/* Provide ssize_t on Windows if missing */
#if defined(_WIN32) || defined(_WIN64)
    #ifndef __ssize_t_defined
        typedef long long ssize_t;
        #define __ssize_t_defined 1
    #endif
#endif

/* Portable getline replacement for platforms that lack it (Windows).
     This implementation reads chars via fgetc and grows the buffer as needed.
*/
ssize_t portable_getline(char **lineptr, size_t *n, FILE *stream) {
        if (!lineptr || !n || !stream) {
                errno = EINVAL;
                return -1;
        }
        size_t pos = 0;
        int c;

        if (*lineptr == NULL || *n == 0) {
                *n = 128;
                *lineptr = malloc(*n);
                if (!*lineptr) return -1;
        }

        while ((c = fgetc(stream)) != EOF) {
                if (pos + 1 >= *n) {
                        size_t newn = *n * 2;
                        char *tmp = realloc(*lineptr, newn);
                        if (!tmp) return -1;
                        *lineptr = tmp;
                        *n = newn;
                }
                (*lineptr)[pos++] = (char)c;
                if (c == '\n') break;
        }

        if (pos == 0 && c == EOF) return -1;

        (*lineptr)[pos] = '\0';
        return (ssize_t)pos;
}

/* Use portable_getline when getline is not available */
#ifndef _GNU_SOURCE
    #define getline portable_getline
#endif

static char *safe_strdup(const char *s) {
    if (!s) return NULL;
    size_t n = strlen(s) + 1;
    char *p = malloc(n);
    if (!p) return NULL;
    memcpy(p, s, n);
    return p;
}

int main(int argc, char *argv[]) {
    FILE *in = NULL, *out = NULL;
    char *in_name = NULL, *out_name = NULL;

    if (argc > 3) {
        fprintf(stderr, "usage: reverse  \n");
        exit(1);
    }

    if (argc >= 2) in_name = argv[1];
    if (argc == 3) out_name = argv[2];

    if (in_name && out_name && strcmp(in_name, out_name) == 0) {
        fprintf(stderr, "Input and output file must differ\n");
        exit(1);
    }

    if (in_name) {
        in = fopen(in_name, "r");
        if (!in) {
            fprintf(stderr, "error: cannot open file '%s'\n", in_name);
            exit(1);
        }
    } else {
        in = stdin;
    }

    if (out_name) {
        out = fopen(out_name, "w");
        if (!out) {
            fprintf(stderr, "error: cannot open file '%s'\n", out_name);
            if (in != stdin) fclose(in);
            exit(1);
        }
    } else {
        out = stdout;
    }

    char *line = NULL;
    size_t linecap = 0;
    ssize_t linelen;

    size_t capacity = 64;
    size_t count = 0;
    char **lines = malloc(capacity * sizeof(char*));
    if (!lines) {
        fprintf(stderr, "malloc failed\n");
        if (in != stdin) fclose(in);
        if (out != stdout) fclose(out);
        exit(1);
    }

    while ((linelen = getline(&line, &linecap, in)) != -1) {
        char *copy = safe_strdup(line);
        if (!copy) {
            fprintf(stderr, "malloc failed\n");
            free(line);
            for (size_t i = 0; i < count; ++i) free(lines[i]);
            free(lines);
            if (in != stdin) fclose(in);
            if (out != stdout) fclose(out);
            exit(1);
        }
        if (count >= capacity) {
            size_t ncap = capacity * 2;
            char **tmp = realloc(lines, ncap * sizeof(char*));
            if (!tmp) {
                fprintf(stderr, "malloc failed\n");
                free(copy);
                free(line);
                for (size_t i = 0; i < count; ++i) free(lines[i]);
                free(lines);
                if (in != stdin) fclose(in);
                if (out != stdout) fclose(out);
                exit(1);
            }
            lines = tmp;
            capacity = ncap;
        }
        lines[count++] = copy;
    }

    free(line);

    for (ssize_t i = (ssize_t)count - 1; i >= 0; --i) {
        fprintf(out, "%s", lines[i]);
        free(lines[i]);
    }

    free(lines);

    if (in != stdin) fclose(in);
    if (out != stdout) fclose(out);

    return 0;
}
