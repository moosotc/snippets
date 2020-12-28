#include <stdio.h>
#include <errno.h>
#include <malloc.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

static void __attribute__ ((noreturn, format (printf, 2, 3)))
    die (int exitcode, const char *fmt, ...)
{
    va_list ap;
    int savederrno;

    savederrno = errno;
    va_start (ap, fmt);
    vfprintf (stderr, fmt, ap);
    va_end (ap);
    fprintf (stderr, ": %s\n", strerror (savederrno));
    fflush (stderr);
    _exit (exitcode);
}

int main (int argc, char **argv)
{
    int n;
    size_t size = 1<<20;

    if (argc > 1) {
        n = sscanf (argv[1], "%zu", &size);
        if (n - 1) {
            die (EXIT_FAILURE, "huh? %d\n", n);
        }
    }
    for (n = 0; n < 100000; n++) {
        void *p = malloc (size);
        if (!p) {
            die (EXIT_FAILURE, "malloc %zu failed", size);
        }
        free (p);
    }
    return 0;
}

/*
  Local Variables:
  compile-command: "clang -Weverything -Werror -o free free.c"
  End:
*/
